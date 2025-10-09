import { AppStorageV2 } from "@kit.ArkUI";
import { htmlToText, toast } from "../../libs/utils";
import Fishpi from "../../service/fishpi";
import { IArticleDetail } from "../../service/types/article";
import { NoticeData, NoticeType } from '../../service/types/notice';
import { IArticleParam } from "../Article/ArticleDetail";
import { ChatItem } from "../Chats/ChatItem";
import { IUserParam } from "../User/Index";

@ComponentV2
export struct NoticeList {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Require @Param type: NoticeType;
  @Local notices: NoticeData[] = [];
  @Local refreshing: boolean = false;
  private page = 1;

  aboutToAppear(): void {
    this.notices = [];
    this.load();
  }

  load() {
    return this.fishpi.notice.list(this.type, this.page)
      .then(res => {
        this.notices.push(...res);
      })
      .catch((e: Error) => {
        toast(e.message, this.getUIContext())
      });
  }

  build() {
    Refresh({ refreshing: $$this.refreshing }) {
      List({ space: 0, initialIndex: 0 }) {
        ForEach(this.notices, (data: NoticeData) => {
          ListItem() {
            if (data.type == NoticeType.Comment) {
              ChatItem({
                icon: data.comment?.commentAuthorThumbnailURL,
                name: data.comment?.commentAuthorName,
                time: data.comment?.oId,
                content: htmlToText(data.comment?.commentContent || ''),
                onTap: () => {
                  this.pathStack.pushPathByName('Article', {
                    id: data.comment?.commentSharpURL.match(/article\/(\d+)\?/)?.[1],
                    comment: data.comment?.commentSharpURL.match(/#(\d+)/)?.[1],
                    page: Number(data.comment?.commentSharpURL.match(/p=(\d+)/)?.[1])
                  } as IArticleParam)
                }
              }).opacity(data.comment?.hasRead ? 0.5 : 1)
            }
            else if (data.type == NoticeType.Reply) {
              ChatItem({
                icon: data.reply?.commentAuthorThumbnailURL,
                name: data.reply?.commentAuthorName,
                time: data.reply?.oId,
                content: htmlToText(data.reply?.commentContent || ''),
                onTap: () => {
                  this.pathStack.pushPathByName('Article', {
                    id: data.comment?.commentSharpURL.match(/article\/(\d+)\?/)?.[1],
                    comment: data.comment?.commentSharpURL.match(/#(\d+)/)?.[1],
                    page: Number(data.comment?.commentSharpURL.match(/p=(\d+)/)?.[1])
                  } as IArticleParam)
                }
              }).opacity(data.reply?.hasRead ? 0.5 : 1)
            }
            else if (data.type == NoticeType.At) {
              ChatItem({
                icon: data.at?.thumbnailURL || data.at?.userAvatarURL,
                name: data.at?.userName + (data.at?.dataType == 38 ? ' 在 聊天室 @了你' : ''),
                time: data.at?.oId,
                content: htmlToText(data.at?.description || data.at?.content || '').replace(data.at?.userName || '', '').trim(),
                onTap: () => {
                  if (data.at?.dataType == 38) {
                    return this.pathStack.pushPathByName('ChatRoom', null)
                  }
                  this.pathStack.pushPathByName('Article', {
                    id: data.at?.dataId.split('-')[0],
                  } as IArticleParam)
                }
              }).opacity(data.at?.hasRead ? 0.5 : 1)
            }
            else if (data.type == NoticeType.Following) {
              ChatItem({
                icon: data.follow?.thumbnailURL,
                name: data.follow?.authorName,
                time: data.follow?.oId,
                content: data.follow?.articleTitle,
                onTap: () => {
                  this.pathStack.pushPathByName('Article', { id: data.follow?.oId } as IArticleParam)
                }
              }).opacity(data.follow?.hasRead ? 0.5 : 1)
            }
            else if (data.type == NoticeType.Point) {
              Text() {
                Span(data.point?.description.match(/member\/([^"]*?)"/)?.[1] || '')
                  .fontSize(16)
                  .fontColor('#1947E6')
                  .fontWeight(FontWeight.Bold)
                  .onClick(() => {
                    if (!data.point?.description.match(/member\/([^"]*?)"/)?.[1]) return;
                    this.pathStack.pushPathByName('User', { user: data.point?.description.match(/member\/([^"]*?)"/)?.[1] } as IUserParam)
                  })
                Span(data.point?.description.match(/<\/a>([^<]*?)</)?.[1] || '')
                  .fontSize(16)
                  .fontColor('#474A57')
                Span(data.point?.description.match(/>([^<]*?)<\/\w+>\s*$/)?.[1] || '')
                  .fontSize(16)
                  .fontColor(data.point?.description.match(/article\/(\d+)/)?.[1] ? '#1947E6' : '#474A57')
                  .onClick(() => {
                    if (!data.point?.description.match(/article\/(\d+)/)?.[1]) return;
                    this.pathStack.pushPathByName('Article', { id: data.point?.description.match(/article\/(\d+)/)?.[1] } as IArticleParam)
                  })
              }.padding({
                top: 10,
                bottom: 10,
                left: 15,
                right: 15,
              })
              .width('100%')
              .border({
                width: { bottom: 1 },
                style: BorderStyle.Dashed,
                color: '#C4C4C4'
              }).opacity(data.point?.hasRead ? 0.5 : 1)
            }
            else if (data.type == NoticeType.System) {
              Row() {
                Text(htmlToText(data.system?.description || ''))
                  .fontSize(16)
                  .fontColor(data.system?.description.match(/article\/(\d+)/)?.[1] ? '#1947E6' : '#474A57')
                  .fontWeight(FontWeight.Bold)
                  .onClick(() => {
                    if (!data.point?.description.match(/article\/(\d+)/)?.[1]) return;
                    this.pathStack.pushPathByName('Article', { id: data.point?.description.match(/article\/(\d+)/)?.[1] } as IArticleParam)
                  })
              }.padding({
                top: 10,
                bottom: 10,
                left: 15,
                right: 15,
              })
              .width('100%')
              .border({
                width: { bottom: 1 },
                style: BorderStyle.Dashed,
                color: '#C4C4C4'
              }).opacity(data.system?.hasRead ? 0.5 : 1)
            }
          }
        })
      }
      .width('100%')
      .height('100%')
      .listDirection(Axis.Vertical) // 排列方向
      .friction(0.6)
      .edgeEffect(EdgeEffect.Spring)
      .onScrollIndex((_, end) => {
        if (end == this.notices.length - 1) {
          this.page += 1;
          this.load()
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#EEEFF4')
    .onRefreshing(() => {
      this.page = 1;
      this.notices = [];
      this.load().finally(() => {
        this.refreshing = false;
      });
    })
  }
}