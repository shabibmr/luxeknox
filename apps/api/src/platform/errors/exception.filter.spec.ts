import { describe, it, expect, vi, beforeEach } from 'vitest';
import { ArgumentsHost, HttpStatus, NotFoundException, UnauthorizedException, ForbiddenException } from '@nestjs/common';
import { z } from 'zod';
import { GlobalExceptionFilter } from './exception.filter';
import { AppError, BadRequestError, UnauthorizedError, ForbiddenError, NotFoundError, ConflictError, BusinessRuleError } from './app-error';
import { ErrorCode } from './codes';
import { runWithRequestContext } from '../http/request-id';

describe('GlobalExceptionFilter', () => {
  let filter: GlobalExceptionFilter;
  let mockStatus: ReturnType<typeof vi.fn>;
  let mockJson: ReturnType<typeof vi.fn>;
  let mockResponse: { status: ReturnType<typeof vi.fn> };
  let mockRequest: { headers: Record<string, string>; requestId?: string };
  let mockHost: ArgumentsHost;

  beforeEach(() => {
    filter = new GlobalExceptionFilter();
    mockJson = vi.fn();
    mockStatus = vi.fn().mockReturnValue({ json: mockJson });
    mockResponse = { status: mockStatus };
    mockRequest = {
      headers: {},
    };

    mockHost = {
      switchToHttp: vi.fn().mockReturnValue({
        getResponse: () => mockResponse,
        getRequest: () => mockRequest,
      }),
    } as unknown as ArgumentsHost;
  });

  it('normalizes 400 BadRequestError correctly', () => {
    const error = new BadRequestError('Invalid input field', [{ field: 'email', issue: 'invalid' }]);

    filter.catch(error, mockHost);

    expect(mockStatus).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
    expect(mockJson).toHaveBeenCalledWith({
      code: ErrorCode.VALIDATION_ERROR,
      message: 'Invalid input field',
      details: [{ field: 'email', issue: 'invalid' }],
      request_id: 'pending',
    });
  });

  it('normalizes ZodError as 400 validation_error', () => {
    const schema = z.object({ email: z.string().email() });
    const parseResult = schema.safeParse({ email: 'not-an-email' });
    if (parseResult.success) throw new Error('Expected validation failure');

    filter.catch(parseResult.error, mockHost);

    expect(mockStatus).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
    expect(mockJson).toHaveBeenCalledWith(
      expect.objectContaining({
        code: ErrorCode.VALIDATION_ERROR,
        message: 'Validation failed',
        request_id: 'pending',
      }),
    );
    const body = mockJson.mock.calls[0][0];
    expect(Array.isArray(body.details)).toBe(true);
    expect(body.details.length).toBeGreaterThan(0);
  });

  it('normalizes 401 UnauthorizedError and Nest UnauthorizedException', () => {
    const appError = new UnauthorizedError('Session expired');

    filter.catch(appError, mockHost);

    expect(mockStatus).toHaveBeenCalledWith(HttpStatus.UNAUTHORIZED);
    expect(mockJson).toHaveBeenCalledWith({
      code: ErrorCode.UNAUTHENTICATED,
      message: 'Session expired',
      details: [],
      request_id: 'pending',
    });

    const nestError = new UnauthorizedException('Missing token');
    filter.catch(nestError, mockHost);

    expect(mockStatus).toHaveBeenCalledWith(HttpStatus.UNAUTHORIZED);
    expect(mockJson).toHaveBeenCalledWith({
      code: ErrorCode.UNAUTHENTICATED,
      message: 'Missing token',
      details: [],
      request_id: 'pending',
    });
  });

  it('normalizes 403 ForbiddenError and Nest ForbiddenException', () => {
    const appError = new ForbiddenError('Insufficient permissions');

    filter.catch(appError, mockHost);

    expect(mockStatus).toHaveBeenCalledWith(HttpStatus.FORBIDDEN);
    expect(mockJson).toHaveBeenCalledWith({
      code: ErrorCode.FORBIDDEN,
      message: 'Insufficient permissions',
      details: [],
      request_id: 'pending',
    });

    const nestError = new ForbiddenException('Forbidden resource');
    filter.catch(nestError, mockHost);

    expect(mockStatus).toHaveBeenCalledWith(HttpStatus.FORBIDDEN);
    expect(mockJson).toHaveBeenCalledWith({
      code: ErrorCode.FORBIDDEN,
      message: 'Forbidden resource',
      details: [],
      request_id: 'pending',
    });
  });

  it('normalizes 404 NotFoundError and NotFoundException', () => {
    const error = new NotFoundError('User not found');

    filter.catch(error, mockHost);

    expect(mockStatus).toHaveBeenCalledWith(HttpStatus.NOT_FOUND);
    expect(mockJson).toHaveBeenCalledWith({
      code: ErrorCode.NOT_FOUND,
      message: 'User not found',
      details: [],
      request_id: 'pending',
    });

    const nestNotFound = new NotFoundException('Cannot GET /unknown');
    filter.catch(nestNotFound, mockHost);
    expect(mockStatus).toHaveBeenCalledWith(HttpStatus.NOT_FOUND);
    expect(mockJson).toHaveBeenCalledWith({
      code: ErrorCode.NOT_FOUND,
      message: 'Cannot GET /unknown',
      details: [],
      request_id: 'pending',
    });
  });

  it('normalizes 409 ConflictError', () => {
    const error = new ConflictError('Version mismatch');

    filter.catch(error, mockHost);

    expect(mockStatus).toHaveBeenCalledWith(HttpStatus.CONFLICT);
    expect(mockJson).toHaveBeenCalledWith({
      code: ErrorCode.CONFLICT,
      message: 'Version mismatch',
      details: [],
      request_id: 'pending',
    });
  });

  it('normalizes 422 BusinessRuleError', () => {
    const error = new BusinessRuleError('Class is full');

    filter.catch(error, mockHost);

    expect(mockStatus).toHaveBeenCalledWith(HttpStatus.UNPROCESSABLE_ENTITY);
    expect(mockJson).toHaveBeenCalledWith({
      code: ErrorCode.BUSINESS_RULE,
      message: 'Class is full',
      details: [],
      request_id: 'pending',
    });
  });

  it('normalizes unhandled 500 Error without leaking stack traces or internal details', () => {
    const unhandledError = new Error('Sensitive database connection failed: secret_pw@10.0.0.1');

    filter.catch(unhandledError, mockHost);

    expect(mockStatus).toHaveBeenCalledWith(HttpStatus.INTERNAL_SERVER_ERROR);
    expect(mockJson).toHaveBeenCalledWith({
      code: ErrorCode.INTERNAL_ERROR,
      message: 'Internal server error',
      details: [],
      request_id: 'pending',
    });
    const body = mockJson.mock.calls[0][0];
    expect(body.stack).toBeUndefined();
    expect(JSON.stringify(body)).not.toContain('secret_pw');
  });

  it('captures request_id from headers or request object if present', () => {
    mockRequest.headers['x-request-id'] = 'req-12345';

    filter.catch(new UnauthorizedError(), mockHost);

    expect(mockJson).toHaveBeenCalledWith(
      expect.objectContaining({
        request_id: 'req-12345',
      }),
    );

    mockRequest.headers = {};
    mockRequest.requestId = 'req-als-999';

    filter.catch(new UnauthorizedError(), mockHost);

    expect(mockJson).toHaveBeenCalledWith(
      expect.objectContaining({
        request_id: 'req-als-999',
      }),
    );
  });

  it('captures request_id from ALS context if available', () => {
    mockRequest.headers = {};
    delete mockRequest.requestId;

    runWithRequestContext({ requestId: 'als-context-id-777' }, () => {
      filter.catch(new UnauthorizedError(), mockHost);
    });

    expect(mockJson).toHaveBeenCalledWith(
      expect.objectContaining({
        request_id: 'als-context-id-777',
      }),
    );
  });
});
