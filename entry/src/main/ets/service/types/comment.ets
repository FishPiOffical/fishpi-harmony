

export interface ICommentPost {
  /**
   * 文章 Id
   */
  articleId: string,
  /**
   * 是否匿名评论
   */
  commentAnonymous: boolean,
  /**
   * 评论是否楼主可见
   */
  commentVisible: boolean,
  /**
   * 评论内容
   */
  commentContent: string,
  /**
   * 回复评论 Id
   */
  commentOriginalCommentId?: string,
}