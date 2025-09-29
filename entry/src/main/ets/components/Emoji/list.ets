
@ComponentV2
export struct EmojiList {
  @Param onSend: (emoji: string) => void = () => {};
  @Require @Param emojis: string[];

  build() {
    GridRow({
      columns: { xs: 5, sm: 6, md: 7, lg: 8, xl: 9, xxl: 10 },
      gutter: { x: 5, y: 10 },
      breakpoints: { value: ["400vp", "600vp", "800vp"],
        reference: BreakpointsReference.WindowSize },
      direction: GridRowDirection.Row
    }) {
      ForEach(this.emojis, (item: string) => {
        GridCol({ span: 1, offset: 0, order: 0 }) {
          Column()
            {
              Image(item)
            }
            .width(50)
            .height(50)
            .clip(true)
          .onClick(() => {
            this.onSend(item)
          })
        }
        .width(50)
        .height(50)
      }, (item: string) => item)
    }
    .alignItems(ItemAlign.Start)
    .padding({
      left: 5,
      right: 5,
      bottom: 20,
      top: 5
    })
    .width('100%')
  }
}