import { Icon } from "../../components/Icon";

export interface IHeaderActionOptions {
  stockColor?: ResourceColor;
  badge?: boolean;
}

@ObservedV2
export class HeaderActionOptions implements IHeaderActionOptions {
  @Trace
  stockColor: ResourceColor = Color.Transparent;
  @Trace
  badge: boolean = false;

  constructor(options?: IHeaderActionOptions) {
    this.stockColor = options?.stockColor || this.stockColor;
    this.badge = options?.badge || this.badge;
  }
}

@ObservedV2
export class HeaderAction {
  @Trace
  icon: ResourceStr;
  @Trace
  onClick: () => void;
  @Trace
  options: HeaderActionOptions;

  constructor(icon: ResourceStr, onClick: () => void, options: HeaderActionOptions = new HeaderActionOptions()) {
    this.icon = icon;
    this.onClick = onClick;
    this.options = options;
  }
}

@ComponentV2
export struct Header {
  @Require @Param title: string;
  @Require @Param leftAction: HeaderAction;
  @Require @Param rightAction: HeaderAction;

  build() {
    Row() {
      Icon({
        icon: this.leftAction.icon,
        stroke: this.leftAction.options.stockColor,
        badge: this.leftAction.options.badge,
      })
        .margin({ left: 10 })
        .onClick(this.leftAction.onClick)
      Text(this.title).fontSize(20).fontWeight('bold')
      Icon({
        icon: this.rightAction.icon,
        stroke: this.rightAction.options.stockColor,
        badge: this.rightAction.options.badge,
      }).margin({ right: 10 })
        .onClick(this.rightAction.onClick)
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .height('100%')
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .backgroundColor('#EEEFF4')
    .border({ width: { bottom: 2 }, color: '#000' })
  }
}