import { AppError, BadRequestError, ConflictError } from '../errors/app-error';
import { ErrorCode } from '../errors/codes';
import {
  isCheckViolation,
  isForeignKeyViolation,
  isInvalidTextRepresentation,
  isStringDataRightTruncation,
  isUniqueViolation,
} from './pg-errors';

export interface DbErrorInfo {
  code?: string | number;
  message: string;
}

/**
 * Translate PostgreSQL errors to application errors via SQLSTATE (see `pg-errors.ts`):
 * - 23505: unique_violation -> ConflictError (409)
 * - 23503: foreign_key_violation -> ConflictError (409)
 * - 23514: check_violation -> BadRequestError (400)
 * - 22P02: invalid_text_representation -> BadRequestError (400)
 * - 22001: string_data_right_truncation -> BadRequestError (400)
 */
export interface TranslateDbErrorOptions {
  duplicateMessage?: string;
  foreignKeyMessage?: string;
  checkViolationMessage?: string;
  checkConstraintMessage?: string;
  invalidInputMessage?: string;
  invalidTextMessage?: string;
  stringTruncationMessage?: string;
}

export function translateDbError(error: unknown, options: TranslateDbErrorOptions = {}): Error {
  if (isUniqueViolation(error)) {
    return new ConflictError(options.duplicateMessage ?? 'Resource already exists; unique constraint violation');
  }

  if (isForeignKeyViolation(error)) {
    return new ConflictError(options.foreignKeyMessage ?? 'Referenced record does not exist or violates foreign key constraint');
  }

  if (isCheckViolation(error)) {
    return new BadRequestError(
      options.checkViolationMessage ?? options.checkConstraintMessage ?? 'Check constraint violation',
    );
  }

  if (isInvalidTextRepresentation(error)) {
    return new BadRequestError(
      options.invalidTextMessage ?? options.invalidInputMessage ?? 'Invalid input data format',
    );
  }

  if (isStringDataRightTruncation(error)) {
    return new BadRequestError(
      options.stringTruncationMessage ?? options.invalidInputMessage ?? 'String data exceeds maximum allowed length',
    );
  }

  if (!(error instanceof Error)) {
    return new AppError({ code: ErrorCode.INTERNAL_ERROR, message: 'Database error' });
  }

  return error;
}

