import { Header, HeaderAction } from "../../layout/main/header";
import { AppStorageV2 } from "@kit.ArkUI";
import Fishpi from "../../service/fishpi";
import { ChatContentType, ChatRoomMessageType, IChatRoomMessage, IMessage } from "../../service/types/chatroom";
import { ChatMsg } from "./ChatMsg";
import { MessageBox, MessageBoxExpose } from "./MessageBox";

@Builder
export function ChatRoomBuilder(name: string, param: Object) {
  ChatRoom()
}

@ComponentV2
export struct ChatRoom {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Local messages: IMessage[] = [];
  private msgScroller: Scroller = new Scroller();
  @Local newMsgSize: number = 0;
  @Local messageBoxExpose?: MessageBoxExpose;

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
      this.msgScroller.scrollToIndex(this.messages.length - 1);
    })
    this.fishpi.chatroom.addListener((res) => {
      if (res.type == ChatRoomMessageType.msg) {
        (res.data as IChatRoomMessage).content = (res.data as IChatRoomMessage).md;
        const isAtEnd = this.msgScroller.isAtEnd();
        this.messages.push(res);
        if (isAtEnd) {
          this.msgScroller.scrollToIndex(this.messages.length - 1);
        } else {
          this.newMsgSize++;
        }
      }
    })
  }

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column }) {
        Stack() {
          List({ space: 20, initialIndex: 0, scroller: this.msgScroller }) {
            ForEach(this.messages, (item: IMessage) => {
              if (item.type == ChatRoomMessageType.msg) {
                ListItem() {
                  ChatMsg({
                    message: (item.data as IChatRoomMessage).content,
                    user: (item.data as IChatRoomMessage).userNickname || (item.data as IChatRoomMessage).userName,
                    time: (item.data as IChatRoomMessage).time,
                    avatar: (item.data as IChatRoomMessage).userAvatarURL
                  })
                }
              }
            })
          }
          .width('100%')
          .height('100%')
          .listDirection(Axis.Vertical) // 排列方向
          .scrollBar(BarState.Auto)
          .friction(0.6)
          .edgeEffect(EdgeEffect.Spring)
          .onScrollIndex(() => {
            if (this.msgScroller.isAtEnd()) {
              this.newMsgSize = 0;
            }
          })
          .onClick(() => {
            this.messageBoxExpose?.blur()
          })
        }
        .width('100%')
        .alignContent(Alignment.Bottom)
        MessageBox({
          onExpose: (expose) => {
            this.messageBoxExpose = expose;
          },
          onSend: async (msg) => {
            return await this.fishpi.chatroom.send(msg).then(() => true).catch(() => false)
          }
        }).width('100%')
      }
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
