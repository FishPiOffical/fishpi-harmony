import { Header, HeaderAction } from "../../layout/main/header";
import { AppStorageV2 } from "@kit.ArkUI";
import Fishpi from "../../service/fishpi";
import {
  ChatContentType,
  ChatMessageMode,
  ChatRoomMessage,
  ChatRoomMessageData,
  ChatRoomMessageType
} from "../../service/types/chatroom";
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
  @Local msgScroller: ListScroller = new ListScroller();
  @Local newMsgSize: number = 0;
  @Local messageBoxExpose?: MessageBoxExpose;
  @Local refreshing: boolean = false;

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
      this.msgScroller.scrollToIndex(res.length)
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

  async getChatRoom() {
    this.refreshing = true;
    await this.fishpi.chatroom.more(this.messages[0]!.message.oId, ChatMessageMode.Before, ChatContentType.Markdown).then((res) => {;
      res.reverse();
      this.messages.unshift(...res.map(item => (new ChatRoomMessageData(item.type, item))));
      this.msgScroller.scrollToIndex(res.length - 1)
    }).catch((err: Error) => {
      toast(err.message, this.getUIContext())
    })
    this.refreshing = false;
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
          Refresh({ refreshing: $$this.refreshing }) {
            List({ space: 20, initialIndex: 0, scroller: this.msgScroller }) {
              ForEach(this.messages, (data: ChatRoomMessageData) => {
                ListItem() {
                  MessageRender({
                    data,
                    openRedPacket: (msg: ChatRoomMessage, gesture?: GestureType) => {
                      this.pathStack.pushPathByName('RedPacketOpen',
                        { oId: msg.oId, type: msg.redPacket?.type, gesture } as IRedPacketOpen)
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
            .onScrollIndex((_, end) => {
              if (end == this.messages.length - 1) {
                this.newMsgSize = 0;
              }
            })
            .onClick(() => {
              this.messageBoxExpose?.blur()
            })
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#EEEFF4')
          .onRefreshing(() => {
            this.getChatRoom();
          })
          Button() {
            Row() {
              Text(){
                SymbolSpan($r('sys.symbol.chevron_down'))
              }.fontSize(14).fontColor('#FFFFFF')
              Text(` ${this.newMsgSize}条新消息`).fontSize(14).fontColor('#FFFFFF')
            }
          }
          .backgroundColor('#AAEB3805')
          .padding(10)
          .visibility(this.newMsgSize > 0 ? Visibility.Visible : Visibility.Hidden)
          .position({ bottom: 10, right: 5 })
          .onClick(() => {
            this.msgScroller.scrollToIndex(this.messages.length - 1);
            this.newMsgSize = 0;
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
                  toast(err.message, this.getUIContext())
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
                  toast(err.message, this.getUIContext())
                  return false
                })
            },
          })
        }
        .width('100%')
      }.width('100%')

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
