import { AppStorageV2, ComponentContent, OverlayManager } from "@kit.ArkUI";
import { lvMarkdownIn } from "@luvi/lv-markdown-in";
import { CircleIcon } from "../../components/CircleIcon";
import { Icon } from "../../components/Icon";
import { Header, HeaderAction } from "../../layout/main/header";
import Fishpi from "../../service/fishpi";
import { IArticleComment, IArticleDetail, IArticleTag, VoteStatus } from "../../service/types/article";
import { RichView } from "../../components/RichView";
import { IArticleListParam } from "./Index";
import { common } from "@kit.AbilityKit";
import { pushToAppUrl, startBrowsableAbility } from "../../libs/utils";
import { ArticleComment } from "./ArticleComment";

export interface IArticleParam {
  id: string;
}
export interface IArticleCommentParam {
  detail: IArticleDetail;
  exist: () => void;
  send: (msg: string, replyId?: string) => void;
}

@Builder
export function ArticleBuilder(_name: string, param: IArticleParam) {
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
  @Local showComments: boolean = false;
  private uiContext: UIContext = this.getUIContext()

  @Computed
  get me() {
    return this.fishpi.user.me
  }

  aboutToAppear(): void {
    this.loadComments();
  }

  loadComments() {
    this.fishpi.article.detail(this.oId).then((res) => {
      this.detail = res;
      this.detail.articleComments?.reverse();
    })
  }

  @Builder
  rewardBackground() {
    Column() {
      Image($r('app.media.r'))
        .objectFit(ImageFit.None)
        .width('100%')
        .height('100%')
        .objectRepeat(ImageRepeat.XY)
        .borderRadius(10)
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .borderRadius(10)
    .opacity(0.8)
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
      Stack({
        alignContent: Alignment.Bottom,
      }) {
        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.SpaceBetween,
        }) {
          if (this.detail) {
            Scroll() {
              Column() {
                Column() {
                  Text(this.detail.articleTitle)
                    .fontSize(24)
                    .fontWeight(FontWeight.Bolder)
                    .fontColor('#232425')
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

                RichView({
                  html: this.detail!.articleContent,
                  onOpenWindow: (url) => {
                    if (!pushToAppUrl(url, this.pathStack))
                      startBrowsableAbility(url, getContext(this) as common.UIAbilityContext);
                  }
                })

                if (this.detail!.articleRewardPoint) {
                  Stack({
                    alignContent: Alignment.BottomEnd
                  }) {
                    Flex({
                      direction: FlexDirection.Column,
                      justifyContent: FlexAlign.SpaceBetween,
                    }) {
                      if (this.detail.rewarded) {
                        lvMarkdownIn({ text: this.detail.articleRewardContent })
                      } else {
                        Row() {
                          Text('打赏').fontColor('#ED8F26').fontSize(14).fontWeight(FontWeight.Bold)
                          Text(' ' + this.detail.articleRewardPoint + ' 积分后可见')
                            .fontSize(14)
                            .fontWeight(FontWeight.Bold)
                        }.width('100%')
                      }

                      Row() {
                        Text(this.detail.rewardedCnt + ' 打赏').fontColor('#ED8F26').fontSize(14)
                      }.justifyContent(FlexAlign.End).width('100%')
                    }
                    .width('100%')
                    .padding(15)
                    .onClick(() => {
                      if (this.detail!.rewarded) {
                        return
                      }
                      AlertDialog.show({
                        title: '打赏',
                        message: '是否花费 ' + this.detail!.articleRewardPoint + ' 积分打赏该文章？',
                        autoCancel: false,
                        secondaryButton: {
                          value: '取消',
                          fontColor: '#b4b4b4',
                          action: () => {
                            console.info('取消');
                          }
                        },
                        primaryButton: {
                          value: '确定',
                          fontColor: '#f0d35e',
                          action: () => {
                            this.fishpi.article.reward(this.oId).then(() => {
                              this.fishpi.article.detail(this.oId).then((res) => {
                                this.detail = res
                              })
                            })
                          }
                        }
                      })
                    })
                  }
                  .height(this.detail.rewarded ? 'auto' : 80)
                  .background(this.rewardBackground)
                }

                Flex() {
                  ForEach(this.detail.articleTagObjs, (tag: IArticleTag) => {
                    Text('# ' + tag.tagTitle)
                      .fontSize(12)
                      .fontColor('#757575')
                      .fontWeight(FontWeight.Bold)
                      .padding({
                        top: 3,
                        bottom: 3,
                        left: 10,
                        right: 10
                      })
                      .border({
                        width: 2,
                        color: '#757575'
                      })
                      .borderRadius(15)
                      .margin({ top: 5, right: 5 })
                      .onClick(() => {
                        this.pathStack.pushPathByName('ArticleList', { tag: tag.tagURI } as IArticleListParam)
                      })
                  })
                }.padding(10)
              }
              .backgroundColor($r('sys.color.white'))
              .width('100%')
            }

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
                    color: this.detail.articleComments?.some(c => c.commentAuthorName == this.me?.userName) ? '#F95A2C' :
                      '#686A8A',
                    iconSize: 20
                  }).margin({ right: 5, left: 10 }).onClick(() => {
                    this.showComments = true;
                  })
                  Text(this.detail.articleCommentCount + '')
                    .fontSize(16)
                    .fontColor(this.detail.articleComments?.some(c => c.commentAuthorName == this.me?.userName) ?
                      '#F95A2C' : '#686A8A')
                    .fontWeight(FontWeight.Bold)
                }
              }
              .alignItems(VerticalAlign.Center)
            }
            .justifyContent(FlexAlign.SpaceBetween)
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

        if (this.detail && this.showComments) {
          ArticleComment({
            comments: this.detail.articleComments || [],
            oId: this.detail.oId,
            count: this.detail.articleCommentCount,
            onExist: () => {
              this.showComments = false;
            },
            onSend: (msg: string, replyId?: string) => {
              this.fishpi.comment.send({
                articleId: this.oId,
                commentContent: msg,
                commentAnonymous: false,
                commentVisible: false,
                commentOriginalCommentId: replyId,
              }).then(() => {
                this.fishpi.article.detail(this.oId).then((res) => {
                  this.detail = res
                  this.detail.articleComments?.reverse();
                })
              })
            }
          }).zIndex(1000)
        }
      }

      Row() {
        Text('')
      }.width('100%')
      .backgroundColor('#FFF4CC')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])

    }
    .menus(this.titleBuilder)
    .backgroundColor('#EEEFF4')
    .title('文章详情')
  }
}