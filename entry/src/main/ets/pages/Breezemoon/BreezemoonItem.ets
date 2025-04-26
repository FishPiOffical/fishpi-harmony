import { CircleIcon } from "../../components/CircleIcon";
import { Icon } from "../../components/Icon";
import { htmlToText } from "../../libs/utils";
import { IBreezemoonContent } from "../../service/types/breezemoon";

@ComponentV2
export struct BreezemoonItem {
  @Require @Param item: IBreezemoonContent;
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()

  build() {
    Column() {
      Column() {
        Column() {
          Flex({
            justifyContent: FlexAlign.SpaceBetween,
          }) {
            Row() {
              CircleIcon({
                icon: this.item.breezemoonAuthorThumbnailURL48,
                iconSize: 32,
              }).width(32)
              Text(this.item.breezemoonAuthorName)
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
                .margin({ left: 10 })
            }
            Text(this.item.timeAgo)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor('#C4C4C4')
          }.width('100%')
        }.padding({
          left: 10,
          right: 10,
          top: 10,
          bottom: 5
        }).width('100%')
        Column() {
          Text(htmlToText(this.item.breezemoonContent))
            .fontSize(18)
            .fontWeight('bold')
            .lineHeight(20)
            .margin({ top: 5, bottom: 5 })
            .textAlign(TextAlign.Start)
        }.alignItems(HorizontalAlign.Start)
         .width('100%')
         .padding(10)
        Row() {
          Icon({
            icon: $r('app.media.location'),
            iconSize: 20,
          })
          Text(this.item.breezemoonCity)
            .fontSize(16)
            .margin({ left: 5 })
        }.width('100%')
        .padding(10)
        .justifyContent(FlexAlign.End)
      }
      .border({
        color: '#18191F',
        width: 2
      })
      .borderRadius(10)
      .backgroundColor('#fff')
      .width('100%')
    }.backgroundColor('#000')
    .borderRadius(10)
    .padding({ bottom: 5 })
    .margin({ left: 15, right: 15 })
  }
}