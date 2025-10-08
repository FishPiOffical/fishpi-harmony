import { Nav } from "../layout/main/nav";
import { AppStorageV2, PersistenceV2, promptAction, router } from '@kit.ArkUI';
import { AppData } from '../service';
import Fishpi from '../service/fishpi';
import { Chats } from './Chats/Index';

import { ArticleList } from './Article/Index';
import { BreezeList } from './Breezemoon/Index';
import { Profile } from './Profile/Index';

@ComponentV2
export struct Home {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  private controller: TabsController = new TabsController()
  @Local app: AppData = PersistenceV2.connect(AppData, () => new AppData())!;
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Event onChangeTitle: (text: string) => void = () => {};
  @Event onLogout: () => void = () => {};

  getTabBarStyle(icon: Resource, text: string) {
    return new BottomTabBarStyle(icon, text).iconStyle({
      selectedColor: "#ed8f26",
    }).labelStyle({
      selectedColor: "#000",
      font: { size: 14, weight: FontWeight.Bold },
    })
  }

  @Builder
  toolbarBuilder() {
    Nav().width('100%').height('100%')
  }

  aboutToAppear() {
    this.fishpi.setToken(this.app.token)
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column }) {
        Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
          TabContent() {
            Chats()
          }.tabBar(this.getTabBarStyle($r('app.media.chats'), '聊天')).backgroundColor('#EEEFF4')

          TabContent() {
            ArticleList()
          }.tabBar(this.getTabBarStyle($r('app.media.article'), '文章')).backgroundColor('#EEEFF4')

          TabContent() {
            BreezeList()
          }.tabBar(this.getTabBarStyle($r('app.media.leaf'), '清风明月')).backgroundColor('#EEEFF4')

          TabContent() {
            Profile({
              onLogout: () => this.onLogout()
            })
          }.tabBar(this.getTabBarStyle($r('app.media.profile'), '我的')).backgroundColor('#EEEFF4')
        }
        .backgroundColor('#F0D35E')
        .barHeight(60)
        .height('100%')
        .onChange((index: number) => {
          const titles = ['聊天', '文章', '清风明月', '我的']
          this.onChangeTitle(titles[index]);
        })


        Row() {
          Text('')
        }.width('100%')
        .backgroundColor('#F0D35E')
        // 设置底部绘制延伸到导航条
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      }
    }.height('100%')
  }
}