export const ACTIVE_SCHEDULE_STATUSES = ['scheduled', 'ongoing'] as const;

export type ScheduleBlock = {
  id: number;
  trainer_id: number | null;
  facility_id: number | null;
  start_time: Date;
  end_time: Date;
  status: string;
};

export function intervalsOverlap(
  startA: Date,
  endA: Date,
  startB: Date,
  endB: Date,
): boolean {
  return startA < endB && startB < endA;
}

export function isActiveScheduleStatus(status: string): boolean {
  return (ACTIVE_SCHEDULE_STATUSES as readonly string[]).includes(status);
}

export function findTrainerConflicts(
  existing: ScheduleBlock[],
  proposed: { trainer_id: number; start_time: Date; end_time: Date },
  excludeId?: number,
): ScheduleBlock[] {
  return existing.filter(
    (row) =>
      row.id !== excludeId &&
      row.trainer_id === proposed.trainer_id &&
      isActiveScheduleStatus(row.status) &&
      intervalsOverlap(row.start_time, row.end_time, proposed.start_time, proposed.end_time),
  );
}

export function isFacilityOverCapacity(
  existing: ScheduleBlock[],
  proposed: { facility_id: number; start_time: Date; end_time: Date },
  facilityCapacity: number,
  excludeId?: number,
): boolean {
  const overlapping = existing.filter(
    (row) =>
      row.id !== excludeId &&
      row.facility_id === proposed.facility_id &&
      isActiveScheduleStatus(row.status) &&
      intervalsOverlap(row.start_time, row.end_time, proposed.start_time, proposed.end_time),
  );
  return overlapping.length >= facilityCapacity;
}

export function findMemberConflicts(
  memberScheduleBlocks: ScheduleBlock[],
  proposed: { start_time: Date; end_time: Date },
  excludeScheduleId?: number,
): ScheduleBlock[] {
  return memberScheduleBlocks.filter(
    (row) =>
      row.id !== excludeScheduleId &&
      isActiveScheduleStatus(row.status) &&
      intervalsOverlap(row.start_time, row.end_time, proposed.start_time, proposed.end_time),
  );
}
