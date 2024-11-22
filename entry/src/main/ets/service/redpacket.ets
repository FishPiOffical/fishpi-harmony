import defHttp from "../libs/http";
import { Chatroom } from "./chatroom";
import { IRedPacketMessage, GestureType, IRedPacketRsp, RedPacketInfo } from './types/redpacket';

export class RedPacket {
  private token: string = '';

  constructor(token?: string) {
    if (!token) return;
    this.setToken(token);
  }

  setToken(token: string) {
    this.token = token;
  }

  /**
   * 打开一个红包
   * @param oId 红包消息 Id
   * @param gesture 猜拳类型
   * @returns 红包信息
   */
  open(oId: string, gesture?: GestureType) {
    return defHttp.post<IRedPacketRsp>('/chat-room/red-packet/open', {
      data: {
        oId,
        gesture,
        apiKey: this.token
      }
    }).then((res) => new RedPacketInfo(res))
  };

  /**
   * 发送一个红包
   * @param data 红包对象
   * @returns 是否发送成功
   */
  send(data: IRedPacketMessage): Promise<boolean> {
    return new Chatroom(this.token).send(`[redpacket]${JSON.stringify(data)}[/redpacket]`)
  }
}