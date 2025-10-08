import { Header, HeaderAction } from "../../layout/main/header";
import { AppStorageV2 } from "@kit.ArkUI";
import Fishpi from "../../service/fishpi";
import { MessageBox, MessageBoxExpose } from "./MessageBox";
import { MessageRender } from "../../components/Message";
import { IRedPacketOpen } from "../RedPacket/Open";
import { ChatData, IChatData } from "../../service/types/chat";
import { IUserInfo } from "../../service/types/user";
import { ChatRender } from "../../components/Message/Chat";
import { toast } from "../../libs/utils";

export interface IChatParam {
  name: string;
}

@Builder
export function ChatBuilder(name: string, param: IChatParam) {
  Chat({
    user: param.name
  })
}

@ComponentV2
export struct Chat {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Require @Param user: string;
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Local messages: IChatData[] = [];
  @Local msgScroller: Scroller = new Scroller();
  @Local newMsgSize: number = 0;
  @Local messageBoxExpose?: MessageBoxExpose;
  @Local talk?: IUserInfo;
  @Local refreshing: boolean = false;
  private currentPage: number = 1;

  @Computed
  get me() {
    return this.fishpi.user.me
  }

  @Builder
  titleBuilder() {
    Header({
      title: this.talk?.userNickname || this.user,
      leftAction: new HeaderAction($r('app.media.back'), () => {
        const stack = this.pathStack.pop()
        console.log('stack', stack)
      }),
    }).height('100%')
  }

  load(page: number) {
    return this.fishpi.chat.history({
      user: this.user,
      page,
      size: 30,
      autoRead: true
    })
      .then((res) => {
        res.reverse();
        res = res.filter((r) => !this.messages.some(m => m.oId == r.oId));
        this.messages.unshift(...res);
        this.currentPage = page;
        return res;
      })
      .catch((err: Error) => {
        toast(err.message, this.getUIContext())
        return [];
      })
  }

  async init() {
    await this.load(this.currentPage);
    await this.fishpi.getUser(this.user)
      .then(res => this.talk = res)
      .catch((err: Error) => {
        console.error(err.message)
      });
    setTimeout(() => {
      this.msgScroller.scrollToIndex(this.messages.length - 1)
    }, 100);
  }

  aboutToAppear(): void {
    this.init();
    this.fishpi.chat.addListener((res) => {
      if (!res.chat) {
        return;
      }
      const isAtEnd = this.msgScroller.isAtEnd();
      this.messages.push(res.chat);
      if (isAtEnd) {
        this.msgScroller.scrollToIndex(this.messages.length - 1);
      } else {
        this.newMsgSize++;
      }
    }, this.user)
  }

  build() {
    NavDestination() {
      Flex({
        direction: FlexDirection.Column,
      }) {
        Stack({
          alignContent: Alignment.Bottom,
        }) {
          Refresh({ refreshing: $$this.refreshing }) {
            List({ space: 20, initialIndex: 0, scroller: this.msgScroller }) {
              ForEach(this.messages, (data: IChatData) => {
                ListItem() {
                  ChatRender({
                    data,
                    isSelf: this.me?.userName == data.senderUserName
                  })
                }
              })
            }
            .width('100%')
            .height('100%')
            .alignListItem(ListItemAlign.End)
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
          .backgroundColor('#EEEFF4')
          .onRefreshing(() => {
            this.load(this.currentPage + 1).then((res) => {
              this.refreshing = false;
              this.msgScroller.scrollToIndex(res.length - 1)
            });
          })

          Button() {
            Row() {
              Text() {
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

        MessageBox({
          onExpose: (expose) => {
            this.messageBoxExpose = expose;
          },
          onSend: async (msg) => {
            return await this.fishpi.chat.send(this.user, msg)
              .then(() => true)
              .catch(() => false)
          }
        })
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
