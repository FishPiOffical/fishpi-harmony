import Fishpi from "../../service/fishpi";
import { AppStorageV2, ComponentContent, OverlayManager } from "@kit.ArkUI";
import { ListButton } from "../Profile/ListButton";
import { IUserInfo } from "../../service/types/user";
import { shortTime } from "../../libs/utils";
import { IChatParam } from "../Chats/ChatPrivate";
import { Pay } from "./pay";

export interface IPayParam {
  user: IUserInfo;
  exit: () => void;
}

@Builder
export function PayBuilder(param: IPayParam) {
  Pay({
    user: param.user,
    onExit: param.exit,
  })
}

@ComponentV2
export struct MoreMenu {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Require @Param user: IUserInfo;
  private uiContext: UIContext = this.getUIContext()
  private overlayNode: OverlayManager = this.uiContext.getOverlayManager()
  private payContent?: ComponentContent<IPayParam>;

  openPay() {
    if (!this.payContent) {
      let payContent = new ComponentContent(
        this.uiContext, wrapBuilder<[IPayParam]>(PayBuilder),
        {
          user: this.user!,
          exit: () => {
            this.overlayNode.removeComponentContent(this.payContent!)
            this.payContent = undefined;
          }
        } as IPayParam,
      )
      this.payContent = payContent
      this.overlayNode.addComponentContent(this.payContent, 0)
    } else {
      this.overlayNode.showComponentContent(this.payContent)
    }
  }

  build() {
    ListButton({
      items: [{
        icon: $r('app.media.pay'),
        name: '转账',
        action: () => {
          this.openPay();
        }
      }, {
        icon: $r('app.media.chat'),
        name: '私聊',
        action: () => {
          this.pathStack.pushPathByName('Chat', { name: this.user.userName } as IChatParam);
        }
      }, {
        icon: $r('app.media.logo'),
        name: '已摸鱼',
        content: shortTime(this.user.onlineMinute)
      }]
    })
      .margin({ top: 16, bottom: 16 })
  }
}