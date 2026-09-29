import { Injectable } from '@nestjs/common';
import { MemberRepository } from '../people/member.repository';
import { TrainerRepository } from '../people/trainer.repository';
import type { Schedule } from '../platform/db/schema/scheduling';
import type { Trainer } from '../platform/db/schema/trainers';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import { wallClockToUtcDate } from '../reports/reports.timezone';
import { intervalsOverlap } from '../sched/schedule-conflict';
import { ScheduleRepository } from '../sched/schedule.repository';
import { minutesToTimeString, parseTimeToMinutes } from '../sched/slot-calculation';
import { TrainerAvailabilityRepository } from '../sched/trainer-availability.repository';
import { SettingsService } from '../sys/settings.service';
import type { PtScheduleGridQueryDto } from './pt.dto';
import { PtProductRepository } from './pt-product.repository';
import {
  addDays,
  coversHour,
  enumerateOccurrenceDates,
  normalizeGender,
  PT_SLOT_MINUTES,
  recurringHoursForWeekday,
  type Gender,
} from './pt-schedule';
import { PtSubscriptionRepository } from './pt-subscription.repository';

/** One PT occurrence: gym-local date + wall-clock slot, and the matching UTC instants. */
export type OccurrenceWindow = { date: string; slot_start: string; start: Date; end: Date };

export type SlotConflict = {
  date: string;
  reason: 'unavailable' | 'trainer_busy' | 'member_busy';
  occupied_by: string | null;
};

export type PtGridCellStatus = 'free' | 'occupied' | 'unavailable';

export type PtGridCell = {
  trainer_id: number;
  slot_start: string;
  status: PtGridCellStatus;
  /** Who holds the slot (member name for PT, otherwise the schedule title). */
  occupied_by: string | null;
  /** Dates in the range that clash; empty when free. */
  conflict_dates: string[];
};

export type PtScheduleGrid = {
  member_id: number;
  gender: Gender;
  start_date: string;
  end_date: string;
  weekdays: number[];
  hours: string[];
  trainers: { id: number; name: string }[];
  cells: PtGridCell[];
};

/**
 * Trainer-hour occupancy for PT. A trainer-hour is free for a PT only when it is inside the
 * trainer's availability and clash-free on **every** occurrence date of the range — that is
 * what "marked occupied for the PT duration" means.
 */
@Injectable()
export class PtScheduleService {
  constructor(
    private readonly memberRepository: MemberRepository,
    private readonly trainerRepository: TrainerRepository,
    private readonly availabilityRepository: TrainerAvailabilityRepository,
    private readonly scheduleRepository: ScheduleRepository,
    private readonly productRepository: PtProductRepository,
    private readonly subscriptionRepository: PtSubscriptionRepository,
    private readonly settingsService: SettingsService,
  ) {}

  /** Gender of the member, or a 422 explaining why PT cannot be assigned. */
  async requireMemberGender(memberId: number): Promise<Gender> {
    const member = await this.memberRepository.findById(memberId);
    if (!member) throw new NotFoundError('Member not found');
    const gender = normalizeGender(member.gender);
    if (!gender) {
      throw new BusinessRuleError(
        'Member gender must be set to Male or Female before assigning a personal trainer',
      );
    }
    return gender;
  }

  /** Trainer must be active and the same gender as the member (hard rule, no override). */
  async requireEligibleTrainer(trainerId: number, memberGender: Gender): Promise<Trainer> {
    const trainer = await this.trainerRepository.findById(trainerId);
    if (!trainer) throw new NotFoundError('Trainer not found');
    if (!trainer.is_active) {
      throw new BusinessRuleError('Inactive trainers cannot take personal training');
    }
    if (normalizeGender(trainer.gender) !== memberGender) {
      throw new BusinessRuleError('Trainer and member must be of the same gender');
    }
    return trainer;
  }

  /** 00:00 on `date` in the gym timezone, as a UTC instant. */
  async startOfDayUtc(date: string): Promise<Date> {
    return wallClockToUtcDate(date, '00:00:00', 0, await this.settingsService.getTimezone());
  }

  async occurrenceWindows(
    startDate: string,
    endDate: string,
    weekdays: readonly number[],
    slotStart: string,
  ): Promise<OccurrenceWindow[]> {
    const tz = await this.settingsService.getTimezone();
    return enumerateOccurrenceDates(startDate, endDate, weekdays).map((date) => {
      const start = wallClockToUtcDate(date, slotStart, 0, tz);
      return {
        date,
        slot_start: slotStart,
        start,
        end: new Date(start.getTime() + PT_SLOT_MINUTES * 60_000),
      };
    });
  }

  /**
   * Every occurrence that the trainer (or member) cannot take. Empty ⇒ slot can be booked.
   * Generated sessions of `excludeSubscriptionId` are ignored so a subscription can be
   * re-planned over its own slot.
   */
  async findConflicts(params: {
    trainerId: number;
    memberId: number;
    windows: OccurrenceWindow[];
    excludeSubscriptionId?: number;
  }): Promise<SlotConflict[]> {
    const { windows } = params;
    if (windows.length === 0) return [];
    const availability = await this.availabilityRepository.findByTrainerId(params.trainerId);
    const busy = await this.loadTrainerBusy(
      params.trainerId,
      windows[0]!.start,
      windows[windows.length - 1]!.end,
      params.excludeSubscriptionId,
    );
    const names = await this.occupantNames(busy);

    const conflicts: SlotConflict[] = [];
    for (const w of windows) {
      if (!coversHour(availability, w.date, parseTimeToMinutes(w.slot_start))) {
        conflicts.push({ date: w.date, reason: 'unavailable', occupied_by: null });
        continue;
      }
      const clash = busy.find((s) => intervalsOverlap(s.start_time, s.end_time, w.start, w.end));
      if (clash) {
        conflicts.push({ date: w.date, reason: 'trainer_busy', occupied_by: names(clash) });
        continue;
      }
      const memberClash = (
        await this.scheduleRepository.findOverlappingBookedForMember(params.memberId, w.start, w.end)
      ).filter((s) => !params.excludeSubscriptionId || s.pt_subscription_id !== params.excludeSubscriptionId);
      if (memberClash.length > 0) {
        conflicts.push({ date: w.date, reason: 'member_busy', occupied_by: memberClash[0]!.title });
      }
    }
    return conflicts;
  }

