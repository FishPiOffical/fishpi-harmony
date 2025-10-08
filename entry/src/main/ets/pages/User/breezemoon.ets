import { AppStorageV2 } from "@kit.ArkUI";
import { BreezemoonQuery } from "../../service";
import Fishpi from "../../service/fishpi";
import { IBreezemoonContent } from "../../service/types/breezemoon";
import { BreezemoonItem } from "../Breezemoon/BreezemoonItem";

@ComponentV2
export struct UserBreezemoon {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Require @Param user: string;
  @Local query: BreezemoonQuery = new BreezemoonQuery();
  @Local breezemoonList: IBreezemoonContent[] = [];
  @Local refreshing: boolean = false;

  aboutToAppear(): void {
    if (this.user) {
      this.query.user = this.user;
    }
    this.breezemoonList = [];
    this.load();
  }

  load() {
    return this.fishpi.breezemoon.list(this.query.toJSON())
      .then((res) => {
        this.breezemoonList.push(...res)
      })
  }

  build() {
    Column() {
      Refresh({ refreshing: $$this.refreshing }) {
        List({ space: 20, initialIndex: 0 }) {
          ForEach(this.breezemoonList, (data: IBreezemoonContent, i) => {
            ListItem() {
              BreezemoonItem({
                item: data,
              }).margin({
                top: i == 0 ? 20 : 0,
                bottom: i == this.breezemoonList.length - 1 ? 20 : 0
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
          if (end == this.breezemoonList.length - 3) {
            this.query.page += 1;
            this.load();
          }
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#EEEFF4')
      .onRefreshing(() => {
        this.query.page = 1;
        this.breezemoonList = [];
        this.load().then(() => {
          this.refreshing = false;
        })
      })
      }
  }
}