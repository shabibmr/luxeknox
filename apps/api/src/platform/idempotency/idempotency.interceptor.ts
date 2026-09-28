import { createHash } from 'node:crypto';
import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
  SetMetadata,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { Request, Response } from 'express';
import { Observable, of, from } from 'rxjs';
import { switchMap, tap } from 'rxjs/operators';
import { ConflictError } from '../errors/app-error';
import { IdempotencyRepository } from './idempotency.repository';

export const IDEMPOTENCY_ENABLED_KEY = 'idempotencyEnabled';

/** Opt a mutation handler into Idempotency-Key replay (FND-010). */
export const UseIdempotency = () => SetMetadata(IDEMPOTENCY_ENABLED_KEY, true);

const DEFAULT_TTL_HOURS = 24;

@Injectable()
export class IdempotencyInterceptor implements NestInterceptor {
  constructor(
    private readonly reflector: Reflector,
    private readonly repository: IdempotencyRepository,
  ) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const enabled = this.reflector.getAllAndOverride<boolean>(IDEMPOTENCY_ENABLED_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!enabled) {
      return next.handle();
    }

    const http = context.switchToHttp();
    const request = http.getRequest<Request>();
    const response = http.getResponse<Response>();

    const rawKey = request.headers['idempotency-key'];
    const idempotencyKey = typeof rawKey === 'string' ? rawKey.trim() : '';
    if (!idempotencyKey) {
      return next.handle();
    }
    if (idempotencyKey.length < 8 || idempotencyKey.length > 128) {
      throw new ConflictError('Idempotency-Key must be 8–128 characters');
    }

    const method = request.method.toUpperCase();
    const path = request.route?.path
      ? `${request.baseUrl ?? ''}${request.route.path}`
      : request.path;
    const requestHash = createHash('sha256')
      .update(JSON.stringify(request.body ?? null))
      .digest('hex');
    const now = new Date();

    return from(this.repository.findActive({ idempotencyKey, method, path }, now)).pipe(
      switchMap((existing) => {
        if (existing) {
          if (existing.request_hash !== requestHash) {
            throw new ConflictError('Idempotency-Key was reused with a different request body');
          }
          response.status(existing.response_status);
          try {
            return of(JSON.parse(existing.response_body));
          } catch {
            return of(existing.response_body);
          }
        }

        return next.handle().pipe(
          tap(async (body) => {
            const statusCode = response.statusCode || 201;
            const expiresAt = new Date(now.getTime() + DEFAULT_TTL_HOURS * 60 * 60 * 1000);
            try {
              await this.repository.insert({
                idempotency_key: idempotencyKey,
                method,
                path,
                user_id: request.user?.id ?? null,
                request_hash: requestHash,
                response_status: statusCode,
                response_body: JSON.stringify(body ?? null),
                created_at: now,
                expires_at: expiresAt,
              });
            } catch {
              // Unique race: another request stored the same key concurrently.
              // Swallow — the winner's row is authoritative for subsequent retries.
            }
          }),
        );
      }),
    );
  }
}
