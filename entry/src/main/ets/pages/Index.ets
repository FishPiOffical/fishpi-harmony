import { Header, HeaderAction, HeaderActionOptions } from '../layout/main/header'
import { Nav } from "../layout/main/nav";
import { AppStorageV2, PersistenceV2, promptAction, router } from '@kit.ArkUI';
import { AppData } from '../service';
import Fishpi from '../service/fishpi';
import { Chats } from './Chats/Index';

import { webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ArticleList } from './Article/Index';
import { BreezeList } from './Breezemoon/Index';
import { Profile } from './Profile/Index';


PersistenceV2.notifyOnError((key: string, reason: string, msg: string) => {
  console.error(`error key: ${key}, reason: ${reason}, message: ${msg}`);
});

@Entry
@ComponentV2
struct Index {
  @Provider('routerTab') pathStack: NavPathStack = new NavPathStack()
  private controller: TabsController = new TabsController()
  @Local ws: webSocket.WebSocket = webSocket.createWebSocket();

  @Local app: AppData = PersistenceV2.connect(AppData, () => new AppData())!;
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Local title: string = '聊天'

  getTabBarStyle(icon: Resource, text: string) {
    return new BottomTabBarStyle(icon, text).iconStyle({
      selectedColor: "#ed8f26",
    }).labelStyle({
      selectedColor: "#000",
      font: { size: 14, weight: FontWeight.Bold },
    })
  }

  @Builder
  titleBuilder() {
    Header({
      title: this.title,
      leftAction: new HeaderAction($r('app.media.scan'), () => {
        promptAction.showToast({
          message: '扫一扫',
          duration: 2000
        });
      }),
      rightAction: new HeaderAction($r('app.media.notice'), () => {
        promptAction.showToast({
          message: '消息查看',
          duration: 2000
        });
      }, new HeaderActionOptions({ stockColor: '#000', badge: true }))
    }).width('100%').height('100%')
  }

  @Builder
  toolbarBuilder() {
    Nav().width('100%').height('100%')
  }

  aboutToAppear() {
    if (!this.app.token) {
      router.replaceUrl({ url: 'pages/Login' })
    }
    else this.fishpi.setToken(this.app.token)
  }

  build() {
    Navigation(this.pathStack) {
      Column() {
        Flex({ direction: FlexDirection.Column }) {
          Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
            TabContent() {
              Chats()
            }.tabBar(this.getTabBarStyle($r('app.media.chats'), '聊天'))

            TabContent() {
              ArticleList()
            }.tabBar(this.getTabBarStyle($r('app.media.article'), '文章'))

            TabContent() {
              BreezeList()
            }.tabBar(this.getTabBarStyle($r('app.media.leaf'), '清风明月'))

            TabContent() {
              Profile()
            }.tabBar(this.getTabBarStyle($r('app.media.profile'), '我的'))
          }
          .backgroundColor('#F0D35E')
          .barHeight(60)
          .height('100%')
          .onChange((index: number) => {
            const titles = ['聊天', '文章', '清风明月', '我的']
            this.title = titles[index]
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
    .width('100%')
    .height('100%')
    .navDestination((name, params: object) => {
      console.info('navDestination', name, params)
    })
    .menus(this.titleBuilder)
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.BOTTOM])
  }
}