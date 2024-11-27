import { IRedPacketMessage, redPacketName } from "../../service/types/redpacket";
import { Icon } from "../Icon";
import { LengthMetrics } from "@kit.ArkUI";

@ComponentV2
export struct RedPacketRender {
  @Require @Param data: IRedPacketMessage;

  build() {
    Flex() {
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
          Text(this.data.msg).textOverflow({
            overflow: TextOverflow.Ellipsis
          }).maxLines(1).fontColor('#fff').fontWeight(FontWeight.Bold).fontSize(18)
        }
        .padding({ bottom: 5, top: 5 })
        .border({ color: '#fff', width: { bottom: 0.5 } })

        Flex({
          justifyContent: FlexAlign.SpaceBetween,
          alignItems: ItemAlign.Center
        }) {
          Text(redPacketName[this.data.type]).fontColor('#ffd991').width('50%').fontSize(12)
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
            })
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
      .backgroundColor('#FF9900')
      .width('100%')
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

  }
}