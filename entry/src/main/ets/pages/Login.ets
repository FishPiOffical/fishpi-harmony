import { AppStorageV2, PersistenceV2, promptAction, router, UIUtils } from '@kit.ArkUI'
import CryptoJS from '@ohos/crypto-js'
import { AppData } from '../service';
import Fishpi, { IAccount } from '../service/fishpi'

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

@Entry
@ComponentV2
struct Login {
  @Local app: AppData = PersistenceV2.connect(AppData, () => new AppData())!;
  @Local account: Account = new Account()
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  build() {
    Column() {
      TextInput({ placeholder: '用户名', text: $$this.account.nameOrEmail }).margin({ top: 20 })
      TextInput({ placeholder: '密码', text: $$this.account.userPassword }).type(InputType.Password).margin({ top: 20 })
      TextInput({ placeholder: '二次验证码', text: $$this.account.mfaCode }).type(InputType.Number).maxLength(6).margin({ top: 20 })
      Button('登录').width(300).margin({ top: 20 })
        .onClick(() => {
          const account = this.account.toJSON()
          account.userPassword = CryptoJS.MD5(account.userPassword).toString()
          this.fishpi.login(account).then((token) => {
            this.app.token = token
            PersistenceV2.save(AppData)
            this.fishpi.setToken(token)
            router.replaceUrl({ url: 'pages/Index' })
          }).catch((e: Error) => {
            promptAction.showToast({
              message: e.message,
              duration: 2000
            });
          })
        })
    }.padding(20)
  }
}