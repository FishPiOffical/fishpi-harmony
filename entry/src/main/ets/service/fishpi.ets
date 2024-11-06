import defHttp, { IKeyVal, IResponseData } from '../libs/http';
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

export class Fishpi {
  private token: string = '';
  user: User = new User();

  constructor(token?: string) {
    if (!token) {
      return;
    }
    this.setToken(token);
  }

  setToken(token: string) {
    this.token = token;
    this.user.setToken(token);
    return token
  }

  /**
   * 登录账号返回 API Key
   * @param data 用户账密
   */
  login(data: IAccount) {
      return defHttp.post<ILoginRsp>('/api/getKey', {
        data
      }).then((res): string => this.setToken(res.Key));
  }


  /**
   * 上传文件
   * @param files 要上传的文件，如果是在 Node 使用，则传入文件路径数组，若是在浏览器使用，则传入文件对象数组。
   */
  async upload(files: string[]) {
    try {
      const rsp = await defHttp.upload<UploadInfo>('/upload', files.map((file) => ({ key: 'file[]', value: file } as IKeyVal)), {
        'apiKey': this.token
      });

      return rsp;
    } catch (e) {
      throw (e as Error);
    }
  }
}

export default Fishpi;