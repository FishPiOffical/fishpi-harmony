import { ChatRoomMessageData, ChatRoomMessageType } from "../../service/types/chatroom"
import { IRedPacketMessage } from "../../service/types/redpacket";
import { CircleIcon } from "../CircleIcon";
import { MsgContent } from "./Content";
import { RedPacketRender } from "./RedPacket";

@ComponentV2
export struct MessageRender {
  @Require @Param data: ChatRoomMessageData;
  @Local date: Date = new Date();

  @Computed get isMessage() {
    return [ChatRoomMessageType.msg, ChatRoomMessageType.redPacket, ChatRoomMessageType.weather, ChatRoomMessageType.music].includes(this.data.type);
  }

  @Computed get avatar() {
    if (this.isMessage) {
      return this.data.message.userAvatarURL;
    }
    else return '';
  }

  @Computed get user() {
    if (this.isMessage) {
      return this.data.message.userNickname || this.data.message.userName;
    }
    else return '';
  }

  @Computed get message() {
    if ([ChatRoomMessageType.msg].includes(this.data.type)) {
      return this.data.message.content;
    }
    else if (this.data.type === ChatRoomMessageType.barrager) {
      return this.data.barrager?.barragerContent || '';
    }
    else if (this.data.type === ChatRoomMessageType.custom) {
      return this.data.custom || '';
    }
    else return '';
  }

  @Computed get time() {
    if (this.isMessage) {
      return this.data.message.time;
    }
    else return '';  }

  @Computed get today() {
    return `${this.date.getFullYear()}-${this.date.getMonth()}-${this.date.getDate()}`;
  }

  build() {
    Flex() {
      if (this.isMessage) {
        CircleIcon({
          icon: this.avatar,
        }).width(48)
          .margin({ right: 5, top: 20 })
        Column() {
          Row() {
            Text(this.user)
              .fontWeight(FontWeight.Bold)
              .fontSize(20)
          }
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Bottom)
          .margin({ bottom: 5})
          if (this.data.type == ChatRoomMessageType.msg) {
            MsgContent({
              message: this.message
            })
              .margin({ bottom: 5 })
          }
          if (this.data.type == ChatRoomMessageType.redPacket) {
            RedPacketRender({
              data: this.data.message.extends as IRedPacketMessage
            })
          }
          Text(this.time.replaceAll(this.today, ''))
            .fontColor('#9FA4B4')
            .fontSize(12)
            .margin({ left: 5, bottom: 2 })
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 10 })
        .width('100%')
      } else if (this.data.type === ChatRoomMessageType.barrager) {
        Flex() {
          CircleIcon({
            icon: this.avatar,
          }).width(48)
            .margin({ right: 5, top: 20 })
          Text(this.message)
        }.backgroundColor(this.data.barrager?.barragerColor || '#000000')
          .borderRadius(48)
          .padding({ left: 10, right: 10, top: 5, bottom: 5 })
          .margin({ left: 10, right: 10 })
      } else if (this.data.type === ChatRoomMessageType.custom) {
        Text(this.data.custom || '')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 10, right: 10 })
      }
    }
    .margin({ left: 10, right: 10 })
  }
}