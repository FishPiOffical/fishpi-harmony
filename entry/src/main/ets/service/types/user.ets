import { IResponseData } from "../../libs/http";

function analyzeMetalAttr(m: Metal): Metal {
  if (!m) return m;
  if (typeof m.attr != 'string') return m;
  let attr = m.attr.split('&');
  let src = m.attr;
  m.attr = new MetalAttr();
  attr.forEach((a:string) => {
    const keyVal = a.split('=');
    if (keyVal[0] == 'backcolor') (m.attr as MetalAttr).backcolor = keyVal[1];
    if (keyVal[0] == 'fontcolor') (m.attr as MetalAttr).fontcolor = keyVal[1];
  })
  m.url = `https://fishpi.cn/gen?txt=${m.description}&url=${src}`;
  m.icon = `https://fishpi.cn/gen?txt=&${src}`;
  return m;
}

export class MetalAttr {
  /**
   * 徽标图地址
   */
  url: string = '';
  /**
   * 背景色
   */
  backcolor: string = '';
  /**
   * 文字颜色
   */
  fontcolor: string = '';

  constructor(metal?: MetalAttr | string) {
    if (metal && typeof metal != 'string') {
      this.url = metal.url;
      this.backcolor = metal.backcolor;
      this.fontcolor = metal.fontcolor;
    }
  }

  toString() {
    return `url=${this.url}&backcolor=${this.backcolor}&fontcolor=${this.fontcolor}`;
  }
}

export class MetalBase {
  /**
   * 徽章属性
   */
  attr: MetalAttr | string = new MetalAttr();
  /**
   * 徽章名
   */
  name: string = '';
  /**
   * 徽章描述
   */
  description: string = '';
  /**
   * 徽章数据
   */
  data: string = '';

  constructor(metal?: MetalBase) {
    if (!metal) {
      return;
    }
    this.attr = new MetalAttr(metal.attr);
    this.name = metal.name;
    this.description = metal.description;
    this.data = metal.data;
  }

  toUrl(includeText: boolean = true) {
    let url = `https://fishpi.cn/gen?txt=${this.name}&${this.attr.toString()}`;
    if (!includeText) {
      url = `https://fishpi.cn/gen?txt=&${this.attr.toString()}`;
    }
    return url;
  }

  static toMetal(sysMetal: string): MetalList {
    try {
      let metal: Metal[] = JSON.parse(sysMetal).list;
      metal.forEach((m, i, list) => {
        list[i] = analyzeMetalAttr(m);
      })
      return metal;
    } catch (error) {
      return []
    }
  }
}


/**
 * 徽章信息
 */
export class Metal extends MetalBase {
  /**
   * 完整徽章地址（含文字）
   */
  url?: string;
  /**
   * 徽章地址（不含文字）
   */
  icon?: string;
  /**
   * 是否佩戴
   */
  enable: boolean = false;
}

/**
 * 徽章列表
 */
export type MetalList = Metal[];

/**
 * 用户角色
 */
export enum UserAppRole {
  /**
   * 黑客
   */
  Hack = 0,
  /**
   * 画家
   */
  Artist = 1,
}

/**
 * 用户信息
 */
export interface IUserInfo extends IUserInfoRsp {
  /**
   * 用户勋章列表
   */
  metalList: MetalList;
}

export interface IUserInfoRsp {
  /**
   * 用户 id
   */
  oId: string;

  /**
   * 用户编号
   */
  userNo: string;

  /**
   * 用户名
   */
  userName: string;

  /**
   * 昵称
   */
  userNickname: string;

  /**
   * 首页地址
   */
  userURL: string;

  /**
   * 所在城市
   */
  userCity: string,

  /**
   * 签名
   */
  userIntro: string;

  /**
   * 是否在线
   */
  userOnlineFlag: boolean,

  /**
   * 用户积分
   */
  userPoint: number;

  /**
   * 用户组
   */
  userRole: string;

  /**
   * 角色
   */
  userAppRole: UserAppRole;

  /**
   * 用户头像地址
   */
  userAvatarURL: string;

  /**
   * 用户卡片背景
   */
  cardBg: string;

  /**
   * 用户关注数
   */
  followingUserCount: number;

  /**
   * 用户被关注数
   */
  followerCount: number;

  /**
   * 在线时长，单位分钟
   */
  onlineMinute: number;

  /**
   * 是否已经关注，未登录则为 `hide`
   */
  canFollow: 'hide' | 'no' | 'yes';

  /**
   * 用户所有勋章列表，包含未佩戴
   */
  allMetalOwned: MetalList;

  /**
   * 用户勋章列表
   */
  sysMetal: string;
}

export interface ILiveness extends  IResponseData {
  liveness: number;
}

export interface ICheckIn extends IResponseData {
  checkedIn: boolean;
}

export interface ICollectedYesterdayLivenessReward extends IResponseData {
  isCollectedYesterdayLivenessReward: boolean;
}

export interface IRewardLiveness extends IResponseData {
  sum: number;
}