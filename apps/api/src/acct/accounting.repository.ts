import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, lte, gte, sql } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  accountingPeriods,
  journalEntries,
  journalLines,
  journalNumberCounters,
  type AccountingPeriod,
  type JournalEntry,
  type JournalLine,
  type JournalSourceType,
  type NewJournalEntry,
  type NewJournalLine,
} from '../platform/db/schema/accounting';

export type JournalEntryWithLines = JournalEntry & { lines: JournalLine[] };

@Injectable()
export class AccountingRepository extends BaseRepository<
  typeof journalEntries,
  JournalEntry,
  NewJournalEntry
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, journalEntries);
  }

  /**
   * Allocate next journal number under row lock.
   * Format: JRN + 8 zero-padded digits.
   * Must run inside `runInTransaction`.
   */
  async allocateJournalNumber(): Promise<string> {
    const db = this.getDb() as any;
    const locked = await db.execute(
      sql`SELECT \`next_value\` AS next_value FROM \`journal_number_counters\` WHERE \`id\` = 1 FOR UPDATE`,
    );
    const rows = Array.isArray(locked) ? (Array.isArray(locked[0]) ? locked[0] : locked) : [];
    const next = Number((rows[0] as { next_value?: unknown } | undefined)?.next_value);
    if (!Number.isFinite(next) || next < 1) {
      throw new Error('journal_number_counters is not initialized');
    }
    await db
      .update(journalNumberCounters)
      .set({ next_value: next + 1 })
      .where(eq(journalNumberCounters.id, 1));
    return `JRN${String(next).padStart(8, '0')}`;
  }

  async findBySource(
    sourceType: JournalSourceType,
    sourceId: number,
  ): Promise<JournalEntry | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(journalEntries)
      .where(
        and(eq(journalEntries.source_type, sourceType), eq(journalEntries.source_id, sourceId)),
      )
      .limit(1);
    return rows[0] ?? null;
  }

  /**
   * Period that contains `entryDate` (inclusive). Returns null when no period covers the date.
   */
  async findPeriodForDate(entryDate: string): Promise<AccountingPeriod | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(accountingPeriods)
      .where(
        and(
          lte(accountingPeriods.starts_on, entryDate),
          gte(accountingPeriods.ends_on, entryDate),
        ),
      )
      .limit(1);
    return rows[0] ?? null;
  }

  async insertJournalEntry(row: NewJournalEntry): Promise<JournalEntry> {
    const db = this.getDb() as any;
    const result = await db.insert(journalEntries).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const created = await this.findById(id);
    if (!created) throw new Error(`Failed to load journal entry ${id}`);
    return created;
  }

  async insertJournalLines(rows: NewJournalLine[]): Promise<JournalLine[]> {
    if (rows.length === 0) return [];
    const db = this.getDb() as any;
    await db.insert(journalLines).values(rows);
    const journalEntryId = rows[0]!.journal_entry_id;
    return this.listLines(journalEntryId);
  }

  async listLines(journalEntryId: number): Promise<JournalLine[]> {
    const db = this.getDb() as any;
    return db
      .select()
      .from(journalLines)
      .where(eq(journalLines.journal_entry_id, journalEntryId))
      .orderBy(asc(journalLines.id));
  }

  async findEntryWithLines(id: number): Promise<JournalEntryWithLines | null> {
    const entry = await this.findById(id);
    if (!entry) return null;
    const lines = await this.listLines(id);
    return { ...entry, lines };
  }
}
