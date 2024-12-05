import { IWeatherMsg } from "../../service/types/chatroom";

@ComponentV2
export struct WeatherRender {
  @Require @Param data: IWeatherMsg;
  @Param isSelf: boolean = false;

  @Computed get dateArray() {
    return this.data ? this.data.date.split(',') : [];
  }
  @Computed get maxTempArray() {
    return this.data ? this.data.max.split(',') : [];
  }
  @Computed get minTempArray() {
    return this.data ? this.data.min.split(',') : [];
  }
  @Computed get weatherDescriptionArray() {
    return this.data ? this.data.weatherCode.split(',') : [];
  }

  @Local weatherImage: Record<string, Resource> = {};

  aboutToAppear(): void {
    this.weatherImage['CLEAR_DAY'] = $r('app.media.CLEAR_DAY');
    this.weatherImage['CLEAR_NIGHT'] = $r('app.media.CLEAR_NIGHT');
    this.weatherImage['CLOUDY'] = $r('app.media.CLOUDY');
    this.weatherImage['DUST'] = $r('app.media.DUST');
    this.weatherImage['FOG'] = $r('app.media.FOG');
    this.weatherImage['HEAVY_HAZE'] = $r('app.media.HEAVY_HAZE');
    this.weatherImage['HEAVY_RAIN'] = $r('app.media.HEAVY_RAIN');
    this.weatherImage['HEAVY_SNOW'] = $r('app.media.HEAVY_SNOW');
    this.weatherImage['LIGHT_HAZE'] = $r('app.media.LIGHT_HAZE');
    this.weatherImage['LIGHT_RAIN'] = $r('app.media.LIGHT_RAIN');
    this.weatherImage['LIGHT_SNOW'] = $r('app.media.LIGHT_SNOW');
    this.weatherImage['MODERATE_HAZE'] = $r('app.media.MODERATE_HAZE');
    this.weatherImage['MODERATE_RAIN'] = $r('app.media.MODERATE_RAIN');
    this.weatherImage['MODERATE_SNOW'] = $r('app.media.MODERATE_SNOW');
    this.weatherImage['PARTLY_CLOUDY_DAY'] = $r('app.media.PARTLY_CLOUDY_DAY');
    this.weatherImage['PARTLY_CLOUDY_NIGHT'] = $r('app.media.PARTLY_CLOUDY_NIGHT');
    this.weatherImage['SAND'] = $r('app.media.SAND');
    this.weatherImage['STORM_RAIN'] = $r('app.media.STORM_RAIN');
    this.weatherImage['STORM_SNOW'] = $r('app.media.STORM_SNOW');
    this.weatherImage['WIND'] = $r('app.media.WIND');
  }

  build() {
    Flex() {
      Column({
        space: 10
      }) {
        Text(this.data.t).fontWeight(FontWeight.Bold).fontSize(20);
        Text(this.data.st).fontSize(16);
        Row() {
          ForEach(this.dateArray, (date: string, index) => {
            Column() {
              Text(date).fontSize(12).fontColor('#ccc');
              Text('最高温').fontSize(12).fontColor('#ccc');
              Text(this.maxTempArray[index] + '°C').fontSize(12).fontColor('#ccc');
              Text('最低温').fontSize(12).fontColor('#bbb');
              Text(this.minTempArray[index] + '°C').fontSize(12).fontColor('#ccc');
              Image(this.weatherImage[this.weatherDescriptionArray[index]]).width('100%');
            }.width((100 / this.dateArray.length) + '%')
            .alignItems(HorizontalAlign.Center)
          });
        };
      }.border({
        color: '#18191F',
        width: 2
      })
      .borderRadius({
        topLeft: this.isSelf ? 10 : 0,
        topRight: this.isSelf ? 0 : 10,
        bottomLeft: 10,
        bottomRight: 10
      })
      .padding(10)
      .backgroundColor('#fff')
      .width('auto')
      .alignItems(HorizontalAlign.Start)
    }.backgroundColor('#000')
    .borderRadius({
      topLeft: this.isSelf ? 10 : 0,
      topRight: this.isSelf ? 0 : 10,
      bottomLeft: 10,
      bottomRight: 10
    })
    .padding({ bottom: 5 })
    .width('auto')
  }
}