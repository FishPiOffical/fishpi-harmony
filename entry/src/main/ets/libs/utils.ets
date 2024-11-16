
export function htmlToText(html: string, userName?: string): string {
  return html
    .replace(/<img [^>]*?>([^<]*?)\/>/g, `[图片]`)
    .replace(/<\/(h\d|p|div)>/, '\n')
    .replace(/<(\w+) [^>]*?>([^<]*?)<\/\1>/g, `$2`)
    .replace(/<\/*\w+[^>]*?>/g, '');
}