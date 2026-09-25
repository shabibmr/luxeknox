import { intervalsOverlap } from './schedule-conflict';

export type TimeInterval = {
  start: Date;
  end: Date;
};

export type RecurringAvailabilityWindow = {
  day_of_week: number;
  start_time: string;
  end_time: string;
  is_available: boolean;
};

export type OverrideAvailabilityWindow = {
  override_date: string;
  start_time: string;
  end_time: string;
  is_available: boolean;
};

const TIME_PATTERN = /^(\d{2}):(\d{2})(?::(\d{2}))?$/;

export function parseTimeToMinutes(time: string): number {
  const match = TIME_PATTERN.exec(time);
  if (!match) {
    throw new Error(`Invalid time format: ${time}`);
  }
  const hours = Number(match[1]);
  const minutes = Number(match[2]);
  return hours * 60 + minutes;
}

export function minutesToTimeString(totalMinutes: number): string {
  const hours = Math.floor(totalMinutes / 60);
  const minutes = totalMinutes % 60;
  return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:00`;
}

export function combineDateAndTime(dateIso: string, time: string): Date {
  const [year, month, day] = dateIso.split('-').map(Number);
  const minutes = parseTimeToMinutes(time);
  const hours = Math.floor(minutes / 60);
  const mins = minutes % 60;
  return new Date(Date.UTC(year, month - 1, day, hours, mins, 0, 0));
}

export function mergeIntervals(intervals: TimeInterval[]): TimeInterval[] {
  if (intervals.length === 0) {
    return [];
  }
  const sorted = [...intervals].sort((a, b) => a.start.getTime() - b.start.getTime());
  const merged: TimeInterval[] = [sorted[0]];

  for (let i = 1; i < sorted.length; i += 1) {
    const current = sorted[i];
    const last = merged[merged.length - 1];
    if (current.start <= last.end) {
      if (current.end > last.end) {
        last.end = current.end;
      }
    } else {
      merged.push({ ...current });
    }
  }

  return merged;
}

export function subtractBusyIntervals(
  available: TimeInterval[],
  busy: TimeInterval[],
): TimeInterval[] {
  const mergedBusy = mergeIntervals(busy);
  const open: TimeInterval[] = [];

  for (const window of available) {
    let cursor = window.start;
    for (const block of mergedBusy) {
      if (block.end <= cursor || block.start >= window.end) {
        continue;
      }
      if (block.start > cursor) {
        open.push({ start: cursor, end: block.start });
      }
      if (block.end > cursor) {
        cursor = block.end;
      }
    }
    if (cursor < window.end) {
      open.push({ start: cursor, end: window.end });
    }
  }

  return open;
}

export function splitIntoSlots(
  intervals: TimeInterval[],
  slotDurationMinutes: number,
): TimeInterval[] {
  const slots: TimeInterval[] = [];
  const durationMs = slotDurationMinutes * 60_000;

  for (const interval of intervals) {
    let cursor = interval.start.getTime();
    const endMs = interval.end.getTime();
    while (cursor + durationMs <= endMs) {
      slots.push({
        start: new Date(cursor),
        end: new Date(cursor + durationMs),
      });
      cursor += durationMs;
    }
  }

  return slots;
}

export function buildDayAvailabilityWindows(
  dateIso: string,
  recurring: RecurringAvailabilityWindow[],
  overrides: OverrideAvailabilityWindow[],
): TimeInterval[] {
  const date = new Date(`${dateIso}T00:00:00.000Z`);
  const dayOfWeek = date.getUTCDay();
  const recurringForDay = recurring.filter((row) => row.day_of_week === dayOfWeek && row.is_available);
  let windows = mergeIntervals(
    recurringForDay.map((row) => ({
      start: combineDateAndTime(dateIso, row.start_time),
      end: combineDateAndTime(dateIso, row.end_time),
    })),
  );

  const dayOverrides = overrides.filter((row) => row.override_date === dateIso);
  if (dayOverrides.length === 0) {
    return windows;
  }

  const blocked = dayOverrides
    .filter((row) => !row.is_available)
    .map((row) => ({
      start: combineDateAndTime(dateIso, row.start_time),
      end: combineDateAndTime(dateIso, row.end_time),
    }));
  windows = subtractBusyIntervals(windows, blocked);

  const extraAvailable = dayOverrides
    .filter((row) => row.is_available)
    .map((row) => ({
      start: combineDateAndTime(dateIso, row.start_time),
      end: combineDateAndTime(dateIso, row.end_time),
    }));

  return mergeIntervals([...windows, ...extraAvailable]);
}

export function computeOpenSlots(params: {
  dateIso: string;
  recurring: RecurringAvailabilityWindow[];
  overrides: OverrideAvailabilityWindow[];
  busy: TimeInterval[];
  slotDurationMinutes: number;
}): TimeInterval[] {
  const availability = buildDayAvailabilityWindows(
    params.dateIso,
    params.recurring,
    params.overrides,
  );
  const open = subtractBusyIntervals(availability, params.busy);
  return splitIntoSlots(open, params.slotDurationMinutes);
}

export function busyIntervalsFromSchedules(
  schedules: { start_time: Date; end_time: Date }[],
): TimeInterval[] {
  return schedules
    .filter((row) => intervalsOverlap(row.start_time, row.end_time, row.start_time, row.end_time))
    .map((row) => ({ start: row.start_time, end: row.end_time }));
}
