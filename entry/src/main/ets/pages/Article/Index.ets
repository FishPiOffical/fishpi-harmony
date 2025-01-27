import { MainLayout } from "../../layout/main";
import Fishpi from "../../service/fishpi";
import { AppStorageV2 } from "@kit.ArkUI";
import { ArticleListType, IArticleDetail, IArticleQuery, IArticleTag } from "../../service/types/article";
import { ArticleItem } from "./ArticleItem";

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
export struct Article {
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local query: ArticleQuery = new ArticleQuery();
  @Local articleList: IArticleDetail[] = [];
  @Local articleTag?: IArticleTag;

  aboutToAppear(): void {
    this.fishpi.article.list(this.query.toJSON())
      .then((res) => {
        this.articleList = res.articles;
        this.articleTag = res.tag;
      })
  }

  build() {
    MainLayout() {
      if (this.articleTag) {
        Column() {
          Text(this.articleTag.tagTitle)
        }
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
    }
  }
}