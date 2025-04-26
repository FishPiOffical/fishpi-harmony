import { Header, HeaderAction } from "../../layout/main/header";
import { AppStorageV2 } from "@kit.ArkUI";
import Fishpi from "../../service/fishpi";
import { ChatContentType,
  ChatRoomMessage,
  ChatRoomMessageData, ChatRoomMessageType } from "../../service/types/chatroom";
import { ChatMsg } from "./ChatMsg";
import { MessageBox, MessageBoxExpose } from "./MessageBox";
import { MessageRender } from "../../components/Message";
import { IRedPacketOpen } from "../RedPacket/Open";
import { GestureType, IRedPacketMessage } from "../../service/types/redpacket";
import { toast } from "../../libs/utils";

@Builder
export function ChatRoomBuilder(name: string, param: Object) {
  ChatRoom()
}

@ComponentV2
export struct ChatRoom {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Local messages: ChatRoomMessageData[] = [];
  @Local msgScroller: Scroller = new Scroller();
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

  load(page: number) {
    return this.fishpi.chatroom.history(page, ChatContentType.Markdown).then((res) => {
      res.reverse();
      this.messages.unshift(...res.map(item => (new ChatRoomMessageData(item.type, item))));
    })
  }

  async init() {
    await this.load(1);
    await this.load(2);
    await this.load(3);
    setTimeout(() => {
      this.msgScroller.scrollToIndex(this.messages.length - 1)
    }, 100);
  }

  aboutToAppear(): void {
    this.init();
    this.fishpi.chatroom.addListener((res) => {
      if (res.type == ChatRoomMessageType.online) {
        return;
      }
      if (res.type == ChatRoomMessageType.discussChanged) {
        return;
      }
      if (res.type == ChatRoomMessageType.revoke) {
        const oId = res.revoke;
        const index = this.messages.findIndex((item) => item.message.oId == oId);
        if (index >= 0) {
          this.messages.splice(index, 1);
        }
        return;
      }
      if (res.type == ChatRoomMessageType.redPacketStatus) {
        return;
      }
      if (res.type == ChatRoomMessageType.msg) {
        res.message.content = res.message.md;
      }
      const isAtEnd = this.msgScroller.isAtEnd();
      this.messages.push(res);
      if (isAtEnd) {
        this.msgScroller.scrollToIndex(this.messages.length - 1);
      } else {
        this.newMsgSize++;
      }
    })
  }

  build() {
    NavDestination() {
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center,
      }) {
        Stack({
          alignContent: Alignment.Bottom,
        }) {
          List({ space: 20, initialIndex: 0, scroller: this.msgScroller }) {
            ForEach(this.messages, (data: ChatRoomMessageData) => {
              ListItem() {
                MessageRender({
                  data,
                  openRedPacket: (msg: ChatRoomMessage, gesture?: GestureType) => {
                    this.pathStack.pushPathByName('RedPacketOpen', { oId: msg.oId, type: msg.redPacket?.type, gesture } as IRedPacketOpen)
                  }
                })
              }
            })
          }
          .width('100%')
          .height('100%')
          .listDirection(Axis.Vertical) // 排列方向
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
        .height('100%')
        Column() {
          MessageBox({
            onExpose: (expose) => {
              this.messageBoxExpose = expose;
            },
            onSend: async (msg) => {
              return await this.fishpi.chatroom.send(msg)
                .then(() => true)
                .catch((err: Error) => {
                  toast(err.message)
                  return false
                })
            },
            redpack: true,
            onRedpack: () => {
              this.pathStack.pushPathByName('RedPacket', null)
            },
            barrage: true,
            onBarrage: async (msg: string) => {
              return await this.fishpi.chatroom.barrage(msg)
                .then(() => true)
                .catch((err: Error) => {
                  toast(err.message)
                  return false
                })
            },
          })
        }
        .width('100%')
        .padding({
          left: 5
        })
        .backgroundColor('#FFF')
      }.width('100%')
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
