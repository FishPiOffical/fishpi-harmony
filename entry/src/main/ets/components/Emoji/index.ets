

@ComponentV2
export struct EmojiPicker {
    @Param onSend: (emoji: string) => void = () => {};

    build() {
      Tabs() {
        TabContent() {
          Scroll() {
            EmojiPicker({

            })
          }
        }
      }
    }
}