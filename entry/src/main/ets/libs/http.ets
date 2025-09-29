import { FileUtil } from '@pura/harmony-utils'
import fs from '@ohos.file.fs';
import axios, { AxiosResponse, FormData } from '@ohos/axios';

interface IRequestParams {
  data?: object | FormData | Record<string, string>,
  params?: object | Record<string, string>
}

interface IRequestOptions<T = object> {
  method: string;
  data?: T;
}

export interface IResponseData<T = object> {
  code?: number;
  result?: number;
  data?: T;
  msg?: string;
}

export interface IKeyVal {
  key: string;
  value: string;
}

export class defHttp {
  private static domain = 'fishpi.cn';
  private static protocol = 'https';
  public  static get origin() {
    return `${defHttp.protocol}://${defHttp.domain}`;
  }

  private static parseUrl(url: string, params?: object) {
    if (!params) return url;
    url = url + '?';
    for (const param of Object.entries(params as Record<string, string>)) {
      const key = param[0], value = param[1];
      if (value != null) url += `${key}=${value}&`;
    }
    return url.slice(0, url.length - 1);
  }

  static post<T>(url: string, options?: IRequestParams): Promise<T> {
    return defHttp.request(defHttp.parseUrl(url, options?.params), { method: 'POST', data: options?.data });
  }

  static get<T>(url: string, options?: IRequestParams): Promise<T> {
    return defHttp.request(defHttp.parseUrl(url, options?.params), { method: 'GET' });
  }

  static put<T>(url: string, options?: IRequestParams): Promise<T> {
    return defHttp.request(defHttp.parseUrl(url, options?.params), { method: 'PUT', data: options?.data });
  }

  static delete<T>(url: string, options?: IRequestParams): Promise<T> {
    return defHttp.request(defHttp.parseUrl(url, options?.params), { method: 'DELETE', data: options?.data });
  }

  static async request(url: string, options: IRequestOptions, headers: Record<string, string> = {}) {
    const axiosInstance = axios.create({
      headers,
    });

    const response: AxiosResponse = await axiosInstance.request({
      url: url.includes('http') ? url : `${defHttp.protocol}://${defHttp.domain}${url}`,
      method: options.method,
      data: options.data,
      headers: {
        'Content-Type': options.data instanceof FormData ? 'multipart/form-data' : 'application/json',
        Referer: `${defHttp.protocol}://${defHttp.domain}`,
      }
    });

    const keys: string[] = Object.keys(response.data);
    if (keys.length == 0) {
      return response.data;
    }
    const res: IResponseData = response.data;
    const code: number | undefined = res.code || res.result;
    if (code != undefined && code != 0 && code != 200) throw new Error(res.msg);
    if (res.data != undefined && keys.length > 3) {
      return res;
    }
    if (res.data != undefined) return res.data;
    return res;
  }

  static upload<T>(url: string, files: IKeyVal[], data: Record<string, string>, method = 'POST'): Promise<T | null> {
    if (files.length == 0) return Promise.resolve(null);
    const formData = new FormData();

    for (let file of files) {
        const fileInstance = fs.openSync(file.value, 0o0);
        const stat = fs.statSync(fileInstance.fd);
        const fileBuffer = new ArrayBuffer(stat.size);
        fs.readSync(fileInstance.fd, fileBuffer); // Read data from the stream file in synchronous mode.
        fs.fsyncSync(fileInstance.fd);
        fs.closeSync(fileInstance.fd);

        formData.append(file.key, fileBuffer, FileUtil.getFileName(file.value))
    }

    for (let keyVal of Object.entries(data)) {
      formData.append(keyVal[0], keyVal[1]);
    }

    return defHttp.request(url, { method, data: formData});
  }
}
export default defHttp;