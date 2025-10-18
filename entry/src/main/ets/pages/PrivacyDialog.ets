import { startBrowsableAbility } from "../libs/utils";
import { common } from "@kit.AbilityKit";

@CustomDialog
export struct PrivacyDialog {
  controller: CustomDialogController;
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  confirm: () => void = () => {};
  cancel: () => void = () => {};

  build() {
    Column() {
      // 标题
      Text('隐私政策')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 16, bottom: 16 })
        .textAlign(TextAlign.Center)
        .fontColor('#000')

      // 内容
      Text() {
        Span('本应用重视并保护所有用户的个人隐私权。为了给您提供更准确、更有个性化的服务，本应用会按照隐私政策')
          .fontSize(16)
          .fontColor('#000')

        Span('的规定使用和披露您的个人信息。可阅读')
          .fontSize(16)
          .fontColor('#000')

        Span('用户协议')
          .fontSize(16)
          .fontColor('#F95A2C')
          .onClick(() => {
            this.controller.close();
            startBrowsableAbility('https://fishpi.cn/agreement', this.context);
          })

        Span('和')
          .fontSize(16)
          .fontColor('#000')

        Span('隐私政策')
          .fontSize(16)
          .fontColor('#F95A2C')
          .onClick(() => {
            this.controller.close();
            startBrowsableAbility('https://fishpi.cn/privacy', this.context);
          })
      }
      .margin({ left: 16, right: 16 })
      .textAlign(TextAlign.Start)

      // 按钮
      Row() {
        Button('同意')
          .width('45%')
          .height(40)
          .backgroundColor('#F95A2C')
          .fontColor(Color.White)
          .onClick(() => {
            this.confirm();
            this.controller.close();
          })

        Button('不同意并退出')
          .width('45%')
          .height(40)
          .fontColor('#000')
          .backgroundColor('#ccc')
          .onClick(() => {
            this.cancel();
            this.controller.close();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .margin({ top: 40, bottom: 16 })
    }
    .width('90%')
    .constraintSize({
      maxWidth: 400,
    })
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .padding(16)
  }
}