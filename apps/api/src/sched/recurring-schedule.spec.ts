import { describe, expect, it } from 'vitest';
import { buildWeeklyOccurrences } from './recurring-schedule';

describe('buildWeeklyOccurrences', () => {
  it('returns a single occurrence when recur_until is omitted', () => {
    const start = new Date('2026-09-21T09:00:00.000Z');
    const end = new Date('2026-09-21T10:00:00.000Z');
    expect(buildWeeklyOccurrences(start, end)).toHaveLength(1);
  });

  it('builds weekly occurrences through recur_until', () => {
    const start = new Date('2026-09-21T09:00:00.000Z');
    const end = new Date('2026-09-21T10:00:00.000Z');
    const occurrences = buildWeeklyOccurrences(start, end, '2026-10-05');
    expect(occurrences).toHaveLength(3);
    expect(occurrences[1]?.start_time.toISOString()).toBe('2026-09-28T09:00:00.000Z');
  });
});
