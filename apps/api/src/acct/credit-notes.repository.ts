import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, sql } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  creditNoteNumberCounters,
  creditNotes,
  type CreditNote,
  type NewCreditNote,
} from '../platform/db/schema/accounting';
import { NotFoundError } from '../platform/errors/app-error';

@Injectable()
export class CreditNotesRepository extends BaseRepository<
  typeof creditNotes,
  CreditNote,
  NewCreditNote
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, creditNotes);
  }

  /**
   * Allocate next credit note number under row lock.
   * Format: CN + 8 zero-padded digits.
   * Must run inside `runInTransaction`.
   */
  async allocateCreditNoteNumber(): Promise<string> {
    const db = this.getDb() as any;
    const locked = await db.execute(
      sql`SELECT \`next_value\` AS next_value FROM \`credit_note_number_counters\` WHERE \`id\` = 1 FOR UPDATE`,
    );
    const rows = Array.isArray(locked) ? (Array.isArray(locked[0]) ? locked[0] : locked) : [];
    const next = Number((rows[0] as { next_value?: unknown } | undefined)?.next_value);
    if (!Number.isFinite(next) || next < 1) {
      throw new Error('credit_note_number_counters is not initialized');
    }
    await db
      .update(creditNoteNumberCounters)
      .set({ next_value: next + 1 })
      .where(eq(creditNoteNumberCounters.id, 1));
    return `CN${String(next).padStart(8, '0')}`;
  }

  async insertCreditNote(row: NewCreditNote): Promise<CreditNote> {
    const db = this.getDb() as any;
    const result = await db.insert(creditNotes).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const created = await this.findById(id);
    if (!created) {
      throw new Error(`Failed to load credit note ${id}`);
    }
    return created;
  }

  async updateCreditNote(id: number, row: Partial<NewCreditNote>): Promise<CreditNote> {
    const db = this.getDb() as any;
    await db.update(creditNotes).set(row).where(eq(creditNotes.id, id));
    const updated = await this.findById(id);
    if (!updated) {
      throw new NotFoundError(`Credit note ${id} was not found`);
    }
    return updated;
  }

  async findByPaymentId(paymentId: number): Promise<CreditNote[]> {
    const db = this.getDb() as any;
    return db
      .select()
      .from(creditNotes)
      .where(eq(creditNotes.payment_id, paymentId))
      .orderBy(desc(creditNotes.id));
  }
}
