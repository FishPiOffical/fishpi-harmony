import { CircleIcon } from "../../components/CircleIcon";
import { Icon } from "../../components/Icon";
import { formatRelative } from "../../libs/utils";
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
              }).width(48)
              Text(this.item.breezemoonAuthorName)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .margin({ left: 10 })
            }
            Text(formatRelative(this.item.breezemoonCreateTime))
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
          Text(this.item.breezemoonContent)
            .fontSize(18)
            .fontWeight('bold')
            .lineHeight(20)
            .margin({ top: 5, bottom: 5 })
        }.alignItems(HorizontalAlign.Start)
        Row() {
          Icon({
            icon: $r('app.media.location'),
            iconSize: 20,
          })
          Text(this.item.breezemoonCity)
            .fontSize(16)
            .margin({ left: 5 })
        }.width('100%')
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