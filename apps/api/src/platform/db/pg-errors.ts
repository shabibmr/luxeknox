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
}

function sqlState(err: unknown): string | undefined {
  return (err as PgDriverError | null | undefined)?.code;
}

/** 23505 unique_violation — a UNIQUE constraint or unique index was violated. */
export function isUniqueViolation(err: unknown): boolean {
  return sqlState(err) === '23505';
}

/** 23503 foreign_key_violation — a referenced row does not exist (or is still referenced). */
export function isForeignKeyViolation(err: unknown): boolean {
  return sqlState(err) === '23503';
}

/** 23514 check_violation — a CHECK constraint was violated. */
export function isCheckViolation(err: unknown): boolean {
  return sqlState(err) === '23514';
}
