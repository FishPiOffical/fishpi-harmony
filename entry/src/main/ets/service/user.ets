import defHttp from  '../libs/http';
import { IToken } from './fishpi';
import { IUserInfo, Metal } from './types/user';

export class User {
  private token: string = '';

  constructor(token?: string) {
    if (!token) return;
    this.setToken(token);
  }

  setToken(token: string) {
    this.token = token;
  }

  info() {
    return defHttp.get<IUserInfo>('/api/user', {
        params: { apiKey: this.token } as IToken
      }).then(res => {
        res.metalList = Metal.toMetal(res.sysMetal);
        return res;
      })
  }
}

export default User;