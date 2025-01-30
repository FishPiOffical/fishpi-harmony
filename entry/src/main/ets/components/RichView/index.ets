import { webview } from "@kit.ArkWeb";
import { baseCss, baseScript } from "./base";
import { promptAction } from "@kit.ArkUI";
import { BusinessError } from "@kit.BasicServicesKit";
import { startBrowsableAbility, toast } from "../../libs/utils";
import { common } from "@kit.AbilityKit";

interface IMessage {
  type: 'openWindow';
  data: string;
}

@ComponentV2
export struct RichView {
  @Require @Param html: string;
  @Event onOpenWindow: (url: string) => void = () => { };
  controller: webview.WebviewController = new webview.WebviewController();
  ports: webview.WebMessagePort[] = [];
  nativePort: webview.WebMessagePort | null = null;

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
                        <script lang="javascript">
                          ${baseScript}
                        </script>
                      </body>
                      </html>`;
          this.controller.loadData(code, 'text/html', 'utf-8')
        } catch (e) {
          toast(e.message);
        }
      })
      .onPageEnd(() => {
        console.log("In ArkTS side message onPageEnd init message channel");
        this.ports = this.controller.createWebMessagePorts(true);
        this.controller.postMessage("InitWebMessagePort", [this.ports[1]], "*");
        this.nativePort = this.ports[0];
        this.nativePort.onMessageEventExt((result) => {
          console.log("In ArkTS side got message");
          try {
            let type = result.getType();
            console.log("In ArkTS side getType:" + type);
            switch (type) {
              case webview.WebMessageType.STRING: {
                const msg: IMessage = JSON.parse(result.getString());
                if (msg.type == 'openWindow') {
                  this.onOpenWindow(msg.data);
                }
                break;
              }
            }
          }
          catch (error) {
            console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        });
      })
  }
}