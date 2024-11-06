import { AppStorageV2, PersistenceV2, router } from '@kit.ArkUI';
import { MainLayout } from '../layout/main';
import { AppData } from '../service';
import Fishpi from '../service/fishpi'

PersistenceV2.notifyOnError((key: string, reason: string, msg: string) => {
  console.error(`error key: ${key}, reason: ${reason}, message: ${msg}`);
});

@Entry
@ComponentV2
struct HomePage {
  @Local app: AppData = PersistenceV2.connect(AppData, () => new AppData())!;
  @Local fishpi: Fishpi = AppStorageV2.connect(Fishpi, () => new Fishpi())!;
  @Local userName: string = '';
  @Local info: string = '';

  aboutToAppear() {
    if (!this.app.token) {
      router.replaceUrl({ url: 'pages/Login' })
    } else {
      this.fishpi.user.info().then((res) => {
        this.userName = res.userName;
        this.info = JSON.stringify(res, null, 2)
      })
    }
  }

  build() {
    Column() {
      MainLayout() {
        Text('2').width('100%').height('100%')
      }
    }
  }
}