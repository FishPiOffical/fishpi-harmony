import { AppStorageV2 } from '@kit.ArkUI';
import { MainLayout } from '../../layout/main';
import { htmlToText } from '../../libs/utils';
import Fishpi from '../../service/fishpi'
import { ChatRoomMessageType } from '../../service/types/chatroom';
import { ChatItem } from './ChatItem';
import { ChatMsg, ChatMsgType } from '../../service/types/chat';
import { IChatParam } from './ChatPrivate';

@ObservedV2
class ChatItemProps {
  @Trace
  icon: ResourceStr;
  @Trace
  name: string;
  @Trace
  time: string;
  @Trace
  content: string;

  constructor(icon: ResourceStr, name: string, time = '', content = '') {
    this.icon = icon;
    this.name = name;
    this.time = time;
    this.content = content;
  }
}

@ComponentV2
export struct Chats {
  @Local userName: string = '';
  @Local info: string = '';
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Local chatList: ChatItemProps[] = [];
  @Local chatroom: ChatItemProps = new ChatItemProps($r('app.media.chatroom'), '聊天室');

  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()

  aboutToAppear() {
    this.fishpi.chatroom.history().then((res) => {
      this.chatroom.time = res[0].time;
      this.chatroom.content = htmlToText(res[0].content);
    })
    this.fishpi.chatroom.addListener((res) => {
      if (res.type != ChatRoomMessageType.msg) return;
      const msg = res.message;
      this.chatroom.time = msg.time;
      this.chatroom.content = htmlToText(msg.content);
    })
    this.fishpi.chat.list().then((res) => {
      res.forEach(chat => {
        this.chatList.push(new ChatItemProps(chat.senderAvatar, chat.senderUserName, chat.time, chat.preview))
      })
    }).then(() => {
      this.fishpi.chat.addListener((data: ChatMsg) => {
        switch(data.type) {
          case ChatMsgType.notice: {
            const userName = data.notice?.senderUserName
            const chat = this.chatList.find(c => c.name == userName);
            if (chat) chat.content = data.notice?.preview || chat.content;
            else if(data.notice) this.chatList.unshift(new ChatItemProps(data.notice.senderAvatar, data.notice.senderUserName, new Date().toLocaleString(), data.notice.preview))
            break;
          }
        }
      });
    })
  }

  build() {
    MainLayout() {
      Column() {
        ChatItem({
          icon: this.chatroom.icon,
          name: this.chatroom.name,
          time: this.chatroom.time,
          content: this.chatroom.content,
          onTap: () => {
            this.pathStack.pushPathByName('ChatRoom', null)
          }
        })
        ForEach(this.chatList, (chat: ChatItemProps) => {
          ChatItem({
            icon: chat.icon,
            name: chat.name,
            time: chat.time,
            content: chat.content,
            onTap: () => {
              this.pathStack.pushPathByName('Chat', { name: chat.name } as IChatParam)
            }
          })
        })
      }
    }
  }
}