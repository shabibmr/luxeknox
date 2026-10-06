/**
 * Pure PT scheduling helpers — no DB, no Nest. Dates are gym-local `YYYY-MM-DD` strings,
 * times are gym wall-clock `HH:MM[:SS]`; conversion to UTC instants happens in the service
 * via the gym timezone.
 */
import { parseTimeToMinutes } from '../sched/slot-calculation';

export const PT_SLOT_MINUTES = 60;

export function addDays(isoDate: string, days: number): string {
  const d = new Date(`${isoDate}T00:00:00.000Z`);
  d.setUTCDate(d.getUTCDate() + days);
  return d.toISOString().slice(0, 10);
}

export function dayOfWeek(isoDate: string): number {
  return new Date(`${isoDate}T00:00:00.000Z`).getUTCDay();
}

/** Every date in [startDate, endDate] (inclusive) whose weekday is in `weekdays`. */
export function enumerateOccurrenceDates(
  startDate: string,
  endDate: string,
  weekdays: readonly number[],
): string[] {
  const wanted = new Set(weekdays);
  const dates: string[] = [];
  for (let d = startDate; d <= endDate; d = addDays(d, 1)) {
    if (wanted.has(dayOfWeek(d))) dates.push(d);
  }
  return dates;
}

/** Normalises "HH:MM" / "HH:MM:SS" to "HH:MM:SS"; rejects anything not on the hour. */
export function normalizeSlotStart(slot: string): string {
  const minutes = parseTimeToMinutes(slot);
  if (minutes % 60 !== 0 || minutes < 0 || minutes >= 24 * 60) {
    throw new Error(`Slot must start on the hour: ${slot}`);
  }
  return `${String(minutes / 60).padStart(2, '0')}:00:00`;
}

export function slotLabel(slotStart: string): string {
  const startH = parseTimeToMinutes(slotStart) / 60;
  return `${String(startH).padStart(2, '0')}:00-${String(startH + 1).padStart(2, '0')}:00`;
}

export type AvailabilityRow = {
  day_of_week: number | null;
  start_time: string;
  end_time: string;
  is_recurring: boolean;
  override_date: string | null;
  is_available: boolean;
};

export const DEFAULT_TRAINER_AVAILABILITY: readonly AvailabilityRow[] = [0, 1, 2, 3, 4, 5, 6].map((day) => ({
  day_of_week: day,
  start_time: '06:00:00',
  end_time: '21:00:00',
  is_recurring: true,
  override_date: null,
  is_available: true,
}));

/**
 * Whether the trainer's availability covers the whole hour starting at `hourMinutes`
 * on `dateIso`. Recurring windows for the weekday apply first; date overrides then
 * block (is_available=false) or add (is_available=true) time — same precedence as
 * `buildDayAvailabilityWindows` in sched/slot-calculation.ts, but in wall-clock minutes.
 * If a trainer has no custom availability rows configured, standard gym hours apply.
 */
export function coversHour(rows: readonly AvailabilityRow[], dateIso: string, hourMinutes: number): boolean {
  const effectiveRows = rows.length === 0 ? DEFAULT_TRAINER_AVAILABILITY : rows;
  const from = hourMinutes;
  const to = hourMinutes + PT_SLOT_MINUTES;
  const within = (r: AvailabilityRow) =>
    parseTimeToMinutes(r.start_time) <= from && parseTimeToMinutes(r.end_time) >= to;
  const overlaps = (r: AvailabilityRow) =>
    parseTimeToMinutes(r.start_time) < to && parseTimeToMinutes(r.end_time) > from;

  const overrides = effectiveRows.filter((r) => !r.is_recurring && r.override_date === dateIso);
  if (overrides.some((r) => !r.is_available && overlaps(r))) return false;
  if (overrides.some((r) => r.is_available && within(r))) return true;

  const dow = dayOfWeek(dateIso);
  return effectiveRows.some((r) => r.is_recurring && r.is_available && r.day_of_week === dow && within(r));
}

/** Candidate hours (minutes since midnight) a trainer could offer on a given weekday. */
export function recurringHoursForWeekday(rows: readonly AvailabilityRow[], weekday: number): number[] {
  const effectiveRows = rows.length === 0 ? DEFAULT_TRAINER_AVAILABILITY : rows;
  const hours = new Set<number>();
  for (const r of effectiveRows) {
    if (!r.is_recurring || !r.is_available || r.day_of_week !== weekday) continue;
    const start = Math.ceil(parseTimeToMinutes(r.start_time) / 60) * 60;
    const end = parseTimeToMinutes(r.end_time);
    for (let m = start; m + PT_SLOT_MINUTES <= end; m += 60) hours.add(m);
  }
  return [...hours].sort((a, b) => a - b);
}

