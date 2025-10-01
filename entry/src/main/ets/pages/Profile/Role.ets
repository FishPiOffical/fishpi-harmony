import { BorderBox } from "../../components/BorderBox";
import { Icon } from "../../components/Icon";

export interface IButtonItem {
  icon: string | Resource;
  name: string;
  action: () => void;
}

@ComponentV2
export struct Role {
  @Require @Param role: string;

  @Computed
  get icon() {
    switch (this.role) {
      case '管理员':
        return $r('app.media.admin');
      case 'OP':
        return $r('app.media.op');
      case '纪律委员':
        return $r('app.media.police');
      case '超级会员':
        return $r('app.media.vip');
      case '成员':
        return $r('app.media.member');
      case '新手':
        return $r('app.media.fresh');
      default:
        return $r('app.media.fresh');
    }
  }

  @Computed
  get bgColor() {
    switch (this.role) {
      case '管理员':
        return '#000';
      case 'OP':
        return '#ED0505';
      case '纪律委员':
        return '#199FE6';
      case '超级会员':
        return '#FFDD07';
      case '成员':
        return '#7CE461';
      case '新手':
        return '#6166E4';
      default:
        return '#6166E4';
    }
  }

  build() {
    Row() {
      Icon({
        icon: this.icon,
        color: null, stroke: null,
        iconSize: 14,
      })
      Text(this.role)
        .fontSize(12)
        .fontColor('#fff')
        .fontWeight(FontWeight.Bold)
        .margin({ left: 5 })
    }.backgroundColor(this.bgColor)
    .borderRadius(5)
    .padding(4)
  }
}