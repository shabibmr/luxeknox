import { Inject, Injectable } from '@nestjs/common';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { JournalSourceType } from '../platform/db/schema/accounting';
import { runInTransaction } from '../platform/db/transaction-context';
import {
  BadRequestError,
  BusinessRuleError,
  NotFoundError,
} from '../platform/errors/app-error';
import { roundMoney, toCents } from '../platform/money/money';
import {
  AccountingRepository,
  type JournalEntryWithLines,
} from './accounting.repository';

export type PostJournalLineInput = {
  accountId: number;
  /** Debit amount as DECIMAL(12,2) string. Exactly one of debit/credit must be positive. */
  debit?: string | number;
  /** Credit amount as DECIMAL(12,2) string. Exactly one of debit/credit must be positive. */
  credit?: string | number;
  memo?: string | null;
  memberId?: number | null;
  vendorId?: number | null;
};

export type PostJournalInput = {
  entryDate: string;
  sourceType: JournalSourceType | string;
  sourceId: number;
  memo?: string | null;
  postedByUserId?: number | null;
  lines: PostJournalLineInput[];
};

export type ReverseJournalInput = {
  journalId: number;
  /** Date of the reversing journal. Defaults to the original entry date. */
  entryDate?: string;
  memo?: string | null;
  postedByUserId?: number | null;
};

type NormalizedLine = {
  accountId: number;
  debit: string;
  credit: string;
  memo: string | null;
  memberId: number | null;
  vendorId: number | null;
};

/**
 * Posts balanced journals into the general ledger.
 * SQL lives in {@link AccountingRepository}.
 * `postJournal` opens or joins `runInTransaction` so source writes and journal
 * inserts share one transaction.
 */
@Injectable()
export class AccountingPostingService {
  constructor(
    private readonly accountingRepository: AccountingRepository,
    @Inject(DRIZZLE_DB_TOKEN) private readonly db: DrizzleDb<any>,
  ) {}

  /**
   * Validate lines, resolve period, allocate number, insert header + lines.
   * Debits must equal credits in cents. A line cannot carry both sides or neither.
   * Amounts on the active side must be positive.
   * Replaying the same `(source_type, source_id)` returns the original journal
   * and writes nothing new (unique index + look-up).
   * A date in a locked period throws and rolls back the shared transaction.
   */
  async postJournal(input: PostJournalInput): Promise<JournalEntryWithLines> {
    return runInTransaction(this.db, async () => {
      const existing = await this.accountingRepository.findBySource(
        input.sourceType as JournalSourceType,
        input.sourceId,
      );
      if (existing) {
        const withLines = await this.accountingRepository.findEntryWithLines(existing.id);
        if (!withLines) {
          throw new NotFoundError(`Journal entry ${existing.id} is missing lines`);
        }
        return withLines;
      }

      const normalized = this.normalizeAndValidateLines(input.lines);

      const period = await this.accountingRepository.findPeriodForDate(input.entryDate);
      if (!period) {
        throw new NotFoundError(`No accounting period covers ${input.entryDate}`);
      }
      if (period.status === 'locked') {
        throw new BusinessRuleError(
          `Accounting period ${period.starts_on} to ${period.ends_on} is locked`,
        );
      }

      const journalNumber = await this.accountingRepository.allocateJournalNumber();
      const now = new Date();

      const entry = await this.accountingRepository.insertJournalEntry({
        journal_number: journalNumber,
        entry_date: input.entryDate,
        accounting_period_id: period.id,
        source_type: input.sourceType,
        source_id: input.sourceId,
        memo: input.memo ?? null,
        posted_at: now,
        posted_by_user_id: input.postedByUserId ?? null,
        reverses_journal_id: null,
        created_at: now,
      });

      const lines = await this.accountingRepository.insertJournalLines(
        normalized.map((line) => ({
          journal_entry_id: entry.id,
          account_id: line.accountId,
          debit: line.debit,
          credit: line.credit,
          memo: line.memo,
          member_id: line.memberId,
          vendor_id: line.vendorId,
        })),
      );

      return { ...entry, lines };
    });
  }

