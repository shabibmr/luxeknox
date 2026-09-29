import { describe, expect, it } from 'vitest';
import {
  addDays,
  coversHour,
  enumerateOccurrenceDates,
  normalizeGender,
  normalizeSlotStart,
  recurringHoursForWeekday,
  slotLabel,
  type AvailabilityRow,
} from './pt-schedule';

const recurring = (day: number, start: string, end: string): AvailabilityRow => ({
  day_of_week: day,
  start_time: start,
  end_time: end,
  is_recurring: true,
  override_date: null,
  is_available: true,
});

describe('pt-schedule helpers', () => {
  it('normalises free-text gender and rejects unknown values', () => {
    expect(normalizeGender(' Male ')).toBe('male');
    expect(normalizeGender('F')).toBe('female');
    expect(normalizeGender('other')).toBeNull();
    expect(normalizeGender(null)).toBeNull();
  });

  it('enumerates only the chosen weekdays across the range (inclusive)', () => {
    // 2026-10-05 is a Monday.
    const dates = enumerateOccurrenceDates('2026-10-05', addDays('2026-10-05', 13), [1, 3, 5]);
    expect(dates).toEqual([
      '2026-10-05',
      '2026-10-07',
      '2026-10-09',
      '2026-10-12',
      '2026-10-14',
      '2026-10-16',
    ]);
  });

  it('accepts only on-the-hour slots', () => {
    expect(normalizeSlotStart('17:00')).toBe('17:00:00');
    expect(() => normalizeSlotStart('17:30')).toThrow();
    expect(slotLabel('17:00:00')).toBe('17:00-18:00');
  });

  it('checks the whole hour sits inside recurring availability', () => {
    const rows = [recurring(1, '15:00', '18:00')];
    expect(coversHour(rows, '2026-10-05', 17 * 60)).toBe(true); // 17-18 fits
    expect(coversHour(rows, '2026-10-05', 18 * 60)).toBe(false); // 18-19 overruns
    expect(coversHour(rows, '2026-10-06', 16 * 60)).toBe(false); // Tuesday — no window
  });

  it('lets a date override block or add availability', () => {
    const rows: AvailabilityRow[] = [
      recurring(1, '15:00', '18:00'),
      { ...recurring(1, '16:00', '17:00'), is_recurring: false, override_date: '2026-10-05', is_available: false },
      { ...recurring(2, '09:00', '10:00'), is_recurring: false, override_date: '2026-10-06', day_of_week: null },
    ];
    expect(coversHour(rows, '2026-10-05', 16 * 60)).toBe(false); // blocked that day
    expect(coversHour(rows, '2026-10-12', 16 * 60)).toBe(true); // next Monday unaffected
    expect(coversHour(rows, '2026-10-06', 9 * 60)).toBe(true); // extra availability
  });

  it('lists whole candidate hours per weekday', () => {
    // 06:30–09:00 → only the whole hours 07–08 and 08–09.
    expect(recurringHoursForWeekday([recurring(1, '06:30', '09:00')], 1)).toEqual([420, 480]);
    expect(recurringHoursForWeekday([recurring(1, '06:30', '08:00')], 1)).toEqual([420]);
    expect(recurringHoursForWeekday([recurring(1, '15:00', '18:00')], 1)).toEqual([900, 960, 1020]);
  });
});
