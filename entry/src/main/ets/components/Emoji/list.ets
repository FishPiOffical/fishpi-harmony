
@ComponentV2
export struct EmojiList {
  @Param onSend: (emoji: string) => void = () => {};
  @Require @Param emojis: string[];

  build() {
    GridRow({
      columns: 5,
      gutter: { x: 5, y: 10 },
      breakpoints: { value: ["400vp", "600vp", "800vp"],
        reference: BreakpointsReference.WindowSize },
      direction: GridRowDirection.Row
    }) {
      ForEach(this.emojis, (item: string) => {
        GridCol({ span: { xs: 1, sm: 2, md: 3, lg: 4 }, offset: 0, order: 0 }) {
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
      }, (item: string) => item)
    }
    .alignItems(ItemAlign.Start)
    .padding({
      left: 5,
      right: 5,
      bottom: 20,
      top: 5
    })
  }
}