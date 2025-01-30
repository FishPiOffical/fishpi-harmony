import { MainLayout } from "../../layout/main";
import Fishpi from "../../service/fishpi";
import { AppStorageV2 } from "@kit.ArkUI";
import { ArticleListType, IArticleDetail, IArticleQuery, IArticleTag } from "../../service/types/article";
import { ArticleItem } from "./ArticleItem";
import { IArticleParam } from "./ArticleDetail";
import { Header, HeaderAction } from "../../layout/main/header";
import { CircleIcon } from "../../components/CircleIcon";
import { Icon } from "../../components/Icon";


export interface IArticleListParam {
  tag: string;
}

@Builder
export function ArticleListBuilder(_name: string, param: IArticleListParam) {
  ArticleList({
    tag: param.tag
  })
}

@ObservedV2
class ArticleQuery implements IArticleQuery {
  @Trace
  page: number = 1;
  @Trace
  size: number = 10;
  @Trace
  user?: string;
  @Trace
  tag?: string;
  @Trace
  type: ArticleListType = ArticleListType.Recent;

  toJSON(): IArticleQuery {
    return {
      page: this.page,
      size: this.size,
      user: this.user,
      tag: this.tag,
      type: this.type
    }
  }
}

@ComponentV2
export struct ArticleList {
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local query: ArticleQuery = new ArticleQuery();
  @Local articleList: IArticleDetail[] = [];
  @Local articleTag?: IArticleTag;
  @Param tag: string = '';

  aboutToAppear(): void {
    if (this.tag) {
      this.query.tag = this.tag;
    }
    this.fishpi.article.list(this.query.toJSON())
      .then((res) => {
        this.articleList = res.articles;
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
      }.width('100%').padding({ top: 10, left: 20, right: 20, bottom: 5 }).justifyContent(FlexAlign.SpaceBetween)
    }
    Column() {
      List({ space: 20, initialIndex: 0 }) {
        ForEach(this.articleList, (data: IArticleDetail, i) => {
          ListItem() {
            ArticleItem({
              item: data,
            }).margin({
              top: i == 0 ? 20 : 0,
              bottom: i == this.articleList.length - 1 ? 20 : 0
            }).onClick(() => {
              this.pathStack.pushPathByName('Article', { id: data.oId } as IArticleParam)
            })
          }
        })
      }
      .width('100%')
      .height('100%')
      .listDirection(Axis.Vertical) // 排列方向
      .friction(0.6)
      .edgeEffect(EdgeEffect.Spring)
    }
    if (this.tag) {
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
    if (this.tag) {
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