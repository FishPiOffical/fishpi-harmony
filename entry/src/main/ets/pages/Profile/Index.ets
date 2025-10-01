import { MainLayout } from "../../layout/main";
import Fishpi from "../../service/fishpi";
import { AppStorageV2, LengthMetrics } from "@kit.ArkUI";
import { CircleIcon } from "../../components/CircleIcon";
import { Icon } from "../../components/Icon";
import { ListButton } from "./ListButton";
import { IArticleListParam } from "../Article/Index";
import { BorderBox } from "../../components/BorderBox";
import { Role } from "./Role";
import { IBreezemoonListParam } from "../Breezemoon/Index";


@ComponentV2
export struct Profile {
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Event onLogout: () => void = () => {
  };

  @Computed
  get me() {
    return this.fishpi.user.me!
  }

  @Builder
  logoutBtn() {
    Column() {
      Text('退出登录')
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .onClick(() => {
      this.onLogout();
    })
  }

  build() {
    MainLayout() {
      Column() {
        Column() {
          Column() {
            Flex({
              justifyContent: FlexAlign.SpaceBetween,
            }) {
              Column({
                space: 4
              }) {
                Flex({
                  justifyContent: FlexAlign.SpaceBetween,
                }) {
                  Column() {
                    Row() {
                      Text(this.me.userNickname || this.me.userName)
                        .fontWeight(FontWeight.Bolder)
                        .fontSize(24)
                    }.width('100%').alignItems(VerticalAlign.Bottom)

                    if (this.me.userNickname && this.me.userNickname !== this.me.userName) {
                      Row() {
                        Text(this.me.userName)
                          .fontSize(14)
                          .fontWeight(FontWeight.Bold)
                          .fontColor('#D6FCF7')
                      }.width('100%').alignItems(VerticalAlign.Bottom)
                    }
                  }

                  Column() {
                    CircleIcon({
                      icon: this.me.userAvatarURL
                    })
                  }
                }

                Row({
                  space: 5
                }) {
                  Text('#' + this.me.userNo).fontWeight(FontWeight.Bolder).fontSize(18)
                  Role({ role: this.me.userRole })
                }.width('100%').alignItems(VerticalAlign.Bottom)

                Row() {
                  Text(this.me.userIntro)
                    .fontSize(12)
                    .fontColor(0x474f57)
                }.width('100%').alignItems(VerticalAlign.Bottom)
              }
            }.width('100%').padding(16)

            Row() {
              Row() {
                Icon({
                  icon: $r('app.media.coin'),
                  color: null, stroke: null
                })
                Text(this.me.userPoint + '').fontWeight(FontWeight.Bolder)
              }

              if (this.me.userCity) {
                Row() {
                  Icon({
                    icon: $r('app.media.location_colorful'),
                    color: null, stroke: null
                  })
                  Text(this.me.userCity).fontWeight(FontWeight.Bolder)
                }
              }
            }.width('100%').padding(16).justifyContent(FlexAlign.SpaceBetween)
          }
          .backgroundColor('#00C6AE')
          .borderRadius(10)
          .width('100%')
        }
        .border({
          color: '#18191F',
          width: 2
        })
        .backgroundColor('#000')
        .borderRadius(10)
        .padding({ bottom: 5 })

        ListButton({
          items: [{
            icon: $r('app.media.article'),
            name: '我的帖子',
            action: () => {
              this.pathStack.pushPathByName('ArticleList', { user: this.me.userName } as IArticleListParam)
            }
          }, {
            icon: $r('app.media.leaf'),
            name: '我的清风明月',
            action: () => {
              this.pathStack.pushPathByName('BreezeList', { user: this.me.userName } as IBreezemoonListParam)
            }
          }, {
            icon: $r('app.media.privacy'),
            name: '隐私政策',
            action: () => {
              this.pathStack.pushPathByName('Privacy', null)
            }
          }]
        })
          .margin({ top: 16, bottom: 16 })

        BorderBox({
          fill: '#f95a2c',
          contentBuilder: (): void => this.logoutBtn()
        })
          .margin({ top: 16, bottom: 16 })
      }.padding(16)
    }
  }
}