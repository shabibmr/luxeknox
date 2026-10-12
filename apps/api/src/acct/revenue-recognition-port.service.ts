import { Inject, Injectable, Optional } from '@nestjs/common';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import { runInTransaction } from '../platform/db/transaction-context';
import { NotFoundError } from '../platform/errors/app-error';
import { cmpMoney, subMoney } from '../platform/money/money';
import { SettingsService } from '../sys/settings.service';
import { AccountingPostingService } from './accounting-posting.service';
import { AccountsRepository } from './accounts.repository';
import { RevenueRecognitionRepository } from './revenue-recognition.repository';

export type FreezeApprovedPortInput = {
  membershipId: number;
  freezeStartDate: string;
};

export type FreezeEndedPortInput = {
  membershipId: number;
  newEndDate: string;
};

export type MembershipExtendedPortInput = {
  membershipId: number;
  newEndDate: string;
};

export type MembershipUpgradedPortInput = {
  membershipId: number;
  newEndDate: string;
};

export type MembershipCancelledPortInput = {
  membershipId: number;
  cancelledByUserId?: number | null;
  cancelDate?: string;
};

export type PtExtendedPortInput = {
  ptSubscriptionId: number;
  newEndDate: string;
};

export type PtCancelledPortInput = {
  ptSubscriptionId: number;
  cancelledByUserId?: number | null;
  cancelDate?: string;
};

/**
 * ACC-058 & ACC-059: Lifecycle revenue recognition port.
 * Called from MembershipService and PtSubscriptionService to re-plan schedules
 * on freeze approval, freeze end, extend, upgrade, renew, and cancel.
 *
 * Rules:
 * - Strictly no-op when `accounting.posting_enabled` is false.
 * - Never edits already posted recognition journals or recognized amounts.
 * - Only remaining unearned moves.
 * - On cancel, forfeits remaining unearned balance to 4300 Forfeited membership income,
 *   closing the schedule with unearned balance zeroed.
 * - AcctModule must NOT import MembershipModule or PtModule.
 */
