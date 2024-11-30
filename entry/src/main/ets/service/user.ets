import defHttp, { IResponseData } from  '../libs/http';
import { IToken } from './types/fishpi';
import { IUserInfo, Metal, ILiveness, ICheckIn, ICollectedYesterdayLivenessReward,
  IRewardLiveness } from './types/user';


export class User {
  private token: string = '';
  private user?: IUserInfo;

  constructor(token?: string) {
    if (!token) return;
    this.setToken(token);
  }

  setToken(token: string) {
    this.token = token;
    return this.info().then(user => this.user = user);
  }

  get me() {
    return this.user;
  }

  /**
   * 返回登录账户信息，需要先登录或设置有效的 api key
   * @returns 用户信息
   */
  info() {
    return defHttp.get<IUserInfo>('/api/user', {
        params: { apiKey: this.token } as IToken
      }).then(res => {
        res.metalList = Metal.toMetal(res.sysMetal);
        return res;
      })
  }

  /**
   * 查询登录用户常用表情
   * @returns 常用表情列表
   */
  emotions() {
    return defHttp.get<object>('/users/emotions', {
      params: { apiKey: this.token } as IToken
    }).then((res) => Object.keys(res))
  }

  /**
   * 查询登录用户当前活跃度，请求频率请控制在 30 ~ 60 秒一次
   * @returns 活跃度
   */
  liveness() {
    return defHttp.get<ILiveness>('/user/liveness', {
      params: { apiKey: this.token } as IToken
    }).then((res) => res.liveness)
  }

  /**
   * 检查登录用户是否已经签到
   * @returns 是否已经签到
   */
  isCheckin() {
    return defHttp.get<ICheckIn>('/user/checkedIn', {
      params: { apiKey: this.token } as IToken
    }).then(res => res.checkedIn || false)
  }

  /**
   * 检查登录用户是否已经领取昨日活跃奖励
   * @returns 是否已经领取昨日活跃奖励
   */
  isCollectedLiveness() {
    return defHttp.get<ICollectedYesterdayLivenessReward>('/api/activity/is-collected-liveness', {
      params: { apiKey: this.token } as IToken
    }).then(res => res.isCollectedYesterdayLivenessReward || false)
  }

  /**
   * 领取昨日活跃度奖励
   * @returns 领取的奖励积分
   */
  rewardLiveness() {
    return defHttp.get<IRewardLiveness>('/activity/yesterday-liveness-reward-api', {
      params: { apiKey: this.token } as IToken
    }).then(res => res.sum || 0)
  }

  /**
   * 转账
   * @param userName 转账目标用户名
   * @param amount 转账金额
   * @param memo 转账备注
   * @returns 转账结果
   */
  transfer(userName: string, amount: number, memo: string) {
    return defHttp.post<IResponseData>('/point/transfer', {
      data: {
        apiKey: this.token,
        userName,
        amount,
        memo
      }
    }).then(() => '转账成功').catch((err: Error) => err.message)
  }
}

export default User;