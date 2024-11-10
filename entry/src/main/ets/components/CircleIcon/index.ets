
@ComponentV2
export struct CircleIcon {
  @Require @Param icon: ResourceStr;
  @Param iconSize: number = 48;
  @Param color: ResourceColor = Color.Black;
  @Param stroke: ResourceColor = Color.Transparent;
  @Param badge: ResourceColor | boolean = false;
  @Computed get needBadge(): boolean {
    return this.badge !== false;
  }

  build() {
    Column() {
      Image(this.icon)
        .width(this.iconSize)
        .height(this.iconSize)
    }
    .width(this.iconSize)
    .height(this.iconSize)
    .backgroundColor("#FFD465")
    .borderRadius(this.iconSize)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .border({ width: 2, color: '#18191F' })
  }
}