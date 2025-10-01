import { Header, HeaderAction, HeaderActionOptions } from '../layout/main/header'
import { Nav } from "../layout/main/nav";
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { AppData } from '../service';
import Fishpi from '../service/fishpi';
import { Home } from './Home';
import { Login } from './Login';


PersistenceV2.notifyOnError((key: string, reason: string, msg: string) => {
  console.error(`error key: ${key}, reason: ${reason}, message: ${msg}`);
});

@Entry
@ComponentV2
struct Index {
  @Provider('routerTab') pathStack: NavPathStack = new NavPathStack()

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
        this.getUIContext().getPromptAction().showToast({
          message: '扫一扫',
          duration: 2000
        });
      }),
      rightAction: new HeaderAction($r('app.media.notice'), () => {
        this.getUIContext().getPromptAction().showToast({
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

  @Computed
  get isLogin() {
    return !!this.app.token;
  }

  aboutToAppear() {
    if (this.isLogin) this.fishpi.setToken(this.app.token)
  }

  build() {
    Navigation(this.pathStack) {
      if (this.isLogin) {
        Home({
          onChangeTitle: (text: string) => {
            this.title = text
          },
          onLogout: () => {
            this.app.token = '';
            PersistenceV2.save(AppData);
            this.fishpi.setToken('');
          }
        })
      } else {
        Login({
          onLogin(token: string) {
            this.app.token = token;
            this.fishpi.setToken(token);
          }
        })
      }
    }
    .width('100%')
    .height('100%')
    .navDestination((name, params: object) => {
      console.info('navDestination', name, params)
    })
    .hideTitleBar(!this.isLogin)
    .menus(this.titleBuilder)
    .titleMode(NavigationTitleMode.Mini)
    .mode(this.isLogin ? NavigationMode.Auto : NavigationMode.Stack)
    .navBarWidth(300)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.BOTTOM])
  }
}