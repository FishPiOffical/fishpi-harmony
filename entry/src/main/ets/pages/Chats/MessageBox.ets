import { EmojiPicker } from "../../components/Emoji";
import { Icon } from "../../components/Icon";
import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { AppStorageV2, LengthMetrics } from "@kit.ArkUI";
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
        if (!res) return;
        const message = res.succFiles.map((item) => `![${item.name}](${item.url})`).join('  \n');
        this.onSend(message);
      }).catch((err: Error) => {
        toast('上传失败: ' + err.message, this.getUIContext());
      });
    }).catch((err: BusinessError) => {
      toast(err.message, this.getUIContext());
    })
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.End,
    }) {
      Flex({
        justifyContent: FlexAlign.Center,
        alignItems: ItemAlign.Center,
        space: {
          main: LengthMetrics.px(20)
        }
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
        Row() {
          TextArea({ placeholder: "说点什么", text: $$this.text, controller: this.controller })
            .margin({ left: 0, right: 5 })
            .height(35)
            .backgroundColor(Color.Transparent)
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
        }.border({
          width: 2,
          color: '#18191F',
          radius: 20,
        })
        if (!this.isFocus) {
          Icon({
            icon: $r('app.media.image_send'),
            color: '#000000',
            iconSize: 30,
          })
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
              .onClick(() => {
                this.onRedpack();
              })
          }
        } else {
          if (this.barrage) {
            Icon({
              icon: $r('app.media.barrage'),
              color: null,
              stroke: null,
              iconSize: 30,
            })
              .onClick(async () => {
                if (!this.text) {
                  toast('写点什么再发弹幕', this.getUIContext());
                  return;
                }
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
            .transform({ rotate: 45 })
            .onClick(async () => {
              if (!await this.onSend(this.text)) {
                return;
              }
              this.text = '';
            })
        }
      }.width('100%')
      if (this.emojiShow) {
        EmojiPicker({
          onPick: (emoji) => {
            this.onSend(emoji);
            this.emojiShow = false;
          }
        })
      }
    }
    .padding(5)
    .width('100%')
    .height('auto')
  }
}