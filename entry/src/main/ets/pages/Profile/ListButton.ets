import { BorderBox } from "../../components/BorderBox";
import { Icon } from "../../components/Icon";

export interface IButtonItem {
  icon: string | Resource;
  name: string;
  action?: () => void;
  content?: string;
  color?: ResourceColor;
}

@ComponentV2
export struct ListButton {
  @Require @Param items: IButtonItem[];
  @Param color: ResourceColor = Color.Black;
  @Param fill: ResourceColor = Color.White;

  @Builder
  listBuilder() {
    Column() {
      ForEach(this.items, (item: IButtonItem) => {
        Row() {
          Row() {
            if (item.icon) {
              Icon({
                icon: item.icon,
                iconSize: 20,
                color: null,
                stroke: null,
              }).margin({ right: 10 })
            }
            Text(item.name)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
          }
          if (item.action) {
            Row() {
              Icon({
                icon: $r('app.media.right'),
                iconSize: 20,
                color: null,
                stroke: '#000',
              })
            }
          } else if (item.content) {
            Text(item.content).fontColor(item.color || Color.Black).align(Alignment.End)
          }
        }.width('100%').justifyContent(FlexAlign.SpaceBetween).onClick(item.action).padding({ left: 20, right: 20, top: 12, bottom: 12 })
      })
    }
  }

  build() {
    BorderBox({
      fill: this.fill,
      contentBuilder: (): void => this.listBuilder(),
    })
  }
}