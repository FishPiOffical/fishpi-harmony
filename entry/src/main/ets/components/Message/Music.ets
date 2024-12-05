import defHttp from "../../libs/http";
import { IMusicMsg } from "../../service/types/chatroom";

@ObservedV2
class MusicData implements IMusicMsg {
  @Trace msgType: "music" = "music";
  @Trace form: string = '';
  @Trace source: string = '';
  @Trace title: string = '';
  @Trace artist: string = '';
  @Trace coverURL: string = '';
  @Trace url: string = '';
}

interface INeteaseName {
  name: string;
}

interface INeteaseUrl {
  picUrl: string;
}

interface INeteaseSong {
  artists: INeteaseName[];
  name: string;
  album: INeteaseUrl;
}

interface INeteaseRsp {
  songs: INeteaseSong[];
}

@ComponentV2
export struct MusicRender {
  @Require @Param data: IMusicMsg;
  @Param isSelf: boolean = false;
  @Local music: MusicData = new MusicData();

  @Computed
  get musicId() {
    return this.data.source.match(/id=(\d+)/)?.[1] || '';
  }

  aboutToAppear(): void {
    this.music.form = this.data.form;
    this.music.source = this.data.source;
    this.music.title = this.data.title;
    this.music.coverURL = this.data.coverURL;
    defHttp.get<INeteaseRsp>(`http://music.163.com/api/song/detail/?id=${this.musicId}&ids=%5B${this.musicId}%5D`).then(rsp => {
      this.music.artist = rsp.songs[0].artists.map(a => a.name).join(',');
      this.music.title = rsp.songs[0].name;
      this.music.coverURL = rsp.songs[0].album.picUrl;
      this.music.url = `http://music.163.com/song/media/outer/url?id=${this.id}`;
    })
  }

  build() {
    Flex() {
      Flex() {
        Image(this.data.coverURL)
          .size({
            width: 70,
            height: 70,
          })
        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.Center,
          alignItems: ItemAlign.Center,
        }) {
          Text(this.music.title + ' - ' + this.music.artist).fontSize(14).fontColor('#333').margin({ bottom: 5 })
          Text('点击聆听').fontSize(12).fontColor('#BBB')
        }.width('auto').padding(10)
      }
      .height(70)
      .width('auto')
      .border({
        color: '#18191F',
        width: 2
      })
      .borderRadius({
        topLeft: this.isSelf ? 10 : 0,
        topRight: this.isSelf ? 0 : 10,
        bottomLeft: 10,
        bottomRight: 10
      })
      .backgroundColor('#fff')
      .clip(true)
    }
    .backgroundColor('#000')
    .borderRadius({
      topLeft: this.isSelf ? 10 : 0,
      topRight: this.isSelf ? 0 : 10,
      bottomLeft: 10,
      bottomRight: 10
    })
    .padding({ bottom: 5 })
    .width('auto')
    .clip(true)
  }
}