import { ArticleListType, IArticleQuery } from "./types/article";
import { IBreezemoonQuery } from "./types/breezemoon";
import { GestureType, IRedPacket, RedPacketType } from "./types/redpacket";

@ObservedV2
export class AppData {
  @Trace token: string = '';
  @Trace isFirstLaunch: boolean = true;
  @Trace agreePrivacy: boolean = false;
}

@ObservedV2
export class RedPacketMessage implements IRedPacket {
  /**
   * 红包数
   */
  @Trace count: number = 2;

  /**
   * 内含积分
   */
  @Trace money: number = 32;

  /**
   * 祝福语
   */
  @Trace msg: string = '';

  /**
   * 红包类型
   */
  @Trace type: RedPacketType = RedPacketType.Random;

  /**
   * 接收者，专属红包有效
   */
  @Trace recivers: string[] = [];

  /**
   * 猜拳类型
   */
  @Trace gesture: GestureType = GestureType.Rock;

  toJSON() {
    return {
      count: this.count,
      money: this.money,
      msg: this.msg,
      type: this.type,
      recivers: this.recivers,
      gesture: this.gesture
    } as IRedPacket;
  }
}

export class ChatMessage {

}

@ObservedV2
export class ArticleQuery implements IArticleQuery {
  @Trace
  page: number = 1;
  @Trace
  size: number = 10;
  @Trace
  user?: string;
  @Trace
  tag?: string;
  @Trace
  type: ArticleListType = ArticleListType.Recent;

  toJSON(): IArticleQuery {
    return {
      page: this.page,
      size: this.size,
      user: this.user,
      tag: this.tag,
      type: this.type
    }
  }
}

@ObservedV2
export class BreezemoonQuery implements IBreezemoonQuery {
  @Trace
  page: number = 1;
  @Trace
  size: number = 10;
  @Trace
  user?: string;

  toJSON(): IBreezemoonQuery {
    return {
      page: this.page,
      size: this.size,
      user: this.user,
    }
  }
}