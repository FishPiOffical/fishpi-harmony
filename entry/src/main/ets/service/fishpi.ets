import defHttp, { IKeyVal, IResponseData } from '../libs/http';
import { Chatroom } from './chatroom';
import { AtUser, IUserQuery, PreRegisterInfo, RegisterInfo, UserLite } from './types/fishpi';
import { IUserInfo, Metal } from './types/user';
import User from './user';

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

export interface UploadInfo {
  /**
   * 上传失败文件
   */
  errFiles: Array<string>;

  /**
   * 上传成功文件
   */
  succMap: Record<string, string>;
}

interface IRegisterUserId extends IResponseData {
  userId: string;
}

export class Fishpi {
  private token: string = '';
  user: User = new User();
  chatroom: Chatroom = new Chatroom();

  constructor(token?: string) {
    if (!token) {
      return;
    }
    this.setToken(token);
  }

  setToken(token: string) {
    this.token = token;
    this.user.setToken(token);
    this.chatroom.setToken(token);
    return token
  }

  /**
   * 登录账号返回 API Key
   *
   * @param data 用户账密
   * @returns 返回 API Key
   */
  login(data: IAccount) {
      return defHttp.post<ILoginRsp>('/api/getKey', {
        data
      }).then((res): string => this.setToken(res.Key));
  }

  static get captcha() { return `${defHttp.origin}/captcha` };

  /**
   * 预注册
   *
   * @param `data` 预注册信息
   * @returns 注册成功返回 `true`，失败返回 `false`
   */
  preRegister(data: PreRegisterInfo) {
    return defHttp.post<IResponseData>('/register', {
      data
    }).then(() => true)
      .catch(() => false);
  }

  /**
   * 验证手机验证码
   *
   * @param code 验证码
   * @returns 返回用户 ID
   */
  verify(code: string) {
    return defHttp.post<IRegisterUserId>('/verify', {
      data: {
        code
      }
    }).then((res) => res.userId);
  }

  /**
   * 注册
   *
   * @param data 注册信息
   * @returns 注册成功返回 `true`，失败返回 `false`
   */
  register(data: RegisterInfo) {
    return defHttp.post<IResponseData>('/register2', {
      data
    }).then(() => true)
      .catch(() => false);
  }

  /**
   * 获取用户信息
   *
   * @param username 用户名
   * @returns 用户信息
   */
  getUser(username: string) {
    return defHttp.get<IUserInfo>('/api/getUserInfo', {
      params: {
        username
      } as IUserQuery
    }).then(res => {
      res.metalList = Metal.toMetal(res.sysMetal);
      return res;
    });
  }

  /**
   * 获取用户名联想
   *
   * @param name 用户名
   * @returns 用户名联想列表
   */
  suggests(name: string) {
    return defHttp.post<AtUser[]>('/users/names', {
      data: {
        name
      }
    });
  }

  /**
   * 获取最近注册的 20 个用户
   *
   * @returns 用户列表
   */
  recent() {
    return defHttp.get<UserLite[]>('/api/user/recentReg');
  }

  /**
   * 上传文件
   * @param files 要上传的文件，如果是在 Node 使用，则传入文件路径数组，若是在浏览器使用，则传入文件对象数组。
   */
  upload(files: string[]) {
     return defHttp.upload<UploadInfo>('/upload', files.map((file) => ({ key: 'file[]', value: file } as IKeyVal)), {
        'apiKey': this.token
     });
  }
}

export default Fishpi;