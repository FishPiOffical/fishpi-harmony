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

  aboutToAppear(): void {
    if (this.user) {
      this.query.user = this.user;
    }
    this.load();
  }

  load() {
    this.fishpi.breezemoon.list(this.query.toJSON())
      .then((res) => {
        this.breezemoonList = res;
      })
  }

  build() {

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