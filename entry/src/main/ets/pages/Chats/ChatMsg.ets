import { DateUtil } from '@pura/harmony-utils';
import { CircleIcon } from '../../components/CircleIcon';
import { ChatContent } from './ChatContent'

@ComponentV2
export struct ChatMsg {
  @Require @Param time: string;
  @Require @Param user: string;
  @Require @Param avatar: string;
  @Param message: string = '';
  @Local date: Date = new Date();
  @Event onRaw: () => string;

  @Computed get today() {
    return `${this.date.getFullYear()}-${this.date.getMonth()}-${this.date.getDate()}`;
  }

  build() {
    Flex() {
      CircleIcon({
        icon: this.avatar,
      }).width(48)
        .margin({ right: 5 })
      Column() {
        Row() {
          Text(this.user)
            .fontWeight(FontWeight.Bold)
            .fontSize(20)
          Text(this.time.replaceAll(this.today, ''))
            .fontColor('#9FA4B4')
            .fontSize(12)
            .margin({ left: 5, bottom: 2 })
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Bottom)
        .margin({ bottom: 5})
        ChatContent({
          message: this.message
        })
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 10 })
      .width('100%')
    }
    .margin(10)
  }
}