  async buildGrid(query: PtScheduleGridQueryDto): Promise<PtScheduleGrid> {
    const gender = await this.requireMemberGender(query.member_id);
    const product = await this.productRepository.findById(query.pt_product_id);
    if (!product) throw new NotFoundError('PT package not found');

    // Re-planning an existing PT: the period ends with the subscription, and the weekday
    // count is the subscription's own (the package may have been edited since).
    let endDate = addDays(query.start_date, product.duration_days);
    let sessionsPerWeek = product.sessions_per_week;
    if (query.exclude_subscription_id) {
      const sub = await this.subscriptionRepository.findById(query.exclude_subscription_id);
      if (!sub || sub.member_id !== query.member_id) {
        throw new NotFoundError('PT subscription not found');
      }
      endDate = sub.end_date;
      sessionsPerWeek = sub.weekdays.length;
    }
    if (query.weekdays.length !== sessionsPerWeek) {
      throw new BusinessRuleError(
        `This PT has ${sessionsPerWeek} session(s) per week; choose exactly that many weekdays`,
      );
    }
    const dates = enumerateOccurrenceDates(query.start_date, endDate, query.weekdays);
    const tz = await this.settingsService.getTimezone();

    const trainers = (await this.trainerRepository.findAllActive()).filter(
      (t) => normalizeGender(t.gender) === gender,
    );

    const availabilityByTrainer = new Map<number, Awaited<ReturnType<TrainerAvailabilityRepository['findByTrainerId']>>>();
    const hourSet = new Set<number>();
    for (const t of trainers) {
      const rows = await this.availabilityRepository.findByTrainerId(t.id);
      availabilityByTrainer.set(t.id, rows);
      for (const wd of query.weekdays) {
        for (const h of recurringHoursForWeekday(rows, wd)) hourSet.add(h);
      }
    }
    const hours = [...hourSet].sort((a, b) => a - b);

    const rangeStart = wallClockToUtcDate(query.start_date, '00:00:00', 0, tz);
    const rangeEnd = wallClockToUtcDate(endDate, '23:59:59', 999, tz);

    const cells: PtGridCell[] = [];
    for (const t of trainers) {
      const availability = availabilityByTrainer.get(t.id) ?? [];
      const busy = await this.loadTrainerBusy(t.id, rangeStart, rangeEnd, query.exclude_subscription_id);
      const names = await this.occupantNames(busy);

      for (const h of hours) {
        const slot = minutesToTimeString(h);
        const conflictDates: string[] = [];
        let occupiedBy: string | null = null;
        let unavailable = dates.length === 0;
        for (const date of dates) {
          if (!coversHour(availability, date, h)) {
            unavailable = true;
            continue;
          }
          const start = wallClockToUtcDate(date, slot, 0, tz);
          const end = new Date(start.getTime() + PT_SLOT_MINUTES * 60_000);
          const clash = busy.find((s) => intervalsOverlap(s.start_time, s.end_time, start, end));
          if (clash) {
            conflictDates.push(date);
            occupiedBy ??= names(clash);
          }
        }
        const status: PtGridCellStatus =
          conflictDates.length > 0 ? 'occupied' : unavailable ? 'unavailable' : 'free';
        cells.push({
          trainer_id: t.id,
          slot_start: slot,
          status,
          occupied_by: status === 'occupied' ? occupiedBy : null,
          conflict_dates: conflictDates,
        });
      }
    }

    return {
      member_id: query.member_id,
      gender,
      start_date: query.start_date,
      end_date: endDate,
      weekdays: [...query.weekdays].sort((a, b) => a - b),
      hours: hours.map(minutesToTimeString),
      trainers: trainers.map((t) => ({ id: t.id, name: `${t.first_name} ${t.last_name}`.trim() })),
      cells,
    };
  }

  private async loadTrainerBusy(
    trainerId: number,
    from: Date,
    to: Date,
    excludeSubscriptionId?: number,
  ): Promise<Schedule[]> {
    const rows = await this.scheduleRepository.findBusyForTrainer(trainerId, from, to);
    return excludeSubscriptionId
      ? rows.filter((s) => s.pt_subscription_id !== excludeSubscriptionId)
      : rows;
  }

  private async occupantNames(busy: Schedule[]): Promise<(s: Schedule) => string> {
    const subIds = [
      ...new Set(busy.map((s) => s.pt_subscription_id).filter((v): v is number => v != null)),
    ];
    const names = await this.subscriptionRepository.memberNamesForSubscriptions(subIds);
    return (s) => (s.pt_subscription_id != null ? names.get(s.pt_subscription_id) : undefined) ?? s.title;
  }
}
