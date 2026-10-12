import { Inject, Injectable } from '@nestjs/common';
import { and, asc, count, desc, eq, gte, like, lte, or, sql, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  expenseVoucherLines,
  expenseVoucherNumberCounters,
  expenseVouchers,
  type ExpenseVoucher,
  type ExpenseVoucherLine,
  type NewExpenseVoucher,
  type NewExpenseVoucherLine,
} from '../platform/db/schema/accounting';
import { NotFoundError } from '../platform/errors/app-error';

export type ExpenseVoucherWithLines = ExpenseVoucher & {
  lines: ExpenseVoucherLine[];
};

export interface ExpenseFilterParams {
  status?: string;
  vendorId?: number;
  from?: string;
  to?: string;
  search?: string;
  limit: number;
  offset: number;
}

@Injectable()
export class ExpensesRepository extends BaseRepository<
  typeof expenseVouchers,
  ExpenseVoucher,
  NewExpenseVoucher
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, expenseVouchers);
  }

  /**
   * Allocate next expense voucher number under row lock.
   * Format: EXP + 8 zero-padded digits.
   * Must run inside `runInTransaction`.
   */
  async allocateExpenseNumber(): Promise<string> {
    const db = this.getDb() as any;
    const locked = await db.execute(
      sql`SELECT \`next_value\` AS next_value FROM \`expense_voucher_number_counters\` WHERE \`id\` = 1 FOR UPDATE`,
    );
    const rows = Array.isArray(locked) ? (Array.isArray(locked[0]) ? locked[0] : locked) : [];
    const next = Number((rows[0] as { next_value?: unknown } | undefined)?.next_value);
    if (!Number.isFinite(next) || next < 1) {
      throw new Error('expense_voucher_number_counters is not initialized');
    }
    await db
      .update(expenseVoucherNumberCounters)
      .set({ next_value: next + 1 })
      .where(eq(expenseVoucherNumberCounters.id, 1));
    return `EXP${String(next).padStart(8, '0')}`;
  }

  async findWithLines(id: number): Promise<ExpenseVoucherWithLines | null> {
    const voucher = await this.findById(id);
    if (!voucher) return null;
    const lines = await this.listLines(id);
    return { ...voucher, lines };
  }

  async listLines(voucherId: number): Promise<ExpenseVoucherLine[]> {
    const db = this.getDb() as any;
    return db
      .select()
      .from(expenseVoucherLines)
      .where(eq(expenseVoucherLines.expense_voucher_id, voucherId))
      .orderBy(asc(expenseVoucherLines.id));
  }

  async insertExpense(
    row: NewExpenseVoucher,
    lines: Array<Omit<NewExpenseVoucherLine, 'expense_voucher_id'>>,
  ): Promise<ExpenseVoucherWithLines> {
    const db = this.getDb() as any;
    const result = await db.insert(expenseVouchers).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    if (lines.length > 0) {
      await db.insert(expenseVoucherLines).values(
        lines.map((line) => ({
          ...line,
          expense_voucher_id: id,
        })),
      );
    }
    const created = await this.findWithLines(id);
    if (!created) {
      throw new Error(`Failed to load expense voucher ${id}`);
    }
    return created;
  }

  async updateExpense(id: number, row: Partial<NewExpenseVoucher>): Promise<ExpenseVoucher> {
    const db = this.getDb() as any;
    await db.update(expenseVouchers).set(row).where(eq(expenseVouchers.id, id));
    const updated = await this.findById(id);
    if (!updated) {
      throw new NotFoundError(`Expense voucher ${id} was not found`);
    }
    return updated;
  }

  async replaceLines(
    voucherId: number,
    lines: Array<Omit<NewExpenseVoucherLine, 'expense_voucher_id'>>,
  ): Promise<ExpenseVoucherLine[]> {
    const db = this.getDb() as any;
    await db
      .delete(expenseVoucherLines)
      .where(eq(expenseVoucherLines.expense_voucher_id, voucherId));
    if (lines.length > 0) {
      await db.insert(expenseVoucherLines).values(
        lines.map((line) => ({
          ...line,
          expense_voucher_id: voucherId,
        })),
      );
    }
    return this.listLines(voucherId);
  }

  async findMany(params: ExpenseFilterParams): Promise<{ rows: ExpenseVoucher[]; total: number }> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [];

    if (params.status) {
      conditions.push(eq(expenseVouchers.status, params.status));
    }
    if (params.vendorId) {
      conditions.push(eq(expenseVouchers.vendor_id, params.vendorId));
    }
    if (params.from) {
      conditions.push(gte(expenseVouchers.expense_date, params.from));
    }
    if (params.to) {
      conditions.push(lte(expenseVouchers.expense_date, params.to));
    }
    if (params.search && params.search.trim().length > 0) {
      const term = `%${params.search.trim()}%`;
      conditions.push(
        or(
          like(expenseVouchers.expense_number, term),
          like(expenseVouchers.payee_name, term),
        ) as SQL,
      );
    }

    const where = conditions.length > 0 ? and(...conditions) : undefined;

    let listQ = db.select().from(expenseVouchers);
    let countQ = db.select({ value: count() }).from(expenseVouchers);
    if (where) {
      listQ = listQ.where(where);
      countQ = countQ.where(where);
    }

    const rows = await listQ
      .orderBy(desc(expenseVouchers.expense_date), desc(expenseVouchers.id))
      .limit(params.limit)
      .offset(params.offset);
    const totalRows = await countQ;

    return { rows, total: Number(totalRows[0]?.value ?? 0) };
  }
}