@Injectable()
export class RevenueRecognitionPortService {
  constructor(
    private readonly revenueRecognitionRepository: RevenueRecognitionRepository,
    private readonly postingService: AccountingPostingService,
    private readonly accountsRepository: AccountsRepository,
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
   * Re-plans schedule when a freeze is approved:
   * status = 'paused', paused_from = freezeStartDate.
   * No recognition occurs for frozen days.
   */
  async onFreezeApproved(input: FreezeApprovedPortInput): Promise<void> {
    if (!(await this.isPostingEnabled())) {
      return;
    }

    await runInTransaction(this.db, async () => {
      const schedules = await this.revenueRecognitionRepository.findByMembershipId(
        input.membershipId,
        ['open'],
      );

      for (const schedule of schedules) {
        await this.revenueRecognitionRepository.updateSchedule(schedule.id, {
          status: 'paused',
          paused_from: input.freezeStartDate,
        });
      }
    });
  }

  /**
   * Re-plans schedule when a freeze ends / unfreezes:
   * status = 'open', ends_on moved out, paused_from = null.
   */
  async onFreezeEnded(input: FreezeEndedPortInput): Promise<void> {
    if (!(await this.isPostingEnabled())) {
      return;
    }

    await runInTransaction(this.db, async () => {
      const schedules = await this.revenueRecognitionRepository.findByMembershipId(
        input.membershipId,
        ['paused'],
      );

      for (const schedule of schedules) {
        await this.revenueRecognitionRepository.updateSchedule(schedule.id, {
          status: 'open',
          ends_on: input.newEndDate,
          paused_from: null,
        });
      }
    });
  }

  /**
   * Re-plans schedule when a membership term is extended:
   * ends_on moved out to the new end date.
   */
  async onMembershipExtended(input: MembershipExtendedPortInput): Promise<void> {
    if (!(await this.isPostingEnabled())) {
      return;
    }

    await runInTransaction(this.db, async () => {
      const schedules = await this.revenueRecognitionRepository.findByMembershipId(
        input.membershipId,
        ['open', 'paused'],
      );

      for (const schedule of schedules) {
        await this.revenueRecognitionRepository.updateSchedule(schedule.id, {
          ends_on: input.newEndDate,
        });
      }
    });
  }

  /**
   * Re-plans existing schedule when a membership is upgraded:
   * original schedule keeps remaining amount on the new end date.
   * (The upgrade invoice creates its own separate schedule).
   */
  async onMembershipUpgraded(input: MembershipUpgradedPortInput): Promise<void> {
    if (!(await this.isPostingEnabled())) {
      return;
    }

    await runInTransaction(this.db, async () => {
      const schedules = await this.revenueRecognitionRepository.findByMembershipId(
        input.membershipId,
        ['open', 'paused'],
      );

      for (const schedule of schedules) {
        await this.revenueRecognitionRepository.updateSchedule(schedule.id, {
          ends_on: input.newEndDate,
        });
      }
    });
  }

  /**
   * ACC-059: On membership cancellation:
   * Forfeit remaining unearned amount (`total_amount - recognized_amount`) to `4300`.
   * Debit unearned (2200), credit 4300 Forfeited membership income.
   * source_type = 'recognition_forfeit', source_id = schedule.id.
   * Schedule status becomes 'closed' with unearned zeroed (`total_amount = recognized_amount`).
   */
  async onMembershipCancelled(input: MembershipCancelledPortInput): Promise<void> {
    if (!(await this.isPostingEnabled())) {
      return;
    }

    await runInTransaction(this.db, async () => {
      const schedules = await this.revenueRecognitionRepository.findByMembershipId(
        input.membershipId,
        ['open', 'paused'],
      );
      if (schedules.length === 0) {
        return;
      }

      const forfeitAccount = await this.accountsRepository.findByCode('4300');
      if (!forfeitAccount) {
        throw new NotFoundError('Forfeited membership income account (4300) was not found');
      }

      const entryDate = input.cancelDate ?? new Date().toISOString().slice(0, 10);

      for (const schedule of schedules) {
        const remaining = subMoney(schedule.total_amount, schedule.recognized_amount);

        if (cmpMoney(remaining, '0.00') > 0) {
          await this.postingService.postJournal({
            entryDate,
            sourceType: 'recognition_forfeit',
            sourceId: schedule.id,
            memo: `Forfeited unearned revenue on membership #${input.membershipId} cancellation`,
            postedByUserId: input.cancelledByUserId,
            lines: [
              {
                accountId: schedule.unearned_account_id,
                debit: remaining,
                memo: `Forfeit unearned balance schedule #${schedule.id}`,
              },
              {
                accountId: forfeitAccount.id,
                credit: remaining,
                memo: `Forfeited income from cancelled membership #${input.membershipId}`,
              },
            ],
          });
        }

        await this.revenueRecognitionRepository.updateSchedule(schedule.id, {
          status: 'closed',
          total_amount: schedule.recognized_amount,
        });
      }
    });
  }

  /**
   * Re-plans schedule when a PT subscription is extended:
   * ends_on moved out to the new end date.
   */
  async onPtExtended(input: PtExtendedPortInput): Promise<void> {
    if (!(await this.isPostingEnabled())) {
      return;
    }

    await runInTransaction(this.db, async () => {
      const schedules = await this.revenueRecognitionRepository.findByPtSubscriptionId(
        input.ptSubscriptionId,
        ['open', 'paused'],
      );

      for (const schedule of schedules) {
        await this.revenueRecognitionRepository.updateSchedule(schedule.id, {
          ends_on: input.newEndDate,
        });
      }
    });
  }

  /**
   * ACC-059: On PT cancellation:
   * Forfeit remaining unearned amount (`total_amount - recognized_amount`) to `4300`.
   * Debit unearned PT (2210), credit 4300 Forfeited membership income.
   * source_type = 'recognition_forfeit', source_id = schedule.id.
   * Schedule status becomes 'closed' with unearned zeroed (`total_amount = recognized_amount`).
   */
  async onPtCancelled(input: PtCancelledPortInput): Promise<void> {
    if (!(await this.isPostingEnabled())) {
      return;
    }

    await runInTransaction(this.db, async () => {
      const schedules = await this.revenueRecognitionRepository.findByPtSubscriptionId(
        input.ptSubscriptionId,
        ['open', 'paused'],
      );
      if (schedules.length === 0) {
        return;
      }

      const forfeitAccount = await this.accountsRepository.findByCode('4300');
      if (!forfeitAccount) {
        throw new NotFoundError('Forfeited membership income account (4300) was not found');
      }

      const entryDate = input.cancelDate ?? new Date().toISOString().slice(0, 10);

      for (const schedule of schedules) {
        const remaining = subMoney(schedule.total_amount, schedule.recognized_amount);

        if (cmpMoney(remaining, '0.00') > 0) {
          await this.postingService.postJournal({
            entryDate,
            sourceType: 'recognition_forfeit',
            sourceId: schedule.id,
            memo: `Forfeited unearned revenue on PT subscription #${input.ptSubscriptionId} cancellation`,
            postedByUserId: input.cancelledByUserId,
            lines: [
              {
                accountId: schedule.unearned_account_id,
                debit: remaining,
                memo: `Forfeit unearned balance schedule #${schedule.id}`,
              },
              {
                accountId: forfeitAccount.id,
                credit: remaining,
                memo: `Forfeited income from cancelled PT #${input.ptSubscriptionId}`,
              },
            ],
          });
        }

        await this.revenueRecognitionRepository.updateSchedule(schedule.id, {
          status: 'closed',
          total_amount: schedule.recognized_amount,
        });
      }
    });
  }
}
