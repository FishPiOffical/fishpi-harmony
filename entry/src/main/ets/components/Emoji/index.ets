import Fishpi from "../../service/fishpi";
import { EmojiList } from "./list";
import { AppStorageV2 } from "@kit.ArkUI";
import { Emoji } from "../../service/emoji";


@ComponentV2
export struct EmojiPicker {
    @Param onPick: (emoji: string) => void = () => {};
    @Local emojis: string[] = [];
    @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;

    aboutToAppear(): void {
      this.fishpi.emoji.list().then(emojis => {
        this.emojis = emojis;
      });
    }

    getTabBarStyle(icon: Resource) {
      return new BottomTabBarStyle(icon, '').iconStyle({
        selectedColor: "#f0d35e",
      }).labelStyle({
        selectedColor: "#000",
        font: { size: 14, weight: FontWeight.Bold },
      })
    }

    build() {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          Scroll() {
            EmojiList({
              emojis: Object.values(Emoji.default),
              onSend: (emoji) => {
                this.onPick(':' + Object.keys(Emoji.default)[Object.values(Emoji.default).indexOf(emoji)] + ':');
              }
            })
          }
        }.tabBar(this.getTabBarStyle($r('app.media.emoji')))
        TabContent() {
          Scroll() {
            EmojiList({
              emojis: this.emojis,
              onSend: (emoji) => {
                this.onPick(`![图片表情](${emoji})`);
              }
            })
          }
        }.tabBar(this.getTabBarStyle($r('app.media.thank')))
      }
      .padding({bottom:20})
    }
}