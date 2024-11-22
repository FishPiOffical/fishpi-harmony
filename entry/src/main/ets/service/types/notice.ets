import { IArticleTag } from "./article";

/**
 * 数据类型
 */
export enum DataType {
  /**
   * 文章
   */
  article = 0,

  /**
   * 评论
   */
  comment = 1,

  /**
   * @
   */
  at = 2,

  /**
   * 被评论
   */
  commented = 3,

  /**
   * 关注者
   */
  followingUser = 4,

  /**
   * 积分 - 充值
   */
  pointCharge = 5,

  /**
   * 积分 - 转账
   */
  pointTransfer = 6,

  /**
   * 积分 - 文章打赏
   */
  pointArticleReward = 7,

  /**
   * 积分 - 评论感谢
   */
  pointCommentThank = 8,

  /**
   * 同城广播
   */
  broadcast = 9,

  /**
   * 积分 - 交易
   */
  pointExchange = 10,

  /**
   * 积分 - 滥用扣除
   */
  abusePointDeduct = 11,

  /**
   * 积分 - 文章被感谢
   */
  pointArticleThank = 12,

  /**
   * 回复
   */
  reply = 13,

  /**
   * 使用邀请码
   */
  invitecodeUsed = 14,

  /**
   * 系统公告 - 文章
   */
  sysAnnounceArticle = 15,

  /**
   * 系统公告 - 新用户
   */
  sysAnnounceNewUser = 16,

  /**
   * 新的关注者
   */
  newFollower = 17,

  /**
   * 邀请链接
   */
  invitationLinkUsed = 18,

  /**
   * 系统通知 - 角色变化
   */
  sysAnnounceRoleChanged = 19,

  /**
   * 关注的文章更新
   */
  followingArticleUpdate = 20,

  /**
   * 关注的文章评论
   */
  followingArticleComment = 21,

  /**
   * 积分 - 文章优选
   */
  pointPerfectArticle = 22,

  /**
   * 文章新的被关注者
   */
  articleNewFollower = 23,

  /**
   * 文章新的关注者
   */
  articleNewWatcher = 24,

  /**
   * 评论点赞
   */
  commentVoteUp = 25,

  /**
   * 评论点踩
   */
  commentVoteDown = 26,

  /**
   * 文章被点赞
   */
  articleVoteUp = 27,

  /**
   * 文章被点踩
   */
  articleVoteDown = 28,

  /**
   * 积分 - 评论被接受
   */
  pointCommentAccept = 33,

  /**
   * 积分 - 举报处理
   */
  pointReportHandled = 36,

  /**
   * 聊天室 @
   */
  chatRoomAt = 38,

  /**
   * 专属红包提醒
   */
  redPacket = 39,
}

/**
 * 通知数
 */
export interface INoticeCount {
  /**
   * 请求结果，成功为 0
   */
  code: number;
  /**
   * 用户是否启用 Web 通知
   */
  userNotifyStatus: boolean;
  /**
   * 未读通知数
   */
  unreadNotificationCnt: number;
  /**
   * 未读回复通知数
   */
  unreadReplyNotificationCnt: number;
  /**
   * 未读积分通知数
   */
  unreadPointNotificationCnt: number;
  /**
   * 未读 @ 通知数
   */
  unreadAtNotificationCnt: number;
  /**
   * 未读同城通知数
   */
  unreadBroadcastNotificationCnt: number;
  /**
   * 未读系统通知数
   */
  unreadSysAnnounceNotificationCnt: number;
  /**
   * 未读关注者通知数
   */
  unreadNewFollowerNotificationCnt: number;
  /**
   * 未读关注通知数
   */
  unreadFollowingNotificationCnt: number;
  /**
   * 未读评论通知数
   */
  unreadCommentedNotificationCnt: number;
}

/**
 * 通知类型
 */
export enum NoticeType {
  /**
   * 积分
   */
  Point = 'point',
  /**
   * 评论
   */
  Comment = 'commented',
  /**
   * 回复
   */
  Reply = 'reply',
  /**
   * 提及我的
   */
  At = 'at',
  /**
   * 我关注的
   */
  Following = 'following',
  /**
   * 同城
   */
  Broadcast = 'broadcast',
  /**
   * 系统
   */
  System = 'sys-announce',
}


