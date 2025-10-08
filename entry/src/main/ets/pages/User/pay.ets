import { AppStorageV2, LengthMetrics } from "@kit.ArkUI";
import { Icon } from "../../components/Icon";
import { toast } from "../../libs/utils";
import Fishpi from "../../service/fishpi";
import { IUserInfo } from "../../service/types/user";


@ComponentV2
export struct Pay {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Local amount: string = '';
  @Local memo: string = '';
  @Require @Param user: IUserInfo;
  @Event onExit: () => void;

  build() {
    Column({
       space: 10
    }) {
      Row() {
        Text('转账给').fontWeight(FontWeight.Bold).fontSize(20)
        Text(this.user.userNickname || this.user.userName).fontWeight(FontWeight.Bold).fontColor('#EB3805').fontSize(20)
      }
      Row() {
        Text('转账后积分即时到账，请谨慎交易！').fontSize(13).fontColor('#18191F')
      }
      Row() {
        Icon({
          icon: $r('app.media.pay'),
          color: null,
          stroke: null,
        })
          .width(20)
          .height(20)

        TextInput({ placeholder: '转账金额', text: $$this.amount })
          .backgroundColor(Color.Transparent)
          .type(InputType.Number)
      }
      .padding({
        left: 10,
        right: 10,
        top: 5,
        bottom: 5
      })
      .border({
        width: 2,
        color: '#18191F',
        radius: 16,
      }).backgroundColor('#FFFFFF')

      Row() {
        TextArea({ placeholder: '转账说明', text: $$this.memo })
          .showCounter(true)
          .backgroundColor(Color.Transparent)
      }
      .padding({
        left: 10,
        right: 10,
        top: 5,
        bottom: 5
      })
      .border({
        width: 2,
        color: '#18191F',
        radius: 16,
      }).backgroundColor('#FFFFFF')

      Flex({
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center,
        space: {
          main: LengthMetrics.px(10)
        }
      }) {
        Button() {
          Text('算了').fontSize(18).fontWeight(FontWeight.Bold).fontColor('#000')
        }.backgroundColor('#fff').border({
          color: '#000',
          width: 2,
        }).padding(10).width('100%')
        .onClick(() => this.onExit && this.onExit())
        Button() {
          Text('转账').fontSize(18).fontWeight(FontWeight.Bold).fontColor('#fff')
        }.backgroundColor('#000').border({
          color: '#000',
          width: 2,
        }).padding(10).width('100%')
        .onClick(() => {
          const amt = parseInt(this.amount);
          if (amt > 0) {
            this.fishpi.user.transfer(this.user.userName, amt, this.memo).then(() => {
              this.onExit && this.onExit();
              toast(`成功转账 ${amt} 积分，附言：${this.memo || '无'}`, this.getUIContext());
            }).catch((e: Error) => {
              toast(e.message || '转账失败', this.getUIContext());
            })
          } else {
            toast('请输入有效的转账金额', this.getUIContext());
          }
        })
      }
    }.backgroundColor('#FFF4CC').border({
      color: '#18191F',
      width: 2,
      radius: 10,
    }).padding(20)
    .constraintSize({
      maxWidth: 400,
    })
  }
}