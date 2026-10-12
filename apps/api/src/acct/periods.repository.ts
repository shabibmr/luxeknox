import { Inject, Injectable } from '@nestjs/common';
import { and, asc, count, eq, gte, lte, sql, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  accountingPeriods,
  creditNotes,
  debitNotes,
  expenseVouchers,
  fiscalYears,
  journalEntries,
  journalLines,
  paymentVouchers,
  purchaseBills,
  type AccountingPeriod,
  type FiscalYear,
  type NewAccountingPeriod,
} from '../platform/db/schema/accounting';
import type { DraftDocumentCountsDto } from './periods.dto';

@Injectable()
export class PeriodsRepository extends BaseRepository<
  typeof accountingPeriods,
  AccountingPeriod,
  NewAccountingPeriod
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, accountingPeriods);
  }

  async listFiscalYears(): Promise<FiscalYear[]> {
    const db = this.getDb() as any;
    return db
      .select()
      .from(fiscalYears)
      .orderBy(asc(fiscalYears.starts_on));
  }

  async listPeriods(filters?: {
    fiscal_year_id?: number;
    status?: 'open' | 'locked';
  }): Promise<AccountingPeriod[]> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [];

    if (filters?.fiscal_year_id !== undefined) {
      conditions.push(eq(accountingPeriods.fiscal_year_id, filters.fiscal_year_id));
    }
    if (filters?.status !== undefined) {
      conditions.push(eq(accountingPeriods.status, filters.status));
    }

    const query = db
      .select()
      .from(accountingPeriods)
      .orderBy(asc(accountingPeriods.starts_on));

    if (conditions.length > 0) {
      return query.where(and(...conditions));
    }
    return query;
  }

  async findPeriodById(id: number): Promise<AccountingPeriod | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(accountingPeriods)
      .where(eq(accountingPeriods.id, id))
      .limit(1);
    return rows[0] ?? null;
  }

  async updatePeriod(
    id: number,
    data: Partial<NewAccountingPeriod>,
  ): Promise<AccountingPeriod> {
    const db = this.getDb() as any;
    await db
      .update(accountingPeriods)
      .set(data)
      .where(eq(accountingPeriods.id, id));
    const updated = await this.findPeriodById(id);
    if (!updated) {
      throw new Error(`Failed to reload accounting period ${id}`);
    }
    return updated;
  }

  async calculateTrialBalanceTotals(
    endsOn: string,
    startsOn?: string,
  ): Promise<{ totalDebit: string; totalCredit: string }> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [lte(journalEntries.entry_date, endsOn)];
    if (startsOn) {
      conditions.push(gte(journalEntries.entry_date, startsOn));
    }
    const rows = await db
      .select({
        totalDebit: sql<string>`COALESCE(SUM(${journalLines.debit}), '0.00')`,
        totalCredit: sql<string>`COALESCE(SUM(${journalLines.credit}), '0.00')`,
      })
      .from(journalLines)
      .innerJoin(journalEntries, eq(journalLines.journal_entry_id, journalEntries.id))
      .where(and(...conditions));

    const row = rows[0];
    return {
      totalDebit: String(row?.totalDebit ?? '0.00'),
      totalCredit: String(row?.totalCredit ?? '0.00'),
    };
  }

  async countDraftDocuments(
    startsOn: string,
    endsOn: string,
  ): Promise<DraftDocumentCountsDto> {
    const db = this.getDb() as any;

    const [pbResult, evResult, pvResult, cnResult, dnResult] = await Promise.all([
      db
        .select({ val: count() })
        .from(purchaseBills)
        .where(
          and(
            gte(purchaseBills.bill_date, startsOn),
            lte(purchaseBills.bill_date, endsOn),
            eq(purchaseBills.status, 'draft'),
          ),
        ),
      db
        .select({ val: count() })
        .from(expenseVouchers)
        .where(
          and(
            gte(expenseVouchers.expense_date, startsOn),
            lte(expenseVouchers.expense_date, endsOn),
            eq(expenseVouchers.status, 'draft'),
          ),
        ),
      db
        .select({ val: count() })
        .from(paymentVouchers)
        .where(
          and(
            gte(paymentVouchers.payment_date, startsOn),
            lte(paymentVouchers.payment_date, endsOn),
            eq(paymentVouchers.status, 'draft'),
          ),
        ),
      db
        .select({ val: count() })
        .from(creditNotes)
        .where(
          and(
            gte(creditNotes.credit_note_date, startsOn),
            lte(creditNotes.credit_note_date, endsOn),
            eq(creditNotes.status, 'draft'),
          ),
        ),
      db
        .select({ val: count() })
        .from(debitNotes)
        .where(
          and(
            gte(debitNotes.debit_note_date, startsOn),
            lte(debitNotes.debit_note_date, endsOn),
            eq(debitNotes.status, 'draft'),
          ),
        ),
    ]);

    const purchase_bills = Number(pbResult[0]?.val ?? 0);
    const expense_vouchers = Number(evResult[0]?.val ?? 0);
    const payment_vouchers = Number(pvResult[0]?.val ?? 0);
    const credit_notes = Number(cnResult[0]?.val ?? 0);
    const debit_notes = Number(dnResult[0]?.val ?? 0);
    const total =
      purchase_bills +
      expense_vouchers +
      payment_vouchers +
      credit_notes +
      debit_notes;

    return {
      purchase_bills,
      expense_vouchers,
      payment_vouchers,
      credit_notes,
      debit_notes,
      total,
    };
  }
}
