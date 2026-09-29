/**
 * SQLSTATE-based PostgreSQL error classification (ADR-0009 Decision 2 / PG-19).
 *
 * MySQL's `insertId` and message-text checks (`/Duplicate|ER_DUP_ENTRY/i`) have no PostgreSQL
 * equivalent; the driver-agnostic replacement is the `code` field node-postgres attaches to
 * every raised error, matching the standard SQLSTATE class.
 *
 * Without this, a duplicate-key create silently turns a 409 Conflict into an unhandled 500.
 */

interface PgDriverError {
  code?: string;
  cause?: unknown;
}

export const UNIQUE_VIOLATION = '23505';
export const FOREIGN_KEY_VIOLATION = '23503';
export const CHECK_VIOLATION = '23514';
export const SERIALIZATION_FAILURE = '40001';
export const DEADLOCK_DETECTED = '40P01';
export const INVALID_TEXT_REPRESENTATION = '22P02';
export const STRING_DATA_RIGHT_TRUNCATION = '22001';

export const PG_ERROR_CODES = {
  UNIQUE_VIOLATION,
  FOREIGN_KEY_VIOLATION,
  CHECK_VIOLATION,
  SERIALIZATION_FAILURE,
  DEADLOCK_DETECTED,
  INVALID_TEXT_REPRESENTATION,
  STRING_DATA_RIGHT_TRUNCATION,
} as const;

export type PgErrorCode = (typeof PG_ERROR_CODES)[keyof typeof PG_ERROR_CODES];

export function sqlState(err: unknown): string | undefined {
  if (!err || typeof err !== 'object') {
    return undefined;
  }
  const pgErr = err as PgDriverError;
  if (typeof pgErr.code === 'string') {
    return pgErr.code;
  }
  if (pgErr.cause && typeof pgErr.cause === 'object' && 'code' in pgErr.cause) {
    const causeCode = (pgErr.cause as { code?: unknown }).code;
    if (typeof causeCode === 'string') {
      return causeCode;
    }
  }
  return undefined;
}

/** 23505 unique_violation — a UNIQUE constraint or unique index was violated. */
export function isUniqueViolation(err: unknown): boolean {
  return sqlState(err) === UNIQUE_VIOLATION;
}

/** 23503 foreign_key_violation — a referenced row does not exist (or is still referenced). */
export function isForeignKeyViolation(err: unknown): boolean {
  return sqlState(err) === FOREIGN_KEY_VIOLATION;
}

/** 23514 check_violation — a CHECK constraint was violated. */
export function isCheckViolation(err: unknown): boolean {
  return sqlState(err) === CHECK_VIOLATION;
}

/** 40001 serialization_failure — transaction could not be serialized. */
export function isSerializationFailure(err: unknown): boolean {
  return sqlState(err) === SERIALIZATION_FAILURE;
}

/** 40P01 deadlock_detected — deadlock condition detected in concurrent transactions. */
export function isDeadlock(err: unknown): boolean {
  return sqlState(err) === DEADLOCK_DETECTED;
}

/**
 * Checks for retryable transaction errors (40001 serialization_failure or 40P01 deadlock_detected).
 * Operations failing with these codes can typically succeed upon retry.
 */
export function isRetryableTxError(err: unknown): boolean {
  const code = sqlState(err);
  return code === SERIALIZATION_FAILURE || code === DEADLOCK_DETECTED;
}

/** 22P02 invalid_text_representation — malformed syntax for data type (e.g. invalid UUID, integer). */
export function isInvalidTextRepresentation(err: unknown): boolean {
  return sqlState(err) === INVALID_TEXT_REPRESENTATION;
}

/** 22001 string_data_right_truncation — string value too long for varchar/char column. */
export function isStringDataRightTruncation(err: unknown): boolean {
  return sqlState(err) === STRING_DATA_RIGHT_TRUNCATION;
}

