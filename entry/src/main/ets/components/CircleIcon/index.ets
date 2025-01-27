
@ComponentV2
export struct CircleIcon {
  @Require @Param icon: ResourceStr;
  @Param iconSize: number = 48;
  @Param strokeSize: number = 2;
  @Param badge: number | ResourceColor | boolean = false;
  @Computed get needBadge(): boolean {
    return this.badge !== false;
  }
  @Computed get isBadgeNumber(): boolean {
    return typeof this.badge == 'number';
  }
  build() {
    Column() {
      Stack({
        alignContent: Alignment.TopEnd
      }) {
        Image(this.icon)
          .width(this.iconSize)
          .height(this.iconSize)
        if (this.needBadge) {
          if (typeof this.badge === 'number') {
            Text(this.badge.toString())
              .fontColor(Color.White)
              .fontSize(10)
              .fontWeight(FontWeight.Bold)
              .width(this.isBadgeNumber ? 16 : 8)
              .height(this.isBadgeNumber ? 16 : 8)
              .backgroundColor(Color.Red)
              .borderRadius(8)
              .textAlign(TextAlign.Center)
              .margin(this.isBadgeNumber ? { top: -4, right: -4 } : null)
          } else {
            Text('')
              .fontColor(Color.White)
              .fontSize(10)
              .fontWeight(FontWeight.Bold)
              .width(8)
              .height(8)
              .backgroundColor(typeof this.badge == 'boolean' ? Color.Red : this.badge)
              .borderRadius(8)
              .textAlign(TextAlign.Center)
              .margin(this.isBadgeNumber ? { top: -4, right: -4 } : null)
          }
        }
      }.width(this.iconSize)
      .height(this.iconSize)
    }
    .width(this.iconSize)
    .height(this.iconSize)
    .backgroundColor("#FFD465")
    .borderRadius(this.iconSize)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .border({ width: this.strokeSize, color: '#18191F' })
    .clip(true)
  }
}