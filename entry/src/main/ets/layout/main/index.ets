import { Header } from "./header"
import { Nav } from "./nav";

@ComponentV2
export struct MainLayout {
  @BuilderParam builder: () => void;

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Header().width('100%').height(60)
      Column() {
        this.builder()
      }.backgroundColor('#FAFAFA')
      Nav().width('100%').height(75)
      Row() {
        Text('').width('100%')
      }
      .backgroundColor('#F0D35E')
      // 设置底部绘制延伸到导航条
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
  }
}