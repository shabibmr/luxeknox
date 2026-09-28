import { describe, expect, it } from 'vitest';
import {
  buildDayAvailabilityWindows,
  computeOpenSlots,
  parseTimeToMinutes,
  subtractBusyIntervals,
} from './slot-calculation';

describe('slot-calculation', () => {
  it('parses HH:MM:SS time strings', () => {
    expect(parseTimeToMinutes('06:00:00')).toBe(360);
    expect(parseTimeToMinutes('09:30')).toBe(570);
  });

  it('builds recurring availability for a weekday', () => {
    const windows = buildDayAvailabilityWindows(
      '2026-09-21',
      [
        {
          day_of_week: 1,
          start_time: '09:00:00',
          end_time: '12:00:00',
          is_available: true,
        },
      ],
      [],
    );

    expect(windows).toHaveLength(1);
    expect(windows[0]?.start.toISOString()).toBe('2026-09-21T09:00:00.000Z');
    expect(windows[0]?.end.toISOString()).toBe('2026-09-21T12:00:00.000Z');
  });

  it('applies date overrides before recurring windows', () => {
    const windows = buildDayAvailabilityWindows(
      '2026-09-21',
      [
        {
          day_of_week: 1,
          start_time: '09:00:00',
          end_time: '17:00:00',
          is_available: true,
        },
      ],
      [
        {
          override_date: '2026-09-21',
          start_time: '10:00:00',
          end_time: '11:00:00',
          is_available: false,
        },
      ],
    );

    expect(windows).toHaveLength(2);
    expect(windows[0]?.end.toISOString()).toBe('2026-09-21T10:00:00.000Z');
    expect(windows[1]?.start.toISOString()).toBe('2026-09-21T11:00:00.000Z');
  });

  it('subtracts busy intervals from availability', () => {
    const open = subtractBusyIntervals(
      [
        {
          start: new Date('2026-09-21T09:00:00.000Z'),
          end: new Date('2026-09-21T12:00:00.000Z'),
        },
      ],
      [
        {
          start: new Date('2026-09-21T10:00:00.000Z'),
          end: new Date('2026-09-21T10:30:00.000Z'),
        },
      ],
    );

    expect(open).toHaveLength(2);
    expect(open[0]?.end.toISOString()).toBe('2026-09-21T10:00:00.000Z');
    expect(open[1]?.start.toISOString()).toBe('2026-09-21T10:30:00.000Z');
  });

  it('computes bookable slots from availability minus busy blocks', () => {
    const slots = computeOpenSlots({
      dateIso: '2026-09-21',
      recurring: [
        {
          day_of_week: 1,
          start_time: '09:00:00',
          end_time: '11:00:00',
          is_available: true,
        },
      ],
      overrides: [],
      busy: [
        {
          start: new Date('2026-09-21T09:00:00.000Z'),
          end: new Date('2026-09-21T09:30:00.000Z'),
        },
      ],
      slotDurationMinutes: 60,
    });

    expect(slots).toHaveLength(1);
    expect(slots[0]?.start.toISOString()).toBe('2026-09-21T09:30:00.000Z');
    expect(slots[0]?.end.toISOString()).toBe('2026-09-21T10:30:00.000Z');
  });
});
