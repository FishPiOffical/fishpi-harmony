import { defHttp, IResponseData } from "../libs/http";
import { Message, ReconnectingWebSocket } from "../libs/ws";
import { ChatListener, ChatMsg, IChatData, IChatMsg, IChatQuery } from "./types/chat";
import { IToken } from "./types/fishpi";

interface IHistory extends IToken {
  toUser: string
  page: number
  pageSize: number
}

interface IMarkRead extends IToken {
  fromUser: string
}

export class Chat {
  private token: string = '';
  private rwsList: Map<string, ReconnectingWebSocket> = new Map();
  private wsCallbacks: Map<string, ChatListener[]> = new Map();

  constructor(token?: string) {
    if (!token) {
      return;
    }
    this.setToken(token);
  }

  setToken(token: string) {
    this.token = token;
  }

  /**
   * 获取有私聊用户列表第一条消息
   * @returns 私聊消息列表
   */
  list() {
    return defHttp.get<IChatData[]>('/chat/get-list', {
      params: {
        apiKey: this.token
      } as IToken
    })
  }

  /**
   * 获取用户私聊历史消息
   * @param param 消息查询条件
   * @returns 私聊消息列表
   */
  history(param: IChatQuery) {
    return defHttp.get<IChatData[]>('/chat/get-message', {
      params: {
        apiKey: this.token,
        toUser: param.user,
        page: param.page || 1,
        pageSize: param.size || 20,
      } as IHistory
    }).then(res => {
      if (param.autoRead || param.autoRead === undefined) {
        this.markRead(param.user);
      }
      return res;
    })
  }

  /**
   * 标记用户消息已读
   * @param user 用户名
   * @returns 执行结果
   */
  markRead(user: string) {
    return defHttp.post<IResponseData>('/chat/mark-read', {
      params: {
        apiKey: this.token,
        fromUser: user
      } as IMarkRead
    }).then(() => true)
  }

  /**
   * 获取未读消息
   * @returns 未读消息列表
   */
  unread() {
    return defHttp.get<IChatData[]>('/chat/get-unread', {
      params: {
        apiKey: this.token
      } as IToken
    })
  }

  /**
   * 撤回私聊消息
   * @param msgId 消息 ID
   */
  revoke(oId: string) {
    return defHttp.get<IResponseData>('/chat/revoke', {
      params: {
        apiKey: this.token,
        oId
      } as IToken
    })
  }

  /**
   * 移除聊天室消息监听函数
   * @param user 指定用户消息监听函数，空为新信息监听
   * @param wsCallback 要移除的函数，若为空，则清空消息监听
   */
  removeListener(user:string = '', wsCallback: ChatListener) {
    if (wsCallback == null) this.wsCallbacks.delete(user);
    if (!this.wsCallbacks.has(user) || !this.wsCallbacks.get(user)?.includes(wsCallback)) return;
    this.wsCallbacks.get(user)?.splice(this.wsCallbacks[user].indexOf(wsCallback), 1);
  }

  /**
   * 添加聊天室消息监听函数
   * @param wsCallback 消息监听函数
   * @param user 指定为用户消息监听函数，空为新信息监听
   */
  async addListener(wsCallback: ChatListener, user:string = '') {
    if (this.rwsList.has(user)) {
      if (!this.wsCallbacks.get(user)?.includes(wsCallback))
        this.wsCallbacks.get(user)?.push(wsCallback);
      return;
    }
    if (this.wsCallbacks.has(user))
      this.wsCallbacks.get(user)?.push(wsCallback);
    else this.wsCallbacks.set(user, [wsCallback]);
    this.connect(user);
  }

  /**
   * 连接用户私聊频道
   * @param user 私聊用户名
   * @returns Websocket 连接对象
   */
  connect(user:string, timeout = 10): Promise<boolean | void> {
    return new Promise(async (resolve, reject) => {
      if (this.rwsList.has(user)) return resolve(this.rwsList[user].reconnect());
      const rws = new ReconnectingWebSocket(user ?
        `wss://fishpi.cn/chat-channel?apiKey=${this.token}&toUser=${user}`
        : `wss://fishpi.cn/user-channel?apiKey=${this.token}`, {
        connectionTimeout:  1000 * timeout,
      });
      rws.onopen = (e) => {
        if (e) {
          reject(e);
        } else {
          resolve(true);
        }
      };
      rws.onmessage = async (_err, msgData: Message) => {
        let data: IChatMsg = JSON.parse(msgData.toString());
        this.wsCallbacks.get(user)?.forEach(call => call(new ChatMsg(data)));
      };
      rws.onerror = (e) => {
        reject(e);
      };
      rws.onclose = ((e) => {
        console.log(`[Chat] ${user} 连接已关闭`, e);
      });

      this.rwsList.set(user, rws);
    })
  }

  /**
   * 关闭用户私聊频道
   * @param user 私聊用户名, 空为关闭所有用户频道
   */
  close(user: string) {
    if (this.rwsList[user]) {
      this.rwsList.get(user)?.close();
      this.rwsList.delete(user);
    }
    if (this.wsCallbacks.has(user))
      this.wsCallbacks.delete(user);
  }

  /**
   * 发送私聊消息
   * @param user 私聊用户名
   * @param content 私聊内容
   * @returns 发送结果
   */
  async send(user: string, content: string): Promise<boolean> {
    if (!this.rwsList.get(user)) await this.connect(user);
    return await this.rwsList.get(user)!.send(content);
  }
}