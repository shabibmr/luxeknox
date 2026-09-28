import { AppError, ConflictError } from '../errors/app-error';
import { ErrorCode } from '../errors/codes';
import { isForeignKeyViolation, isUniqueViolation } from './pg-errors';

export interface DbErrorInfo {
  code?: string | number;
  message: string;
}

/**
 * Translate PostgreSQL errors to application errors via SQLSTATE (see `pg-errors.ts`):
 * - 23505: unique_violation
 * - 23503: foreign_key_violation
 */
export interface TranslateDbErrorOptions {
  duplicateMessage?: string;
  foreignKeyMessage?: string;
}

export function translateDbError(error: unknown, options: TranslateDbErrorOptions = {}): Error {
  if (!(error instanceof Error)) {
    return new AppError({ code: ErrorCode.INTERNAL_ERROR, message: 'Database error' });
  }

  if (isUniqueViolation(error)) {
    return new ConflictError(options.duplicateMessage ?? 'Resource already exists; unique constraint violation');
  }

  if (isForeignKeyViolation(error)) {
    return new ConflictError(options.foreignKeyMessage ?? 'Referenced record does not exist or violates foreign key constraint');
  }

  return error;
}
