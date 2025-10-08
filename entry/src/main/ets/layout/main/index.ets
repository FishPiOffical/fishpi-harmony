import { Header, HeaderAction, HeaderActionOptions } from "./header"
import { Nav } from "./nav/index";

@ComponentV2
export struct MainLayout {
  @BuilderParam builder: () => void;

  build() {
    Column() {
      this.builder()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#EEEFF4')
    .border({ width: { bottom: 2 }, color: '#000' })
  }
}