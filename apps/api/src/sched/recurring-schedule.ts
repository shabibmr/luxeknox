export type OccurrenceDraft = {
  start_time: Date;
  end_time: Date;
};

const MS_PER_WEEK = 7 * 24 * 60 * 60 * 1000;

export function buildWeeklyOccurrences(
  startTime: Date,
  endTime: Date,
  recurUntilIso?: string,
): OccurrenceDraft[] {
  if (!recurUntilIso) {
    return [{ start_time: startTime, end_time: endTime }];
  }

  const [year, month, day] = recurUntilIso.split('-').map(Number);
  const recurUntil = new Date(Date.UTC(year, month - 1, day, 23, 59, 59, 999));
  const occurrences: OccurrenceDraft[] = [];
  let cursorStart = startTime;
  let cursorEnd = endTime;

  while (cursorStart <= recurUntil) {
    occurrences.push({ start_time: cursorStart, end_time: cursorEnd });
    cursorStart = new Date(cursorStart.getTime() + MS_PER_WEEK);
    cursorEnd = new Date(cursorEnd.getTime() + MS_PER_WEEK);
  }

  return occurrences;
}
