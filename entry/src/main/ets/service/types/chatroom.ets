import { IRedPacketMessage, IRedPacketStatusMsg } from "./redpacket";
import { Metal, MetalList } from "./user";

export interface IChatroomQuery {
  apiKey: string;
  type: ChatContentType;
  page?: number;
  mode?: ChatMessageMode;
  size?: number;
  oId?: string;
}

export interface IChatroomSend {
  apiKey: string;
  content: string;
  client: string;
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
   * Golang 插件
   */
  Harmony = 'Harmony',
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

export type ExtendsType = IRedPacketMessage | IWeatherMsg | IMusicMsg;

export class ChatRoomMessage implements IChatRoomMessageRsp {
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
  /**
   * 消息来源解析
   */
  via: IChatVia;

  /**
   * 用户勋章列表
   */
  metalList: MetalList;

  /**
   * 扩展消息内容
   */
  extends?: ExtendsType;
  /**
   * 消息类型
   */
  type: ChatRoomMessageType;

  constructor(data?: IChatRoomMessageRsp | IMessageEvent) {
    this.oId = data?.oId ?? '';
    this.userOId = data?.userOId ?? '';
    this.userName = data?.userName ?? '';
    this.userNickname = data?.userNickname ?? '';
    this.userAvatarURL = data?.userAvatarURL ?? '';
    this.sysMetal = data?.sysMetal ?? '';
    this.client = data?.client ?? '';
    this.content = data?.content ?? '';
    this.md = data?.md ?? '';
    this.time = data?.time ?? '';
    this.type = ChatRoomMessageType.msg;
    const clients = this.client.split('/');
    this.via = {
      client: clients[0] as ClientType || ClientType.Other,
      version: clients[1] || 'unknown'
    };
    this.metalList = Metal.toMetal(this.sysMetal);

    if (!data?.content) return;
    try {
      const extend: ExtendsType = JSON.parse(data.content);
      if (extend.msgType == 'redPacket' && extend.recivers && typeof extend.recivers == 'string') {
        try { extend.recivers = JSON.parse(extend.recivers); } catch (_) { }
      }
      this.extends = extend;
      if (extend.msgType == 'redPacket') {
        this.content = '[收到一个红包]'
        this.type = ChatRoomMessageType.redPacket;
      } else if (extend.msgType == 'weather') {
        this.content = '[收到一个天气卡片]'
        this.type = ChatRoomMessageType.weather;
      } else if (extend.msgType == 'music') {
        this.content = '[收到一个音乐卡片]'
        this.type = ChatRoomMessageType.music;
      }
    } catch (e) {}
  }

  get redPacket() {
    if (this.type == ChatRoomMessageType.redPacket) {
      return this.extends as IRedPacketMessage;
    }
    return null;
  }
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
export enum ChatMessageMode {
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
  /**
   * 天气
   */
  weather = 'weather',
  /**
   * 音乐
   */
  music = 'music',
}

/**
 * 聊天室消息
 */
export class ChatRoomMessageData {
  /**
   * 消息类型，
   */
  type: ChatRoomMessageType;
  /**
   * 消息内容
   */
  data: MessageData;

  constructor(type: ChatRoomMessageType, data: MessageData) {
    this.type = type;
    this.data = data;
  }

  get onlineList() {
    if (this.type != ChatRoomMessageType.online) return [];
    return this.data as IOnlineMsg[];
  }

  get discuss() {
    if (this.type != ChatRoomMessageType.discussChanged) return '';
    return this.data as discussMsg;
  }

  get revoke() {
    if (this.type != ChatRoomMessageType.revoke) return '';
    return this.data as RevokeMsg;
  }

  get message() {
    if (![ChatRoomMessageType.msg, ChatRoomMessageType.redPacket, ChatRoomMessageType.weather, ChatRoomMessageType.music].includes(this.type))
      return new ChatRoomMessage();
    return this.data as ChatRoomMessage;
  }

  get redPacketStatus() {
    if (this.type != ChatRoomMessageType.redPacketStatus) return null;
    return this.data as IRedPacketStatusMsg;
  }

  get barrager() {
    if (this.type != ChatRoomMessageType.barrager) return null;
    return this.data as IBarragerMsg;
  }

  get custom() {
    if (this.type != ChatRoomMessageType.custom) return '';
    return this.data as ICustomMsg;
  }

}

export type MessageData = IOnlineMsg[] | discussMsg | RevokeMsg | ChatRoomMessage | IRedPacketStatusMsg | IBarragerMsg | ICustomMsg;

export type ChatroomListener = (data: ChatRoomMessageData) => void;

export interface IMessageEvent extends IRedPacketStatusMsg, IBarragerMsg {
  /**
   * 消息类型，
   */
  type: ChatRoomMessageType;

  /**
   * 在线用户
   */
  users: IOnlineMsg[];

  /**
   * 话题
   */
  discussing: discussMsg;

  /**
   * 新话题
   */
  newDiscuss: discussMsg;

  /**
   * 用户 Id
   */
  userOId: string;

  /**
   * 时间
   */
  time: string;

  /**
   * 用户名
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
   * 消息内容
   */
  content: string;

  /**
   * 消息内容 Markdown
   */
  md: string;

  /**
   * 消息来源
   */
  client: string;

  /**
   * 进出场消息
   */
  message: string;

  /**
   * 用户徽章
   */
  sysMetal: string;
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

/**
 * 禁言用户信息
 */
export interface IMuteItem {
  /**
   * 解除禁言时间戳
   */
  time: number;
  /**
   * 用户头像
   */
  userAvatarURL: string;
  /**
   * 用户名
   */
  userName: string;
  /**
   * 用户昵称
   */
  userNickname: string;
}

export interface IMusicMsg {
  msgType: 'music';
  /**
   * 音乐标题
   */
  title: string;
  /**
   * 来源
   */
  form: string;
  /**
   * 音乐封面
   */
  coverURL: string;
  /**
   * 音乐链接
   */
  source: string;
}

export interface IWeatherMsg {
  msgType: 'weather';
  /**
   * 天气城市
   */
  t: string;
  /**
   * 天气
   */
  st: string;
  /**
   * 日期
   */
  date: string;
  /**
   * 最低温
   */
  min: string;
  /**
   * 最高温
   */
  max: string;
  /**
   * 天气代码
   */
  weatherCode: string;
}
export interface IChatroomNode {
  node: string;
  name: string;
  weight?: number;
  online?: number;
}

export interface IChatroomNodeData {
  data: string;
  msg: string;
  avaliable: IChatroomNode[];
}

export interface IChatroomNodeInfo {
  recommend: IChatroomNode;
  avaliable: IChatroomNode[];
}