import { IResponseData } from "../../libs/http";

/**
 * 预注册账户信息
 */
export class PreRegisterInfo {
  /**
   * 用户名
   */
  username: string;
  /**
   * 手机号
   */
  phone: string;
  /**
   * 邀请码
   */
  invitecode?: string;
  /**
   * 验证码
   */
  captcha: string;

  constructor(data: Record<string, string> = {}) {
    this.username = data['username'] || '';
    this.phone = data['phone'] || '';
    this.invitecode = data['invitecode'] || '';
    this.captcha = data['captcha'] || '';
  }
}

/**
 * 注册账户信息
 */
export class RegisterInfo {
  /**
   * 用户角色
   */
  role: string;
  /**
   * 用户密码
   */
  passwd: string;
  /**
   * 用户 Id
   */
  userId: string;
  /**
   * 邀请人用户名
   */
  r?: string;

  constructor(data: Record<string, string> = {}) {
    this.role = data['role'] || '';
    this.passwd = data['passwd'] || '';
    this.userId = data['userId'] || '';
    this.r = data['r'] || '';
  }
}

export interface IUserQuery {
  /**
   * 用户名
   */
  username: string;
}

export class AtUser {
  /**
   * 用户名
   */
  userName: string;
  /**
   * 用户头像
   */
  userAvatarURL: string;
  /**
   * 全小写用户名
   */
  userNameLowerCase: string;

  constructor(data: Record<string, string> = {}) {
    this.userName = data['userName'] || '';
    this.userAvatarURL = data['userAvatarURL'] || '';
    this.userNameLowerCase = data['userNameLowerCase'] || '';
  }
}

export class UserLite {
  /**
   * 用户名
   */
  userName: string;
  /**
   * 用户昵称
   */
  userNickname: string;

  constructor(data: Record<string, string> = {}) {
    this.userName = data['userName'] || '';
    this.userNickname = data['userNickname'] || '';
  }
}

/**
 * 举报数据类型
 */
export enum ReportDataType {
  /**
   * 文章
   */
  article = 0,
  /**
   * 评论
   */
  comment = 1,
  /**
   * 用户
   */
  user = 2,
  /**
   * 聊天消息
   */
  chatroom = 3,
}

/**
 * 举报类型
 */
export enum ReportType {
  /**
   * 垃圾广告
   */
  advertise = 0,
  /**
   * 色情
   */
  porn = 1,
  /**
   * 违规
   */
  violate = 2,
  /**
   * 侵权
   */
  infringement = 3,
  /**
   * 人身攻击
   */
  attacks = 4,
  /**
   * 冒充他人账号
   */
  impersonate = 5,
  /**
   * 垃圾广告账号
   */
  advertisingAccount = 6,
  /**
   * 违规泄露个人信息
   */
  leakPrivacy = 7,
  /**
   * 其它
   */
  other = 8
}

/**
 * 举报接口数据
 */
export class Report {
  /**
   * 举报对象的 oId
   */
  reportDataId: string;
  /**
   * 举报数据的类型
   */
  reportDataType: ReportDataType;
  /**
   * 举报的类型
   */
  reportType: ReportType;
  /**
   * 举报的理由
   */
  reportMemo: string;

  constructor(data: Record<string, string> = {}) {
    this.reportDataId = data['reportDataId'] || '';
    this.reportDataType = Number(data['reportDataType']);
    this.reportType = Number(data['reportType']);
    this.reportMemo = data['reportMemo'] || '';
  }
}

export interface IPageParam {
  page: number;
  pageSize: number;
}

export interface ILog {
  /**
   * 操作时间
   */
  key1: string;
  /**
   * IP
   */
  key2: string;
  /**
   * 内容
   */
  data: string;
  /**
   * 是否公开
   */
  public: boolean;
  /**
   * 操作类型
   */
  key3: string;
  /**
   * 唯一标识
   */
  oId: string;
  /**
   * 类型
   */
  type: string;
}

export interface IToken {
  apiKey: string;
}

/**
 * 登录信息
 */
export interface IAccount {
  /**
   * 用户名
   */
  nameOrEmail: string;

  /**
   * 密码
   */
  userPassword: string;

  /**
   * 二次验证码，非必填
   */
  mfaCode?: string;
}

export interface ILoginRsp extends IResponseData {
  Key: string;
}

export interface IUploadInfo {
  /**
   * 上传失败文件
   */
  errFiles: Array<string>;

  /**
   * 上传成功文件
   */
  succMap: Record<string, string>;
}

export interface IUploadFile {
  /**
   * 文件名
   */
  name: string;
  /**
   * 文件内容
   */
  url: string;
}

export class UploadInfo {
  /**
   * 上传失败文件
   */
  errFiles: Array<string>;
  /**
   * 上传成功文件
   */
  succFiles: Array<IUploadFile>;

  constructor(data: IUploadInfo) {
    this.errFiles = data.errFiles;
    this.succFiles = Object.keys(data.succMap).map(key => {
      return {
        name: key,
        url: data.succMap[key]
      } as IUploadFile;
    });
  }
}

export interface IRegisterUserId extends IResponseData {
  userId: string;
}