import { lvMarkdownIn } from '@luvi/lv-markdown-in'

@ComponentV2
export struct ChatContent {
  @Require @Param message: string;
  @Param isSelf: boolean = false;

  @Styles messageStyle() {
    .border({
      color: '#18191F',
      width: 2
    })
    .borderRadius({
      topLeft: this.isSelf ? 10 : 0,
      topRight: this.isSelf ? 0 : 10,
      bottomLeft: 10,
      bottomRight: 10
    })
    .shadow({
      color: '#18191F',
      offsetY: 16,
      radius: 4,
    })
    .padding(10)
  }

  build() {
    if (this.message.match(/(!\[|\]\(|#|>)/)) {
      Flex() {
        lvMarkdownIn({ text: this.message })
      }.messageStyle()
    } else {
      Text(this.message)
        .messageStyle()
    }
  }
}