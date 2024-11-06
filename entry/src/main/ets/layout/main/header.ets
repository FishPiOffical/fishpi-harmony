import { Icon } from "../../components/Icon";

@ComponentV2
export struct Header {
  @Param title: string = '摸鱼派';

  build() {
    Row() {
      Icon({
        icon: $r('app.media.scan')
      }).margin({ left: 10 })
      Text(this.title).fontSize(20).fontWeight('bold')
      Icon({
        icon: $r('app.media.notice'),
        stroke: '#000',
        badge: true,
      }).margin({ right: 10 })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .height('100%')
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .backgroundColor('#EEEFF4')
    .border({ width: { bottom: 2 }, color: '#000' })
  }
}