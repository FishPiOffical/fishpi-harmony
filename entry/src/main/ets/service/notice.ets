import { defHttp, IResponseData } from "../libs/http";
import { IToken } from "./types/fishpi";
import { INoticeData, INoticeCount, NoticeType, NoticeData } from "./types/notice";

export class Notice {
  private token: string = '';

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
  list(type: NoticeType) {
    return defHttp.get<INoticeData[]>('/api/getNotifications', {
      params: {
        apiKey: this.token,
        type,
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
}