/**
 * 积分通知
 */
export interface INoticePoint {
  /**
   * 通知 id
   */
  oId: string;
  /**
   * 数据 id
   */
  dataId: string;
  /**
   * 用户 id
   */
  userId: string;
  /**
   * 数据类型
   */
  dataType: DataType;
  /**
   * 通知描述
   */
  description: string;
  /**
   * 是否已读
   */
  hasRead: boolean
  /**
   * 创建日期
   */
  createTime: string;
}

/**
 * 评论/回帖通知
 */
export interface INoticeComment {
  /**
   * 通知 id
   */
  oId: string;
  /**
   * 文章标题
   */
  commentArticleTitle: string;
  /**
   * 文章作者
   */
  commentAuthorName: string;
  /**
   * 作者头像
   */
  commentAuthorThumbnailURL: string;
  /**
   * 文章类型
   */
  commentArticleType: number;
  /**
   * 是否精选
   */
  commentArticlePerfect: number;
  /**
   * 评论内容
   */
  commentContent: string;
  /**
   * 评论地址
   */
  commentSharpURL: string;
  /**
   * 是否已读
   */
  hasRead: boolean;
  /**
   * 评论时间
   */
  commentCreateTime: string;
}

/**
 * 提到我通知
 */
export interface INoticeAt {
  /**
   * 通知 id
   */
  oId: string;
  /**
   * 数据类型
   */
  dataType: DataType;
  /**
   * 用户名
   */
  userName: string;
  /**
   * 用户头像
   */
  userAvatarURL: string;
  /**
   * 通知内容
   */
  content: string;
  /**
   * 是否已读
   */
  hasRead: boolean;
  /**
   * 创建时间
   */
  createTime: string;
}

/**
 * 我关注的通知
 */
export interface INoticeFollow {
  /**
   * 通知 Id
   */
  oId: string;
  /**
   * 文章地址
   */
  url: string;
  /**
   * 数据类型
   */
  dataType: DataType;
  /**
   * 文章标题
   */
  articleTitle: string;
  /**
   * 作者
   */
  authorName: string;
  /**
   * 通知内容
   */
  content: string;
  /**
   * 是否评论
   */
  isComment: boolean;
  /**
   * 作者头像
   */
  thumbnailURL: string;
  /**
   * 文章评论数
   */
  articleCommentCount: number;
  /**
   * 是否精选
   */
  articlePerfect: number;
  /**
   * 文章标签列表
   */
  articleTagObjs: IArticleTag[];
  /**
   * 文章标签
   */
  articleTags: string;
  /**
   * 文章类型
   */
  articleType: number;
  /**
   * 是否已读
   */
  hasRead: boolean;
  /**
   * 通知创建时间
   */
  createTime: string;
}

/**
 * 系统通知数据
 */
export interface INoticeSystem {
  /**
   * 消息的 oId
   */
  oId: string;
  /**
   * 用户 Id
   */
  userId: string;
  /**
   * 数据 Id
   */
  dataId: string;
  /**
   * 数据类型
   */
  dataType: DataType;
  /**
   * 消息描述
   */
  description: string;
  /**
   * 是否已读
   */
  hasRead: boolean;
  /**
   * 创建日期
   */
  createTime: string;
}

/**
 * 通知类型
 */
export type INoticeData = INoticePoint | INoticeComment | INoticeAt | INoticeFollow | INoticeSystem;

export class NoticeData {
  private data: INoticeData;
  type: NoticeType;

  constructor(type: NoticeType, data: INoticeData) {
    this.type = type;
    this.data = data;
  }

  get point() {
    if (this.type === NoticeType.Point) {
      return this.data as INoticePoint;
    }
    return null;
  }

  get comment() {
    if (this.type === NoticeType.Comment) {
      return this.data as INoticeComment;
    }
    return null;
  }

  get at() {
    if (this.type === NoticeType.At) {
      return this.data as INoticeAt;
    }
    return null;
  }

  get follow() {
    if (this.type === NoticeType.Following) {
      return this.data as INoticeFollow;
    }
    return null;
  }

  get system() {
    if (this.type === NoticeType.System) {
      return this.data as INoticeSystem;
    }
    return null;
  }
}