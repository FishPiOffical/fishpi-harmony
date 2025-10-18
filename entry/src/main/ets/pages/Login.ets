import { AppStorageV2, PersistenceV2, promptAction, router, UIUtils } from '@kit.ArkUI'
import CryptoJS from '@ohos/crypto-js'
import { Icon } from '../components/Icon';
import { startBrowsableAbility, startScanQrCode, toast } from '../libs/utils';
import { AppData } from '../service';
import Fishpi from '../service/fishpi';
import { IAccount } from '../service/types/fishpi'
import { common } from '@kit.AbilityKit';
import { PrivacyDialog } from './PrivacyDialog';

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
  @Local agreePrivacy: boolean = false;

  private dialogController: CustomDialogController = new CustomDialogController({
    builder: PrivacyDialog({
      context: this.getUIContext().getHostContext() as common.UIAbilityContext,
      confirm: async () => {
        try {
          this.agreePrivacy = true;
        } catch (error) {
          console.error('Update privacy agreement flag failed:', error);
        }
      },
      cancel: () => {
        // 退出应用
        (this.getUIContext().getHostContext() as common.UIAbilityContext).terminateSelf().catch(() => {
          // TODO: Implement error handling.
        })
      }
    }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true,
    autoCancel: false
  });

  aboutToAppear(): void {
    if (this.app.isFirstLaunch) {
      this.app.isFirstLaunch = false;
      this.dialogController.open()
    }
    this.agreePrivacy = this.app.agreePrivacy;
  }

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
              .width(45)
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
          .backgroundColor(this.agreePrivacy ? '#18191F' : '#888888')
          .borderRadius(16)
          .margin({ top: 20 })
          .constraintSize({
            maxWidth: 400,
          })
          .onClick(() => {
            if (!this.agreePrivacy) {
              toast('请先阅读并同意用户协议和隐私政策', this.getUIContext())
              return
            }
            const account = this.account.toJSON()
            account.userPassword = CryptoJS.MD5(account.userPassword).toString()
            this.fishpi.login(account).then((token) => {
              this.app.token = token
              this.app.agreePrivacy = this.agreePrivacy;
              PersistenceV2.save(AppData)
              this.fishpi.setToken(token)
              this.onLogin(token)
            }).catch((e: Error) => {
              toast(e.message, this.getUIContext())
            })
          })
          Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
            Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
              .size({
                width: 12,
                height: 12
              })
              .select(this.app.agreePrivacy)
              .selectedColor(0xed6f21)
              .shape(CheckBoxShape.CIRCLE)
              .onChange((value: boolean) => {
                console.info('Checkbox1 change is' + value);
              })
            Text() {
              Span('我已阅读并同意')
              Span('《用户协议》')
                .fontColor('#F95A2C')
                .onClick(() => {
                  startBrowsableAbility('https://fishpi.cn/agreement',
                    this.getUIContext().getHostContext() as common.UIAbilityContext);
                })
              Span('和')
              Span('《隐私政策》')
                .fontColor('#F95A2C')
                .onClick(() => {
                  startBrowsableAbility('https://fishpi.cn/privacy',
                    this.getUIContext().getHostContext() as common.UIAbilityContext);
                })
            }.fontSize(12)
          }.padding({
            top: 20, left: 10, right: 10, bottom: 0
          })
          Flex({
            direction: FlexDirection.Row,
            justifyContent: FlexAlign.SpaceBetween
          }) {
            Row() {
              Text('没有账号？')
              Text('立即注册')
                .fontColor('#F95A2C')
                .onClick(() => {
                  startBrowsableAbility('https://fishpi.cn/register', this.getUIContext().getHostContext() as common.UIAbilityContext);
                })
            }
            Row({
              space: 5
            }) {
              Icon({
                icon: $r('app.media.scan'),
                iconSize: 20,
              })
                .margin({ left: 10 })
              Text('扫码登录')
                .fontColor('#000')
            }
            .onClick(() => {
              startScanQrCode(this.getUIContext().getHostContext() as common.UIAbilityContext).then(async (result) => {
                const token = result.replace(/login:/, '');
                let isValid = false;
                if (token && result.startsWith('login:')) {
                  this.fishpi.setToken(token);
                  isValid = await this.fishpi.user.info().then(() => true).catch(() => false)
                }
                if (!isValid) {
                  toast('无效的登录二维码，请扫码账户设置中的二维码！', this.getUIContext());
                  return;
                }
                this.app.token = token
                PersistenceV2.save(AppData);
                this.onLogin(token)
              }).catch((error: Error) => {
                toast(`扫码登录失败：${error.message}`, this.getUIContext());
              })
            })
          }.padding({ top: 20, left: 10, right: 10, bottom: 20 })
        }.constraintSize({
          maxWidth: 400,
        }).padding(20)
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