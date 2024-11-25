import { lvMarkdownIn } from '@luvi/lv-markdown-in'
import { emojis } from '../../service/emoji';

@ComponentV2
export struct MsgContent {
  @Require @Param message: string;
  @Param isSelf: boolean = false;
  @Computed get isImage() {
    return this.content.trim().match(/^!\[.*\]\(.*\)$/)
  }
  @Local content: string = '';

  @Local realHeight: number = 0;

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
    .padding(10)
    .backgroundColor('#fff')
    .width('auto')
  }

  aboutToAppear(): void {
    this.content = this.message
    if (this.message.startsWith(':')){
      this.message.match(/:([\w+-]+):/g)?.forEach((emoji) => {
        const emojiName = emoji.replace(/:/g, '')
        const emojiUrl = emojis[emojiName];
        if (!emojiUrl) return;
        this.content = this.message.replace(emoji, `![${emojiName}](${emojiUrl})`)
      })
    }
  }

  build() {
    if (this.isImage) {
      Image(this.content.match(/\((.*)\)/)![1]).constraintSize({
        maxWidth: '90%',
        maxHeight: 150,
        minHeight: 100,
      })
        .onComplete((msg) => {
          if(msg){
            this.realHeight = Math.min(msg.height, 150)
          }
        })
        .height(this.realHeight || 150)
    } else if (this.content.match(/(!\[|\]\(|#|>)|\*|~/)) {
      Flex() {
        Flex() {
          lvMarkdownIn({ text: this.content })
        }.messageStyle().constraintSize({
          maxHeight: 300,
        })
      }.backgroundColor('#000')
      .borderRadius({
        topLeft: this.isSelf ? 10 : 0,
        topRight: this.isSelf ? 0 : 10,
        bottomLeft: 10,
        bottomRight: 10
      })
      .padding({ bottom: 5 })
      .width('auto')
    } else {
      Flex() {
        Text(this.content)
          .messageStyle()
      }.backgroundColor('#000')
      .borderRadius({
        topLeft: this.isSelf ? 10 : 0,
        topRight: this.isSelf ? 0 : 10,
        bottomLeft: 10,
        bottomRight: 10
      })
      .padding({ bottom: 5 })
      .width('auto')
    }
  }
}