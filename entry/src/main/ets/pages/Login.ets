import { AppStorageV2, PersistenceV2, promptAction, router, UIUtils } from '@kit.ArkUI'
import CryptoJS from '@ohos/crypto-js'
import { Icon } from '../components/Icon';
import { toast } from '../libs/utils';
import { AppData } from '../service';
import Fishpi from '../service/fishpi';
import { IAccount } from '../service/types/fishpi'

@ObservedV2
class Account implements IAccount {
  @Trace
  nameOrEmail: string = '';
  @Trace
  userPassword: string = '';
  @Trace
  mfaCode: string = '';

  toJSON(): IAccount {
    return {
      nameOrEmail: this.nameOrEmail,
      userPassword: this.userPassword,
      mfaCode: this.mfaCode
    }
  }
}

@ComponentV2
export struct Login {
  @Consumer('routerTab') pathStack: NavPathStack = new NavPathStack()
  @Local app: AppData = PersistenceV2.connect(AppData, () => new AppData())!;
  @Local account: Account = new Account()
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Event onLogin: (token: string) => void = () => {};

  build() {
    NavDestination() {
      Column() {
        Flex({
          direction: FlexDirection.Column,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.Center,
        }) {
          Row() {
            Image($r('app.media.logo'))
              .width(40)
              .margin({ right: 10 })
            Text('登录')
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
            Text('摸鱼派')
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
              .fontColor('#ed8f26')
          }

          Row() {
            Text() {
              SymbolSpan($r('sys.symbol.person'))
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
            }

            TextInput({ placeholder: '用户名', text: $$this.account.nameOrEmail })
              .backgroundColor(Color.Transparent)
          }
          .padding({
            left: 10,
            right: 10,
            top: 5,
            bottom: 5
          })
          .margin({ top: 20 })
          .border({
            width: 2,
            color: '#18191F',
            radius: 16,
          }).backgroundColor('#FFFFFF')

          Row() {
            Text() {
              SymbolSpan($r('sys.symbol.lock'))
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
            }

            TextInput({ placeholder: '密码', text: $$this.account.userPassword })
              .backgroundColor(Color.Transparent)
              .type(InputType.Password)
          }
          .padding({
            left: 10,
            right: 10,
            top: 5,
            bottom: 5
          })
          .margin({ top: 20 })
          .border({
            width: 2,
            color: '#18191F',
            radius: 16,
          }).backgroundColor('#FFFFFF')

          Row() {
            Text() {
              SymbolSpan($r('sys.symbol.key_shield'))
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
            }

            TextInput({ placeholder: '二次验证码', text: $$this.account.mfaCode })
              .backgroundColor(Color.Transparent)
              .type(InputType.Number)
              .maxLength(6)
          }
          .padding({
            left: 10,
            right: 10,
            top: 5,
            bottom: 5
          })
          .margin({ top: 20 })
          .border({
            width: 2,
            color: '#18191F',
            radius: 16,
          }).backgroundColor('#FFFFFF')

          Flex({
            justifyContent: FlexAlign.Center,
            alignItems: ItemAlign.Center,
          }) {
            Text('登录')
              .fontSize(18)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
              .padding({
                top: 15,
                bottom: 15
              })
          }
          .backgroundColor('#18191F')
          .borderRadius(16)
          .margin({ top: 20 })
          .constraintSize({
            maxWidth: 400,
          })
          .onClick(() => {
            const account = this.account.toJSON()
            account.userPassword = CryptoJS.MD5(account.userPassword).toString()
            this.fishpi.login(account).then((token) => {
              this.app.token = token
              PersistenceV2.save(AppData)
              this.fishpi.setToken(token)
              this.onLogin(token)
            }).catch((e: Error) => {
              toast(e.message, this.getUIContext())
            })
          })
        }.constraintSize({
          maxWidth: 400,
        })
      }
      .padding({
        bottom: 100
      })
      .backgroundColor('#f0d35e')
      .height('100%')
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)

      Row() {
        Text('')
      }.width('100%')
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .backgroundColor('#f0d35e')
    .title('')
  }
}