
@ComponentV2
export struct EmojiPicker {
  @Param onSend: (emoji: string) => void = () => {};
  @Require @Param emojis: string[];

  build() {
    Grid() {
      GridItem() {
        Column()
          {

          }
          .width('100%')
          .height('100%')
          .clip(true)
      }
      .border({
        color: '#000000',
        width: 2,
        radius: 5
      })
    }
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
    .height(80)
    .padding({
      left: 5,
      right: 5,
      bottom: 20,
      top: 5
    })
    .columnsGap(15)
    .rowsGap(10)
  }
}