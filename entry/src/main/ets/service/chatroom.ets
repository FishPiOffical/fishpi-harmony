import defHttp from "../libs/http";
import { Message, ReconnectingWebSocket } from "../libs/ws";
import { ChatContentType, ExtendsType, IChatRoomMessage, IChatroomQuery, IChatVia,
  IMessageEvent,
  IOnlineMsg,
  IMessage,
  MessageData} from "./types/chatroom";
import { Metal } from "./types/user";
import { BusinessError } from "@kit.BasicServicesKit";
import { IRedPacketStatusMsg } from "./redpack";

function clientToVia(client: string): IChatVia | undefined {
  if (!client) {
    return;
  }
  const via = client.split('/')
  return { client: via[0], version: via[1] };
}

export class Chatroom {
  private token: string = '';
  private rws?: ReconnectingWebSocket;
  private discusse:string = '';
  private onlines:IOnlineMsg[] = [];
  private _wsCallbacks:Array<(msg: IMessage) => void> = [];


  constructor(token?: string) {
    if (!token) {
      return;
    }
    this.setToken(token);
  }

  setToken(token: string) {
    this.token = token;
  }

  more(page = 1, type = ChatContentType.HTML): Promise<IChatRoomMessage[]> {
    return defHttp.get<IChatRoomMessage[]>(`/chat-room/more`, {
      params: { apiKey: this.token, type, page } as IChatroomQuery
    }).then((res) => res.map((item) => {
      item.via = clientToVia(item.client)
      item.metalList = Metal.toMetal(item.sysMetal);
      try {
        const data: ExtendsType = JSON.parse(item.content);
        if (data.msgType == 'redPacket' && data.recivers && typeof data.recivers == 'string') {
          data.recivers = JSON.parse(data.recivers);
        }
        item.extends = data;
        if (data.msgType == 'redPacket') {
          item.content = '[收到一个红包]'
        }
      } catch (e) {
        console.error(e);
      }
      return item;
    }));
  }

  connect(timeout = 10): Promise<BusinessError<void>> {
    return new Promise(async (resolve, reject) => {

      if (!this.rws) {
        return;
      }
      this.rws = new ReconnectingWebSocket(`wss://fishpi.cn/chat-room-channel?apiKey=${this.token}`, {
        connectionTimeout: 1000 * timeout,
      });
      this.rws.onopen = (e) => {
        resolve(e);
      };
      this.rws.onmessage = (_err, msgData: Message) => {
        const msg = JSON.parse(msgData.toString()) as IMessageEvent;
        let data: MessageData;
        switch (msg.type) {
          case 'online': {
            this.onlines = msg.users!;
            this.discusse = msg.discussing!;
            data = this.onlines;
            break;
          }
          case 'discussChanged': {
            data = msg.newDiscuss;
            break;
          }
          case 'revoke': {
            data = msg.oId;
            break;
          }
          case 'barrager': {
            data = {
              barragerContent: msg.barragerContent,
              userAvatarURL: msg.userAvatarURL,
              userAvatarURL20: msg.userAvatarURL20,
              userNickname: msg.userNickname,
              barragerColor: msg.barragerColor,
              userName: msg.userName,
              userAvatarURL210: msg.userAvatarURL210,
              userAvatarURL48: msg.userAvatarURL48
            };
            break;
          }
          case 'msg': {
            let extendsData: ExtendsType | undefined = undefined;
            try {
              let content = JSON.parse(msg.content) as ExtendsType;
              extendsData = content;
              msg.type = content.msgType
            } catch (e) {
            }
            data = {
              userOId: msg.userOId,
              oId: msg.oId,
              time: msg.time,
              userName: msg.userName,
              userNickname: msg.userNickname,
              userAvatarURL: msg.userAvatarURL,
              content: msg.content,
              md: msg.md,
              client: msg.client,
              via: clientToVia(msg.client),
              extends: extendsData
            } as IChatRoomMessage;
            break;
          }
          case 'redPacketStatus': {
            data = {
              oId: msg.oId,
              count: msg.count,
              got: msg.got,
              whoGive: msg.whoGive,
              whoGot: msg.whoGot
            } as IRedPacketStatusMsg;
            break;
          }
          case 'customMessage': {
            data = msg.message;
            break;
          }
        }
        this._wsCallbacks.forEach(call => call({ type: msg.type, data } as IMessage));
      }
      this.rws.onerror = ((e) => {
        console.error(e.message);
      });
      this.rws.onclose = ((e) => {
        console.log(e.message);
      });
    });
  }
}