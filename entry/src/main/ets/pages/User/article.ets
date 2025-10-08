import Fishpi from "../../service/fishpi";
import { AppStorageV2 } from "@kit.ArkUI";
import { ArticleItem } from "../Article/ArticleItem";
import { IArticleParam } from "../Article/ArticleDetail";
import { IArticleDetail } from "../../service/types/article";
import { ArticleQuery } from "../../service";

@ComponentV2
export struct UserArticle {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Require @Param user: string;
  @Local articleList: IArticleDetail[] = [];
  @Local query: ArticleQuery = new ArticleQuery();
  @Local refreshing: boolean = false;

  aboutToAppear(): void {
    this.query.user = this.user;
    this.articleList = [];
    this.load();
  }

  load () {
    return this.fishpi.article.list(this.query.toJSON())
      .then((res) => {
        this.articleList.push(...res.articles);
      })
  }

  build() {
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
  }
}