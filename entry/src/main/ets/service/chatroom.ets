import defHttp from "../libs/http";
import { Message, ReconnectingWebSocket } from "../libs/ws";
import { ChatContentType, ExtendsType, IChatRoomMessage, IChatroomQuery, IChatVia,
  IMessageEvent,
  IOnlineMsg,
  IMessage,
  MessageData,
  ChatRoomMessageType} from "./types/chatroom";
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
  private wsCallbacks:Array<(msg: IMessage) => void> = [];


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
      item.type = ChatRoomMessageType.msg;
      try {
        const data: ExtendsType = JSON.parse(item.content);
        if (data.msgType == 'redPacket' && data.recivers && typeof data.recivers == 'string') {
          data.recivers = JSON.parse(data.recivers);
        }
        item.extends = data;
        if (data.msgType == 'redPacket') {
          item.content = '[收到一个红包]'
          item.type = ChatRoomMessageType.redPacket;
        }
      } catch (e) {
        console.error(e);
      }
      return item;
    }));
  }

  connect(timeout = 10): Promise<boolean | void> {
    return new Promise(async (resolve, reject) => {

      if (this.rws) {
        return resolve(this.rws.reconnect());
      }
      this.rws = new ReconnectingWebSocket(`wss://fishpi.cn/chat-room-channel?apiKey=${this.token}`, {
        connectionTimeout: 1000 * timeout,
      });
      this.rws.onopen = (e) => {
        if (e) reject(e);
        else resolve(true);
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
        this.wsCallbacks.forEach(call => call({ type: msg.type, data } as IMessage));
      }
      this.rws.onerror = ((e) => {
        console.error(e.message);
      });
      this.rws.onclose = ((e) => {
        console.log(e.message);
      });
    });
  }


  /**
   * 清除聊天室监听
   */
  clearListener() {
    this.wsCallbacks = [];
  }

  /**
   * 移除聊天室消息监听函数
   * @param wsCallback 消息监听函数
   */
  removeListener(wsCallback: (msg: IMessage) => void) {
    if (this.wsCallbacks.indexOf(wsCallback) < 0) return;
    this.wsCallbacks.splice(this.wsCallbacks.indexOf(wsCallback), 1);
  }

  /**
   * 添加聊天室消息监听函数
   * @param wsCallback 消息监听函数
   * @param timeout 超时时间
   * @param error 错误回调
   * @param close 关闭回调
   */
  async addListener(wsCallback: (msg: IMessage) => void, timeout=10) {
    if (this.rws !== undefined) {
      if (this.wsCallbacks.indexOf(wsCallback) < 0)
        this.wsCallbacks.push(wsCallback);
      return;
    }
    this.wsCallbacks.push(wsCallback);
    await this.connect(timeout);
  }

}