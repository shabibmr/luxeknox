import { describe, expect, it } from 'vitest';
import {
  findMemberConflicts,
  findTrainerConflicts,
  intervalsOverlap,
  isFacilityOverCapacity,
} from './schedule-conflict';

function at(hour: number, minute = 0): Date {
  return new Date(Date.UTC(2026, 8, 21, hour, minute, 0, 0));
}

describe('schedule-conflict', () => {
  it('detects interval overlap', () => {
    expect(intervalsOverlap(at(9), at(10), at(9, 30), at(10, 30))).toBe(true);
    expect(intervalsOverlap(at(9), at(10), at(10), at(11))).toBe(false);
  });

  it('detects trainer double-book conflicts', () => {
    const existing = [
      {
        id: 1,
        trainer_id: 5,
        facility_id: 2,
        start_time: at(9),
        end_time: at(10),
        status: 'scheduled',
      },
    ];

    const conflicts = findTrainerConflicts(existing, {
      trainer_id: 5,
      start_time: at(9, 30),
      end_time: at(10, 30),
    });

    expect(conflicts).toHaveLength(1);
    expect(conflicts[0]?.id).toBe(1);
  });

  it('ignores cancelled schedules for trainer conflicts', () => {
    const existing = [
      {
        id: 1,
        trainer_id: 5,
        facility_id: 2,
        start_time: at(9),
        end_time: at(10),
        status: 'cancelled',
      },
    ];

    expect(
      findTrainerConflicts(existing, {
        trainer_id: 5,
        start_time: at(9),
        end_time: at(10),
      }),
    ).toHaveLength(0);
  });

  it('detects exclusive facility capacity conflicts', () => {
    const existing = [
      {
        id: 1,
        trainer_id: 1,
        facility_id: 9,
        start_time: at(8),
        end_time: at(9),
        status: 'scheduled',
      },
    ];

    expect(
      isFacilityOverCapacity(
        existing,
        { facility_id: 9, start_time: at(8, 30), end_time: at(9, 30) },
        1,
      ),
    ).toBe(true);
  });

  it('allows facility overlap when capacity is greater than one', () => {
    const existing = [
      {
        id: 1,
        trainer_id: 1,
        facility_id: 9,
        start_time: at(8),
        end_time: at(9),
        status: 'scheduled',
      },
    ];

    expect(
      isFacilityOverCapacity(
        existing,
        { facility_id: 9, start_time: at(8, 30), end_time: at(9, 30) },
        2,
      ),
    ).toBe(false);
  });

  it('detects member overlapping bookings', () => {
    const memberBlocks = [
      {
        id: 10,
        trainer_id: null,
        facility_id: null,
        start_time: at(12),
        end_time: at(13),
        status: 'scheduled',
      },
    ];

    expect(
      findMemberConflicts(memberBlocks, {
        start_time: at(12, 30),
        end_time: at(13, 30),
      }),
    ).toHaveLength(1);
  });
});
