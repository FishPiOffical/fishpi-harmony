import { IRedPacketMessage, IRedPacketStatusMsg } from "../redpack";
import { MetalList } from "./user";

export interface IChatroomQuery {
  apiKey: string;
  type: ChatContentType;
  page: number;
}

export enum ClientType {
  /**
   * 网页端
   */
  Web = 'Web',
  /**
   * PC 端
   */
  PC = 'PC',
  /**
   * 移动端聊天室
   */
  Mobile = 'Mobile',
  /**
   * Windows 客户端
   */
  Windows = 'Windows',
  /**
   * macOS 客户端
   */
  macOS = 'macOS',
  /**
   * iOS 客户端
   */
  iOS = 'iOS',
  /**
   * Android 客户端
   */
  Android = 'Android',
  /**
   * IDEA 插件
   */
  IDEA = 'IDEA',
  /**
   * Chrome 插件
   */
  Chrome = 'Chrome',
  /**
   * Edge 插件
   */
  Edge = 'Edge',
  /**
   * VSCode 插件
   */
  VSCode = 'VSCode',
  /**
   * Python 插件
   */
  Python = 'Python',
  /**
   * Golang 插件
   */
  Golang = 'Golang',
  /**
   * 小冰机器人
   */
  IceNet = 'IceNet',
  /**
   * 凌机器人
   */
  ElvesOnline = 'ElvesOnline',
  /**
   * 其他插件
   */
  Other = 'Other',
}

export interface IChatVia {
  /**
   * 消息来源
   */
  client: ClientType | string;
  /**
   * 消息来源版本
   */
  version: string;
}

export type ExtendsType = IRedPacketMessage;

/**
 * 聊天室消息
 */
export interface IChatRoomMessage extends IChatRoomMessageRsp {
  /**
   * 用户勋章列表
   */
  metalList: MetalList;

  /**
   * 扩展消息内容
   */
  extends: ExtendsType;
}
export interface IChatRoomMessageRsp {
  /**
   * 消息 Id
   */
  oId: string;
  /**
   * 发送用户 Id
   */
  userOId: string;
  /**
   * 发送者用户名
   */
  userName: string;
  /**
   * 用户昵称
   */
  userNickname: string;
  /**
   * 用户头像
   */
  userAvatarURL: string;
  /**
   * 用户徽章
   */
  sysMetal: string;
  /**
   * 消息来源
   */
  client: string;
  /**
   * 消息来源解析
   */
  via?: IChatVia;
  /**
   * 消息内容
   */
  content: string;

  /**
   * 消息内容 Markdown
   */
  md: string;

  /**
   * 发送时间
   */
  time: string;
}

/**
 * 历史消息类型
 */
export enum ChatContentType {
  /**
   * 原始 Markdown
   */
  Markdown = 'md',
  /**
   * 渲染 HTML
   */
  HTML = 'html'
}

/**
 * chatroom get 接口获取 oId 的相关消息类型
 */
export enum ChatMessageType {
  /**
   * 前后消息
   */
  Context = 0,
  /**
   * 前面的消息
   */
  Before = 1,
  /**
   * 后面的消息
   */
  After = 2,
}

/**
 * 聊天室消息类型
 */
export enum ChatRoomMessageType {
  /**
   * 在线用户
   */
  online = 'online',
  /**
   * 话题修改
   */
  discussChanged = 'discussChanged',
  /**
   * 消息撤回
   */
  revoke = 'revoke',
  /**
   * 消息
   */
  msg = 'msg',
  /**
   * 红包
   */
  redPacket = 'redPacket',
  /**
   * 红包状态
   */
  redPacketStatus = 'redPacketStatus',
  /**
   * 弹幕
   */
  barrager = 'barrager',
  /**
   * 自定义消息
   */
  custom = 'customMessage',
}

/**
 * 聊天室消息
 */
export interface IMessage {
  /**
   * 消息类型，
   */
  type: ChatRoomMessageType | string;
  /**
   * 消息内容
   */
  data: MessageData;
}

export type MessageData = IOnlineMsg[] | discussMsg | RevokeMsg | IChatRoomMessage | IRedPacketStatusMsg | IBarragerMsg | ICustomMsg;

export interface IMessageEvent extends IRedPacketStatusMsg, IBarragerMsg {
  /**
   * 消息类型，
   */
  type: ChatRoomMessageType | string;

  users: IOnlineMsg[];

  discussing: discussMsg;

  newDiscuss: discussMsg;

  userOId: string;

  time: string;

  userName: string;

  userNickname: string;

  userAvatarURL: string;

  content: string;

  md: string;

  client: string;

  message: string;
}

export type ICustomMsg = string;

/**
 * 弹幕消息
 */
export interface IBarragerMsg {
  /**
   * 用户名
   */
  userName: string,
  /**
   * 用户昵称
   */
  userNickname: string,
  /**
   * 弹幕内容
   */
  barragerContent: string,
  /**
   * 弹幕颜色
   */
  barragerColor: string,
  /**
   * 用户头像地址
   */
  userAvatarURL: string,
  /**
   * 用户头像地址 20x20
   */
  userAvatarURL20: string,
  /**
   * 用户头像地址 48x48
   */
  userAvatarURL48 : string,
  /**
   * 用户头像地址 210x210
   */
  userAvatarURL210: string,
}

/**
 * 在线用户消息
 */
export interface IOnlineMsg {
  /**
   * 用户首页
   */
  homePage: string,
  /**
   * 用户头像
   */
  userAvatarURL: string,
  /**
   * 用户名
   */
  userName: string,
}

/**
 * 主题修改消息，主题内容
 */
export type discussMsg = string

/**
 * 撤回消息，被撤回消息的 oId
 */
export type RevokeMsg = string
