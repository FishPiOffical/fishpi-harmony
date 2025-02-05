import { MainLayout } from "../../layout/main";
import Fishpi from "../../service/fishpi";
import { AppStorageV2 } from "@kit.ArkUI";
import { Header, HeaderAction } from "../../layout/main/header";
import { IBreezemoonContent, IBreezemoonQuery } from "../../service/types/breezemoon";
import { BreezemoonItem } from "./BreezemoonItem";

@ObservedV2
class BreezemoonQuery implements IBreezemoonQuery {
  @Trace
  page: number = 1;
  @Trace
  size: number = 10;
  @Trace
  user?: string;

  toJSON(): IBreezemoonQuery {
    return {
      page: this.page,
      size: this.size,
      user: this.user,
    }
  }
}

@ComponentV2
export struct BreezeList {
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local query: BreezemoonQuery = new BreezemoonQuery();
  @Local breezemoonList: IBreezemoonContent[] = [];

  aboutToAppear(): void {
    this.fishpi.breezemoon.list(this.query.toJSON())
      .then((res) => {
        this.breezemoonList = res;
      })
  }

  build() {
    MainLayout() {
      Column() {
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
      }
    }
  }
}