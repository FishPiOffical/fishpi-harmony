import { promptAction } from "@kit.ArkUI";
import { common, Want } from "@kit.AbilityKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { IArticleParam } from "../pages/Article/ArticleDetail";
import { IArticleListParam } from "../pages/Article/Index";

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