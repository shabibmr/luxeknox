/**
 * Utilities for applying gym timezone date boundaries consistently (RPT-011).
 * Timestamps in DB are stored in UTC via `DATETIME(3)`.
 * User query inputs are date strings (YYYY-MM-DD).
 * Start of day is 00:00:00.000 in gym timezone.
 * End of day is 23:59:59.999 in gym timezone.
 */

export interface DateRangeBoundary {
  from: string; // YYYY-MM-DD
  to: string; // YYYY-MM-DD
  startUtc: Date;
  endUtc: Date;
  timezone: string;
}

const formatterCache = new Map<string, Intl.DateTimeFormat>();

function getFormatter(timeZone: string): Intl.DateTimeFormat {
  let formatter = formatterCache.get(timeZone);
  if (!formatter) {
    formatter = new Intl.DateTimeFormat('en-US', {
      timeZone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      hourCycle: 'h23',
    });
    formatterCache.set(timeZone, formatter);
  }
  return formatter;
}

/**
 * Resolves the offset in milliseconds (target timezone wall clock vs UTC) for a target timezone.
 */
export function getTimezoneOffsetMs(timeZone: string, date: Date = new Date()): number {
  if (timeZone === 'UTC') return 0;
  try {
    const formatter = getFormatter(timeZone);
    const dateForParts = new Date(Math.floor(date.getTime() / 1000) * 1000);
    const parts = formatter.formatToParts(dateForParts);
    const getPart = (type: string) => parts.find((p) => p.type === type)?.value || '0';
    const year = parseInt(getPart('year'), 10);
    const month = parseInt(getPart('month'), 10) - 1;
    const day = parseInt(getPart('day'), 10);
    const hour = parseInt(getPart('hour'), 10);
    const minute = parseInt(getPart('minute'), 10);
    const second = parseInt(getPart('second'), 10);

    const asUtc = Date.UTC(year, month, day, hour, minute, second);
    return asUtc - dateForParts.getTime();
  } catch {
    return 0; // Fallback to UTC if timezone is invalid
  }
}

/**
 * Converts a date string (YYYY-MM-DD) and wall-clock time in the given timezone to a UTC Date.
 */
export function wallClockToUtcDate(
  dateStr: string,
  timeStr: string,
  millis: number,
  timeZone: string,
): Date {
  const [year, month, day] = dateStr.split('-').map((v) => parseInt(v, 10));
  const [hour, minute, second] = timeStr.split(':').map((v) => parseInt(v, 10));

  const baseUtc = Date.UTC(year, month - 1, day, hour, minute, second, 0);
  const offsetMs = getTimezoneOffsetMs(timeZone, new Date(baseUtc));
  return new Date(baseUtc - offsetMs + millis);
}

/**
 * Formats a Date to YYYY-MM-DD in the specified timezone.
 */
export function formatDateInTimezone(date: Date, timeZone: string): string {
  try {
    const formatter = new Intl.DateTimeFormat('en-CA', {
      timeZone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    });
    return formatter.format(date);
  } catch {
    return date.toISOString().slice(0, 10);
  }
}

/**
 * Resolves standard date boundaries for a report in the gym's canonical timezone.
 * Defaults:
 * - If `to` is omitted, defaults to today in gym timezone.
 * - If `from` is omitted, defaults to 30 days before `to`.
 */
export function resolveReportDateRange(
  fromParam?: string,
  toParam?: string,
  timeZone: string = 'UTC',
): DateRangeBoundary {
  const now = new Date();
  const to = toParam ?? formatDateInTimezone(now, timeZone);

  let from = fromParam;
  if (!from) {
    const toDate = wallClockToUtcDate(to, '12:00:00', 0, timeZone);
    const thirtyDaysBefore = new Date(toDate.getTime() - 30 * 24 * 60 * 60 * 1000);
    from = formatDateInTimezone(thirtyDaysBefore, timeZone);
  }

  const startUtc = wallClockToUtcDate(from, '00:00:00', 0, timeZone);
  const endUtc = wallClockToUtcDate(to, '23:59:59', 999, timeZone);

  return {
    from,
    to,
    startUtc,
    endUtc,
    timezone: timeZone,
  };
}
