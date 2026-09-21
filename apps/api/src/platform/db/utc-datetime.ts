import { timestamp, type PgTimestampBuilderInitial } from 'drizzle-orm/pg-core';

/**
 * Custom Drizzle column helper for UTC timestamps.
 * Enforces `TIMESTAMPTZ(3)` precision and mode: 'date', ensuring timestamps are
 * handled consistently as UTC Date instances in JavaScript/TypeScript.
 *
 * Rules:
 * - Always TIMESTAMPTZ(3) — the engine stores an absolute instant, so this is a guarantee,
 *   not a convention (ADR-0009 Decision 1; previously ADR-0002's highest-risk convention
 *   under MySQL's plain DATETIME(3)).
 * - Never a bare TIMESTAMP (without time zone) or local NOW() in application code.
 *
 * @param name Column name in the database table
 */
export function utcDatetime<TName extends string>(name: TName): PgTimestampBuilderInitial<TName> {
  return timestamp(name, { precision: 3, withTimezone: true, mode: 'date' });
}
