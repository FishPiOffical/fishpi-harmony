@ComponentV2
export struct Nav {
  build() {
    Grid() {
      GridItem() {
        Text('聊天')
      }

      GridItem() {
        Text('文章')
      }

      GridItem() {
        Text('清风明月')
      }

      GridItem() {
        Text('我的')
      }
    }
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .backgroundColor('#F0D35E')
  }
}