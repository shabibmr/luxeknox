import { describe, expect, it } from 'vitest';
import { pgTable } from 'drizzle-orm/pg-core';
import type { PgTimestamp } from 'drizzle-orm/pg-core';
import { utcDatetime } from './utc-datetime';

describe('utcDatetime', () => {
  it('creates a timestamptz(3) column builder with date mode', () => {
    const table = pgTable('test_table', {
      createdAt: utcDatetime('created_at'),
    });

    const column = table.createdAt as unknown as PgTimestamp<any>;

    expect(column.dataType).toBe('date');
    expect(column.columnType).toBe('PgTimestamp');
    expect(column.withTimezone).toBe(true);
    expect(column.getSQLType()).toBe('timestamp (3) with time zone');
    expect(column.precision).toBe(3);
  });

  it('round-trips a known UTC instant preserving millisecond precision and UTC value', () => {
    const table = pgTable('test_table', {
      createdAt: utcDatetime('created_at'),
    });

    const column = table.createdAt as unknown as PgTimestamp<any>;

    const isoString = '2026-09-16T12:00:00.123Z';
    const originalDate = new Date(isoString);

    // drizzle-orm's PgTimestamp (withTimezone: true) sends parameterized values as an
    // ISO-8601 string; node-postgres passes it through to PostgreSQL as-is.
    const driverValue = column.mapToDriverValue(originalDate);
    expect(driverValue).toBe('2026-09-16T12:00:00.123Z');

    // Round-trip back from driver string to Date instance
    const restoredDate = column.mapFromDriverValue(driverValue as string)!;
    expect(restoredDate).toBeInstanceOf(Date);
    expect(restoredDate.toISOString()).toBe(isoString);
    expect(restoredDate.getTime()).toBe(originalDate.getTime());
    expect(restoredDate.getUTCMilliseconds()).toBe(123);
    expect(restoredDate.getUTCHours()).toBe(12);
  });

  it('round-trips identically when read back from a session in a non-UTC timezone', () => {
    // TIMESTAMPTZ stores an absolute instant (UTC internally); the session timezone only
    // affects display formatting on the wire, never the value drizzle maps back to a Date.
    // This is the regression test for ADR-0002/0009's highest-risk convention, now an
    // engine guarantee rather than an application-level rule.
    const table = pgTable('test_table', {
      createdAt: utcDatetime('created_at'),
    });
    const column = table.createdAt as unknown as PgTimestamp<any>;

    const isoString = '2026-09-16T23:30:00.500Z';
    // Simulates what node-postgres would hand back from a session with e.g. timezone
    // 'Asia/Kolkata' (+05:30) — same instant, different offset in the driver string.
    const driverValueFromIstSession = '2026-09-17 05:00:00.500+05:30';

    const restoredDate = column.mapFromDriverValue(driverValueFromIstSession)!;
    expect(restoredDate.toISOString()).toBe(isoString);
  });
});
