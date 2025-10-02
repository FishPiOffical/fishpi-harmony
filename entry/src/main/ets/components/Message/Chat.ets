import { MsgContent } from "./Content";
import { IChatData } from "../../service/types/chat";
import { Avatar } from "../Avatar/Index";

@ComponentV2
export struct ChatRender {
  @Require @Param data: IChatData;
  @Local date: Date = new Date();
  @Param isSelf: boolean = false;

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
      alignItems: ItemAlign.Start,
      direction: this.isSelf ? FlexDirection.RowReverse : FlexDirection.Row
    }) {
        Avatar({
          avatar: this.avatar,
          user: this.data.senderUserName,
        }).width(48)
          .margin({ right: this.isSelf ? 0 : 5, top: 2, left: this.isSelf ? 5 : 0 })
        Column() {
          MsgContent({
              message: this.message,
              isSelf: this.isSelf,
            })
              .margin({ bottom: 5 })
          Text(this.time.replaceAll(this.today, ''))
            .fontColor('#9FA4B4')
            .fontSize(12)
            .margin({ left: 5 })
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(this.isSelf ? HorizontalAlign.End : HorizontalAlign.Start)
        .margin({ left: 10 })
        .width('100%')
    }
    .margin({ left: 10, right: 10, top: 5 })
  }
}