import { describe, expect, it } from 'vitest';
import { mysqlTable } from 'drizzle-orm/mysql-core';
import type { MySqlDateTime } from 'drizzle-orm/mysql-core';
import { utcDatetime } from './utc-datetime';

describe('utcDatetime', () => {
  it('creates a datetime(3) column builder with date mode', () => {
    const table = mysqlTable('test_table', {
      createdAt: utcDatetime('created_at'),
    });

    const column = table.createdAt as unknown as MySqlDateTime<any>;

    expect(column.dataType).toBe('date');
    expect(column.columnType).toBe('MySqlDateTime');
    expect(column.getSQLType()).toBe('datetime(3)');
    expect(column.fsp).toBe(3);
  });

  it('round-trips a known UTC instant preserving millisecond precision and UTC value', () => {
    const table = mysqlTable('test_table', {
      createdAt: utcDatetime('created_at'),
    });

    const column = table.createdAt as unknown as MySqlDateTime<any>;

    const isoString = '2026-09-16T12:00:00.123Z';
    const originalDate = new Date(isoString);

    // Driver value format expected by MySQL: YYYY-MM-DD HH:mm:ss.mmm
    const driverValue = column.mapToDriverValue(originalDate);
    expect(driverValue).toBe('2026-09-16 12:00:00.123');

    // Round-trip back from driver string to Date instance
    const restoredDate = column.mapFromDriverValue(driverValue as string);
    expect(restoredDate).toBeInstanceOf(Date);
    expect(restoredDate.toISOString()).toBe(isoString);
    expect(restoredDate.getTime()).toBe(originalDate.getTime());
    expect(restoredDate.getUTCMilliseconds()).toBe(123);
    expect(restoredDate.getUTCHours()).toBe(12);
  });
});
