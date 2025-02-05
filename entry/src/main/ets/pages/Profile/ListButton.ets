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
                iconSize: 20
              })
              Text(item.name)
                .fontSize(20)
            }
            Row() {
              Icon({
                icon: $r('app.media.right'),
                iconSize: 20
              })
            }
          }.width('100%').justifyContent(FlexAlign.SpaceBetween).onClick(item.action)
        })
      }.border({
        color: '#18191F',
        width: 2
      })
      .borderRadius(10)
      .backgroundColor('#fff')
      .width('100%')
    }.backgroundColor('#000')
    .borderRadius(10)
    .padding({ bottom: 5 })
  }
}