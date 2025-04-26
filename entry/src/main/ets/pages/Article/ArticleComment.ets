import { lvMarkdownIn } from "@luvi/lv-markdown-in";
import { CircleIcon } from "../../components/CircleIcon";
import { Icon } from "../../components/Icon";
import { IArticleComment, VoteStatus } from "../../service/types/article";
import { LengthMetrics } from "@kit.ArkUI";
import { MessageBox, MessageBoxExpose } from "../Chats/MessageBox";


@ComponentV2
export struct ArticleComment {
  @Require @Param oId: string;
  @Require @Param comments: IArticleComment[];
  @Require @Param count: number;
  @Event onExist: () => void;
  @Local messageBoxExpose?: MessageBoxExpose;

  build() {
    Column() {
      Flex({
        direction: FlexDirection.Column,
      }) {
        Text("评论 " + this.count)
          .fontSize(20)
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .margin({ bottom: 20 })
        List({ space: 1, initialIndex: 0 }) {
          ForEach(this.comments, (comment: IArticleComment) => {
            ListItem() {
              Flex({
                direction: FlexDirection.Row,
                alignItems: ItemAlign.Start,
                space: { main: LengthMetrics.px(40) }
              }) {
                Row() {
                  CircleIcon({
                    icon: comment.commenter.userAvatarURL,
                    iconSize: 40,
                  })
                }

                Column() {
                  Row() {
                    Row({
                      space: 5,
                    }) {
                      Text(comment.commenter.userNickname + `(${comment.commentAuthorName})`)
                        .fontSize(14)
                        .fontColor('#333333')
                      Text(comment.timeAgo)
                        .fontSize(14)
                        .fontColor('#999999')
                    }

                    Row() {
                      Text('回复')
                        .fontSize(14)
                        .fontColor('#333333')
                        .onClick(() => {
                          // TODO
                        })
                      Text(comment.commentGoodCnt + '')
                        .margin({ right: 2, left: 5 })
                      Icon({
                        icon: $r('app.media.like'),
                        color: comment.commentVote == VoteStatus.up ? '#F95A2C' : '#313233',
                        iconSize: 16,
                      })
                    }.alignItems(VerticalAlign.Center)
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.SpaceBetween)

                  lvMarkdownIn({ text: comment.commentContent })
                }
              }
            }
          })
        }
        .width('100%')
        .height('100%')
        .listDirection(Axis.Vertical) // 排列方向
        .friction(0.6)
        .edgeEffect(EdgeEffect.Spring)
        .onClick(() => {
          this.messageBoxExpose?.blur()
        })
        MessageBox({
          onExpose: (expose) => {
            this.messageBoxExpose = expose;
          },
          onSend: async (msg) => {
            // TODO
            return true;
          }
        })
      }
      .width('100%')
      .height('70%')
      .backgroundColor('#FFF4CC')
      .borderRadius({
        topLeft: 20,
        topRight: 20,
      })
      .padding({
        top: 20,
        left: 10,
        right: 10,
        bottom: 20,
      })
    }
    .justifyContent(FlexAlign.End)
    .backgroundColor(0xaa000000)
    .height('100%')
    .width('100%')
    .onClick(() => {
      this.onExist?.() // 点击空白区域关闭评论
    })
  }
}