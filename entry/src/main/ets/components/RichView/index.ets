import { webview } from "@kit.ArkWeb";
import { baseCss } from "./baseCss";
import { promptAction } from "@kit.ArkUI";


@ComponentV2
export struct RichView {
  @Require @Param html: string;
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Web({
      src: '',
      controller: this.controller,
      renderMode: RenderMode.ASYNC_RENDER,
    })
      .layoutMode(WebLayoutMode.FIT_CONTENT)
      .overScrollMode(OverScrollMode.NEVER)
      .onControllerAttached(() => {
        try {
          const code = `<html>
                      <head>
                        <meta charset="utf-8" />
                        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
                        <link rel="stylesheet" href=resource://rawfile/base.css />
                        <style>${baseCss}</style>
                      </head>
                      <body>
                        <div class="vditor-reset article-content">
                        ${this.html}
                        </div>
                      </body>
                      </html>`;
          this.controller.loadData(code, 'text/html', 'utf-8')
        } catch (e) {
          promptAction.showToast({
            message: e.message,
            duration: 2000
          });
        }
      })
  }
}