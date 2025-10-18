import { AlertDialog } from '@kit.ArkUI';
import { Header, HeaderAction, HeaderActionOptions } from '../layout/main/header'
import { Nav } from "../layout/main/nav";
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { AppData } from '../service';
import Fishpi from '../service/fishpi';
import { Home } from './Home';
import { Login } from './Login';
import { NoticeCommandType } from '../service/types/notice';
import { startScanQrCode, toast } from '../libs/utils';
import { common } from '@kit.AbilityKit';

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
  @Local noticeCount: number = 0;

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
        startScanQrCode(this.getUIContext().getHostContext() as common.UIAbilityContext).then((result) => {
          if (!result.startsWith('web:')) {
            toast('无效的登录二维码，请扫码网页登录界面的二维码！', this.getUIContext());
            return;
          }
          this.fishpi.scanLogin(result.replace('web:', ''), (cb) => {
            this.getUIContext().showAlertDialog(
              {
                title: '登录设备',
                message: '是否确认在此设备上登录？',
                autoCancel: true,
                alignment: DialogAlignment.Center,
                gridCount: 4,
                offset: { dx: 0, dy: -20 },
                buttonDirection: DialogButtonDirection.HORIZONTAL,
                buttons: [
                  {
                    value: '取消',
                    action: () => {
                      cb(false);
                    }
                  },
                  {
                    value: '确认',
                    enabled: true,
                    defaultFocus: true,
                    style: DialogButtonStyle.HIGHLIGHT,
                    backgroundColor: '#ed8f26',
                    action: () => {
                      cb(true);
                    }
                  }],
                cancel: () => {
                  console.info('Closed callbacks');
                },
                onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
                  console.info(`reason= ${dismissDialogAction.reason}`);
                  console.info('AlertDialog onWillDismiss');
                  if (dismissDialogAction.reason === DismissReason.PRESS_BACK) {
                    dismissDialogAction.dismiss();
                  }
                  if (dismissDialogAction.reason === DismissReason.TOUCH_OUTSIDE) {
                    dismissDialogAction.dismiss();
                  }
                }
              }
            )
          })
        }).catch((err: Error) => {
          toast('扫码失败：' + err.message, this.getUIContext());
        });
      }),
      rightAction: new HeaderAction($r('app.media.notice'), () => {
        this.pathStack.pushPathByName('Notice', null);
      }, new HeaderActionOptions({ stockColor: '#000', badge: this.noticeCount > 0 }))
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
    if (!this.isLogin) return;
    this.fishpi.setToken(this.app.token)
    this.fishpi.notice.count().then((res) => {
      this.noticeCount = res.unreadNotificationCnt;
    })
    this.fishpi.notice.addListener((res) => {
      switch(res.command) {
        case NoticeCommandType.RefreshNotification:
          this.fishpi.notice.count().then((res) => {
            this.noticeCount = res.unreadNotificationCnt;
          })
          break;
      }
    })
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
    .navBarWidth('33%')
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.BOTTOM])
  }
}