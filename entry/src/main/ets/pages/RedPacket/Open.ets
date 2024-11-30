import Fishpi from "../../service/fishpi";
import { AppStorageV2, LengthMetrics } from "@kit.ArkUI";
import {
  GestureType,
  IRedPacketGot,
  RedPacketInfo,
  redPacketMsg,
  redPacketName,
  RedPacketType
} from "../../service/types/redpacket";
import { CircleIcon } from "../../components/CircleIcon";
import { toast } from "../../libs/utils";
import { LogUtil } from "@pura/harmony-utils";

export interface IRedPacketOpen {
  oId: string;
  type?: RedPacketType;
  gesture?: GestureType;
}

@Builder
export function RedPacketOpenBuilder(name: string, param: IRedPacketOpen) {
  RedPacketOpen({ oId: param.oId, type: param.type, gestureType: param.gesture })
}

@ComponentV2
export struct RedPacketOpen {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Require @Param oId: string;
  @Param type: RedPacketType = RedPacketType.Random;
  @Require @Param gestureType: GestureType;
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Local data: RedPacketInfo = new RedPacketInfo();
  @Local date: Date = new Date();
  redPacketTypes: string[] = [
    RedPacketType.Random,
    RedPacketType.Average,
    RedPacketType.Specify,
    RedPacketType.Heartbeat,
    RedPacketType.RockPaperScissors,
  ]
  redPacketNames: string[] = [
    redPacketName[RedPacketType.Random],
    redPacketName[RedPacketType.Average],
    redPacketName[RedPacketType.Specify],
    redPacketName[RedPacketType.Heartbeat],
    redPacketName[RedPacketType.RockPaperScissors],
  ]

  @Computed
  get current() {
    return this.fishpi.user.me;
  }

  @Computed
  get isSpecify() {
    return this.type == RedPacketType.Specify;
  }

  @Computed
  get isRockPaperScissors() {
    return this.type == RedPacketType.RockPaperScissors;
  }

  @Computed
  get rockPaperScissorsTitle() {
    if (!this.isRockPaperScissors) {
      return '';
    }
    if (this.data.userName == this.current?.userName
      && this.data.who.length > 0) {
      return this.data.who[0].userMoney > 0 ? '猜拳落败！😭' :
        this.data.who[0].userMoney == 0 ? '打成平手🤣' : '猜拳胜利！✌'
    } else if (this.data.userName == this.current?.userName) {
      return '还没人猜...'
    }
    if (this.data.who.length > 0
      && this.data.who[0].userName == this.current?.userName) {
      return this.data.who[0].userMoney > 0 ? '猜拳胜利！✌' :
        this.data.who[0].userMoney == 0 ? '打成平手🤣' : '猜拳落败！😭'
    }

    return "错过一个亿";
  }

  @Computed
  get money() {
    let money = this.data.who.find(
      (w) => w.userName == this.fishpi.user.me?.userName
    );
    return money?.userMoney;
  }

  @Computed
  get today() {
    return `${this.date.getFullYear()}-${this.date.getMonth() + 1}-${this.date.getDate()} `;
  }

  @Computed
  get redpacketTitle() {
    let money = this.money;
    let specify = (this.isSpecify && this.data.recivers.indexOf(this.fishpi.user.me?.userName || '') >= 0)
    let msg: string;
    if (this.isSpecify && !specify) {
      msg = "会错意了"
    } else if (this.isRockPaperScissors) {
      msg = this.rockPaperScissorsTitle;
    } else if (money == undefined) {
      msg = "错过一个亿";
    } else {
      msg = money == 0
        ? "抢了个寂寞"
        : ``;
    }

    return msg
  }

  isMaxRedpacket(who: IRedPacketGot) {
    return who.userMoney > 0 && Math.max(...this.data.who.map(a => a.userMoney)) == who.userMoney &&
      this.data.got == this.data.count;
  }

  aboutToAppear() {
    this.fishpi.redPacket.open(this.oId, this.gestureType)
      .then((res) => {
        this.data = res;
        LogUtil.info('redPacket.open', this.oId)
      })
      .catch((err: Error) => {
        LogUtil.error('redPacket.open', err.message)
        toast(err.message)
        this.pathStack.pop(false);
      })
  }

  @Builder
  menusBuilder() {
    Row() {
      Text('...')
    }
  }

