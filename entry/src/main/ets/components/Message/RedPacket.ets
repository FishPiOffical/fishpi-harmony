import { IRedPacketMessage, redPacketName } from "../../service/types/redpacket";
import { Icon } from "../Icon";

@ComponentV2
export struct RedPacketRender {
  @Require @Param data: IRedPacketMessage;

  build() {
    Flex() {
      Flex({
        direction: FlexDirection.Column,
      }) {
        Row() {
          Icon({
            icon: $r('app.media.redpack'),
            color: null,
            stroke: null,
            iconSize: 40,
          })
            .margin({ left: 5, right: 5 })
          Text(this.data.msg).textOverflow({
            overflow: TextOverflow.Ellipsis
          }).maxLines(2)
        }
        .padding(5)
        .border({ color: 0xF95A2C, width: { bottom: 2 } })

        Row() {
          Text(redPacketName[this.data.interface]).fontColor(0xF0D35E)
          Flex() {
            Icon({
              icon: $r('app.media.money'),
              color: null,
              stroke: null,
              iconSize: 15,
            })
            Text(this.data.money.toString()).fontColor(0xffffff)
          }
        }.justifyContent(FlexAlign.SpaceBetween)
      }.backgroundColor(0xFF9900)
    }.backgroundColor(0xF95A2C).border({
      color: 0xF95A2C,
      width: 1,
    }).padding({ bottom: 5 })
    .borderRadius(10)
    .clip(true)
    .width('auto')
  }
}