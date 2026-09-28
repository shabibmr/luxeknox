import { Injectable } from '@nestjs/common';
import type { TrainerAvailability } from '../platform/db/schema/scheduling';
import type { Schedule } from '../platform/db/schema/scheduling';
import {
  computeOpenSlots,
  type OverrideAvailabilityWindow,
  type RecurringAvailabilityWindow,
  type TimeInterval,
} from './slot-calculation';

@Injectable()
export class SlotCalculationService {
  toRecurringWindows(rows: TrainerAvailability[]): RecurringAvailabilityWindow[] {
    return rows
      .filter((row) => row.is_recurring)
      .map((row) => ({
        day_of_week: row.day_of_week ?? 0,
        start_time: row.start_time,
        end_time: row.end_time,
        is_available: row.is_available,
      }));
  }

  toOverrideWindows(rows: TrainerAvailability[]): OverrideAvailabilityWindow[] {
    return rows
      .filter((row) => !row.is_recurring && row.override_date)
      .map((row) => ({
        override_date: row.override_date!,
        start_time: row.start_time,
        end_time: row.end_time,
        is_available: row.is_available,
      }));
  }

  computeTrainerSlots(params: {
    dateIso: string;
    availability: TrainerAvailability[];
    busySchedules: Schedule[];
    slotDurationMinutes: number;
  }): TimeInterval[] {
    const busy: TimeInterval[] = params.busySchedules.map((row) => ({
      start: row.start_time,
      end: row.end_time,
    }));

    return computeOpenSlots({
      dateIso: params.dateIso,
      recurring: this.toRecurringWindows(params.availability),
      overrides: this.toOverrideWindows(params.availability),
      busy,
      slotDurationMinutes: params.slotDurationMinutes,
    });
  }
}
