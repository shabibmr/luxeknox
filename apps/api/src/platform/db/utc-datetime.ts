import { datetime, type MySqlDateTimeBuilderInitial } from 'drizzle-orm/mysql-core';

/**
 * Custom Drizzle column helper for UTC timestamps.
 * Enforces `DATETIME(3)` precision and mode: 'date', ensuring timestamps are
 * handled consistently as UTC Date instances in JavaScript/TypeScript.
 *
 * Rules:
 * - Always DATETIME(3) in UTC.
 * - Never TIMESTAMP or local NOW() in application code.
 *
 * @param name Column name in the database table
 */
export function utcDatetime<TName extends string>(name: TName): MySqlDateTimeBuilderInitial<TName> {
  return datetime(name, { fsp: 3, mode: 'date' });
}
