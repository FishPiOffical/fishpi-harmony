import { NavItem } from "./navItem"

@ComponentV2
export struct Nav {
  build() {
    Grid() {
      GridItem() {
        NavItem({
          label: '聊天',
          icon: $r("app.media.chats"),
          active: true,
          route: { url: '/home' },
        })
      }

      GridItem() {
        NavItem({
          label: '文章',
          icon: $r("app.media.article"),
          active: false,
          route: { url: '/home' },
        })
      }

      GridItem() {
        NavItem({
          label: '清风明月',
          icon: $r("app.media.leaf"),
          active: false,
          route: { url: '/home' },
        })
      }

      GridItem() {
        NavItem({
          label: '我的',
          icon: $r("app.media.profile"),
          active: false,
          route: { url: '/home' },
        })
      }
    }
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .backgroundColor('#F0D35E')
    .border({ width: { top: 2 }, color: '#000' })
  }
}