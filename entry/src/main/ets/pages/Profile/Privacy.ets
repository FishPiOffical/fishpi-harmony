import { webview } from "@kit.ArkWeb";
import { Header, HeaderAction } from "../../layout/main/header";

@Builder
export function PrivacyBuilder(_name: string) {
  Privacy()
}

@ComponentV2
export struct Privacy {
  private webController: WebviewController = new webview.WebviewController();
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()

  @Builder
  titleBuilder() {
    Header({
      title: '',
      leftAction: new HeaderAction($r('app.media.back'), () => {
        const stack = this.pathStack.pop()
        console.log('stack', stack)
      }),
      bgColor: '#FFF',
      noBorder: true,
    }).height('100%')
  }

  build() {
    NavDestination() {
      Web({
        src: 'https://fishpi.cn/privacy',
        controller: this.webController
      })
        .width('100%')
        .height('100%')
    }.menus(this.titleBuilder)
    .backgroundColor('#FFF')
    .title('')
  }
}