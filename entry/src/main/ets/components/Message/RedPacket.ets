import { GestureType, IRedPacketMessage, redPacketName, RedPacketType } from "../../service/types/redpacket";
import { Icon } from "../Icon";
import { AppStorageV2, LengthMetrics } from "@kit.ArkUI";
import Fishpi from "../../service/fishpi";

@ComponentV2
export struct RedPacketRender {
  @Require @Param data: IRedPacketMessage;
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Event onOpen: (gesture?: GestureType) => void = () => {
  };

  @Computed
  get isRockPaperScissors() {
    return this.data.type == RedPacketType.RockPaperScissors;
  }

  @Computed
  get isRead() {
    return this.data.count == this.data.got || this.data.who?.some(w => w.userName == this.fishpi.user.me?.userName);
  }

  @Computed get isSelf() {
    return this.fishpi.user.me?.oId == this.data.senderId
  }

  build() {
    Row() {
      Flex({
        alignItems: ItemAlign.Center
      })
      {
        Flex({
          direction: FlexDirection.Column,
        }) {
          Flex({
            alignItems: ItemAlign.Center
          }) {
            Icon({
              icon: $r('app.media.redpack'),
              color: null,
              stroke: null,
              iconSize: 40,
            })
              .margin({ left: 5, right: 5 })
            Text(this.data.msg)
              .textOverflow({
                overflow: TextOverflow.Ellipsis
              })
              .maxLines(1)
              .fontColor('#fff')
              .fontWeight(FontWeight.Bold)
              .fontSize(18)
          }
          .padding({ bottom: 5, top: 5 })
          .border({ color: '#fff', width: { bottom: 0.5 } })

          Flex({
            justifyContent: FlexAlign.SpaceBetween,
            alignItems: ItemAlign.Center
          }) {
            Text(redPacketName[this.data.type]).fontColor(this.isRead ? '#fff' : '#ffd991').width('50%').fontSize(12)
            Flex({
              justifyContent: FlexAlign.End,
              alignItems: ItemAlign.Center,
              space: { main: LengthMetrics.px(5) }
            }) {
              Icon({
                icon: $r('app.media.money'),
                color: null,
                stroke: null,
                iconSize: 13,
              }).margin({ bottom: 4 })
              Text(this.data.money.toString()).fontColor($r('sys.color.white')).fontSize(12)
            }.width('50%')
          }.width('100%').padding(2)
        }
        .borderRadius(10)
        .padding({
          top: 5,
          left: 8,
          right: 8,
          bottom: 2
        })
        .backgroundColor(this.isRead ? '#fecd41' : '#FF9900')
        .width('100%')
        .onClick(() => {
          if (!this.isRockPaperScissors || this.isRead) {
            this.onOpen();
          }
        })
      }
      .border({
        color: '#F95A2C',
        width: 1
      })
      .backgroundColor('#F95A2C')
      .borderRadius(10)
      .padding({ bottom: 5 })
      .width('80%')
      .constraintSize({
        maxWidth: 250
      })
      .margin({ bottom: 5 })

      if (this.isRockPaperScissors && !this.isRead && !this.isSelf) {
        Stack({
          alignContent: Alignment.Start
        }) {
          Button() {
            Icon({
              icon: $r('app.media.rock'),
              color: null,
              stroke: null,
              iconSize: 40,
            })
          }.position({ bottom: 40, left: 0 }).onClick(() => {
            this.onOpen(GestureType.Rock);
          })

          Button() {
            Icon({
              icon: $r('app.media.scissors'),
              color: null,
              stroke: null,
              iconSize: 40,
            })
          }.position({ left: 20 }).onClick(() => {
            this.onOpen(GestureType.Scissors);
          })

          Button() {
            Icon({
              icon: $r('app.media.paper'),
              color: null,
              stroke: null,
              iconSize: 40,
            })
          }.position({ top: 40, left: 0 }).onClick(() => {
            this.onOpen(GestureType.Paper);
          })
        }
        .width("20%")
      }
    }.reverse(this.isSelf)
  }
}