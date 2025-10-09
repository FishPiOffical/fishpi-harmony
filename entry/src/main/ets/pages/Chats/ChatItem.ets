import { DateUtil } from "@pura/harmony-utils";
import { CircleIcon } from "../../components/CircleIcon"

@ComponentV2
export struct ChatItem {
  @Require @Param icon: ResourceStr;
  @Require @Param name: string;
  @Require @Param content: string;
  @Require @Param time: string;
  @Param fontColor: ResourceColor = '#18191F';

  @Event onTap: (event?: ClickEvent) => void = ()=>{};

  getShortTime() {
    if (!this.time) return ''
    return DateUtil.getTipDateStr(this.time)
  }

  build() {
    Flex({ direction: FlexDirection.Row }) {
      CircleIcon({
        icon: this.icon,
      }).width(48)
      Column() {
        Row(){
          Text(this.name).fontWeight(FontWeight.Bold).fontSize(20)
            .textAlign(TextAlign.Start)
            .fontColor(this.fontColor)
          Text(this.getShortTime())
            .fontSize(11)
            .fontColor('#9FA4B4')
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .height('50%')
        Row() {
          Text(this.content)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .fontSize(15)
            .width('100%')
            .fontColor(this.fontColor)
        }
        .alignItems(VerticalAlign.Center)
        .height('50%')
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .padding({ left: 10, right: 10 })
      .width('100%')
    }
    .padding({
      top: 10,
      bottom: 10,
      left: 15,
      right: 15,
    })
    .border({
      width: { bottom: 1 },
      style: BorderStyle.Dashed,
      color: '#C4C4C4'
    })
    .width('100%')
    .height(70)
    .onClick(this.onTap)

  }
}