  /**
   * Post a reversing journal for a posted entry.
   * Swaps debit and credit on each line, sets `reverses_journal_id` on the new
   * entry, and never mutates the original.
   * Replaying reverse for the same journal returns the existing reversal
   * (`source_type = journal_reversal`, `source_id = original id`).
   */
  async reverseJournal(input: ReverseJournalInput): Promise<JournalEntryWithLines> {
    return runInTransaction(this.db, async () => {
      const original = await this.accountingRepository.findEntryWithLines(input.journalId);
      if (!original) {
        throw new NotFoundError(`Journal entry ${input.journalId} was not found`);
      }

      const existing = await this.accountingRepository.findBySource(
        'journal_reversal',
        input.journalId,
      );
      if (existing) {
        const withLines = await this.accountingRepository.findEntryWithLines(existing.id);
        if (!withLines) {
          throw new NotFoundError(`Journal entry ${existing.id} is missing lines`);
        }
        return withLines;
      }

      const entryDate = input.entryDate ?? original.entry_date;
      const period = await this.accountingRepository.findPeriodForDate(entryDate);
      if (!period) {
        throw new NotFoundError(`No accounting period covers ${entryDate}`);
      }
      if (period.status === 'locked') {
        throw new BusinessRuleError(
          `Accounting period ${period.starts_on} to ${period.ends_on} is locked`,
        );
      }

      let memo = input.memo;
      if (memo === undefined) {
        memo = original.memo
          ? `Reversal of ${original.journal_number}: ${original.memo}`
          : `Reversal of ${original.journal_number}`;
      }

      const swapped = this.normalizeAndValidateLines(
        original.lines.map((line) => ({
          accountId: line.account_id,
          debit: line.credit,
          credit: line.debit,
          memo: line.memo,
          memberId: line.member_id,
          vendorId: line.vendor_id,
        })),
      );

      const journalNumber = await this.accountingRepository.allocateJournalNumber();
      const now = new Date();

      const entry = await this.accountingRepository.insertJournalEntry({
        journal_number: journalNumber,
        entry_date: entryDate,
        accounting_period_id: period.id,
        source_type: 'journal_reversal',
        source_id: input.journalId,
        memo,
        posted_at: now,
        posted_by_user_id: input.postedByUserId ?? null,
        reverses_journal_id: original.id,
        created_at: now,
      });

      const lines = await this.accountingRepository.insertJournalLines(
        swapped.map((line) => ({
          journal_entry_id: entry.id,
          account_id: line.accountId,
          debit: line.debit,
          credit: line.credit,
          memo: line.memo,
          member_id: line.memberId,
          vendor_id: line.vendorId,
        })),
      );

      return { ...entry, lines };
    });
  }

  private normalizeAndValidateLines(lines: PostJournalLineInput[]): NormalizedLine[] {
    if (!Array.isArray(lines) || lines.length === 0) {
      throw new BadRequestError('Journal must have at least one line');
    }

    let debitTotal = 0n;
    let creditTotal = 0n;
    const normalized: NormalizedLine[] = [];

    for (const [index, line] of lines.entries()) {
      const debitRaw = line.debit ?? '0.00';
      const creditRaw = line.credit ?? '0.00';
      let debit: string;
      let credit: string;
      try {
        debit = roundMoney(debitRaw);
        credit = roundMoney(creditRaw);
      } catch {
        throw new BadRequestError(`Journal line ${index + 1} has an invalid amount`);
      }

      const debitCents = toCents(debit);
      const creditCents = toCents(credit);

      if (debitCents > 0n && creditCents > 0n) {
        throw new BadRequestError(
          `Journal line ${index + 1} cannot carry both debit and credit`,
        );
      }
      if (debitCents === 0n && creditCents === 0n) {
        throw new BadRequestError(
          `Journal line ${index + 1} must have a positive debit or credit`,
        );
      }
      if (debitCents < 0n || creditCents < 0n) {
        throw new BadRequestError(
          `Journal line ${index + 1} amounts must be positive`,
        );
      }

      debitTotal += debitCents;
      creditTotal += creditCents;

      normalized.push({
        accountId: line.accountId,
        debit,
        credit,
        memo: line.memo ?? null,
        memberId: line.memberId ?? null,
        vendorId: line.vendorId ?? null,
      });
    }

    if (debitTotal !== creditTotal) {
      throw new BusinessRuleError('Journal debits must equal credits');
    }

    return normalized;
  }
}
