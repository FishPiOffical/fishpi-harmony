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
        Flex({
          justifyContent: FlexAlign.SpaceBetween
        }) {
          Column() {
            Row() {
              Text(this.me.userNickname || this.me.userName)
              if (this.me.userNickname && this.me.userNickname !== this.me.userName) {
                Text(this.me.userName)
              }
            }
            Row() {
              Text(this.me.userIntro)
            }
            Row() {
              Text('#' + this.me.userNo)
              Text(this.me.userRole)
            }
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
            })
            Text(this.me.userPoint + '')
          }
          Row() {
            Icon({
              icon: $r('app.media.location_colorful'),
            })
            Text(this.me.userCity)
          }
        }.width('100%').padding(16).justifyContent(FlexAlign.SpaceBetween)
      }
      ListButton({
        items: [{
          icon: $r('app.media.article'),
          name: '我的文章',
          action: () => {
            this.pathStack.pushPathByName('ArticleList', { user: this.me.userName } as IArticleListParam)
          }
        }]
      })
    }
  }
}