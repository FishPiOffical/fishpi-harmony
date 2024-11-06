@ComponentV2
export struct Icon {
  @Require @Param icon: ResourceStr;
  @Param iconSize: number = 24;
  @Param color: ResourceColor = Color.Black;
  @Param stroke: ResourceColor = Color.Transparent;
  @Param badge: number | boolean = false;
  @Computed get isBadgeNumber(): boolean {
    return typeof this.badge == 'number';
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.icon)
        .width(this.iconSize)
        .height(this.iconSize)
        .fillColor(this.stroke == Color.Transparent ? this.color : Color.Transparent)
        .colorBlend(this.stroke)
      if (this.badge) {
          Text(this.isBadgeNumber ? this.badge.toString() : '')
            .fontColor(Color.White)
            .fontSize(10)
            .fontWeight(FontWeight.Bold)
            .width(this.isBadgeNumber ? 16 : 8)
            .height(this.isBadgeNumber ? 16 : 8)
            .backgroundColor(Color.Red)
            .borderRadius(8)
            .textAlign(TextAlign.Center)
            .margin(this.isBadgeNumber ? { top: -4, right: -4 } : null)
      }
    }
  }
}