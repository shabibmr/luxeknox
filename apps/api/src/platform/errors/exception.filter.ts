import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Response, Request } from 'express';
import { ZodError } from 'zod';
import { AppError } from './app-error';
import { ErrorCode, ErrorResponseBody } from './codes';
import { getRequestId } from '../http/request-id';

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    // Extract request_id from ALS context, request object, or incoming header; fallback to 'pending'
    const requestId =
      getRequestId() ||
      (request as unknown as { requestId?: string })?.requestId ||
      (request?.headers ? (request.headers['x-request-id'] as string) : undefined) ||
      'pending';

    let statusCode = HttpStatus.INTERNAL_SERVER_ERROR;
    let code: string = ErrorCode.INTERNAL_ERROR;
    let message = 'An unexpected internal server error occurred';
    let details: unknown[] = [];

    if (exception instanceof AppError) {
      statusCode = exception.getStatus();
      code = exception.code;
      message = exception.message;
      details = exception.details;
    } else if (exception instanceof ZodError) {
      statusCode = HttpStatus.BAD_REQUEST;
      code = ErrorCode.VALIDATION_ERROR;
      message = 'Validation failed';
      details = exception.errors;
    } else if (exception instanceof HttpException) {
      statusCode = exception.getStatus();
      const res = exception.getResponse();

      if (typeof res === 'string') {
        message = res;
      } else if (typeof res === 'object' && res !== null) {
        const record = res as Record<string, unknown>;
        if (typeof record.message === 'string') {
          message = record.message;
        } else if (Array.isArray(record.message)) {
          message = record.message.join('; ');
          details = record.message;
        }
        if (typeof record.code === 'string') {
          code = record.code;
        }
        if (Array.isArray(record.details)) {
          details = record.details;
        }
      }

      // Map HTTP status codes to standard error codes if not set
      if (code === ErrorCode.INTERNAL_ERROR || !code) {
        code = this.mapStatusToErrorCode(statusCode);
      }
    } else if (exception instanceof Error) {
      this.logger.error(
        `Unhandled exception: ${exception.message}`,
        exception.stack,
      );
      statusCode = HttpStatus.INTERNAL_SERVER_ERROR;
      code = ErrorCode.INTERNAL_ERROR;
      message = 'Internal server error';
      details = [];
    } else {
      this.logger.error('Unhandled non-Error exception thrown', String(exception));
      statusCode = HttpStatus.INTERNAL_SERVER_ERROR;
      code = ErrorCode.INTERNAL_ERROR;
      message = 'Internal server error';
      details = [];
    }

    const errorBody: ErrorResponseBody = {
      code,
      message,
      details,
      request_id: requestId,
    };

    response.status(statusCode).json(errorBody);
  }

  private mapStatusToErrorCode(status: number): string {
    switch (status) {
      case HttpStatus.BAD_REQUEST:
        return ErrorCode.VALIDATION_ERROR;
      case HttpStatus.UNAUTHORIZED:
        return ErrorCode.UNAUTHENTICATED;
      case HttpStatus.FORBIDDEN:
        return ErrorCode.FORBIDDEN;
      case HttpStatus.NOT_FOUND:
        return ErrorCode.NOT_FOUND;
      case HttpStatus.CONFLICT:
        return ErrorCode.CONFLICT;
      case HttpStatus.UNPROCESSABLE_ENTITY:
        return ErrorCode.BUSINESS_RULE;
      case HttpStatus.TOO_MANY_REQUESTS:
        return ErrorCode.RATE_LIMITED;
      default:
        return ErrorCode.INTERNAL_ERROR;
    }
  }
}
