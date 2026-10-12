import { Inject, Injectable, OnModuleInit, Optional } from '@nestjs/common';
import { and, eq, gte, inArray } from 'drizzle-orm';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  accounts,
  journalEntries,
  journalLines,
  type Account,
} from '../platform/db/schema/accounting';
import { memberships, membershipProducts } from '../platform/db/schema/memberships';
import { payments } from '../platform/db/schema/payments';
import { ptSubscriptions, ptProducts } from '../platform/db/schema/personal-training';
import { NotFoundError } from '../platform/errors/app-error';
import {
  addMoney,
  cmpMoney,
  fromCents,
  roundMoney,
  subMoney,
  toCents,
} from '../platform/money/money';
import { SettingsService } from '../sys/settings.service';
import { AccountsRepository } from './accounts.repository';
import type { UnearnedPreviewItemDto, UnearnedPreviewResponseDto } from './go-live.dto';
import { RevenueRecognitionRepository } from './revenue-recognition.repository';
import { countDaysInclusive } from './revenue-recognition.service';

function subtractOneDay(dateStr: string): string {
  const parts = dateStr.slice(0, 10).split('-');
  const year = parseInt(parts[0], 10);
  const month = parseInt(parts[1], 10) - 1;
  const day = parseInt(parts[2], 10);
  const d = new Date(Date.UTC(year, month, day));
  d.setUTCDate(d.getUTCDate() - 1);
  return d.toISOString().slice(0, 10);
}

@Injectable()
export class GoLiveService implements OnModuleInit {
  constructor(
    private readonly accountsRepository: AccountsRepository,
    private readonly revenueRecognitionRepository: RevenueRecognitionRepository,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
    @Optional()
    private readonly settingsService?: SettingsService,
  ) {}

  onModuleInit(): void {
    if (this.settingsService) {
      this.settingsService.setPostingPrerequisiteHook(async (overrides) => {
        const targetDate = overrides?.goLiveDate ?? new Date().toISOString().slice(0, 10);
        const { failingReasons, preview } = await this.validateOpeningJournalMatch(targetDate);
        return {
          failingReasons,
          createGoLiveSchedules: async () => {
            await this.createGoLiveSchedules(targetDate, preview.items);
          },
        };
      });
    }
  }

