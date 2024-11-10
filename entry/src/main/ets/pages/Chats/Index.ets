import { AppStorageV2 } from '@kit.ArkUI';
import { MainLayout } from '../../layout/main';
import { htmlToText } from '../../libs/utils';
import Fishpi from '../../service/fishpi'
import { ChatItem } from './ChatItem';

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

  pathStack: NavPathStack = new NavPathStack()

  aboutToAppear() {
    this.fishpi.chatroom.more().then((res) => {
      this.chatroom.time = res[0].time;
      this.chatroom.content = htmlToText(res[0].content);
    })
  }

  build() {
    MainLayout() {
      Column() {
        ChatItem({
          icon: this.chatroom.icon,
          name: this.chatroom.name,
          time: this.chatroom.time,
          content: this.chatroom.content
        })
      }
    }
  }
}