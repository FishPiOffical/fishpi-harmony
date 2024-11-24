import { Icon } from '../../components/Icon';

@ComponentV2
export struct Field {
  @Param controller: TextAreaController = new TextAreaController();
  @Param label: string = '';
  @Param value: string | number = '';
  @Param icon?: Resource = undefined;
  @Param placeholder: string = '';
  @Param unit: string = '';
  @Param area: boolean = false;
  @Event $value: (value: string | number) => void;
  @Local text: string = '';

  @BuilderParam builder?: () => void;

  @Computed
  get isNumber() {
    return typeof this.value === 'number';
  }

  @Monitor("value")
  onStrChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      if (monitor.value(path)) {
        this.text = (monitor.value(path)?.now as string).toString()
      }
    })
  }

  aboutToAppear(): void {
    this.text = this.value.toString();
  }

  build() {
    Flex({
      alignItems: ItemAlign.Center,
    }) {
      if (this.icon) {
        Icon({
          icon: this.icon,
          color: null,
          stroke: null,
          iconSize: 20,
        })
          .margin({ right: 10 })
      }
      if (this.label) {
        Text(this.label)
          .width(this.label.length * 30 + 5)
      }
      if (this.builder) {
        this.builder();
      } else if (this.area) {
        TextArea({
          text: this.text,
          placeholder: this.placeholder,
          controller: this.controller,
        })
          .textAlign(TextAlign.Start)
          .backgroundColor(Color.Transparent)
          .border({ width: 0, color: Color.Transparent })
          .onChange((text) => {
            this.text = text;
            this.$value(text);
          })
          .height(100)
      } else {
        TextInput({
          text: this.text,
          placeholder: this.placeholder,
          controller: this.controller,
        })
          .type(this.isNumber ? InputType.Number : InputType.Normal)
          .textAlign(this.label ? TextAlign.End : TextAlign.Start)
          .backgroundColor(Color.Transparent)
          .border({ width: 0, color: Color.Transparent })
          .onChange((text) => {
            this.text = text;
            if (this.isNumber) {
              this.$value(Number(text));
            } else {
              this.$value(text);
            }
          })
      }
      if (this.unit.length > 0) {
        Text(this.unit)
      }
    }

    .borderRadius(10)
    .backgroundColor(Color.White)
    .padding({
      top: 5,
      bottom: 5,
      left: this.label ? 20 : 0,
      right: this.unit ? 20 : 0,
    })
    .margin(5)
  }
}