import { describe, it, expect, vi, beforeEach } from 'vitest';
import { ExecutionContext, CallHandler } from '@nestjs/common';
import { of, lastValueFrom } from 'rxjs';
import { Request, Response } from 'express';
import { RequestIdInterceptor } from './request-id.interceptor';
import { getRequestId } from './request-id';

describe('RequestIdInterceptor', () => {
  let interceptor: RequestIdInterceptor;
  let mockRequest: Partial<Request> & { requestId?: string; headers: Record<string, string | string[]> };
  let mockResponse: {
    headers: Record<string, string>;
    setHeader: ReturnType<typeof vi.fn>;
  };
  let mockExecutionContext: ExecutionContext;
  let mockCallHandler: CallHandler;

  beforeEach(() => {
    interceptor = new RequestIdInterceptor();
    mockRequest = {
      headers: {},
    };
    mockResponse = {
      headers: {},
      setHeader: vi.fn((key: string, value: string) => {
        mockResponse.headers[key.toLowerCase()] = value;
      }),
    };
    mockExecutionContext = {
      switchToHttp: () => ({
        getRequest: () => mockRequest,
        getResponse: () => mockResponse,
      }),
    } as unknown as ExecutionContext;
  });

  it('generates a UUID request_id when none is supplied', async () => {
    let capturedAlsRequestId: string | undefined;

    mockCallHandler = {
      handle: () => {
        capturedAlsRequestId = getRequestId();
        return of({ ok: true });
      },
    };

    const observable = interceptor.intercept(mockExecutionContext, mockCallHandler);
    const result = await lastValueFrom(observable);

    expect(result).toEqual({ ok: true });
    expect(mockRequest.requestId).toBeDefined();
    // Verify UUID format: 8-4-4-4-12 hex digits
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    expect(mockRequest.requestId).toMatch(uuidRegex);
    expect(capturedAlsRequestId).toBe(mockRequest.requestId);
    expect(mockResponse.setHeader).toHaveBeenCalledWith('x-request-id', mockRequest.requestId);
  });

  it('reuses incoming x-request-id header when provided', async () => {
    const incomingId = 'client-trace-id-abc-123';
    mockRequest.headers['x-request-id'] = incomingId;

    let capturedAlsRequestId: string | undefined;

    mockCallHandler = {
      handle: () => {
        capturedAlsRequestId = getRequestId();
        return of({ ok: true });
      },
    };

    const observable = interceptor.intercept(mockExecutionContext, mockCallHandler);
    const result = await lastValueFrom(observable);

    expect(result).toEqual({ ok: true });
    expect(mockRequest.requestId).toBe(incomingId);
    expect(capturedAlsRequestId).toBe(incomingId);
    expect(mockResponse.setHeader).toHaveBeenCalledWith('x-request-id', incomingId);
  });

  it('propagates request_id to response headers even when handler errors', async () => {
    const incomingId = 'custom-error-id-456';
    mockRequest.headers['x-request-id'] = incomingId;

    mockCallHandler = {
      handle: () => {
        throw new Error('Downstream failure');
      },
    };

    try {
      interceptor.intercept(mockExecutionContext, mockCallHandler);
    } catch {
      // Expected synchronous error or throw in handle
    }

    expect(mockResponse.setHeader).toHaveBeenCalledWith('x-request-id', incomingId);
    expect(mockRequest.requestId).toBe(incomingId);
  });

  it('AsyncLocalStorage context is restored/cleared outside request', () => {
    expect(getRequestId()).toBeUndefined();
  });
});
