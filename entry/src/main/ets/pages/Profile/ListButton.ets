import { Icon } from "../../components/Icon";

export interface IButtonItem {
  icon: string | Resource;
  name: string;
  action: () => void;
}

@ComponentV2
export struct ListButton {
  @Require @Param items: IButtonItem[];

  build() {
    Column() {
      Column() {
        ForEach(this.items, (item: IButtonItem) => {
          Row() {
            Row() {
              Icon({
                icon: item.icon,
                iconSize: 20,
                color: null,
                stroke: null,
              }).margin({ right: 10 })
              Text(item.name)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
            }
            Row() {
              Icon({
                icon: $r('app.media.right'),
                iconSize: 20,
                color: null,
                stroke: '#000',
              })
            }
          }.width('100%').justifyContent(FlexAlign.SpaceBetween).onClick(item.action).padding({ left: 20, right: 20, top: 12, bottom: 12 })
        })
      }.border({
        color: '#18191F',
        width: 2
      })
      .borderRadius(10)
      .backgroundColor('#fff')
      .width('100%')
      .padding({ top: 10, bottom: 10, })
    }.backgroundColor('#000')
    .borderRadius(10)
    .padding({ bottom: 5 })
  }
}