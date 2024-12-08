import { EmojiPicker } from "../../components/Emoji";
import { Icon } from "../../components/Icon";
import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { AppStorageV2 } from "@kit.ArkUI";
import Fishpi from "../../service/fishpi";
import { toast } from "../../libs/utils";

export interface MessageBoxExpose {
  blur: () => void;
}


@ComponentV2
export struct MessageBox {
  @Param redpack: boolean = false;
  @Param barrage: boolean = false;
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Local controller: TextAreaController = new TextAreaController();
  @Local text: string = '';
  @Local isFocus: boolean = false;
  @Local emojiShow: boolean = false;
  @Event onSend: (text: string) => boolean | Promise<boolean> = () => true;
  @Event onExpose: (expose: MessageBoxExpose) => void = () => { };
  @Event onRedpack: () => void = () => { };
  @Event onBarrage: (text: string) => boolean | Promise<boolean> = () => true;

  aboutToAppear(): void {
    this.onExpose({
      blur: () => {
        if (this.isFocus) this.controller.stopEditing();
        if (this.emojiShow) this.emojiShow = false;
      }
    });
  }

  sendImage() {
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    photoSelectOptions.maxSelectNumber = 5;

    let uris: Array<string> = [];
    const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
    photoViewPicker.select(photoSelectOptions).then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
      uris = photoSelectResult.photoUris;
      console.info('photoViewPicker.select to file succeed and uris are:' + uris);
      this.fishpi.upload(uris).then((res) => {
        const message = res.succFiles.map((item) => `![${item.name}](${item.url})`).join('  \n');
        this.onSend(message);
      }).catch((err: Error) => {
        toast('上传失败: ' + err.message);
      });
    }).catch((err: BusinessError) => {
      toast(err.message);
    })
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.End,
    }) {
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
          .onClick(() => {
            this.emojiShow = !this.emojiShow;
            this.controller.stopEditing();
          })
        TextArea({ placeholder: "说点什么", text: $$this.text, controller: this.controller })
          .margin({ left: 5, right: 5 })
          .onClick(() => {
            this.emojiShow = false;
          })
          .onFocus(() => {
            this.isFocus = true;
            this.emojiShow = false;
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
              this.sendImage();
            })
          if (this.redpack) {
            Icon({
              icon: $r('app.media.redpack'),
              color: null,
              stroke: null,
              iconSize: 30,
            })
              .margin({ left: 5, right: 5 })
              .onClick(() => {
                this.onRedpack();
              })
          }
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
          if (this.barrage) {
            Icon({
              icon: $r('app.media.barrage'),
              color: null,
              stroke: null,
              iconSize: 30,
            })
              .margin({ left: 5, right: 5 })
              .onClick(async () => {
                if (!await this.onBarrage(this.text)) {
                  return;
                }
                this.text = '';
              })
          }
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
      if (this.emojiShow) {
        EmojiPicker({
          onPick: (emoji) => {
            this.onSend(emoji);
            this.emojiShow = false;
          }
        })
      }
    }
    .padding({
      left: 10,
      right: 5,
      bottom: 5,
      top: 5
    })
    .width('100%')
    .gridSpan(2)
    .backgroundColor('#AAffffff')
    .height('auto')
  }
}