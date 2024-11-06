import { webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

export type OpenListener =  (err: BusinessError, value: Object) => void;
export type CloseListener = (err: BusinessError, value: webSocket.CloseResult) => void;
export type MessageListener =  (err: BusinessError, value: Message) => void;
export type ErrorListener =  (err: BusinessError) => void;

type Listener = OpenListener |  CloseListener | MessageListener | ErrorListener;

export interface  ListenersMap {
  open: OpenListener[];
  close: CloseListener[];
  message: MessageListener[];
  error: ErrorListener[];
};

const DEFAULT: WsOptions = {
  maxReconnectionDelay: 10000,
  minReconnectionDelay: 1000 + Math.random() * 4000,
  minUptime: 5000,
  reconnectionDelayGrowFactor: 1.3,
  connectionTimeout: 4000,
  maxRetries: Infinity,
  maxEnqueuedMessages: Infinity,
  startClosed: false,
  debug: false,
};

export interface WsOptions {
  maxReconnectionDelay?: number;
  minReconnectionDelay?: number;
  reconnectionDelayGrowFactor?: number;
  minUptime?: number;
  connectionTimeout?: number;
  maxRetries?: number;
  maxEnqueuedMessages?: number;
  startClosed?: boolean;
  debug?: boolean;
  protocols?: string;
}

export type Message = string | ArrayBuffer;

export class ReconnectingWebSocket {
  private ws?: webSocket.WebSocket;
  private url: string;
  private options: WsOptions;
  private listeners: ListenersMap = {
    error: [],
    message: [],
    open: [],
    close: [],
  };

  private _retryCount = -1;
  private uptimeTimeout?: number;
  private connectTimeout?: number;
  private shouldReconnect = true;
  private connectLock = false;
  private closeCalled = false;
  private messageQueue: Message[] = [];

  constructor(url: string, options?: WsOptions) {
    this.url = url;
    this.options = options || {};
  }

  /**
   * Returns the number or connection retries
   */
  get retryCount(): number {
    return Math.max(this._retryCount, 0);
  }


  /**
   * An event listener to be called when the WebSocket connection's readyState changes to CLOSED
   */
  public onclose: ((err: BusinessError, value: webSocket.CloseResult) => void) | null = null;

  /**
   * An event listener to be called when an error occurs
   */
  public onerror: ((err: BusinessError) => void) | null = null;

  /**
   * An event listener to be called when a message is received from the server
   */
  public onmessage: ((err: BusinessError, message: Message) => void) | null = null;

  /**
   * An event listener to be called when the WebSocket connection's readyState changes to OPEN;
   * this indicates that the connection is ready to send and receive data
   */
  public onopen: ((err: BusinessError, value: Object) => void) | null = null;

  /**
   * Closes the WebSocket connection or connection attempt, if any. If the connection is already
   * CLOSED, this method does nothing
   */
  public close(code = 1000, reason?: string) {
    this.closeCalled = true;
    this.shouldReconnect = false;
    this.clearTimeouts();
    if (!this.ws) {
      this.debug('close enqueued: no ws instance');
      return;
    }
    return this.ws.close({ code, reason });
  }

  /**
   * Closes the WebSocket connection or connection attempt and connects again.
   * Resets retry counter;
   */
  public reconnect(code?: number, reason?: string) {
    this.shouldReconnect = true;
    this.closeCalled = false;
    this._retryCount = -1;
    this.disconnect(code, reason);
    this.connect();
  }

  /**
   * Enqueue specified data to be transmitted to the server over the WebSocket connection
   */
  public send(data: Message) {
    if (this.ws) {
      this.debug('send', data);
      return this.ws.send(data);
    } else {
      const maxEnqueuedMessages = this.options.maxEnqueuedMessages || DEFAULT.maxEnqueuedMessages!;
      if (this.messageQueue.length < maxEnqueuedMessages) {
        this.debug('enqueue', data);
        this.messageQueue.push(data);
      }
      return Promise.resolve(false);
    }
  }

  /**
   * Register an event handler of a specific event type
   */
  public addEventListener(type: 'open', listener: OpenListener): void
  public addEventListener(type: 'close', listener: CloseListener): void
  public addEventListener(type: 'message', listener: MessageListener): void
  public addEventListener(type: 'error', listener: ErrorListener): void
  public addEventListener(
    type: 'open' | 'close' | 'message' | 'error',
    listener: Listener,
  ): void {
    if (type == 'open') {
      this.listeners.open.push(listener as OpenListener);
    } else if(type == 'close') {
      this.listeners.close.push(listener as CloseListener);
    } else if(type == 'message') {
      this.listeners.message.push(listener as MessageListener);
    } else if(type == 'error') {
      this.listeners.error.push(listener as ErrorListener);
    }
  }

  /**
   * Removes an event listener
   */
  public removeEventListener(type: 'open', listener: OpenListener): void
  public removeEventListener(type: 'close', listener: CloseListener): void
  public removeEventListener(type: 'message', listener: MessageListener): void
  public removeEventListener(type: 'error', listener: ErrorListener): void
  public removeEventListener(
    type: 'open' | 'close' | 'message' | 'error',
    listener: Listener,
  ): void {
    if (type == 'open') {
      this.listeners.open.filter(l => l !== listener)
    } else if(type == 'close') {
      this.listeners.close.filter(l => l !== listener)
    } else if(type == 'message') {
      this.listeners.message.filter(l => l !== listener)
    } else if(type == 'error') {
      this.listeners.error.filter(l => l !== listener)
    }
  }

  private debug(...args: (object | string | number | boolean)[]) {
    if (this.options.debug) {
      // not using spread because compiled version uses Symbols
      // tslint:disable-next-line
      console.log('RWS>', ...args);
    }
  }

  private getNextDelay() {
    const reconnectionDelayGrowFactor = this.options.reconnectionDelayGrowFactor || DEFAULT.reconnectionDelayGrowFactor!;
    const minReconnectionDelay =  this.options.minReconnectionDelay || DEFAULT.minReconnectionDelay!;
    const maxReconnectionDelay =  this.options.maxReconnectionDelay || DEFAULT.maxReconnectionDelay!;
    let delay = 0;
    if (this._retryCount > 0) {
      delay =
        minReconnectionDelay * Math.pow(reconnectionDelayGrowFactor, this._retryCount - 1);
      if (delay > maxReconnectionDelay) {
        delay = maxReconnectionDelay;
      }
    }
    this.debug('next delay', delay);
    return delay;
  }

  private wait(): Promise<void> {
    return new Promise(resolve => {
      setTimeout(resolve, this.getNextDelay());
    });
  }

  private connect() {
    if (this.connectLock || !this.shouldReconnect) {
      return;
    }
    this.connectLock = true;

    const maxRetries = this.options.maxRetries || DEFAULT.maxRetries!;
    const connectionTimeout = this.options.maxRetries || DEFAULT.connectionTimeout!;

    if (this._retryCount >= maxRetries) {
      this.debug('max retries reached', this._retryCount, '>=', maxRetries);
      return;
    }

    this._retryCount++;

    this.debug('connect', this._retryCount);
    this.removeListeners();
    this.wait()
      .then(() => this.url)
      .then(async url => {
        // close could be called before creating the ws
        if (this.closeCalled) {
          return;
        }
        this.debug('connect', url, ', protocols:', this.options.protocols || 'undefined');
        this.ws = webSocket.createWebSocket();
        await this.ws.connect(url, {
          protocol: this.options.protocols
        })
        this.connectLock = false;
        this.addListeners();

        this.connectTimeout = setTimeout((): void => this.handleTimeout(), connectionTimeout);
      });
  }

  private handleTimeout() {
    this.debug('timeout event');
    this.handleError(new Error('TIMEOUT') as BusinessError);
  }

  private disconnect(code = 1000, reason?: string) {
    this.clearTimeouts();
    if (!this.ws) {
      return;
    }
    this.removeListeners();
    try {
      this.ws.close({ code, reason });
    } catch (error) {
      // ignore
    }
  }

  private acceptOpen() {
    this.debug('accept open');
    this._retryCount = 0;
  }

  private handleOpen = (err: BusinessError, value: Object) => {
    this.debug('open event');
    const minUptime = this.options.minUptime || DEFAULT.minUptime!;

    clearTimeout(this.connectTimeout);
    this.uptimeTimeout = setTimeout((): void => this.acceptOpen(), minUptime);

    // send enqueued messages (messages sent before websocket open event)
    this.messageQueue.forEach(message => this.ws?.send(message));
    this.messageQueue = [];

    if (this.onopen) {
      this.onopen(err, value);
    }
    this.listeners.open.forEach(listener => listener(err, value));
  };

  private handleMessage = (err: BusinessError, value: Message) => {
    this.debug('message event');

    if (this.onmessage) {
      this.onmessage(err, value);
    }
    this.listeners.message.forEach(listener => listener(err, value));
  };

  private handleError = (err: BusinessError) => {
    this.debug('error event', err);
    this.disconnect(undefined, err.message === 'TIMEOUT' ? 'timeout' : undefined);

    if (this.onerror) {
      this.onerror(err);
    }
    this.debug('exec error listeners');
    this.listeners.error.forEach(listener => listener(err));

    this.connect();
  };

  private handleClose = (err: BusinessError, value: webSocket.CloseResult) => {
    this.debug('close event');
    this.clearTimeouts();

    if (this.shouldReconnect) {
      this.connect();
    }

    if (this.onclose) {
      this.onclose(err, value);
    }
    this.listeners.close.forEach(listener => listener(err, value));
  };

  private removeListeners() {
    if (!this.ws) {
      return;
    }
    this.debug('removeListeners');
    this.ws.off('open', this.handleOpen);
    this.ws.off('close', this.handleClose);
    this.ws.off('message', this.handleMessage);
    this.ws.off('error', this.handleError);
  }

  private addListeners() {
    if (!this.ws) {
      return;
    }
    this.debug('addListeners');
    this.ws.on('open', this.handleOpen);
    this.ws.on('close', this.handleClose);
    this.ws.on('message', this.handleMessage);
    this.ws.on('error', this.handleError);
  }

  private clearTimeouts() {
    clearTimeout(this.connectTimeout);
    clearTimeout(this.uptimeTimeout);
  }
}