/**
 * 猜拳类型
 */
export enum GestureType {
  /**
   * 石头
   */
  Rock = 0,
  /**
   * 剪刀
   */
  Scissors = 1,
  /**
   * 布
   */
  Paper = 2,
}

/**
 * 红包类型
 */
export enum RedPacketType {
  /**
   * 拼手气
   */
  Random = 'random',
  /**
   * 平分
   */
  Average = 'average',
  /**
   * 专属
   */
  Specify = 'specify',
  /**
   * 心跳
   */
  Heartbeat = 'heartbeat',
  /**
   * 猜拳
   */
  RockPaperScissors = 'rockPaperScissors',
}

/**
 * 红包数据
 */
export interface IRedPacket {
  /**
   * 红包类型
   */
  type: RedPacketType;

  /**
   * 红包积分
   */
  money: number;

  /**
   * 红包个数
   */
  count: number;

  /**
   * 祝福语
   */
  msg: string;

  /**
   * 接收者，专属红包有效
   */
  recivers?: Array<string>;

  /**
   * 出拳，猜拳红包有效
   */
  gesture?: GestureType;
}

/**
 * 红包领取者信息
 */
export interface IRedPacketGot {
  /**
   * 用户 id
   */
  userId: string;

  /**
   * 用户名
   */
  userName: string;

  /**
   * 用户头像
   */
  avatar: string;

  /**
   * 领取到的积分
   */
  userMoney: number;

  /**
   * 领取积分时间
   */
  time: string;
}

/**
 * 红包历史信息
 */
export interface IRedPacketMessage {
  /**
   * 消息类型，固定为 redPacket
   */
  msgType: string;

  /**
   * 红包数
   */
  count: number;

  /**
   * 领取数
   */
  got: number;

  /**
   * 内含积分
   */
  money: number;

  /**
   * 祝福语
   */
  msg: string;

  /**
   * 发送者 id
   */
  senderId: string;

  /**
   * 红包类型
   */
  interface: string;

  /**
   * 接收者，专属红包有效
   */
  recivers: string[] | string;

  /**
   * 已领取者列表
   */
  who: IRedPacketGot[]
}

/**
 * 红包信息
 */
export class RedPacketInfo {
  /**
   * 数量
   */
  count: number;

  /**
   * 猜拳类型
   */
  gesture?: GestureType;

  /**
   * 领取数
   */
  got: number;

  /**
   * 祝福语
   */
  msg: string;

  /**
   * 发送者用户名
   */
  userName: string;

  /**
   * 用户头像
   */
  userAvatarURL: string;

  /**
   * 接收者，专属红包有效
   */
  recivers: string[];

  /**
   * 已领取者列表
   */
  who: Array<IRedPacketGot>;

  constructor(data?: IRedPacketRsp) {
    this.count = data?.info.count || 0;
    this.gesture = data?.info.gesture;
    this.got = data?.info.who.length || 0;
    this.msg = data?.info.msg || '';
    this.userName = data?.info.userName || '';
    this.userAvatarURL = data?.info.userAvatarURL || '';
    this.recivers = data?.recivers || [];
    this.who = data?.who || [];
  }
}

/**
 * 红包状态信息
 */
export interface IRedPacketStatusMsg {
  /**
   * 对应红包消息 oId
   */
  oId: string,

  /**
   * 红包个数
   */
  count: number,

  /**
   * 已领取数量
   */
  got: number,

  /**
   * 发送者信息
   */
  whoGive: string,

  /**
   * 领取者信息
   */
  whoGot: IRedPacketGot[],
}

/**
 * 红包信息
 */
export interface IRedPacketRsp {
  /**
   * 红包基本信息
   */
  info: RedPacketInfo;
  /**
   * 接收者，专属红包有效
   */
  recivers: string[];
  /**
   * 已领取者列表
   */
  who: IRedPacketGot[];
}