import { Header, HeaderActionOptions, HeaderAction } from "../../layout/main/header";
import { promptAction } from "@kit.ArkUI";

@Builder
export function ChatRoomBuilder(name: string, param: Object) {
  ChatRoom()
}

@ComponentV2
export struct ChatRoom {
  pathStack: NavPathStack = new NavPathStack()

  @Builder
  titleBuilder() {
    Header({
      title: '聊天室',
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
    }).height('100%')
  }

  build() {
    NavDestination() {
      Column() {
        Text("Hello")
      }
    }.menus(this.titleBuilder)
  }
}