import defHttp, { IKeyVal, IResponseData } from '../libs/http';
import { Article } from './article';
import { Breezemoon } from './breezemoon';
import { Chat } from './chat';
import { Chatroom } from './chatroom';
import { Emoji } from './emoji';
import { Notice } from './notice';
import { RedPacket } from './redpacket';
import {
  AtUser,
  IAccount,
  ILog,
  ILoginRsp,
  IPageParam,
  IRegisterUserId,
  PreRegisterInfo,
  RegisterInfo,
  Report,
  IUploadInfo,
  UserLite,
  UploadInfo,
  IToken
} from './types/fishpi';
import { IUserInfo, Metal } from './types/user';
import User from './user';

export class Fishpi {
  private token: string = '';
  user: User = new User();
  chatroom: Chatroom = new Chatroom();
  redPacket: RedPacket = new RedPacket();
  emoji: Emoji = new Emoji();
  chat: Chat = new Chat();
  breezemoon: Breezemoon = new Breezemoon();
  notice: Notice = new Notice();
  article: Article = new Article();

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
    this.redPacket.setToken(token);
    this.emoji.setToken(token);
    this.chat.setToken(token);
    this.breezemoon.setToken(token);
    this.notice.setToken(token);
    this.article.setToken(token);
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

  static get captcha() {
    return `${defHttp.origin}/captcha`
  };

  /**
   * 预注册
   *
   * @param `data` 预注册信息
   * @returns 注册成功返回 `true`，失败抛出错误
   */
  preRegister(data: PreRegisterInfo) {
    return defHttp.post<IResponseData>('/register', {
      data
    }).then(() => true);
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
   * @returns 注册成功返回 `true`，失败抛出错误
   */
  register(data: RegisterInfo) {
    return defHttp.post<IResponseData>('/register2', {
      data
    }).then(() => true);
  }

  /**
   * 获取用户信息
   *
   * @param username 用户名
   * @returns 用户信息
   */
  getUser(username: string) {
    return defHttp.get<IUserInfo>('/user/' + username, {
      params: {
        apiKey: this.token
      } as IToken
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
    return defHttp.get<UserLite[]>('/api/user/recentReg').then(res => res || []);
  }

  /**
   * 举报
   * @param data 举报信息
   * @returns 举报成功返回 `true`，失败抛出错误
   */
  report(data: Report) {
    return defHttp.post<IResponseData>('/report', {
      data
    }).then(() => true);
  }

  /**
   * 获取操作日志
   * @param page 页码
   * @param pageSize 每页数量
   * @returns 操作日志列表
   */
  getLogs(page: number = 1, pageSize: number = 30) {
    return defHttp.get<ILog[]>('/logs/more', {
      params: {
        page,
        pageSize
      } as IPageParam
    });
  }

  /**
   * 上传文件
   * @param files 要上传的文件，如果是在 Node 使用，则传入文件路径数组，若是在浏览器使用，则传入文件对象数组。
   */
  upload(files: string[]) {
    return defHttp.upload<IUploadInfo>('/upload', files.map((file) => ({ key: 'file[]', value: file } as IKeyVal)), {
      'apiKey': this.token
    }).then(res => new UploadInfo(res));
  }
}

export default Fishpi;