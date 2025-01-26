import { Icon } from "../../components/Icon";
import { IArticleDetail, IArticleTag } from "../../service/types/article";

@ComponentV2
export struct ArticleItem {
  @Require @Param item: IArticleDetail;

  build() {
    Column() {
      if (this.item.articleThumbnailURL) {
        Image(this.item.articleThumbnailURL)
          .height(50)
      }
      Text(this.item.articleTitleEmoj)
        .fontSize(18)
        .fontWeight('bold')
        .lineHeight(20)
      Text(this.item.articlePreviewContent)
        .fontSize(14)
        .lineHeight(18)
        .fontColor('#c4c4c4')
        .maxLines(2)
      Row() {
        Row() {
          ForEach(this.item.articleTagObjs, (tag: IArticleTag) => {
            Text(tag.tagTitle)
              .padding(5)
              .borderRadius(5)
              .fontColor('#c4c4c4')
          })
        }
        Row() {
          if (this.item.articleCommentable) {
            Icon({
              icon: $r('app.media.comment'),
              iconSize: 18
            })
            Text(this.item.articleCommentCount + '')
          }
          Icon({
            icon: this.item.thanked ? $r('app.media.thank-fill') : $r('app.media.thank'),
            iconSize: 18
          })
          Text(this.item.articleThankCnt + '')
        }
      }.justifyContent(FlexAlign.SpaceBetween)
    }
    .border({
      color: '#18191F',
      width: 2
    })
    .borderRadius(10)
    .padding(10)
    .backgroundColor('#fff')
    .width('auto')
  }
}