  /**
   * ACC-064: Generates the unearned revenue preview for running memberships and PT terms.
   * Scans active/frozen memberships and active PT terms that extend to or past goLiveDate,
   * having paid/partial payments. Computes the unexpired net share as of goLiveDate.
   */
  async getUnearnedPreview(goLiveDate?: string): Promise<UnearnedPreviewResponseDto> {
    const targetDate = goLiveDate ?? new Date().toISOString().slice(0, 10);

    const unearned2200 = await this.accountsRepository.findByCode('2200');
    if (!unearned2200) {
      throw new NotFoundError('Unearned membership revenue account (2200) was not found');
    }

    const unearned2210 = await this.accountsRepository.findByCode('2210');
    if (!unearned2210) {
      throw new NotFoundError('Unearned PT revenue account (2210) was not found');
    }

    const defaultIncome4000 = await this.accountsRepository.findByCode('4000');
    if (!defaultIncome4000) {
      throw new NotFoundError('Membership revenue account (4000) was not found');
    }

    const defaultIncome4100 = await this.accountsRepository.findByCode('4100');
    if (!defaultIncome4100) {
      throw new NotFoundError('PT revenue account (4100) was not found');
    }

    const db = this.db as any;
    const items: UnearnedPreviewItemDto[] = [];
    let unearnedMembershipTotal = '0.00';
    let unearnedPtTotal = '0.00';

    // 1. Running memberships
    const runningMemberships = await db
      .select({
        membershipId: memberships.id,
        memberId: memberships.member_id,
        startDate: memberships.start_date,
        endDate: memberships.end_date,
        status: memberships.status,
        productId: memberships.product_id,
        paymentId: payments.id,
        subtotal: payments.subtotal,
        amountPaid: payments.amount_paid,
        paymentStatus: payments.status,
      })
      .from(memberships)
      .innerJoin(payments, eq(memberships.id, payments.membership_id))
      .where(
        and(
          inArray(memberships.status, ['active', 'frozen']),
          gte(memberships.end_date, targetDate),
          inArray(payments.status, ['paid', 'partial']),
        ),
      );

    for (const m of runningMemberships) {
      if (cmpMoney(String(m.amountPaid), '0.00') <= 0) {
        continue;
      }

      const totalDays = countDaysInclusive(m.startDate, m.endDate);
      if (totalDays <= 0) {
        continue;
      }

      let unexpiredDays = 0;
      if (targetDate <= m.startDate) {
        unexpiredDays = totalDays;
      } else {
        unexpiredDays = countDaysInclusive(targetDate, m.endDate);
      }

      if (unexpiredDays <= 0) {
        continue;
      }

      const totalNet = roundMoney(String(m.subtotal));
      let unexpiredAmount: string;
      if (unexpiredDays >= totalDays) {
        unexpiredAmount = totalNet;
      } else {
        const cents = Math.round((Number(toCents(totalNet)) * unexpiredDays) / totalDays);
        unexpiredAmount = fromCents(BigInt(cents));
        if (cmpMoney(unexpiredAmount, totalNet) > 0) {
          unexpiredAmount = totalNet;
        }
      }

      let incomeAccountId = defaultIncome4000.id;
      if (m.productId != null) {
        const prod = await db
          .select({ incomeAccountId: membershipProducts.income_account_id })
          .from(membershipProducts)
          .where(eq(membershipProducts.id, m.productId))
          .limit(1);
        if (prod[0]?.incomeAccountId != null) {
          incomeAccountId = prod[0].incomeAccountId;
        }
      }

      items.push({
        kind: 'membership',
        source_id: m.membershipId,
        payment_id: m.paymentId,
        member_id: m.memberId,
        starts_on: m.startDate,
        ends_on: m.endDate,
        unearned_account_id: unearned2200.id,
        income_account_id: incomeAccountId,
        account_code: '2200',
        total_net: totalNet,
        unexpired_amount: unexpiredAmount,
      });

      unearnedMembershipTotal = addMoney(unearnedMembershipTotal, unexpiredAmount);
    }

    // 2. Running PT subscriptions
    const runningPt = await db
      .select({
        ptSubscriptionId: ptSubscriptions.id,
        memberId: ptSubscriptions.member_id,
        startDate: ptSubscriptions.start_date,
        endDate: ptSubscriptions.end_date,
        status: ptSubscriptions.status,
        ptProductId: ptSubscriptions.pt_product_id,
        paymentId: payments.id,
        subtotal: payments.subtotal,
        amountPaid: payments.amount_paid,
        paymentStatus: payments.status,
      })
      .from(ptSubscriptions)
      .innerJoin(payments, eq(ptSubscriptions.id, payments.pt_subscription_id))
      .where(
        and(
          eq(ptSubscriptions.status, 'active'),
          gte(ptSubscriptions.end_date, targetDate),
          inArray(payments.status, ['paid', 'partial']),
        ),
      );

    for (const pt of runningPt) {
      if (cmpMoney(String(pt.amountPaid), '0.00') <= 0) {
        continue;
      }

      const totalDays = countDaysInclusive(pt.startDate, pt.endDate);
      if (totalDays <= 0) {
        continue;
      }

      let unexpiredDays = 0;
      if (targetDate <= pt.startDate) {
        unexpiredDays = totalDays;
      } else {
        unexpiredDays = countDaysInclusive(targetDate, pt.endDate);
      }

      if (unexpiredDays <= 0) {
        continue;
      }

      const totalNet = roundMoney(String(pt.subtotal));
      let unexpiredAmount: string;
      if (unexpiredDays >= totalDays) {
        unexpiredAmount = totalNet;
      } else {
        const cents = Math.round((Number(toCents(totalNet)) * unexpiredDays) / totalDays);
        unexpiredAmount = fromCents(BigInt(cents));
        if (cmpMoney(unexpiredAmount, totalNet) > 0) {
          unexpiredAmount = totalNet;
        }
      }

      let incomeAccountId = defaultIncome4100.id;
      if (pt.ptProductId != null) {
        const prod = await db
          .select({ incomeAccountId: ptProducts.income_account_id })
          .from(ptProducts)
          .where(eq(ptProducts.id, pt.ptProductId))
          .limit(1);
        if (prod[0]?.incomeAccountId != null) {
          incomeAccountId = prod[0].incomeAccountId;
        }
      }

      items.push({
        kind: 'pt',
        source_id: pt.ptSubscriptionId,
        payment_id: pt.paymentId,
        member_id: pt.memberId,
        starts_on: pt.startDate,
        ends_on: pt.endDate,
        unearned_account_id: unearned2210.id,
        income_account_id: incomeAccountId,
        account_code: '2210',
        total_net: totalNet,
        unexpired_amount: unexpiredAmount,
      });

      unearnedPtTotal = addMoney(unearnedPtTotal, unexpiredAmount);
    }

    return {
      go_live_date: targetDate,
      totals: {
        unearned_membership_total: unearnedMembershipTotal,
        unearned_pt_total: unearnedPtTotal,
        combined_total: addMoney(unearnedMembershipTotal, unearnedPtTotal),
      },
      items,
    };
  }

