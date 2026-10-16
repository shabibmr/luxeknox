import { AppError, ConflictError } from '../errors/app-error';
import { ErrorCode } from '../errors/codes';

export interface DbErrorInfo {
  code?: string | number;
  message: string;
  errno?: number;
}

/**
 * Translate MySQL/database errors to application errors.
 * Common MySQL error codes:
 * - 1062: Duplicate entry (unique constraint violation)
 * - 1452: Foreign key constraint violation
 */
export interface TranslateDbErrorOptions {
  duplicateMessage?: string;
  foreignKeyMessage?: string;
}

/** True when the driver reports a unique-constraint / duplicate-key failure. */
export function isDuplicateKeyError(error: unknown): boolean {
  if (!(error instanceof Error)) return false;
  const msg = error.message || '';
  return /Duplicate|ER_DUP_ENTRY/i.test(msg) || msg.includes('UNIQUE constraint failed');
}

export function translateDbError(error: unknown, options: TranslateDbErrorOptions = {}): Error {
  if (!(error instanceof Error)) {
    return new AppError({ code: ErrorCode.INTERNAL_ERROR, message: 'Database error' });
  }

  const msg = error.message || '';

  // MySQL: "Duplicate entry ... for key ..."
  if (isDuplicateKeyError(error)) {
    return new ConflictError(options.duplicateMessage ?? 'Resource already exists; unique constraint violation');
  }

  // MySQL: "Foreign key constraint fails"
  if (msg.includes('Foreign key constraint') || msg.includes('FOREIGN KEY constraint failed')) {
    return new ConflictError(options.foreignKeyMessage ?? 'Referenced record does not exist or violates foreign key constraint');
  }

  return error;
}