  @Builder
  titleBuilder() {
    Row() {
      CircleIcon({
        icon: this.data.userAvatarURL,
        iconSize: 32
      })
      Text(this.data.userName + ' 的红包')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#fff')
        .margin({ left: 5 })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .height('100%')
    .width('80%')
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          Stack() {
            Column()
              .backgroundColor("#f45e4d")
              .borderRadius('300%')
              .border({ width: 4, color: '#f1ca74' })
              .size({
                width: '250%',
                height: '200%'
              })
              .position({
                top: '-195%',
                left: '-75%'
              })
            Flex({
              direction: FlexDirection.Column,
              alignItems: ItemAlign.Center
            }) {
              if (this.money) {
                Row() {
                  Text(this.money + '')
                    .fontSize(60)
                    .fontColor('#cfaa75')
                    .fontWeight(FontWeight.Bold)
                    .textAlign(TextAlign.Center)
                    .margin({ right: 5 })
                  Text('积分')
                    .fontSize(16)
                    .fontColor('#cfaa75')
                    .fontWeight(FontWeight.Bold)
                    .textAlign(TextAlign.Center)
                    .margin({ top: 10 })
                }.alignItems(VerticalAlign.Bottom)
                　.justifyContent(FlexAlign.Center)
              } else {
                Text(this.redpacketTitle)
                  .fontSize(60)
                  .fontColor('#cfaa75')
                  .textAlign(TextAlign.Center)
                  .width('100%')
                  .margin({ top: 10, bottom: 10 })
              }
              Text(this.data.msg)
                .fontSize(14)
                .fontColor('#b0b0b0')
                .textAlign(TextAlign.Center)
                .width('100%')
                .margin({ top: 10, bottom: 10 })
              Row().width('100%').backgroundColor('#f8f8f8').height(10).margin({ top: 10, bottom: 10 })
              Text(`已领取 ${this.data.got} / ${this.data.count} 个`)
                .fontColor('#b0b0b0')
                .fontSize(12)
                .textAlign(TextAlign.Start)
                .width('100%')
                .padding({ left: 10 })
              Divider().width('90%').color('#cdcdcd').margin({ top: 10, bottom: 10 })
              List() {
                ForEach(this.data.who, (who: IRedPacketGot, index) => {
                  ListItem() {
                    Flex({
                      alignItems: ItemAlign.Center
                    }) {
                      CircleIcon({
                        icon: who.avatar,
                        iconSize: 50
                      }).flexBasis(50)
                      Flex({
                        direction: FlexDirection.Column,
                        justifyContent: FlexAlign.SpaceBetween
                      }) {
                        Row() {
                          Text(who.userName)
                            .fontSize(20)
                            .fontColor('#000')
                            .margin({ left: 10 })
                          Text(who.userMoney + ' 积分')
                            .fontSize(20)
                            .fontColor('#000')
                            .margin({ left: 10 })
                        }.justifyContent(FlexAlign.SpaceBetween).width('100%')

                        Row() {
                          Text(who.time.replaceAll(this.today, ''))
                            .fontSize(14)
                            .fontColor('#b0b0b0')
                            .margin({ left: 10 })
                          if (this.isMaxRedpacket(who)) {
                            Text('来自老王的认可')
                              .fontSize(12)
                              .fontColor('#fff')
                              .margin({ left: 10 })
                              .backgroundColor('#60b044')
                              .padding(5)
                              .borderRadius(5)
                          }
                          if (who.userMoney == 0) {
                            Text('0溢事件')
                              .fontSize(12)
                              .fontColor('#f45e4d')
                              .margin({ left: 10 })
                              .backgroundColor('#fff')
                              .padding(5)
                              .borderRadius(5)
                              .border({ width: 1, color: '#f45e4d' })
                          }
                        }.justifyContent(FlexAlign.SpaceBetween).width('100%')
                      }.width('100%').padding({
                        left: 10, right: 10
                      })
                    }
                    .margin(10)
                    .height(50)
                  }
                })
              }.height('100%').width('100%')
            }
            .margin({ top: '15%' })
            .height('90%')
          }
          .align(Alignment.Top)
          .height('100%')
        }
        .backgroundColor('#fff')
        .height('100%')
      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .title(this.titleBuilder)
    .backgroundColor('#fff')
  }
}