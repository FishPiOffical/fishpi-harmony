import { AppStorageV2 } from "@kit.ArkUI";
import { CircleIcon } from "../../components/CircleIcon";
import { Icon } from "../../components/Icon";
import { Header, HeaderAction } from "../../layout/main/header";
import Fishpi from "../../service/fishpi";
import { IArticleDetail, VoteStatus } from "../../service/types/article";
import { baseCss } from "./baseCss";

export interface IArticleParam {
  id: string;
}

@Builder
export function ArticleBuilder(name: string, param: IArticleParam) {
  ArticleDetail({
    oId: param.id
  })
}

@ComponentV2
export struct ArticleDetail {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Require @Param oId: string;
  @Local detail?: IArticleDetail;

  @Computed get me() {
    return this.fishpi.user.me
  }

  aboutToAppear(): void {
    this.fishpi.article.detail(this.oId).then((res) => {
      this.detail = res
    })
  }

  @Builder
  titleBuilder() {
    Header({
      title: '',
      leftAction: new HeaderAction($r('app.media.back'), () => {
        const stack = this.pathStack.pop()
        console.log('stack', stack)
      }),
    }).height('100%')
  }

  build() {
    NavDestination() {
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.SpaceBetween,
      }) {
        if (this.detail) {
          Column() {
            Column() {
              Text(this.detail.articleTitle)
                .fontSize(24)
                .fontWeight(FontWeight.Bolder)
                .fontColor('#474A57')
                .margin({ top: 10, bottom: 10 })
                .width('100%')
              Row() {
                Text(this.detail.articleAuthorName)
                  .fontSize(14)
                  .fontColor('#9FA4B4')
                Text('·')
                  .margin({ right: 5, left: 5 })
                  .fontWeight(FontWeight.Bolder)
                  .fontColor('#9FA4B4')
                Text(this.detail.timeAgo)
                  .fontSize(14)
                  .fontColor('#9FA4B4')
                Text('·')
                  .margin({ right: 5, left: 5 })
                  .fontWeight(FontWeight.Bolder)
                  .fontColor('#9FA4B4')
                Text(this.detail.articleViewCount + ' 人看过')
                  .fontSize(14)
                  .fontColor('#9FA4B4')
                  .margin({ right: 10 })
              }
                .justifyContent(FlexAlign.End)
                .width('100%')
            }.padding(10)
            RichText(`<div class="vditor-reset article-content">${this.detail.articleContent}</div><style>${baseCss}</style>`)
              .size({ width: '100%' })
              .layoutWeight(1)
          }
          .backgroundColor($r('sys.color.white'))
          .width('100%')

          Row() {
            Row() {
              CircleIcon({
                icon: this.detail.articleAuthorThumbnailURL48,
                iconSize: 24,
                strokeSize: 1,
              })
              Text(this.detail.articleAuthorName)
                .fontSize(18)
                .fontColor('#474A57')
                .margin({ left: 8 })
                .fontWeight(FontWeight.Bolder)
            }
            .alignItems(VerticalAlign.Center)

            Row() {
              Icon({
                icon: $r('app.media.unlike'),
                color: this.detail.articleVote == VoteStatus.down ? '#F95A2C' : '#686A8A',
                iconSize: 20
              }).margin({ right: 5 })
              Text(this.detail.articleBadCnt + '')
                .fontSize(16)
                .fontColor(this.detail.articleVote == VoteStatus.down ? '#F95A2C' : '#686A8A')
                .fontWeight(FontWeight.Bold)
              Icon({
                icon: $r('app.media.like'),
                color: this.detail.articleVote == VoteStatus.up ? '#F95A2C' : '#686A8A',
                iconSize: 20
              }).margin({ right: 5, left: 10 })
              Text(this.detail.articleGoodCnt + '')
                .fontSize(16)
                .fontColor(this.detail.articleVote == VoteStatus.up ? '#F95A2C' : '#686A8A')
                .fontWeight(FontWeight.Bold)
              Icon({
                icon: $r('app.media.thank_fill'),
                color: this.detail.thanked ? '#F95A2C' : '#686A8A',
                iconSize: 20
              }).margin({ right: 5, left: 10 })
              Text(this.detail.thankedCnt + '')
                .fontSize(16)
                .fontColor(this.detail.thanked ? '#F95A2C' : '#686A8A')
                .fontWeight(FontWeight.Bold)
              if (this.detail.articleCommentable) {
                Icon({
                  icon: $r('app.media.comment_fill'),
                  color: this.detail.articleComments?.some(c => c.commentAuthorName == this.me?.userName) ? '#F95A2C' : '#686A8A',
                  iconSize: 20
                }).margin({ right: 5, left: 10 })
                Text(this.detail.thankedCnt + '')
                  .fontSize(16)
                  .fontColor(this.detail.articleComments?.some(c => c.commentAuthorName == this.me?.userName) ? '#F95A2C' : '#686A8A')
                  .fontWeight(FontWeight.Bold)
              }
            }
            .alignItems(VerticalAlign.Center)
          }.justifyContent(FlexAlign.SpaceBetween)
          .padding(5)
          .backgroundColor('#FFF4CC')
          .width('100%')
          .border({
            width: { top: 1 },
            color: '#C4C4C4'
          })
        }
      }
      .backgroundColor($r('sys.color.white'))
      .width('100%')
      Row() {
        Text('')
      }.width('100%')
      .backgroundColor('#FFF4CC')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])

    }.menus(this.titleBuilder)
    .backgroundColor('#EEEFF4')
    .title('文章详情')
  }
}