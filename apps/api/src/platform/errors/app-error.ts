import { HttpException, HttpStatus } from '@nestjs/common';
import { ErrorCode } from './codes';

export interface AppErrorOptions {
  code: ErrorCode | string;
  message: string;
  statusCode?: number;
  details?: unknown[];
  cause?: unknown;
}

export class AppError extends HttpException {
  public readonly code: string;
  public readonly details: unknown[];

  constructor(options: AppErrorOptions) {
    const statusCode = options.statusCode ?? HttpStatus.INTERNAL_SERVER_ERROR;
    super(
      {
        code: options.code,
        message: options.message,
        details: options.details ?? [],
      },
      statusCode,
      options.cause ? { cause: options.cause } : undefined,
    );
    this.code = options.code;
    this.details = options.details ?? [];
  }
}

export class BadRequestError extends AppError {
  constructor(message = 'Validation failed', details: unknown[] = [], code: string = ErrorCode.VALIDATION_ERROR) {
    super({
      code,
      message,
      statusCode: HttpStatus.BAD_REQUEST,
      details,
    });
  }
}

export class UnauthorizedError extends AppError {
  constructor(message = 'Authentication required', details: unknown[] = []) {
    super({
      code: ErrorCode.UNAUTHENTICATED,
      message,
      statusCode: HttpStatus.UNAUTHORIZED,
      details,
    });
  }
}

export class ForbiddenError extends AppError {
  constructor(message = 'Forbidden resource', details: unknown[] = []) {
    super({
      code: ErrorCode.FORBIDDEN,
      message,
      statusCode: HttpStatus.FORBIDDEN,
      details,
    });
  }
}

export class NotFoundError extends AppError {
  constructor(message = 'Resource not found', details: unknown[] = []) {
    super({
      code: ErrorCode.NOT_FOUND,
      message,
      statusCode: HttpStatus.NOT_FOUND,
      details,
    });
  }
}

export class ConflictError extends AppError {
  constructor(message = 'Resource conflict', details: unknown[] = []) {
    super({
      code: ErrorCode.CONFLICT,
      message,
      statusCode: HttpStatus.CONFLICT,
      details,
    });
  }
}

export class BusinessRuleError extends AppError {
  constructor(message = 'Business rule violation', details: unknown[] = []) {
    super({
      code: ErrorCode.BUSINESS_RULE,
      message,
      statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
      details,
    });
  }
}

export class RateLimitedError extends AppError {
  constructor(message = 'Too many requests', details: unknown[] = []) {
    super({
      code: ErrorCode.RATE_LIMITED,
      message,
      statusCode: HttpStatus.TOO_MANY_REQUESTS,
      details,
    });
  }
}
