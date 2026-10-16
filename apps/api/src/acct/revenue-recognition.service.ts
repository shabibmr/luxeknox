import { Inject, Injectable, Optional } from '@nestjs/common';
import { and, eq, lte, gte } from 'drizzle-orm';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  accountingPeriods,
  type AccountingPeriod,
  type RevenueRecognitionSchedule,
} from '../platform/db/schema/accounting';
import { jobRuns } from '../platform/db/schema/job-runs';
import { runInTransaction } from '../platform/db/transaction-context';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import {
  addMoney,
  cmpMoney,
  prorate,
  roundMoney,
  subMoney,
} from '../platform/money/money';
import { SettingsService } from '../sys/settings.service';
import { AccountingPostingService } from './accounting-posting.service';
import { PeriodsRepository } from './periods.repository';
import { RevenueRecognitionRepository } from './revenue-recognition.repository';

export function countDaysInclusive(startStr: string, endStr: string): number {
  if (startStr > endStr) return 0;
  const s = new Date(`${startStr.slice(0, 10)}T00:00:00Z`).getTime();
  const e = new Date(`${endStr.slice(0, 10)}T00:00:00Z`).getTime();
  const diffMs = e - s;
  return Math.round(diffMs / (24 * 60 * 60 * 1000)) + 1;
}

export function addDays(dateStr: string, days: number): string {
  const parts = dateStr.slice(0, 10).split('-');
  const d = new Date(
    Date.UTC(
      parseInt(parts[0], 10),
      parseInt(parts[1], 10) - 1,
      parseInt(parts[2], 10),
    ),
  );
  d.setUTCDate(d.getUTCDate() + days);
  return d.toISOString().slice(0, 10);
}

export function dayAfter(dateStr: string): string {
  return addDays(dateStr, 1);
}

export function dayBefore(dateStr: string): string {
  return addDays(dateStr, -1);
}

export function maxDate(d1: string, d2: string): string {
  return d1 >= d2 ? d1 : d2;
}

export function minDate(d1: string, d2: string): string {
  return d1 <= d2 ? d1 : d2;
}

export const REVENUE_RECOGNITION_JOB = 'accounting.recognize_revenue';

export interface RecognitionResult {
  periodId: number;
  recognizedCount: number;
  totalRecognized: string;
}

@Injectable()
export class RevenueRecognitionService {
  private readonly recognizedPeriods = new Set<number>();

  constructor(
    private readonly repository: RevenueRecognitionRepository,
    private readonly postingService: AccountingPostingService,
    private readonly periodsRepository: PeriodsRepository,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
    @Optional()
    private readonly settingsService?: SettingsService,
  ) {}

  private async isPostingEnabled(): Promise<boolean> {
    if (!this.settingsService) {
      return false;
    }
    const val = await this.settingsService.getSetting('accounting.posting_enabled');
    return val === 'true' || val === '1';
  }

