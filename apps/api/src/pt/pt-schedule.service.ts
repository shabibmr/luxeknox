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
  PT_SLOT_MINUTES,
  recurringHoursForWeekday,
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

  /** Member must exist. */
  async requireMember(memberId: number): Promise<void> {
    const member = await this.memberRepository.findById(memberId);
    if (!member) throw new NotFoundError('Member not found');
  }

  /** Trainer must exist and be active. */
  async requireEligibleTrainer(trainerId: number): Promise<Trainer> {
    const trainer = await this.trainerRepository.findById(trainerId);
    if (!trainer) throw new NotFoundError('Trainer not found');
    if (!trainer.is_active) {
      throw new BusinessRuleError('Inactive trainers cannot take personal training');
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
   * Every occurrence that the trainer (or any of `memberIds`) cannot take. Empty ⇒ slot can
   * be booked. Generated sessions of the occurrence-owner for `excludeSubscriptionId` are
   * ignored so a subscription (or its couple partner) can be re-planned over its own slot.
   */
  async findConflicts(params: {
    trainerId: number;
    memberIds: number[];
    windows: OccurrenceWindow[];
    excludeSubscriptionId?: number;
  }): Promise<SlotConflict[]> {
    const { windows } = params;
    if (windows.length === 0) return [];
    const excludeOwnerId = await this.resolveExcludeOwnerId(params.excludeSubscriptionId);
    const availability = await this.availabilityRepository.findByTrainerId(params.trainerId);
    const busy = await this.loadTrainerBusy(
      params.trainerId,
      windows[0]!.start,
      windows[windows.length - 1]!.end,
      excludeOwnerId,
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
      let memberBusyTitle: string | null = null;
      for (const memberId of params.memberIds) {
        const memberClash = (
          await this.scheduleRepository.findOverlappingBookedForMember(memberId, w.start, w.end)
        ).filter((s) => !excludeOwnerId || s.pt_subscription_id !== excludeOwnerId);
        if (memberClash.length > 0) {
          memberBusyTitle = memberClash[0]!.title;
          break;
        }
      }
      if (memberBusyTitle != null) {
        conflicts.push({ date: w.date, reason: 'member_busy', occupied_by: memberBusyTitle });
      }
    }
    return conflicts;
  }

  async buildGrid(query: PtScheduleGridQueryDto): Promise<PtScheduleGrid> {
    await this.requireMember(query.member_id);
    const product = await this.productRepository.findById(query.pt_product_id);
    if (!product) throw new NotFoundError('PT package not found');

    const memberIds = [query.member_id];
    if (query.partner_member_id != null) {
      if (query.partner_member_id === query.member_id) {
        throw new BusinessRuleError('partner_member_id must differ from member_id');
      }
      await this.requireMember(query.partner_member_id);
      memberIds.push(query.partner_member_id);
    }

    // Re-planning an existing PT: the period ends with the subscription — the member's
    // chosen weekdays can change freely and are not tied to the package.
    let endDate = addDays(query.start_date, product.duration_days);
    let excludeOwnerId: number | undefined;
    if (query.exclude_subscription_id) {
      const sub = await this.subscriptionRepository.findById(query.exclude_subscription_id);
      if (!sub) {
        throw new NotFoundError('PT subscription not found');
      }
      const partner = await this.subscriptionRepository.findPartner(sub);
      const allowedMemberIds = new Set([sub.member_id, ...(partner ? [partner.member_id] : [])]);
      if (!allowedMemberIds.has(query.member_id)) {
        throw new NotFoundError('PT subscription not found');
      }
      endDate = sub.end_date;
      excludeOwnerId = this.subscriptionRepository.occurrenceOwnerId(sub);
      // Re-plan of a couple: include the partner even when the query omitted partner_member_id.
      if (partner && !memberIds.includes(partner.member_id)) {
        memberIds.push(partner.member_id);
      }
    }
    const dates = enumerateOccurrenceDates(query.start_date, endDate, query.weekdays);
    const tz = await this.settingsService.getTimezone();

    const trainers = await this.trainerRepository.findAllActive();

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

    const memberBusy = await this.loadMembersBusy(memberIds, rangeStart, rangeEnd, excludeOwnerId);
    const memberNames = await this.occupantNames(memberBusy);

    const cells: PtGridCell[] = [];
    for (const t of trainers) {
      const availability = availabilityByTrainer.get(t.id) ?? [];
      const busy = await this.loadTrainerBusy(t.id, rangeStart, rangeEnd, excludeOwnerId);
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
          const memberClash = memberBusy.find((s) => intervalsOverlap(s.start_time, s.end_time, start, end));
          if (clash || memberClash) {
            conflictDates.push(date);
            occupiedBy ??= clash ? names(clash) : memberNames(memberClash!);
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
      start_date: query.start_date,
      end_date: endDate,
      weekdays: [...query.weekdays].sort((a, b) => a - b),
      hours: hours.map(minutesToTimeString),
      trainers: trainers.map((t) => ({ id: t.id, name: `${t.first_name} ${t.last_name}`.trim() })),
      cells,
    };
  }

  /** Resolve a subscription id to the primary row that owns shared sessions. */
  private async resolveExcludeOwnerId(excludeSubscriptionId?: number): Promise<number | undefined> {
    if (excludeSubscriptionId == null) return undefined;
    const sub = await this.subscriptionRepository.findById(excludeSubscriptionId);
    return sub ? this.subscriptionRepository.occurrenceOwnerId(sub) : excludeSubscriptionId;
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

  private async loadMembersBusy(
    memberIds: number[],
    from: Date,
    to: Date,
    excludeSubscriptionId?: number,
  ): Promise<Schedule[]> {
    const all: Schedule[] = [];
    const seen = new Set<number>();
    for (const memberId of memberIds) {
      const rows = await this.scheduleRepository.findOverlappingBookedForMember(memberId, from, to);
      for (const row of rows) {
        if (excludeSubscriptionId && row.pt_subscription_id === excludeSubscriptionId) continue;
        if (seen.has(row.id)) continue;
        seen.add(row.id);
        all.push(row);
      }
    }
    return all;
  }

  private async occupantNames(busy: Schedule[]): Promise<(s: Schedule) => string> {
    const subIds = [
      ...new Set(busy.map((s) => s.pt_subscription_id).filter((v): v is number => v != null)),
    ];
    const names = await this.subscriptionRepository.memberNamesForSubscriptions(subIds);
    return (s) => (s.pt_subscription_id != null ? names.get(s.pt_subscription_id) : undefined) ?? s.title;
  }
}
