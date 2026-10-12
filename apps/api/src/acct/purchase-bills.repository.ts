import { Inject, Injectable } from '@nestjs/common';
import { and, asc, count, desc, eq, gte, like, lte, sql, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  purchaseBillLines,
  purchaseBillNumberCounters,
  purchaseBills,
  type NewPurchaseBill,
  type NewPurchaseBillLine,
  type PurchaseBill,
  type PurchaseBillLine,
} from '../platform/db/schema/accounting';
import { NotFoundError } from '../platform/errors/app-error';

export type PurchaseBillWithLines = PurchaseBill & {
  lines: PurchaseBillLine[];
};

export interface PurchaseBillFilterParams {
  status?: string;
  vendorId?: number;
  from?: string;
  to?: string;
  search?: string;
  limit: number;
  offset: number;
}

@Injectable()
export class PurchaseBillsRepository extends BaseRepository<
  typeof purchaseBills,
  PurchaseBill,
  NewPurchaseBill
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, purchaseBills);
  }

  /**
   * Allocate next purchase bill number under row lock.
   * Format: BIL + 8 zero-padded digits.
   * Must run inside `runInTransaction`.
   */
  async allocateBillNumber(): Promise<string> {
    const db = this.getDb() as any;
    const locked = await db.execute(
      sql`SELECT \`next_value\` AS next_value FROM \`purchase_bill_number_counters\` WHERE \`id\` = 1 FOR UPDATE`,
    );
    const rows = Array.isArray(locked) ? (Array.isArray(locked[0]) ? locked[0] : locked) : [];
    const next = Number((rows[0] as { next_value?: unknown } | undefined)?.next_value);
    if (!Number.isFinite(next) || next < 1) {
      throw new Error('purchase_bill_number_counters is not initialized');
    }
    await db
      .update(purchaseBillNumberCounters)
      .set({ next_value: next + 1 })
      .where(eq(purchaseBillNumberCounters.id, 1));
    return `BIL${String(next).padStart(8, '0')}`;
  }

  async findWithLines(id: number): Promise<PurchaseBillWithLines | null> {
    const bill = await this.findById(id);
    if (!bill) return null;
    const lines = await this.listLines(id);
    return { ...bill, lines };
  }

  async listLines(billId: number): Promise<PurchaseBillLine[]> {
    const db = this.getDb() as any;
    return db
      .select()
      .from(purchaseBillLines)
      .where(eq(purchaseBillLines.purchase_bill_id, billId))
      .orderBy(asc(purchaseBillLines.id));
  }

  async insertBill(
    row: NewPurchaseBill,
    lines: Array<Omit<NewPurchaseBillLine, 'purchase_bill_id'>>,
  ): Promise<PurchaseBillWithLines> {
    const db = this.getDb() as any;
    const result = await db.insert(purchaseBills).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    if (lines.length > 0) {
      await db.insert(purchaseBillLines).values(
        lines.map((line) => ({
          ...line,
          purchase_bill_id: id,
        })),
      );
    }
    const created = await this.findWithLines(id);
    if (!created) {
      throw new Error(`Failed to load purchase bill ${id}`);
    }
    return created;
  }

  async updateBill(id: number, row: Partial<NewPurchaseBill>): Promise<PurchaseBill> {
    const db = this.getDb() as any;
    await db.update(purchaseBills).set(row).where(eq(purchaseBills.id, id));
    const updated = await this.findById(id);
    if (!updated) {
      throw new NotFoundError(`Purchase bill ${id} was not found`);
    }
    return updated;
  }

  async replaceLines(
    billId: number,
    lines: Array<Omit<NewPurchaseBillLine, 'purchase_bill_id'>>,
  ): Promise<PurchaseBillLine[]> {
    const db = this.getDb() as any;
    await db
      .delete(purchaseBillLines)
      .where(eq(purchaseBillLines.purchase_bill_id, billId));
    if (lines.length > 0) {
      await db.insert(purchaseBillLines).values(
        lines.map((line) => ({
          ...line,
          purchase_bill_id: billId,
        })),
      );
    }
    return this.listLines(billId);
  }

  async findMany(params: PurchaseBillFilterParams): Promise<{ rows: PurchaseBill[]; total: number }> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [];

    if (params.status) {
      conditions.push(eq(purchaseBills.status, params.status));
    }
    if (params.vendorId) {
      conditions.push(eq(purchaseBills.vendor_id, params.vendorId));
    }
    if (params.from) {
      conditions.push(gte(purchaseBills.bill_date, params.from));
    }
    if (params.to) {
      conditions.push(lte(purchaseBills.bill_date, params.to));
    }
    if (params.search && params.search.trim().length > 0) {
      const term = `%${params.search.trim()}%`;
      conditions.push(like(purchaseBills.bill_number, term));
    }

    const where = conditions.length > 0 ? and(...conditions) : undefined;

    let listQ = db.select().from(purchaseBills);
    let countQ = db.select({ value: count() }).from(purchaseBills);
    if (where) {
      listQ = listQ.where(where);
      countQ = countQ.where(where);
    }

    const rows = await listQ
      .orderBy(desc(purchaseBills.bill_date), desc(purchaseBills.id))
      .limit(params.limit)
      .offset(params.offset);
    const totalRows = await countQ;

    return { rows, total: Number(totalRows[0]?.value ?? 0) };
  }
}
