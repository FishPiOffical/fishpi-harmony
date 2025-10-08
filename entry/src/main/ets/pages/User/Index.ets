import Fishpi from "../../service/fishpi";
import { AppStorageV2 } from "@kit.ArkUI";
import { CircleIcon } from "../../components/CircleIcon";
import { Icon } from "../../components/Icon";
import { BorderBox } from "../../components/BorderBox";
import { Header, HeaderAction } from "../../layout/main/header";
import { IUserInfo, Metal } from "../../service/types/user";
import { Avatar } from "../../components/Avatar/Index";
import { fetchImageSize } from "../../libs/utils";
import { UserArticle } from "./article";
import { UserBreezemoon } from "./breezemoon";
import { MoreMenu } from "./menu";


export interface IUserParam {
  user?: string;
}

@Builder
export function UserBuilder(_name: string, param: IUserParam) {
  User({
    user: param.user,
  })
}

@ComponentV2
export struct User {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Require @Param user: string;
  @Local info?: IUserInfo;
  @Local viewWidth: Length = 0;
  @Local cardSize: Size = { width: 0, height: 0 };
  @Local currentTab: number = 0;

  aboutToAppear(): void {
    this.fishpi.getUser(this.user).then((user) => {
      this.info = user;
      this.autoCardBg(this.info.cardBg)
    })
  }

  @Computed
  get panelHeight() {
    if (this.cardSize.width && this.cardSize.height && this.viewWidth) {
      const height = this.cardSize.height * (this.viewWidth as number) / this.cardSize.width
      this.cardSize = { width: this.viewWidth as number, height }
      return Math.min(Math.max(height, 200), 300)
    }
    return 200;
  }

  autoCardBg(url: string) {
    fetchImageSize(url).then((size) => {
      this.cardSize = size;
    })
  }

  @Computed
  get isSelf() {
    return this.fishpi.user.me?.userName == this.user
  }

  @Computed
  get title() {
    return this.info?.userNickname || this.info?.userName || '...'
  }

  @Builder
  titleBuilder() {
    Header({
      title: this.title,
      leftAction: new HeaderAction($r('app.media.back'), () => {
        const stack = this.pathStack.pop()
        console.log('stack', stack)
      }),
    }).height('100%')
  }

  build() {
    NavDestination() {
      if (this.info) {
        Column() {
          Stack() {
            Column() {
              Image(this.info.cardBg)
                .objectFit(ImageFit.Cover)
            }.height('100%')

            Flex({
              direction: FlexDirection.Column,
              justifyContent: FlexAlign.SpaceBetween,
            }) {
              Column() {
                if (!this.isSelf) {
                  Button() {
                    Row({
                      space: 2
                    }) {
                      Icon({
                        icon: this.info.canFollow == 'no' ? $r('app.media.stared') : $r('app.media.star'),
                        color: null,
                        stroke: null,
                        iconSize: 14
                      })
                      Text(this.info.canFollow == 'no' ? '取消关注' : '关注').fontSize(14).fontWeight(FontWeight.Bold)
                    }.alignItems(VerticalAlign.Center)
                  }.backgroundColor('#fff')
                  .border({ color: '#000', width: 2 })
                  .padding({
                    left: 10,
                    right: 10,
                    top: 5,
                    bottom: 5
                  })
                }
              }
              .padding({
                top: 5,
                bottom: 5,
                left: 10,
                right: 10
              })

              Stack({
                alignContent: Alignment.Top
              }) {
                Column() {
                  Column() {
                    Row({
                      space: 2
                    }) {
                      Text(this.info.userNickname || this.info.userName)
                        .fontWeight(FontWeight.Bolder)
                        .fontSize(24)

                      if (this.info.userNickname && this.info.userNickname !== this.info.userName) {
                        Text(this.info.userName)
                          .fontSize(14)
                          .fontWeight(FontWeight.Bold)
                          .fontColor('#867777')
                      }
                    }.width('100%').alignItems(VerticalAlign.Bottom)
                  }

                  Row() {
                    Text(this.info.userIntro)
                      .fontSize(14)
                      .fontColor(0x474f57)
                  }.width('100%').alignItems(VerticalAlign.Bottom)

                  Flex({
                    justifyContent: FlexAlign.SpaceBetween
                  }) {
                    Row({
                      space: 5
                    }) {
                      if (this.info.userCity) {
                        Icon({
                          icon: $r('app.media.location'),
                          iconSize: 15,
                          color: null,
                          stroke: null,
                        })
                        Text(this.info.userCity)
                          .fontSize(14)
                          .fontColor('#000')
                          .margin({ right: 3 })
                          .fontWeight(FontWeight.Bold)
                      }
                      Icon({
                        icon: $r('app.media.coin_line'),
                        iconSize: 15,
                        color: null,
                        stroke: null,
                      })
                      Text(this.info.userPoint + '').fontSize(14).fontColor('#000').fontWeight(FontWeight.Bold)
                    }

                    Row({ space: 3 }) {
                      ForEach(this.info.metalList, (metal: Metal) => {
                        Image(metal.icon).width(16).borderRadius(8).shadow({ color: '#33000000', radius: 2 })
                      })
                    }
                  }.margin({ top: 5 })
                }

                Avatar({
                  avatar: this.info.userAvatarURL,
                  user: this.info.userName,
                  badge: this.info.userOnlineFlag ? '#56F92C' : '#C4C4C4',
                  iconSize: 60
                }).position({
                  top: -30,
                  right: 20,
                }).width(60).height(60)
              }
              .backgroundColor('#AAFFFFFF')
              .padding(10)
            }
            .width('100%')
          }.height(this.panelHeight)
          .onAreaChange((_, size) => {
            this.viewWidth = size.width;
          })
        }
        .border({
          color: '#18191F',
          width: { bottom: 5 }
        })
        .clip(true)
        .borderRadius({ bottomLeft: 16, bottomRight: 16 })
        .width('100%')

        Column({ space: 10 }) {
          Row({ space: 10 }) {
            Button() {
              Text('TA 的文章').fontSize(16).fontWeight(FontWeight.Bold)
            }
            .backgroundColor(this.currentTab == 0 ? '#00C6AE' : Color.White)
            .border({ width: 2 })
            .padding({
              left: 10,
              right: 10,
              top: 5,
              bottom: 5
            })
            .onClick(() => this.currentTab = 0)

            Button() {
              Text('TA 的清风明月').fontSize(16).fontWeight(FontWeight.Bold)
            }
            .backgroundColor(this.currentTab == 1 ? '#00C6AE' : Color.White)
            .border({ width: 2 })
            .padding({
              left: 10,
              right: 10,
              top: 5,
              bottom: 5
            })
            .onClick(() => this.currentTab = 1)

            Button() {
              Text('更多').fontSize(16).fontWeight(FontWeight.Bold)
            }
            .backgroundColor(this.currentTab == 2 ? '#00C6AE' : Color.White)
            .border({ width: 2 })
            .padding({
              left: 10,
              right: 10,
              top: 5,
              bottom: 5
            })
            .onClick(() => this.currentTab = 2)
          }

          if (this.currentTab == 0) {
            UserArticle({ user: this.user })
          } else if (this.currentTab == 1) {
            UserBreezemoon({ user: this.user })
          } else {
            MoreMenu({ user: this.info })
          }
        }.padding(10)
      }
    }.menus(this.titleBuilder)
    .backgroundColor('#EEEFF4')
    .title(this.title)
  }
}