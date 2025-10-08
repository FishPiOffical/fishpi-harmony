import { MainLayout } from "../../layout/main";
import Fishpi from "../../service/fishpi";
import { AppStorageV2, LengthMetrics } from "@kit.ArkUI";
import { Header, HeaderAction } from "../../layout/main/header";
import { IBreezemoonContent } from "../../service/types/breezemoon";
import { BreezemoonItem } from "./BreezemoonItem";
import { IUserInfo } from "../../service/types/user";
import { Icon } from "../../components/Icon";
import { Avatar } from "../../components/Avatar/Index";
import { BreezemoonQuery } from "../../service";


export interface IBreezemoonListParam {
  user?: string;
}

@Builder
export function BreezemoonListBuilder(_name: string, param: IBreezemoonListParam) {
  BreezeList({
    user: param.user,
  })
}

@ComponentV2
export struct BreezeList {
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local query: BreezemoonQuery = new BreezemoonQuery();
  @Local breezemoonList: IBreezemoonContent[] = [];
  @Local userInfo?: IUserInfo;
  @Param user: string = '';
  @Local text: string = '';
  @Local controller: TextAreaController = new TextAreaController();

  aboutToAppear(): void {
    if (this.user) {
      this.query.user = this.user;
      this.fishpi.getUser(this.user).then(user => this.userInfo = user);
    }
    this.load();
  }

  load() {
    this.fishpi.breezemoon.list(this.query.toJSON())
      .then((res) => {
        this.breezemoonList = res;
      })
  }

  @Builder
  mainBuilder() {
    if (this.userInfo) {
      Row() {
        Avatar({
          avatar: this.userInfo.userAvatarURL,
          user: this.userInfo.userName,
        })
        Text(this.userInfo.userNickname || this.userInfo.userName).fontSize(20).fontWeight(FontWeight.Bold)
        Text(' 的清风明月').fontSize(20).fontWeight(FontWeight.Bold)
      }.width('100%').padding({ top: 10, left: 20, right: 20, bottom: 5 })
    } else {
      Flex({
        justifyContent: FlexAlign.Center,
        alignItems: ItemAlign.Center,
        space: {
          main: LengthMetrics.px(20)
        }
      }) {
        Row() {
          TextInput({ placeholder: "随便说说", text: $$this.text, controller: this.controller })
            .height(35)
            .backgroundColor(Color.Transparent)
        }.border({
          width: 2,
          color: '#18191F',
          radius: 20,
        })

        Icon({
          icon: $r('app.media.send'),
          color: '#000000',
          iconSize: 30,
        })
          .onClick(() => {
            this.fishpi.breezemoon.send(this.text);
            this.text = '';
            this.load();
          })
      }.width('100%')
      .padding({ top: 10, left: 10, right: 10, bottom: 0 })
    }
    Column() {
      List({ space: 20, initialIndex: 0 }) {
        ForEach(this.breezemoonList, (data: IBreezemoonContent, i) => {
          ListItem() {
            BreezemoonItem({
              item: data,
            }).margin({
              top: i == 0 ? 20 : 0,
              bottom: i == this.breezemoonList.length - 1 ? 20 : 0
            })
          }
        })
      }
      .width('100%')
      .height('100%')
      .listDirection(Axis.Vertical) // 排列方向
      .friction(0.6)
      .edgeEffect(EdgeEffect.Spring)
    }
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
    if (this.user) {
      NavDestination() {
        this.mainBuilder()
      }.menus(this.titleBuilder)
      .backgroundColor('#EEEFF4')
      .title('清风明月')
    } else {
      MainLayout() {
        this.mainBuilder()
      }
    }
  }
}