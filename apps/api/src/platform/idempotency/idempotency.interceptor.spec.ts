import { createHash } from 'node:crypto';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { of, lastValueFrom } from 'rxjs';
import { Reflector } from '@nestjs/core';
import { ConflictError } from '../errors/app-error';
import { IdempotencyInterceptor } from './idempotency.interceptor';
import type { IdempotencyRepository } from './idempotency.repository';

function mockContext(headers: Record<string, string>, body: unknown = { a: 1 }) {
  const response = { statusCode: 201, status: vi.fn() };
  const request = {
    headers,
    method: 'POST',
    path: '/attendances/check-in',
    baseUrl: '',
    route: { path: '/attendances/check-in' },
    body,
    user: { id: 9 },
  };
  return {
    context: {
      getHandler: () => ({}),
      getClass: () => ({}),
      switchToHttp: () => ({
        getRequest: () => request,
        getResponse: () => response,
      }),
    } as any,
    response,
    request,
  };
}

describe('IdempotencyInterceptor', () => {
  let reflector: Reflector;
  let repository: {
    findActive: ReturnType<typeof vi.fn>;
    insert: ReturnType<typeof vi.fn>;
  };
  let interceptor: IdempotencyInterceptor;

  beforeEach(() => {
    reflector = {
      getAllAndOverride: vi.fn().mockReturnValue(true),
    } as unknown as Reflector;
    repository = {
      findActive: vi.fn().mockResolvedValue(null),
      insert: vi.fn().mockResolvedValue(undefined),
    };
    interceptor = new IdempotencyInterceptor(
      reflector,
      repository as unknown as IdempotencyRepository,
    );
  });

  it('passes through when metadata is disabled', async () => {
    vi.mocked(reflector.getAllAndOverride).mockReturnValue(false);
    const { context } = mockContext({ 'idempotency-key': 'abcdefgh' });
    const result = await lastValueFrom(interceptor.intercept(context, { handle: () => of({ ok: 1 }) }));
    expect(result).toEqual({ ok: 1 });
    expect(repository.findActive).not.toHaveBeenCalled();
  });

  it('passes through when Idempotency-Key header is absent', async () => {
    const { context } = mockContext({});
    const result = await lastValueFrom(interceptor.intercept(context, { handle: () => of({ ok: 1 }) }));
    expect(result).toEqual({ ok: 1 });
    expect(repository.findActive).not.toHaveBeenCalled();
  });

  it('replays a stored response on matching key+body', async () => {
    const body = { user_id: 1 };
    const hash = createHash('sha256').update(JSON.stringify(body)).digest('hex');
    repository.findActive.mockResolvedValue({
      request_hash: hash,
      response_status: 201,
      response_body: JSON.stringify({ id: 42 }),
    });
    const { context, response } = mockContext({ 'idempotency-key': 'abcdefgh' }, body);
    const result = await lastValueFrom(interceptor.intercept(context, { handle: () => of({ should: 'not-run' }) }));
    expect(result).toEqual({ id: 42 });
    expect(response.status).toHaveBeenCalledWith(201);
  });

  it('409s when the same key is reused with a different body', async () => {
    repository.findActive.mockResolvedValue({
      request_hash: 'different',
      response_status: 201,
      response_body: '{}',
    });
    const { context } = mockContext({ 'idempotency-key': 'abcdefgh' }, { a: 2 });
    await expect(
      lastValueFrom(interceptor.intercept(context, { handle: () => of({}) })),
    ).rejects.toBeInstanceOf(ConflictError);
  });

  it('persists the response on first success', async () => {
    const { context } = mockContext({ 'idempotency-key': 'abcdefghij' }, { x: 1 });
    const result = await lastValueFrom(interceptor.intercept(context, { handle: () => of({ id: 7 }) }));
    expect(result).toEqual({ id: 7 });
    // tap is async; give the microtask a tick
    await new Promise((r) => setTimeout(r, 0));
    expect(repository.insert).toHaveBeenCalled();
    expect(repository.insert.mock.calls[0][0].idempotency_key).toBe('abcdefghij');
  });
});
