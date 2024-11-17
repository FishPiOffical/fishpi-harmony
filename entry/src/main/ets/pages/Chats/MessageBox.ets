import { Icon } from "../../components/Icon";

export interface MessageBoxExpose {
  blur: () => void;
}


@ComponentV2
export struct MessageBox {
  @Local controller: TextAreaController = new TextAreaController();
  @Local text: string = '';
  @Local isFocus: boolean = false;
  @Local expandFeature: boolean = false;
  @Event onSend: (text: string) => boolean | Promise<boolean> = () => true;
  @Event onExpose: (expose: MessageBoxExpose) => void = () => { };

  aboutToAppear(): void {
    this.onExpose({
      blur: () => {
        if (this.isFocus) this.controller.stopEditing();
        if (this.expandFeature) this.expandFeature = false;
      }
    });
  }

  build() {
    Column() {
      Flex({
        justifyContent: FlexAlign.Center,
        alignItems: ItemAlign.End,
      }) {
        Icon({
          icon: $r('app.media.face'),
          color: '#000000',
          iconSize: 30,
        })
          .margin({ left: 5 })
        TextArea({ placeholder: "说点什么", text: $$this.text, controller: this.controller })
          .margin({ left: 5, right: 5 })
          .onFocus(() => {
            this.isFocus = true;
            this.expandFeature = false;
          })
          .onBlur(() => {
            this.isFocus = false;
          })
        if (!this.isFocus) {
          Icon({
            icon: $r('app.media.image_send'),
            color: '#000000',
            iconSize: 30,
          })
            .margin({ left: 5, right: 5 })
            .onClick(() => {
              console.log('image');
            })
          Icon({
            icon: $r('app.media.redpack'),
            color: null,
            stroke: null,
            iconSize: 30,
          })
            .margin({ left: 5, right: 5 })
            .onClick(() => {
              console.log('image');
            })
          // Icon({
          //   icon: $r('app.media.plus_circle'),
          //   stroke: '#000000',
          //   iconSize: 30,
          // })
          //   .margin({ left: 5, right: 5 })
          //   .onClick(() => {
          //     this.expandFeature = !this.expandFeature;
          //   })
        } else {
          Icon({
            icon: $r('app.media.send'),
            color: '#000000',
            iconSize: 30,
          })
            .margin({ left: 5, right: 5 })
            .transform({ rotate: 45 })
            .onClick(async () => {
              if (!await this.onSend(this.text)) {
                return;
              }
              this.text = '';
            })
        }
      }
      if (this.expandFeature) {
        Grid() {
          GridItem() {
            Icon({
              icon: $r('app.media.redpack'),
              color: null,
              stroke: null,
              iconSize: 30,
            })
              .onClick(() => {
                console.log('image');
              })
          }
          .border({
            color: '#000000',
            width: 2,
            radius: 5
          })
        }
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
        .height(80)
        .padding({
          left: 5,
          right: 5,
          bottom: 20,
          top: 5
        })
        .columnsGap(15)
        .rowsGap(10)
      }
    }
    .alignSelf(ItemAlign.Center)
    .padding({
      left: 10,
      right: 5,
      bottom: 5,
      top: 5
    })
    .width('100%')
    .gridSpan(2)
    .backgroundColor('#AAffffff')

  }
}