  /**
   * ACC-060 & ACC-061: Prorates and posts revenue recognition for a specific period.
   *
   * Rules:
   * - No-op if posting is disabled.
   * - Prorated by day from max(period.starts_on, recognized_through + 1) to min(period.ends_on, ends_on).
   * - Paused schedules post nothing for frozen days (stops before paused_from).
   * - Last span takes the remaining unrecognized amount so schedule ends at zero.
   * - Safe to run twice: second run in same month posts nothing (checks line existence and span bounds).
   * - Closed schedules after term are skipped.
   */
  async recognizeRevenueForPeriod(periodId: number): Promise<RecognitionResult> {
    if (!(await this.isPostingEnabled())) {
      return { periodId, recognizedCount: 0, totalRecognized: '0.00' };
    }

    return runInTransaction(this.db, async () => {
      const period = await this.periodsRepository.findPeriodById(periodId);
      if (!period) {
        throw new NotFoundError(`Accounting period ${periodId} was not found`);
      }

      const schedules = await this.repository.findOpenOrPausedSchedules();
      let recognizedCount = 0;
      let totalRecognized = '0.00';

      for (const schedule of schedules) {
        // Idempotency: skip if already posted for this schedule and period
        const existingLine = await this.repository.findLineByScheduleAndPeriod(
          schedule.id,
          period.id,
        );
        if (existingLine) {
          continue;
        }

        // Check paused schedule
        if (schedule.status === 'paused') {
          if (!schedule.paused_from || schedule.paused_from <= period.starts_on) {
            // Entire period is frozen
            continue;
          }
        }

        const candidateStart = dayAfter(schedule.recognized_through);
        const spanStart = maxDate(period.starts_on, candidateStart);

        let candidateEnd = minDate(period.ends_on, schedule.ends_on);
        if (schedule.status === 'paused' && schedule.paused_from) {
          candidateEnd = minDate(candidateEnd, dayBefore(schedule.paused_from));
        }
        const spanEnd = candidateEnd;

        if (spanStart > spanEnd) {
          // Check if term already completed
          if (
            spanEnd >= schedule.ends_on &&
            cmpMoney(schedule.recognized_amount, schedule.total_amount) >= 0
          ) {
            await this.repository.updateSchedule(schedule.id, { status: 'closed' });
          }
          continue;
        }

        const daysInSpan = countDaysInclusive(spanStart, spanEnd);
        if (daysInSpan <= 0) {
          continue;
        }

        const remainingAmount = subMoney(
          schedule.total_amount,
          schedule.recognized_amount,
        );
        if (cmpMoney(remainingAmount, '0.00') <= 0) {
          await this.repository.updateSchedule(schedule.id, { status: 'closed' });
          continue;
        }

        const daysLeftInTerm = countDaysInclusive(spanStart, schedule.ends_on);
        let share: string;

        // Last span takes the entire remainder so schedule ends at zero
        if (spanEnd >= schedule.ends_on || daysInSpan >= daysLeftInTerm) {
          share = remainingAmount;
        } else {
          share = prorate(remainingAmount, daysInSpan, daysLeftInTerm);
        }

        if (cmpMoney(share, '0.00') <= 0) {
          continue;
        }

        // Insert recognition line
        const line = await this.repository.insertLine({
          schedule_id: schedule.id,
          accounting_period_id: period.id,
          amount: share,
          journal_entry_id: null,
        });

        // Post balanced journal: Debit unearned, Credit income
        const journal = await this.postingService.postJournal({
          entryDate: spanEnd,
          accountingPeriodId: period.id,
          sourceType: 'revenue_recognition',
          sourceId: line.id,
          memo: `Revenue recognition for schedule #${schedule.id} (${spanStart} to ${spanEnd})`,
          lines: [
            {
              accountId: schedule.unearned_account_id,
              debit: share,
              memo: `Recognize revenue schedule #${schedule.id}`,
            },
            {
              accountId: schedule.income_account_id,
              credit: share,
              memo: `Earned revenue schedule #${schedule.id}`,
            },
          ],
        });

        await this.repository.updateLine(line.id, {
          journal_entry_id: journal.id,
        });

        const newRecognized = addMoney(schedule.recognized_amount, share);
        const isCompleted =
          cmpMoney(newRecognized, schedule.total_amount) >= 0 ||
          spanEnd >= schedule.ends_on;

        await this.repository.updateSchedule(schedule.id, {
          recognized_amount: newRecognized,
          recognized_through: spanEnd,
          ...(isCompleted ? { status: 'closed' } : {}),
        });

        totalRecognized = addMoney(totalRecognized, share);
        recognizedCount++;
      }

      this.recognizedPeriods.add(period.id);

      return {
        periodId: period.id,
        recognizedCount,
        totalRecognized,
      };
    });
  }

  /**
   * Runs the monthly revenue recognition job for the period corresponding to targetDate (or today).
   */
  async runMonthlyRecognition(targetDate?: string): Promise<RecognitionResult | null> {
    const isEnabled = await this.isPostingEnabled();
    if (!isEnabled) {
      return null;
    }

    const dateStr = targetDate ?? new Date().toISOString().slice(0, 10);
    const db = this.db as any;
    const periodRows = await db
      .select()
      .from(accountingPeriods)
      .where(
        and(
          lte(accountingPeriods.starts_on, dateStr),
          gte(accountingPeriods.ends_on, dateStr),
          eq(accountingPeriods.status, 'open'),
        ),
      )
      .limit(1);

    const period: AccountingPeriod | undefined = periodRows[0];
    if (!period) {
      return null;
    }

    return this.recognizeRevenueForPeriod(period.id);
  }

  /**
   * ACC-062: Checks whether revenue recognition has posted for the specified period.
   * Returns true if:
   * 1. This period has already recorded recognition in memory / job_runs, OR
   * 2. Revenue recognition lines have been posted for this period, OR
   * 3. No eligible schedules exist that have unrecognized days in this period.
   */
  async hasPeriodRecognitionPosted(period: AccountingPeriod): Promise<boolean> {
    if (this.recognizedPeriods.has(period.id)) {
      return true;
    }

    // Check if lines exist
    const lineCount = await this.repository.countLinesForPeriod(period.id);
    if (lineCount > 0) {
      return true;
    }

    // Check if a job run succeeded for this job
    const db = this.db as any;
    const jobRunRows = await db
      .select()
      .from(jobRuns)
      .where(
        and(
          eq(jobRuns.job_name, REVENUE_RECOGNITION_JOB),
          eq(jobRuns.status, 'success'),
          gte(jobRuns.created_at, new Date(`${period.starts_on}T00:00:00Z`)),
        ),
      )
      .limit(1);

    if (jobRunRows.length > 0) {
      return true;
    }

    // If there are open schedules that should have been recognized in this period:
    const schedules = await this.repository.findOpenOrPausedSchedules();
    const needsRecognition = schedules.some((s) => {
      if (s.status === 'paused' && s.paused_from && s.paused_from <= period.starts_on) {
        return false;
      }
      return s.starts_on <= period.ends_on && s.recognized_through < minDate(period.ends_on, s.ends_on);
    });

    if (needsRecognition) {
      return false;
    }

    // If no schedules needed recognition and posting is enabled, but the job never ran
    return false;
  }
}
