import { AlertDialog } from '@kit.ArkUI';
import { AppStorageV2 } from "@kit.ArkUI";
import { Header, HeaderAction } from "../../layout/main/header";
import Fishpi from "../../service/fishpi";
import { INoticeCount, NoticeType } from '../../service/types/notice';
import { NoticeList } from './NoticeList';

@Builder
export function NoticeBuilder(name: string, param: Object) {
  Notice()
}

@ComponentV2
export struct Notice {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Local noticeCount?: INoticeCount;
  readConfirm: CustomDialogController = new CustomDialogController({
    builder: AlertDialog({
      primaryTitle: '标记所有消息已读',
      content: '是否确认标记所有消息为已读？',
      primaryButton: {
        value: '取消',
        action: () => {
        },
      },
      secondaryButton: {
        value: '确认',
        role: ButtonRole.ERROR,
        action: () => {
          this.fishpi.notice.readAll();
        }
      },
    }),
  })

  @Builder
  titleBuilder() {
    Header({
      title: '通知',
      leftAction: new HeaderAction($r('app.media.back'), () => {
        const stack = this.pathStack.pop()
        console.log('stack', stack)
      }),
      rightAction: new HeaderAction($r('app.media.read'), () => {
        this.readConfirm.open();
      }),
    }).height('100%')
  }

  aboutToAppear(): void {
    this.fishpi.notice.count().then((res) => {
      this.noticeCount = res;
    })
  }

  @Builder
  TabBuilder(name: string, unreadCount: number) {
    Column() { // 红点提示
      if (unreadCount > 0) {
        Badge({
          count: unreadCount,
          position: BadgePosition.RightTop,
          style: {
            color: Color.Red,
            fontSize: 12
          }
        })
      }

      Text(name)
        .fontSize(12)
    }
  }

  build() {
    NavDestination() {
      Tabs({
        barPosition: BarPosition.Start,
      }) {
        TabContent() {
          NoticeList({
            type: NoticeType.Comment
          })
        }.tabBar(SubTabBarStyle.of('评论').indicator({ color: '#F95A2C' }).labelStyle({ selectedColor: '#F95A2C' }))
        TabContent() {
          NoticeList({
            type: NoticeType.Reply
          })
        }.tabBar(SubTabBarStyle.of('回复').indicator({ color: '#F95A2C' }).labelStyle({ selectedColor: '#F95A2C' }))
        TabContent() {
          NoticeList({
            type: NoticeType.At
          })
        }.tabBar(SubTabBarStyle.of('@我').indicator({ color: '#F95A2C' }).labelStyle({ selectedColor: '#F95A2C' }))
        TabContent() {
          NoticeList({
            type: NoticeType.Following
          })
        }.tabBar(SubTabBarStyle.of('关注').indicator({ color: '#F95A2C' }).labelStyle({ selectedColor: '#F95A2C' }))
        TabContent() {
          NoticeList({
            type: NoticeType.Point
          })
        }.tabBar(SubTabBarStyle.of('积分').indicator({ color: '#F95A2C' }).labelStyle({ selectedColor: '#F95A2C' }))
        TabContent() {
          NoticeList({
            type: NoticeType.System
          })
        }.tabBar(SubTabBarStyle.of('系统').indicator({ color: '#F95A2C' }).labelStyle({ selectedColor: '#F95A2C' }))
      }
    }.menus(this.titleBuilder)
    .backgroundColor('#EEEFF4')
    .title('消息')
  }
}