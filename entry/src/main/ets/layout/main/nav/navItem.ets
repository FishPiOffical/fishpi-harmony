import { Icon } from "../../../components/Icon";
import { router } from "@kit.ArkUI";

@ComponentV2
export struct NavItem {
  @Require @Param label: string | Resource;
  @Require @Param icon: ResourceStr;
  @Require @Param route: router.RouterOptions;
  @Param badge: boolean = false;
  @Param active: boolean = false;
  @Param useStock: boolean = false;

  @Computed get color(): ResourceColor {
    if (this.active) {
      return "#ed8f26"
    }
    return Color.Transparent
  }

  build() {
    Column() {
      Icon({
        icon: this.icon,
        color: this.color,
        stroke: this.useStock ? this.color : Color.Transparent,
        badge: this.badge,
        iconSize: 35,
      })
      Text(this.label)
        .fontColor('#000')
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      router.pushUrl(this.route )
    })
  }
}