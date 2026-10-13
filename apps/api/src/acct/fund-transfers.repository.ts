import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, gte, like, lte, or, sql, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  fundTransferNumberCounters,
  fundTransfers,
  type FundTransfer,
  type NewFundTransfer,
} from '../platform/db/schema/accounting';

@Injectable()
export class FundTransfersRepository extends BaseRepository<
  typeof fundTransfers,
  FundTransfer,
  NewFundTransfer
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, fundTransfers);
  }

  /**
   * Allocate next fund transfer number under row lock.
   * Format: FT + 8 zero-padded digits.
   * Must run inside `runInTransaction`.
   */
  async allocateFundTransferNumber(): Promise<string> {
    const db = this.getDb() as any;
    const locked = await db.execute(
      sql`SELECT \`next_value\` AS next_value FROM \`fund_transfer_number_counters\` WHERE \`id\` = 1 FOR UPDATE`,
    );
    const rows = Array.isArray(locked) ? (Array.isArray(locked[0]) ? locked[0] : locked) : [];
    const next = Number((rows[0] as { next_value?: unknown } | undefined)?.next_value);
    if (!Number.isFinite(next) || next < 1) {
      throw new Error('fund_transfer_number_counters is not initialized');
    }
    await db
      .update(fundTransferNumberCounters)
      .set({ next_value: next + 1 })
      .where(eq(fundTransferNumberCounters.id, 1));
    return `FT${String(next).padStart(8, '0')}`;
  }

  async insertTransfer(row: NewFundTransfer): Promise<FundTransfer> {
    const db = this.getDb() as any;
    const result = await db.insert(fundTransfers).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const created = await this.findById(id);
    if (!created) {
      throw new Error(`Failed to load fund transfer ${id}`);
    }
    return created;
  }

  async updateTransfer(id: number, row: Partial<NewFundTransfer>): Promise<FundTransfer> {
    const db = this.getDb() as any;
    await db.update(fundTransfers).set(row).where(eq(fundTransfers.id, id));
    const updated = await this.findById(id);
    if (!updated) {
      throw new Error(`Failed to load fund transfer ${id}`);
    }
    return updated;
  }

  async findMany(params: {
    status?: string;
    from?: string;
    to?: string;
    accountId?: number;
    search?: string;
    limit: number;
    offset: number;
  }): Promise<{ rows: FundTransfer[]; total: number }> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [];

    if (params.status) {
      conditions.push(eq(fundTransfers.status, params.status));
    }
    if (params.from) {
      conditions.push(gte(fundTransfers.transfer_date, params.from));
    }
    if (params.to) {
      conditions.push(lte(fundTransfers.transfer_date, params.to));
    }
    if (params.accountId) {
      conditions.push(
        or(
          eq(fundTransfers.from_account_id, params.accountId),
          eq(fundTransfers.to_account_id, params.accountId),
        ) as SQL,
      );
    }
    if (params.search) {
      const pattern = `%${params.search}%`;
      conditions.push(
        or(
          like(fundTransfers.transfer_number, pattern),
          like(fundTransfers.memo, pattern),
        ) as SQL,
      );
    }

    const where = conditions.length ? and(...conditions) : undefined;

    let listQ = db.select().from(fundTransfers);
    let countQ = db.select({ value: count() }).from(fundTransfers);
    if (where) {
      listQ = listQ.where(where);
      countQ = countQ.where(where);
    }

    const rows = await listQ
      .orderBy(desc(fundTransfers.transfer_date), desc(fundTransfers.id))
      .limit(params.limit)
      .offset(params.offset);
    const totalRows = await countQ;
    return { rows, total: Number(totalRows[0]?.value ?? 0) };
  }
}