  /**
   * ACC-064: Writes go-live recognition schedules with recognized_through set to day before go-live.
   */
  async createGoLiveSchedules(
    goLiveDate: string,
    items: UnearnedPreviewItemDto[],
  ): Promise<void> {
    const recognizedThrough = subtractOneDay(goLiveDate);

    for (const item of items) {
      const existing = await this.revenueRecognitionRepository.findByPaymentId(
        item.payment_id,
      );
      if (existing) {
        continue;
      }

      await this.revenueRecognitionRepository.insertSchedule({
        payment_id: item.payment_id,
        unearned_account_id: item.unearned_account_id,
        income_account_id: item.income_account_id,
        total_amount: item.unexpired_amount,
        recognized_amount: '0.00',
        starts_on: goLiveDate,
        ends_on: item.ends_on,
        recognized_through: recognizedThrough,
        status: 'open',
        paused_from: null,
      });
    }
  }

  /**
   * ACC-064: Checks opening balance journal net credits on accounts 2200 and 2210 against preview.
   * Returns failing check messages if missing or mismatched, naming both actual and expected amounts.
   */
  async validateOpeningJournalMatch(
    goLiveDate: string,
  ): Promise<{ failingReasons: string[]; preview: UnearnedPreviewResponseDto }> {
    const preview = await this.getUnearnedPreview(goLiveDate);
    const db = this.db as any;

    const openingJournals = await db
      .select({
        id: journalEntries.id,
      })
      .from(journalEntries)
      .where(eq(journalEntries.source_type, 'opening_balance'));

    if (openingJournals.length === 0) {
      return {
        failingReasons: ['No posted opening balance journal found.'],
        preview,
      };
    }

    const unearned2200 = await this.accountsRepository.findByCode('2200');
    const unearned2210 = await this.accountsRepository.findByCode('2210');

    let actual2200 = '0.00';
    let actual2210 = '0.00';

    const journalIds = openingJournals.map((j: { id: number }) => j.id);
    const lines = await db
      .select({
        accountId: journalLines.account_id,
        debit: journalLines.debit,
        credit: journalLines.credit,
      })
      .from(journalLines)
      .where(inArray(journalLines.journal_entry_id, journalIds));

    for (const line of lines) {
      if (unearned2200 && line.accountId === unearned2200.id) {
        const netCredit = subMoney(String(line.credit), String(line.debit));
        actual2200 = addMoney(actual2200, netCredit);
      }
      if (unearned2210 && line.accountId === unearned2210.id) {
        const netCredit = subMoney(String(line.credit), String(line.debit));
        actual2210 = addMoney(actual2210, netCredit);
      }
    }

    const failingReasons: string[] = [];
    if (cmpMoney(actual2200, preview.totals.unearned_membership_total) !== 0) {
      failingReasons.push(
        `Opening balance journal 2200 unearned membership balance (${actual2200}) does not match unearned preview (${preview.totals.unearned_membership_total}).`,
      );
    }

    if (cmpMoney(actual2210, preview.totals.unearned_pt_total) !== 0) {
      failingReasons.push(
        `Opening balance journal 2210 unearned PT balance (${actual2210}) does not match unearned preview (${preview.totals.unearned_pt_total}).`,
      );
    }

    return { failingReasons, preview };
  }
}
