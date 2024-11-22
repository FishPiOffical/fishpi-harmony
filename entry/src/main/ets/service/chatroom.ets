import defHttp, { IResponseData } from "../libs/http";
import { Message, ReconnectingWebSocket } from "../libs/ws";
import {
  ChatContentType,
  ExtendsType,
  IChatroomQuery,
  IChatVia,
  IMessageEvent,
  IOnlineMsg,
  ChatRoomMessageData,
  MessageData,
  ClientType,
  IChatroomSend,
  ChatRoomMessage,
  ChatMessageMode,
  IMuteItem,
  ChatRoomMessageType
} from "./types/chatroom";
import { IRedPacketStatusMsg } from "./types/redpacket";
import { bundleManager } from "@kit.AbilityKit";

function clientToVia(client: string): IChatVia | undefined {
  if (!client) {
    return { client: ClientType.Other, version: 'unknown' }
  }
  const via = client.split('/')
  return { client: via[0], version: via[1] };
}

interface IBarrageCost {
  cost: number;
  unit: string;
}

export class Chatroom {
  private token: string = '';
  private rws?: ReconnectingWebSocket;
  private _onlineList: IOnlineMsg[] = [];
  private wsCallbacks: Array<(msg: ChatRoomMessageData) => void> = [];
  private version = '';
  private _discusse: string = '';

  constructor(token?: string) {
    bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      .then((info) => {
        this.version = info.versionName;
      })
    if (!token) {
      return;
    }
    this.setToken(token);
  }

  setToken(token: string) {
    this.token = token;
  }

  /**
   * 当前在线人数列表，需要先调用 addListener 添加聊天室消息监听
   */
  get onlineList() {
    return this._onlineList;
  }

  /**
   * 当前聊天室话题，需要先调用 addListener 添加聊天室消息监听
   */
  get discusse() {
    return this._discusse;
  }

  /**
   * 設置当前聊天室话题
   */
  set discusse(val) {
    this.send(`[setdiscuss]${val}[/setdiscuss]`);
  }

  /**
   * 获取历史消息(按页)
   * @param page 页码
   * @param type 内容类型
   * @returns
   */
  history(page = 1, type = ChatContentType.Markdown): Promise<ChatRoomMessage[]> {
    return defHttp.get<ChatRoomMessage[]>(`/chat-room/more`, {
      params: { apiKey: this.token, type, page } as IChatroomQuery
    }).then((res) => res.map((item) => new ChatRoomMessage(item)));
  }

  /**
   * 获取更多消息
   * @param oId 消息 id
   * @param mode 获取模式
   * @param type 内容类型
   * @param size 获取数量
   * @returns
   */
  more(oId: string, mode: ChatMessageMode = ChatMessageMode.Before, type = ChatContentType.Markdown,
    size: 25): Promise<ChatRoomMessage[]> {
    return defHttp.get<ChatRoomMessage[]>(`/chat-room/getMessage`, {
      params: {
        apiKey: this.token,
        type,
        oId,
        mode,
        size
      } as IChatroomQuery
    }).then((res) => res.map((item) => new ChatRoomMessage(item)));
  }

  /**
   * 撤回消息，普通成员 24 小时内可撤回一条自己的消息，纪律委员/OP/管理员角色可以撤回任意人消息
   * @param oId 消息 Id
   */
  revoke(oId: string) {
    return defHttp.post<IResponseData>(`/chat-room/revoke/${oId}`).then(() => true);
  }

  /**
   * 发送消息
   * @param msg 消息内容
   * @param clientType 客户端类型
   * @param version 客户端版本
   */
  send(msg: string, clientType: ClientType | string = ClientType.Harmony, version: string = '0.0.1') {
    return defHttp.post<IResponseData>(`/chat-room/send`, {
      data: {
        apiKey: this.token,
        content: msg,
        client: `${clientType}/${this.version || version}`
      } as IChatroomSend
    }).then(() => true);
  }

  /**
   * 发送一条弹幕
   * @param msg 消息内容，支持 Markdown
   * @param color 弹幕颜色
   */
  barrage(msg: string, color: string = '#ffffff'): Promise<boolean> {
    return this.send(`[barrager]{\"color\":\"${color}\",\"content\":\"${msg}\"}[/barrager]`);
  }

  /**
   * 获取禁言中成员列表（思过崖）
   */
  mutes() {
    return defHttp.get<IMuteItem[]>(`/chat-room/mutes`);
  }

  /**
   * 连接聊天室
   * @param timeout 超时时间
   * @returns 连接是否成功
   */
  connect(timeout = 10): Promise<boolean | void> {
    return new Promise(async (resolve, reject) => {

      if (this.rws) {
        return resolve(this.rws.reconnect());
      }
      this.rws = new ReconnectingWebSocket(`wss://fishpi.cn/chat-room-channel?apiKey=${this.token}`, {
        connectionTimeout: 1000 * timeout,
      });
      this.rws.onopen = (e) => {
        if (e) {
          reject(e);
        } else {
          resolve(true);
        }
      };
      this.rws.onmessage = (_err, msgData: Message) => {
        const msg = JSON.parse(msgData.toString()) as IMessageEvent;
        let data: MessageData;
        switch (msg.type) {
          case 'online': {
            this._onlineList = msg.users!;
            this._discusse = msg.discussing!;
            data = this.onlineList;
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
              msg.type = content.msgType as ChatRoomMessageType
            } catch (e) {
            }
            data = new ChatRoomMessage(msg);
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
        this.wsCallbacks.forEach(call => call(new ChatRoomMessageData(msg.type, data)));
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
  removeListener(wsCallback: (msg: ChatRoomMessageData) => void) {
    if (this.wsCallbacks.indexOf(wsCallback) < 0) {
      return;
    }
    this.wsCallbacks.splice(this.wsCallbacks.indexOf(wsCallback), 1);
  }

  /**
   * 添加聊天室消息监听函数
   * @param wsCallback 消息监听函数
   * @param timeout 超时时间
   * @param error 错误回调
   * @param close 关闭回调
   */
  async addListener(wsCallback: (msg: ChatRoomMessageData) => void, timeout = 10) {
    if (this.rws !== undefined) {
      if (this.wsCallbacks.indexOf(wsCallback) < 0) {
        this.wsCallbacks.push(wsCallback);
      }
      return;
    }
    this.wsCallbacks.push(wsCallback);
    await this.connect(timeout);
  }
}