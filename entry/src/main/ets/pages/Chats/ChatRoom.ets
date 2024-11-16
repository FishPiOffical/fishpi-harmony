import { Header, HeaderAction } from "../../layout/main/header";
import { AppStorageV2 } from "@kit.ArkUI";
import { HPRichTextV2, RichTextOptionModelV2 } from '@ohasasugar/hp-richtext';
import Fishpi from "../../service/fishpi";
import { ChatContentType, ChatRoomMessageType, IChatRoomMessage, IMessage } from "../../service/types/chatroom";
import { ChatMsg } from "./ChatMsg";

@Builder
export function ChatRoomBuilder(name: string, param: Object) {
  ChatRoom()
}

@ComponentV2
export struct ChatRoom {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Local messages: IMessage[] = [];

  @Builder
  titleBuilder() {
    Header({
      title: '聊天室',
      leftAction: new HeaderAction($r('app.media.back'), () => {
        const stack = this.pathStack.pop()
        console.log('stack', stack)
      }),
    }).height('100%')
  }

  aboutToAppear(): void {
    this.fishpi.chatroom.more(1, ChatContentType.Markdown).then((res) => {
      res.reverse();
      this.messages.push(...res.map(item => ({
        type: item.type,
        data: item
      } as IMessage)));
    })
    this.fishpi.chatroom.addListener((res) => {
      if (res.type == ChatRoomMessageType.msg) {
        this.messages.push(res);
      }
    })
  }

  build() {
    NavDestination() {
      List({ space: 20, initialIndex: 0 }) {
        ForEach(this.messages, (item: IMessage) => {
          if (item.type == ChatRoomMessageType.msg) {
            ChatMsg({
              message: (item.data as IChatRoomMessage).content,
              user: (item.data as IChatRoomMessage).userNickname || (item.data as IChatRoomMessage).userName,
              time: (item.data as IChatRoomMessage).time,
              avatar: (item.data as IChatRoomMessage).userAvatarURL
            })
          }
        })
      }
      .width('100%')
      .height('100%')
      .listDirection(Axis.Vertical) // 排列方向
      .scrollBar(BarState.Off)
      .friction(0.6)
      .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
      .edgeEffect(EdgeEffect.Spring)
      .backgroundColor('#FFF')
      Row() {
        Text('')
      }.width('100%')
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }.menus(this.titleBuilder)
    .backgroundColor('#EEEFF4')
    .title('聊天室')
  }
}
