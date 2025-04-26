import { defHttp, IResponseData } from "../libs/http";
import { ICommentPost } from "./types/comment";
import { IToken } from "./types/fishpi";

interface ICommentPostData extends ICommentPost {
  apiKey: string;
}

interface IArticleVoteRsp {
  type: 0 | -1;
}

export class Comment {
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
   * 发布文章
   * @param data 文章信息
   * @returns 发布成功返回文章Id (articleId)
   */
  async send(article: ICommentPost) {
    const data: ICommentPostData = article as ICommentPostData;
    data.apiKey = this.token;
    return defHttp.post<IResponseData>('/comment', { data });
  }

  /**
   * 评论点赞
   * @param id 文章id
   * @param type 点赞类型
   * @returns 文章点赞状态
   */
  vote(dataId: string, type: 'up' | 'down') {
    return defHttp.post<IArticleVoteRsp>(`/vote/${type}`, {
      data: {
        apiKey: this.token,
        dataId,
      } as IToken
    }).then((res) => res.type);
  }

  /**
   * 感谢文章
   * @param id 文章id
   */
  thank(id: string) {
    return defHttp.post<IResponseData>(`/article/thank?articleId=${id}`, {
      data: {
        apiKey: this.token
      } as IToken
    }).then(() => true);
  }

}