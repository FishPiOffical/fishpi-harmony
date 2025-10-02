import { IUserParam } from "../../pages/User/Index";
import Fishpi from "../../service/fishpi";
import { CircleIcon } from "../CircleIcon";
import { AppStorageV2 } from "@kit.ArkUI";

@ComponentV2
export struct Avatar {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Require @Param user: string;
  @Require @Param avatar: string;
  @Param iconSize: number = 48;
  @Param strokeSize: number = 2;
  @Param badge: number | ResourceColor | boolean = false;

  build() {
    CircleIcon({
      icon: this.avatar,
      iconSize: this.iconSize,
      strokeSize: this.strokeSize,
      badge: this.badge,
    }).width(this.iconSize)
      .onClick(() => {
        this.pathStack.pushPathByName('User', { user: this.user } as IUserParam);
      })
  }
}