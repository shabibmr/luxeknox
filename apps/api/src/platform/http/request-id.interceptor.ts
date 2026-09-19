import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { Request, Response } from 'express';
import { Observable } from 'rxjs';
import { requestContextStorage } from './request-id';

@Injectable()
export class RequestIdInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const httpCtx = context.switchToHttp();
    const req = httpCtx.getRequest<Request>();
    const res = httpCtx.getResponse<Response>();

    // Check incoming x-request-id header or request object property, else generate new UUID
    const headerRequestId = req?.headers?.['x-request-id'];
    const existingId =
      (typeof headerRequestId === 'string' && headerRequestId.trim().length > 0
        ? headerRequestId.trim()
        : Array.isArray(headerRequestId) && headerRequestId.length > 0
          ? headerRequestId[0].trim()
          : undefined) ||
      (req as unknown as { requestId?: string })?.requestId;

    const requestId = existingId || randomUUID();

    // Attach to request object
    (req as unknown as { requestId: string }).requestId = requestId;

    // Attach to response header
    if (res && typeof res.setHeader === 'function') {
      res.setHeader('x-request-id', requestId);
    }

    // Run downstream execution within AsyncLocalStorage context
    return new Observable((subscriber) => {
      requestContextStorage.run({ requestId }, () => {
        next.handle().subscribe(subscriber);
      });
    });
  }
}
