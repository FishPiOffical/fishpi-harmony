import { ChatRoomMessage, ChatRoomMessageData, ChatRoomMessageType,
  IMusicMsg,
  IWeatherMsg } from "../../service/types/chatroom"
import { IRedPacketMessage, GestureType } from "../../service/types/redpacket";
import { CircleIcon } from "../CircleIcon";
import { MsgContent } from "./Content";
import { RedPacketRender } from "./RedPacket";
import { LengthMetrics } from "@kit.ArkUI";
import { WeatherRender } from "./Weather";
import { MusicRender } from "./Music";
import { IChatData } from "../../service/types/chat";

@ComponentV2
export struct ChatRender {
  @Require @Param data: IChatData;
  @Local date: Date = new Date();

  @Computed
  get avatar() {
    return this.data.senderAvatar;
  }

  @Computed
  get message() {
    return this.data.markdown;
  }

  @Computed
  get time() {
    return this.data.time;
  }

  @Computed
  get today() {
    return `${this.date.getFullYear()}-${this.date.getMonth() + 1}-${this.date.getDate()} `;
  }

  build() {
    Flex({
      alignItems: ItemAlign.Start
    }) {
      CircleIcon({
          icon: this.avatar,
        }).width(48)
          .margin({ right: 5, top: 2 })
        Column() {
          MsgContent({
              message: this.message
            })
              .margin({ bottom: 5 })
          Text(this.time.replaceAll(this.today, ''))
            .fontColor('#9FA4B4')
            .fontSize(12)
            .margin({ left: 5 })
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 10 })
        .width('100%')
    }
    .margin({ left: 10, right: 10, top: 5 })
  }
}