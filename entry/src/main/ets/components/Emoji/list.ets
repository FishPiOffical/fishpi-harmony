
@ComponentV2
export struct EmojiPicker {
  @Param onSend: (emoji: string) => void = () => {};
  @Require @Param emojis: string[];

  build() {
    Grid() {
      ForEach(this.emojis, (item: string) => {
        GridItem() {
          Column()
            {
              Image(item)
            }
            .width('100%')
            .height('100%')
            .clip(true)
        }
      }, (item: string) => item)
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