import { defHttp, IResponseData } from "../libs/http";
import { Message, ReconnectingWebSocket } from "../libs/ws";
import { IToken } from "./types/fishpi";
import { INoticeData, INoticeCount, NoticeType, NoticeData, NoticeMsg, INoticeMsg,
  NoticeListener } from "./types/notice";

export class Notice {
  private token: string = '';
  private rws?: ReconnectingWebSocket;
  private wsCallbacks: NoticeListener[] = [];

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
   * 获取未读消息数
   */
  count() {
    return defHttp.get<INoticeCount>('/notifications/unread/count', {
      params: {
        apiKey: this.token,
      } as IToken
    })
  }

  /**
   * 获取消息列表
   * @param type 消息类型
   */
  list(type: NoticeType, p = 1) {
    return defHttp.get<INoticeData[]>('/api/getNotifications', {
      params: {
        apiKey: this.token,
        type,
        p,
      } as IToken
    }).then((res) => res.map((item) => new NoticeData(type, item)))
  }

  /**
   * 已读指定类型消息
   * @param type 消息类型
   */
  markRead(type: NoticeType) {
    return defHttp.post<IResponseData>(`/notifications/make-read/${type}`, {
      params: {
        apiKey: this.token,
      } as IToken
    }).then(() => true)
  }

  readAll() {
    return defHttp.post<IResponseData>('/notifications/all-read', {
      params: {
        apiKey: this.token,
      } as IToken
    }).then(() => true)
  }


  /**
   * 移除通知监听函数
   * @param wsCallback 要移除的函数，若为空，则清空消息监听
   */
  removeListener(wsCallback: NoticeListener) {
    if (wsCallback == null) this.wsCallbacks = [];
    if (!this.wsCallbacks.includes(wsCallback)) return;
    this.wsCallbacks.splice(this.wsCallbacks.indexOf(wsCallback), 1);
  }

  /**
   * 添加通知听函数
   * @param wsCallback 消息监听函数
   * @param user 指定为用户消息监听函数，空为新信息监听
   */
  async addListener(wsCallback: NoticeListener, user:string = '') {
    if (this.rws) {
      if (!this.wsCallbacks.includes(wsCallback))
        this.wsCallbacks.push(wsCallback);
      return;
    }
    this.wsCallbacks.push(wsCallback);
    this.connect();
  }

  /**
   * 连接通知频道
   * @returns Websocket 连接对象
   */
  connect(timeout = 10): Promise<boolean | void> {
    return new Promise(async (resolve, reject) => {
      if (this.rws) return resolve(this.rws.reconnect());
      const rws = new ReconnectingWebSocket(`wss://fishpi.cn/user-channel?apiKey=${this.token}`, {
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
        let data: INoticeMsg = JSON.parse(msgData.toString());
        this.wsCallbacks.forEach(call => call(new NoticeMsg(data)));
      };
      rws.onerror = (e) => {
        reject(e);
      };
      rws.onclose = ((e) => {
        console.log(`[Notice] 连接已关闭`, e);
      });

      this.rws = rws;
    })
  }
}
