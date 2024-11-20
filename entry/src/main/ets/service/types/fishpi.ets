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