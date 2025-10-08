
import { common, Want } from "@kit.AbilityKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { IArticleParam } from "../pages/Article/ArticleDetail";
import { IArticleListParam } from "../pages/Article/Index";
import { http } from '@kit.NetworkKit';
import { image } from "@kit.ImageKit";

export function htmlToText(html: string, userName?: string): string {
  return html
    .replace(/<img [^>]*?>([^<]*?)\/>/g, `[图片]`)
    .replace(/<\/(h\d|p|div)>/, '\n')
    .replace(/<(\w+) [^>]*?>([^<]*?)<\/\1>/g, `$2`)
    .replace(/<\/*\w+[^>]*?>/g, '');
}

export function toast(message: string | Resource, context: UIContext): void {
  try {
    context.getPromptAction().showToast({
      message: message,
      duration: 2000
    });
  } catch (error) {
    // TODO: Implement error handling.
  }
}

export function startBrowsableAbility(url: string, context: common.UIAbilityContext): void {
  let want: Want = {
    action: 'ohos.want.action.viewData',
    entities: ['entity.system.browsable'],
    uri: url
  };
  context.startAbility(want)
    .then(() => {
      console.error('Start browsableAbility successfully.');
    })
    .catch((err: BusinessError) => {
      console.error(`Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
    });
}

export function pushToAppUrl(url: string, pathStack: NavPathStack) {
  if (url.startsWith('https://fishpi.cn/article/')) {
    const id = url.split('/').pop()?.split('?')[0];
    pathStack.pushPathByName('Article', { id } as IArticleParam);
    return true;
  }
  if (url.startsWith('https://fishpi.cn/tag')) {
    const tag = url.split('/').pop()?.split('?')[0];
    pathStack.pushPathByName('ArticleList', { tag } as IArticleListParam);
    return true;
  }
  if (url.startsWith('https://fishpi.cn/cr')) {
    pathStack.pushPathByName('ChatRoom', null);
    return true;
  }
  return false;
}

export async function fetchImageSize(url: string) {
  try {
    // 创建HTTP请求对象
    const httpRequest = http.createHttp();

    // 发起网络请求获取图片数据
    const response = await httpRequest.request(url);
    const imageData = response.result as ArrayBuffer;

    // 创建ImageSource并生成PixelMap
    const imageSource = image.createImageSource(imageData);
    const pixelMap = await imageSource.createPixelMap();

    // 获取图片原始尺寸
    const imageInfo = await pixelMap.getImageInfo();

    // 释放资源
    imageSource.release();
    return imageInfo.size;
  } catch (error) {
    const err = error as BusinessError;
    console.error(`错误码：${err.code}，错误信息：${err.message}`);
    return { width: 0, height: 0 } as Size;
  }
}

export function shortTime(minute: number) {
  let time = '';
  const year = Math.floor(minute / 525600);
  minute = minute % 525600;
  const month = Math.floor(minute / 43200);
  minute = minute % 43200;
  const day = Math.floor(minute / 1440);
  minute = minute % 1440;
  const hour = Math.floor(minute / 60);
  minute = minute % 60;
  if (year > 0) {
    time += year + '年';
  }
  if (month > 0) {
    time += month + '个月';
  }
  if (day > 0) {
    time += day + '天';
  }
  if (hour > 0) {
    time += hour + '小时';
  }
  if (minute > 0) {
    time += minute + '分钟';
  }
  return time;
}