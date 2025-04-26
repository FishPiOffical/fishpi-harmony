import { MainLayout } from "../../layout/main";
import Fishpi from "../../service/fishpi";
import { AppStorageV2 } from "@kit.ArkUI";
import { CircleIcon } from "../../components/CircleIcon";
import { Icon } from "../../components/Icon";
import { ListButton } from "./ListButton";
import { IArticleListParam } from "../Article/Index";


@ComponentV2
export struct Profile {
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()

  @Computed
  get me() {
    return this.fishpi.user.me!
  }

  build() {
    MainLayout() {
      Column() {
        Column() {
          Column() {
            Flex({
              justifyContent: FlexAlign.SpaceBetween
            }) {
              Column() {
                Row() {
                  Text(this.me.userNickname || this.me.userName)
                    .fontWeight(FontWeight.Bolder)
                    .fontSize(24)
                  if (this.me.userNickname && this.me.userNickname !== this.me.userName) {
                    Text(this.me.userName)
                      .fontSize(14)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(0xd9d9d9)
                  }
                }.width('100%').alignItems(VerticalAlign.Bottom)

                Row() {
                  Text(this.me.userIntro)
                    .fontSize(14)
                    .fontColor(0x474f57)
                }.width('100%').alignItems(VerticalAlign.Bottom)

                Row() {
                  Text('#' + this.me.userNo).fontWeight(FontWeight.Bolder).fontSize(18)
                  Text(this.me.userRole)
                }.width('100%').alignItems(VerticalAlign.Bottom)
              }

              Column() {
                CircleIcon({
                  icon: this.me.userAvatarURL
                })
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

              Row() {
                Icon({
                  icon: $r('app.media.location_colorful'),
                  color: null, stroke: null
                })
                Text(this.me.userCity).fontWeight(FontWeight.Bolder)
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
          }]
        })
          .margin({ top: 16, bottom: 16 })
      }.padding(16)
    }
  }
}