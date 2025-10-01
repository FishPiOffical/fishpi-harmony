import { AppStorageV2 } from '@kit.ArkUI';
import { CircleIcon } from '../../components/CircleIcon';
import { Icon } from '../../components/Icon';
import { toast } from '../../libs/utils';
import { RedPacketMessage } from '../../service';
import Fishpi from '../../service/fishpi'
import { IOnlineMsg } from '../../service/types/chatroom';
import { GestureType, redPacketMsg, redPacketName, RedPacketType } from '../../service/types/redpacket';
import { Field } from './Field';


@Builder
export function RedPacketBuilder(name: string, param: Object) {
  RedPacket()
}

@ComponentV2
export struct RedPacket {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Local redPacket: RedPacketMessage = new RedPacketMessage();
  @Local selectType: boolean = false;
  @Local selectUser: boolean = false;
  @Local onlines: IOnlineMsg[] = this.fishpi.chatroom.onlineList;
  @Local controller: TextAreaController = new TextAreaController();
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

  aboutToAppear() {
  }

  @Builder
  menuBuilder() {
    Row()
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
                width: '200%',
                height: '200%'
              })
              .position({
                top: '-185%',
                left: '-50%'
              })
            Row() {
              Text('发个 ')
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
                .fontColor('#f1ca74')
              Text(redPacketName[this.redPacket.type])
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
                .fontColor('#f1ca74')
                .align(Alignment.Center)
              Icon({
                icon: $r('app.media.down_fill'),
                iconSize: 25,
                color: '#f1ca74',
                stroke: Color.Transparent
              })
              Text('红包')
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
                .fontColor('#f1ca74')
            }.margin({ top: '5%' })
            .onClick(() => {
              this.selectType = !this.selectType;
              this.controller.stopEditing();
            })

            Flex({
              direction: FlexDirection.Column,
              justifyContent: FlexAlign.SpaceBetween,
            }) {
              Flex({
                direction: FlexDirection.Column,
              }) {

                if (this.redPacket.type != RedPacketType.RockPaperScissors &&
                  this.redPacket.type != RedPacketType.Specify) {
                  Field({
                    label: '红包个数',
                    placeholder: '填写个数',
                    value: this.redPacket.count!!,
                    icon: $r('app.media.redpack'),
                    unit: '个',
                    controller: this.controller,
                  })
                } else if (this.redPacket.type == RedPacketType.RockPaperScissors) {
                  Row() {
                    Image($r('app.media.rock'))
                      .size({ width: 80, height: 80 })
                      .margin(10)
                      .renderMode(this.redPacket.gesture == GestureType.Rock ? ImageRenderMode.Original :
                      ImageRenderMode.Template)
                      .onClick(() => {
                        this.redPacket.gesture = GestureType.Rock;
                        this.controller.stopEditing();
                      })
                    Image($r('app.media.scissors'))
                      .size({ width: 80, height: 80 })
                      .margin(10)
                      .renderMode(this.redPacket.gesture == GestureType.Scissors ? ImageRenderMode.Original :
                      ImageRenderMode.Template)
                      .onClick(() => {
                        this.redPacket.gesture = GestureType.Scissors;
                        this.controller.stopEditing();
                      })
                    Image($r('app.media.paper'))
                      .size({ width: 80, height: 80 })
                      .margin(10)
                      .renderMode(this.redPacket.gesture == GestureType.Paper ? ImageRenderMode.Original :
                      ImageRenderMode.Template)
                      .onClick(() => {
                        this.redPacket.gesture = GestureType.Paper
                        this.controller.stopEditing();
                      })
                  }
                  .justifyContent(FlexAlign.SpaceBetween).width('100%').padding({ left: 10, right: 10 });
                } else if (this.redPacket.type == RedPacketType.Specify) {
                  Field({
                    label: '发给谁',
                    icon: $r('app.media.heart'),
                  }) {
                    Row() {
                      ForEach(this.redPacket.recivers, (item: string) => {
                        CircleIcon({
                          icon: this.onlines.find((online) => online.userName == item)?.userAvatarURL,
                          iconSize: 25,
                        })
                          .margin({ right: 5 })
                          .onClick(() => {
                            this.redPacket.recivers.splice(this.redPacket.recivers.indexOf(item), 1)
                          })
                        Text(item)
                      })

                      Icon({
                        icon: $r('app.media.right'),
                        iconSize: 20,
                        color: null,
                        stroke: null
                      })
                        .margin({ right: 10 })
                    }.onClick(() => {
                      this.selectUser = true;
                    })
                    .justifyContent(FlexAlign.End)
                    .width('100%')
                    .height(40)
                  }
                }
                Field({
                  label: this.redPacket.type == RedPacketType.Average ? '单个积分' : '总积分',
                  value: this.redPacket.money!!,
                  icon: $r('app.media.point'),
                  controller: this.controller,
                })
                Field({
                  placeholder: redPacketMsg[this.redPacket.type],
                  value: this.redPacket.msg!!,
                  area: true,
                  controller: this.controller,
                })
              }
              .width('100%')
              .height('auto')

              Row() {
                Text((this.redPacket.type == RedPacketType.Average ? this.redPacket.money * this.redPacket.count :
                this.redPacket.money) + ' ')
                  .fontSize(40)
                  .textAlign(TextAlign.Center)
                  .fontWeight(FontWeight.Bold)
                Text('积分')
                  .margin({ bottom: 10 })
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Bottom)

              Button('发红包')
                .backgroundColor('#f45e4d')
                .borderRadius(20)
                .onClick(() => {
                  this.fishpi.redPacket.send(this.redPacket.toJSON()).then(() => {
                    this.pathStack.pop();
                  }).catch((e: Error) => {
                    toast(e.message, this.getUIContext())
                  })
                })
                .margin(10)
                .width('100%')

            }.position({
              top: '18%',
              left: '5%',
            })
            .width('90%')
            .height('82%')
          }
          .align(Alignment.Top)
          .height('100%')
        }
        .backgroundColor('#ededed')
        .height('100%')
        .onClick(() => {
          this.selectUser = this.selectType = false;
          this.controller.stopEditing();
        })

        if (this.selectType) {
          TextPicker({
            range: this.redPacketNames,
            selected: this.redPacketTypes.indexOf(this.redPacket.type),
          })
            .onChange((_: string | string[], index: number | number[]) => {
              this.redPacket.type = this.redPacketTypes[index as number] as RedPacketType
            })
            .backgroundColor(Color.White)
            .borderRadius({ topLeft: 20, topRight: 20 })
            .width('100%')
            .onClick(() => {
              this.selectUser = this.selectType = false;
            })
            .selectedTextStyle({
              color: '#f1ca74',
            })
        }
        if (this.selectUser) {
          TextPicker({
            range: this.onlines.map((online) => ({
              icon: online.userAvatarURL,
              text: online.userName
            } as TextPickerRangeContent)),
            selected: this.onlines.findIndex((online) => this.redPacket.recivers.includes(online.userName)),
          })
            .onChange((_: string | string[], index: number | number[]) => {
              this.redPacket.recivers.splice(0, this.redPacket.recivers.length, this.onlines[index as number].userName)
            })
            .backgroundColor(Color.White)
            .borderRadius({ topLeft: 20, topRight: 20 })
            .width('100%')
            .onClick(() => {
              this.selectUser = false;
            })
            .selectedTextStyle({
              color: '#f1ca74',
            })
            .padding({
              left: 20,
              right: 20,
            })
        }
      }

      Row() {
        Text('')
      }.width('100%')
      .backgroundColor(this.selectType ? Color.White : '#ededed')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }

  }
}