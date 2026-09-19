import { AsyncLocalStorage } from 'node:async_hooks';

export interface RequestContext {
  requestId: string;
}

export const requestContextStorage = new AsyncLocalStorage<RequestContext>();

/**
 * Get the current request ID from AsyncLocalStorage, or undefined if outside request context.
 */
export function getRequestId(): string | undefined {
  return requestContextStorage.getStore()?.requestId;
}

/**
 * Execute a callback within an AsyncLocalStorage request context.
 */
export function runWithRequestContext<T>(context: RequestContext, fn: () => T): T {
  return requestContextStorage.run(context, fn);
}
