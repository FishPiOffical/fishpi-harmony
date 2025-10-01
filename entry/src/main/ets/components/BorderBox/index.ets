

@ComponentV2
export struct BorderBox {
  @Param fill: ResourceColor = Color.White;

  @Require @BuilderParam contentBuilder: () => void;

  build() {
    Column() {
      Column() {
        this.contentBuilder()
      }.border({
      color: '#18191F',
      width: 2
    })
      .borderRadius(10)
      .backgroundColor(this.fill)
      .width('100%')
      .padding({ top: 10, bottom: 10, })
    }.backgroundColor('#000')
    .borderRadius(10)
    .padding({ bottom: 5 })
  }
}