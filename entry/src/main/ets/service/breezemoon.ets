import { defHttp, IResponseData } from '../libs/http';
import { IBreezemoonQuery, IBreezemoonRsp } from './types/breezemoon';

export class Breezemoon {
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
   * 获取清风明月列表
   * @param page 消息页码
   * @param size 每页个数
   * @returns 返回清风明月列表
   */
  list(query: IBreezemoonQuery) {
    return query.user ?
    defHttp.get<IBreezemoonRsp>(`/api/user/${query.user}/breezemoons?p=${query.page || 1}&size=${query.size ||
      20}&apiKey=${this.token}`).then(res => res.breezemoons) :
    defHttp.get<IBreezemoonRsp>(`/api/breezemoons?p=${query.page || 1}&size=${query.size ||
      20}&apiKey=${this.token}`).then(res => res.breezemoons);
  }

  /**
   * 发送清风明月
   * @param content 内容
   * @returns 返回是否发送成功
   */
  send(content: string) {
    return defHttp.post<IResponseData>(`/breezemoon`, {
      data: {
        apiKey: this.token,
        breezemoonContent: content
      }
    }).then(() => true);
  }
}
