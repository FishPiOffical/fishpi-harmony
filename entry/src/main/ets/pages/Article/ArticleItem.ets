import { CircleIcon } from "../../components/CircleIcon";
import { Icon } from "../../components/Icon";
import { IArticleDetail, IArticleTag } from "../../service/types/article";

@ComponentV2
export struct ArticleItem {
  @Require @Param item: IArticleDetail;

  build() {
    Column() {
      Column() {
        if (this.item.articleThumbnailURL) {
          Image(this.item.articleThumbnailURL.split('?')[0])
            .height(150)
            .width('100%')
            .border({
              color: '#18191F',
              width: {
                bottom: 2
              }
            })
        }
        Column() {
          Flex({
            justifyContent: FlexAlign.SpaceBetween,
          }) {
            Column() {
              Text(this.item.articleTitleEmoj)
                .fontSize(18)
                .fontWeight('bold')
                .lineHeight(20)
                .margin({ top: 5, bottom: 5 })
              Text(this.item.articlePreviewContent)
                .fontSize(14)
                .lineHeight(18)
                .fontColor('#474A57')
                .maxLines(2)
            }.alignItems(HorizontalAlign.Start)
            CircleIcon({
              icon: this.item.articleAuthorThumbnailURL210,
            }).width(48)
          }.width('100%')
          Row() {
            Row() {
              ForEach(this.item.articleTagObjs, (tag: IArticleTag) => {
                Text(tag.tagTitle)
                  .fontSize(12)
                  .padding(5)
                  .borderRadius(5)
                  .fontColor('#c4c4c4')
              })
            }

            Row() {
              Icon({
                icon: $r('app.media.comment'),
                iconSize: 12,
                stroke: '#18191',
              }).margin({ right: 5 })
              Text(this.item.articleCommentCount + '').fontSize(12).margin({ right: 10 })
              Icon({
                icon: $r('app.media.thank'),
                iconSize: 12,
                stroke: '#18191',
              }).margin({ right: 5 })
              Text(this.item.articleThankCnt + '').fontSize(12)
            }
            .alignItems(VerticalAlign.Center)
            .margin({
              top: 5
            })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
        }.padding({
          left: 10,
          right: 10,
          top: 10,
          bottom: 5
        }).width('100%')
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