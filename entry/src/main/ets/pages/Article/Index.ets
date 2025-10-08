import { MainLayout } from "../../layout/main";
import Fishpi from "../../service/fishpi";
import { AppStorageV2 } from "@kit.ArkUI";
import { IArticleDetail, IArticleTag } from "../../service/types/article";
import { ArticleItem } from "./ArticleItem";
import { IArticleParam } from "./ArticleDetail";
import { Header, HeaderAction } from "../../layout/main/header";
import { CircleIcon } from "../../components/CircleIcon";
import { Icon } from "../../components/Icon";
import { IUserInfo } from "../../service/types/user";
import { Avatar } from "../../components/Avatar/Index";
import { ArticleQuery } from "../../service";


export interface IArticleListParam {
  tag?: string;
  user?: string;
}

@Builder
export function ArticleListBuilder(_name: string, param: IArticleListParam) {
  ArticleList({
    tag: param.tag,
    user: param.user,
  })
}


@ComponentV2
export struct ArticleList {
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local query: ArticleQuery = new ArticleQuery();
  @Local articleList: IArticleDetail[] = [];
  @Local articleTag?: IArticleTag;
  @Local articleUser?: IUserInfo;
  @Param tag: string = '';
  @Param user: string = '';
  @Local refreshing: boolean = false;
  @Local currentPage: number = 1;

  aboutToAppear(): void {
    if (this.tag) {
      this.query.tag = this.tag;
    }
    if (this.user) {
      this.query.user = this.user;
      this.fishpi.getUser(this.user).then(user => this.articleUser = user);
    }
    this.fishpi.article.list(this.query.toJSON())
      .then((res) => {
        this.articleList = res.articles;
        this.articleTag = res.tag;
      })
  }

  load() {
    return this.fishpi.article.list(this.query.toJSON())
      .then((res) => {
        this.articleList.push(...res.articles);
        this.articleTag = res.tag;
      })
  }

  @Builder
  mainBuilder() {
    if (this.articleTag) {
      Row() {
        Row({ space: 5 }) {
          if (this.articleTag.tagIconPath) {
            CircleIcon({
              icon: this.articleTag.tagIconPath
            })
          }
          Column() {
            Text(this.articleTag.tagTitle).fontSize(20).fontWeight(FontWeight.Bold)
            Row() {
              Text(this.articleTag.tagReferenceCount + ' ').fontSize(14).fontColor('#ED3905')
              Text(`引用 ${this.articleTag.tagCommentCount} 回帖`)
            }
          }.alignItems(HorizontalAlign.Start)
        }

        Row({
          space: 10
        }) {
          Icon({
            icon: $r('app.media.star'),
            stroke: '#000000'
          })
          Text(this.articleTag.tagFollowerCount + '').fontSize(20).fontColor('#000').fontWeight(FontWeight.Bold)
        }
      }
      .backgroundColor('#EEEFF4')
      .width('100%')
      .padding({
        top: 10,
        left: 20,
        right: 20,
        bottom: 5
      })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    if (this.articleUser) {
      Row() {
        Avatar({
          avatar: this.articleUser.userAvatarURL,
          user: this.articleUser.userName,
        })
        Text(this.articleUser.userNickname || this.articleUser.userName).fontSize(20).fontWeight(FontWeight.Bold)
        Text(' 的文章列表').fontSize(20).fontWeight(FontWeight.Bold)
      }
      .backgroundColor('#EEEFF4')
      .width('100%')
      .padding({
        top: 10,
        left: 20,
        right: 20,
        bottom: 5
      })
    }
    Column() {
      Refresh({ refreshing: $$this.refreshing }) {
        List({ space: 20, initialIndex: 0 }) {
          ForEach(this.articleList, (data: IArticleDetail, i) => {
            ListItem() {
              ArticleItem({
                item: data,
              }).margin({
                top: i == 0 ? 20 : 0,
                bottom: i == this.articleList.length - 1 ? 20 : 0
              }).onClick(() => {
                if (this.pathStack.getAllPathName().pop() != 'Article' ||
                  (this.pathStack.getParamByName('Article').pop() as IArticleParam)?.id != data.oId) {
                  this.pathStack.pushPathByName('Article', { id: data.oId } as IArticleParam)
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
          if (end == this.articleList.length - 3) {
            this.query.page = this.query.page + 1;
            this.load();
          }
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#EEEFF4')
      .onRefreshing(() => {
        this.query.page = 1;
        this.articleList = [];
        this.load().then(() => {
          this.refreshing = false;
        })
      })
    }

    if (this.tag || this.user) {
      Row() {
        Text(' ')
      }.width('100%')
      .backgroundColor('#eeeff4')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
  }

  @Builder
  titleBuilder() {
    Header({
      title: '',
      leftAction: new HeaderAction($r('app.media.back'), () => {
        const stack = this.pathStack.pop()
        console.log('stack', stack)
      }),
    }).height('100%')
  }

  build() {
    if (this.tag || this.user) {
      NavDestination() {
        this.mainBuilder()
      }.menus(this.titleBuilder)
      .backgroundColor('#EEEFF4')
      .title('文章列表')
    } else {
      MainLayout() {
        this.mainBuilder()
      }
    }
  }
}