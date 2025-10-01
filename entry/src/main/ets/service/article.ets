import { defHttp, IResponseData } from "../libs/http";
import { Message, ReconnectingWebSocket } from "../libs/ws";
import {
  ArticleType,
  IArticleDetail,
  IArticleHeat,
  IArticleList,
  IArticlePost,
  IArticleQuery,
  VoteType
} from "./types/article";
import { IToken } from "./types/fishpi";

interface IArticlePostData extends IArticlePost, IToken {}

interface IArticlePostRsp extends IResponseData {
  articleId: string;
}

interface IArticleDetailRsp extends IResponseData {
  article: IArticleDetail;
}

interface IArticleVoteRsp extends IResponseData {
  type: VoteType;
}

interface IArticleHeatRsp extends IResponseData {
  articleHeat: number;
}

export class Article {
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
  async post(article: IArticlePost) {
    const data: IArticlePostData = article as IArticlePostData;
    data.apiKey = this.token;
    return defHttp.post<IArticlePostRsp>('/article', { data }).then((res) => res.articleId);
  }

  /**
   * 更新文章
   * @param id 文章 Id
   * @param data 文章信息
   * @returns 更新成功返回文章Id (articleId)
   */
  async update(id: string, article: IArticlePost) {
    const data: IArticlePostData = article as IArticlePostData;
    data.apiKey = this.token;
    return defHttp.put<IArticlePostRsp>(`/article/update`, { data }).then((res) => res.articleId);
  }

  /**
   * 查询文章列表
   * @param type 查询类型
   * @param tag 指定查询标签，可选
   * @returns 文章列表
   */
  list(query: IArticleQuery) {
    return query.user ?
      defHttp.get<IArticleList>(`/api/user/${query.user}/articles?p=${query.page || 1}&size=${query.size ||
        20}&apiKey=${this.token}`).then((res) => {
        return res
      }) :
      defHttp.get<IArticleList>(`/api/articles/${query.tag !== undefined ? `tag/${query.tag}` :
        'recent'}${query.type}?p=${query.page || 1}&size=${query.size || 20}&apiKey=${this.token}`).then((res) => res);
  }

  /**
   * 获取文章详情
   * @param id 文章id
   * @param p 评论页码
   * @returns 文章详情
   */
  detail(id: string, p: number = 1) {
    return defHttp.get<IArticleDetailRsp>(`/api/article/${id}?p=${p}&apiKey=${this.token}`).then((res) => res.article);
  }

  /**
   * 点赞/取消点赞文章
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

  /**
   * 收藏/取消收藏文章
   * @param followingId 文章id
   */
  follow(followingId: string) {
    return defHttp.post<IResponseData>(`/follow/article`, {
      data: {
        apiKey: this.token,
        followingId
      } as IToken
    }).then(() => true);
  }

  /**
   * 关注/取消关注文章
   * @param followingId 文章id
   */
  watch(followingId: string) {
    return defHttp.post<IResponseData>(`/follow/article-watch`, {
      data: {
        apiKey: this.token,
        followingId
      } as IToken
    }).then(() => true);
  }

  /**
   * 打赏文章
   * @param id 文章id
   */
  reward(id: string) {
    return defHttp.post<IResponseData>(`/article/reward?articleId=${id}`, {
      data: {
        apiKey: this.token
      } as IToken
    }).then(() => true);
  }

  /**
   * 获取文章在线人数
   * @param id 文章id
   */
  heat(id: string) {
    return defHttp.get<IArticleHeatRsp>(`/api/article/heat/${id}?apiKey=${this.token}`).then((res) => res.articleHeat);
  }

  /**
   * 添加文章监听器
   * @param id 文章id
   * @param type 文章类型
   * @param callback 监听回调
   */
  async addListener(id: string, type: ArticleType,
    callback: (ev: IArticleHeat) => void): Promise<ReconnectingWebSocket> {
    return new Promise((resolve, reject) => {
      const rws = new ReconnectingWebSocket(
        `wss://fishpi.cn/article-channel?articleId=${id}&articleType=${type}&apiKey=${this.token}`, {
        connectionTimeout: 10000
      }
      );

      rws.onopen = (e) => {
        if (e) {
          reject(e);
        } else {
          resolve(rws);
        }
      };
      rws.onmessage = (_err, msgData: Message) => callback(JSON.parse(msgData.toString()) as IArticleHeat);
      rws.onerror = ((e) => {
        console.error(e.message);
      });
      rws.onclose = ((e) => {
        console.log(e.message);
      });
    })
  }
}