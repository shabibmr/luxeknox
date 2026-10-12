import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, gte, like, lte, or, sql, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  debitNoteNumberCounters,
  debitNotes,
  type DebitNote,
  type NewDebitNote,
} from '../platform/db/schema/accounting';
import { NotFoundError } from '../platform/errors/app-error';
import { roundMoney } from '../platform/money/money';

export interface DebitNoteFilterParams {
  status?: string;
  purchaseBillId?: number;
  from?: string;
  to?: string;
  search?: string;
  limit: number;
  offset: number;
}

@Injectable()
export class DebitNotesRepository extends BaseRepository<
  typeof debitNotes,
  DebitNote,
  NewDebitNote
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, debitNotes);
  }

  /**
   * Allocate next debit note number under row lock.
   * Format: DN + 8 zero-padded digits.
   * Must run inside `runInTransaction`.
   */
  async allocateDebitNoteNumber(): Promise<string> {
    const db = this.getDb() as any;
    const locked = await db.execute(
      sql`SELECT \`next_value\` AS next_value FROM \`debit_note_number_counters\` WHERE \`id\` = 1 FOR UPDATE`,
    );
    const rows = Array.isArray(locked) ? (Array.isArray(locked[0]) ? locked[0] : locked) : [];
    const next = Number((rows[0] as { next_value?: unknown } | undefined)?.next_value);
    if (!Number.isFinite(next) || next < 1) {
      throw new Error('debit_note_number_counters is not initialized');
    }
    await db
      .update(debitNoteNumberCounters)
      .set({ next_value: next + 1 })
      .where(eq(debitNoteNumberCounters.id, 1));
    return `DN${String(next).padStart(8, '0')}`;
  }

  async insertDebitNote(row: NewDebitNote): Promise<DebitNote> {
    const db = this.getDb() as any;
    const result = await db.insert(debitNotes).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const created = await this.findById(id);
    if (!created) {
      throw new Error(`Failed to load debit note ${id}`);
    }
    return created;
  }

  async updateDebitNote(id: number, row: Partial<NewDebitNote>): Promise<DebitNote> {
    const db = this.getDb() as any;
    await db.update(debitNotes).set(row).where(eq(debitNotes.id, id));
    const updated = await this.findById(id);
    if (!updated) {
      throw new NotFoundError(`Debit note ${id} was not found`);
    }
    return updated;
  }

  async sumPostedDebitNotesForBill(billId: number): Promise<string> {
    const db = this.getDb() as any;
    const result = await db
      .select({
        total: sql<string>`COALESCE(SUM(${debitNotes.total_amount}), '0.00')`,
      })
      .from(debitNotes)
      .where(
        and(
          eq(debitNotes.purchase_bill_id, billId),
          eq(debitNotes.status, 'posted'),
        ),
      );
    const rawTotal = result[0]?.total;
    return rawTotal != null ? roundMoney(rawTotal) : '0.00';
  }

  async findMany(params: DebitNoteFilterParams): Promise<{ rows: DebitNote[]; total: number }> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [];

    if (params.status) {
      conditions.push(eq(debitNotes.status, params.status));
    }
    if (params.purchaseBillId) {
      conditions.push(eq(debitNotes.purchase_bill_id, params.purchaseBillId));
    }
    if (params.from) {
      conditions.push(gte(debitNotes.debit_note_date, params.from));
    }
    if (params.to) {
      conditions.push(lte(debitNotes.debit_note_date, params.to));
    }
    if (params.search && params.search.trim().length > 0) {
      const term = `%${params.search.trim()}%`;
      conditions.push(
        or(
          like(debitNotes.debit_note_number, term),
          like(debitNotes.reason, term),
        ) as SQL,
      );
    }

    const where = conditions.length > 0 ? and(...conditions) : undefined;

    let listQ = db.select().from(debitNotes);
    let countQ = db.select({ value: count() }).from(debitNotes);
    if (where) {
      listQ = listQ.where(where);
      countQ = countQ.where(where);
    }

    const rows = await listQ
      .orderBy(desc(debitNotes.debit_note_date), desc(debitNotes.id))
      .limit(params.limit)
      .offset(params.offset);
    const totalRows = await countQ;

    return { rows, total: Number(totalRows[0]?.value ?? 0) };
  }
}
