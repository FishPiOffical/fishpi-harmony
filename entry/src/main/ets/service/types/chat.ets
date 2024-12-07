/**
 * 私聊内容
 */
export interface IChatData {
  /**
   * 接收者 Id
   */
  toId: string,

  /**
   * 预览内容
   */
  preview: string,

  /**
   * 消息用户 Session
   */
  user_session: string,

  /**
   * 发送者头像
   */
  senderAvatar: string,

  /**
   * 消息 Markdown
   */
  markdown: string,

  /**
   * 接收者头像
   */
  receiverAvatar: string,

  /**
   * 消息 Id
   */
  oId: string,

  /**
   * 发送时间
   */
  time: string,

  /**
   * 来源 Id
   */
  fromId: string,

  /**
   * 发送者用户名
   */
  senderUserName: string,

  /**
   * 消息内容 HTML
   */
  content: string,

  /**
   * 接收者用户名
   */
  receiverUserName: string
}

export interface IChatQuery {
  user: string;
  page?: number;
  size?: number;
  autoRead?: boolean;
}

interface IChatNotice {
  command: string;
  userId: string;
  preview?: string;
  senderAvatar?: string;
  senderUserName?: string;
}

export class ChatNotice implements IChatNotice {
  command: string;
  userId: string;
  preview: string;
  senderAvatar: string;
  senderUserName: string;

  constructor(data?: IChatNotice) {
    this.command = data?.command || '';
    this.userId = data?.userId || '';
    this.preview = data?.preview || '';
    this.senderAvatar = data?.senderAvatar || '';
    this.senderUserName = data?.senderUserName || '';
  }
}

export class ChatData implements IChatData {
  toId: string;
  preview: string;
  user_session: string;
  senderAvatar: string;
  markdown: string;
  receiverAvatar: string;
  oId: string;
  time: string;
  fromId: string;
  senderUserName: string;
  content: string;
  receiverUserName: string;

  constructor(data?: IChatData) {
    this.toId = data?.toId || '';
    this.preview = data?.preview || '';
    this.user_session = data?.user_session || '';
    this.senderAvatar = data?.senderAvatar || '';
    this.markdown = data?.markdown || '';
    this.receiverAvatar = data?.receiverAvatar || '';
    this.oId = data?.oId || '';
    this.time = data?.time || '';
    this.fromId = data?.fromId || '';
    this.senderUserName = data?.senderUserName || '';
    this.content = data?.content || '';
    this.receiverUserName = data?.receiverUserName || '';
  }
}

export type IChatRevoke = string;

/**
 * 聊天消息类型
 */
export enum ChatMsgType {
  /**
   * 新聊天通知
   */
  notice,

  /**
   * 聊天内容
   */
  data,

  /**
   * 撤回聊天
   */
  revoke,
}

export type IChatMsg = IChatNotice | IChatData | IChatRevoke;

export class ChatMsg {
  /**
   * 消息类型
   */
  type: ChatMsgType;
  /**
   * 新聊天通知/聊天内容/撤回聊天
   */
  msg: ChatNotice | ChatData | IChatRevoke;

  constructor(data: IChatMsg) {
    if (typeof data === 'string') {
      this.type = ChatMsgType.revoke;
      this.msg = data;
    } else if (Object.keys(data).includes('command') && ['chatUnreadCountRefresh', 'newIdleChatMessage'].includes((data as IChatNotice).command)) {
      this.type = ChatMsgType.notice;
      this.msg = new ChatNotice(data as IChatNotice);
    } else {
      this.type = ChatMsgType.data;
      this.msg = new ChatData(data as IChatData);
    }
  }

  get notice() {
    if (this.type != ChatMsgType.notice) return null;
    return this.msg as ChatNotice;
  }

  get chat() {
    if (this.type != ChatMsgType.data) return null;
    return this.msg as ChatData;
  }

  get revoke() {
    if (this.type != ChatMsgType.revoke) return null;
    return this.msg as IChatRevoke;
  }
}

export type ChatListener = (
  data: ChatMsg
) => void;
