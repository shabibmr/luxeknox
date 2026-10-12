import { Inject, Injectable } from '@nestjs/common';
import { and, asc, count, desc, eq, gte, inArray, like, lte, ne, or, sql, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  debitNotes,
  expenseVouchers,
  paymentAllocations,
  paymentVoucherNumberCounters,
  paymentVouchers,
  purchaseBills,
  type ExpenseVoucher,
  type NewPaymentAllocation,
  type NewPaymentVoucher,
  type PaymentAllocation,
  type PaymentVoucher,
  type PurchaseBill,
} from '../platform/db/schema/accounting';
import { fromCents, toCents } from '../platform/money/money';

export type PaymentVoucherWithAllocations = PaymentVoucher & {
  allocations: PaymentAllocation[];
};

@Injectable()
export class PaymentVouchersRepository extends BaseRepository<
  typeof paymentVouchers,
  PaymentVoucher,
  NewPaymentVoucher
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, paymentVouchers);
  }

  /**
   * Allocate next payment voucher number under row lock.
   * Format: PV + 8 zero-padded digits.
   * Must run inside `runInTransaction`.
   */
  async allocatePaymentVoucherNumber(): Promise<string> {
    const db = this.getDb() as any;
    const locked = await db.execute(
      sql`SELECT \`next_value\` AS next_value FROM \`payment_voucher_number_counters\` WHERE \`id\` = 1 FOR UPDATE`,
    );
    const rows = Array.isArray(locked) ? (Array.isArray(locked[0]) ? locked[0] : locked) : [];
    const next = Number((rows[0] as { next_value?: unknown } | undefined)?.next_value);
    if (!Number.isFinite(next) || next < 1) {
      throw new Error('payment_voucher_number_counters is not initialized');
    }
    await db
      .update(paymentVoucherNumberCounters)
      .set({ next_value: next + 1 })
      .where(eq(paymentVoucherNumberCounters.id, 1));
    return `PV${String(next).padStart(8, '0')}`;
  }

  async findWithAllocations(id: number): Promise<PaymentVoucherWithAllocations | null> {
    const voucher = await this.findById(id);
    if (!voucher) return null;
    const allocations = await this.listAllocations(id);
    return { ...voucher, allocations };
  }

  async listAllocations(voucherId: number): Promise<PaymentAllocation[]> {
    const db = this.getDb() as any;
    return db
      .select()
      .from(paymentAllocations)
      .where(eq(paymentAllocations.payment_voucher_id, voucherId))
      .orderBy(asc(paymentAllocations.id));
  }

  async listAllocationsForVoucherIds(voucherIds: number[]): Promise<PaymentAllocation[]> {
    if (voucherIds.length === 0) return [];
    const db = this.getDb() as any;
    return db
      .select()
      .from(paymentAllocations)
      .where(inArray(paymentAllocations.payment_voucher_id, voucherIds))
      .orderBy(asc(paymentAllocations.id));
  }

  async insertVoucher(
    row: NewPaymentVoucher,
    allocations: Array<Omit<NewPaymentAllocation, 'payment_voucher_id' | 'id'>>,
  ): Promise<PaymentVoucherWithAllocations> {
    const db = this.getDb() as any;
    const result = await db.insert(paymentVouchers).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    if (allocations.length > 0) {
      await db.insert(paymentAllocations).values(
        allocations.map((a) => ({
          payment_voucher_id: id,
          purchase_bill_id: a.purchase_bill_id ?? null,
          expense_voucher_id: a.expense_voucher_id ?? null,
          amount: a.amount,
        })),
      );
    }
    const created = await this.findWithAllocations(id);
    if (!created) {
      throw new Error(`Failed to load payment voucher ${id}`);
    }
    return created;
  }

  async updateVoucher(id: number, row: Partial<NewPaymentVoucher>): Promise<PaymentVoucher> {
    const db = this.getDb() as any;
    await db.update(paymentVouchers).set(row).where(eq(paymentVouchers.id, id));
    const updated = await this.findById(id);
    if (!updated) {
      throw new Error(`Failed to load payment voucher ${id}`);
    }
    return updated;
  }

  async replaceAllocations(
    voucherId: number,
    allocations: Array<Omit<NewPaymentAllocation, 'payment_voucher_id' | 'id'>>,
  ): Promise<PaymentAllocation[]> {
    const db = this.getDb() as any;
    await db
      .delete(paymentAllocations)
      .where(eq(paymentAllocations.payment_voucher_id, voucherId));
    if (allocations.length > 0) {
      await db.insert(paymentAllocations).values(
        allocations.map((a) => ({
          payment_voucher_id: voucherId,
          purchase_bill_id: a.purchase_bill_id ?? null,
          expense_voucher_id: a.expense_voucher_id ?? null,
          amount: a.amount,
        })),
      );
    }
    return this.listAllocations(voucherId);
  }

  async findMany(params: {
    status?: string;
    from?: string;
    to?: string;
    bankAccountId?: number;
    search?: string;
    limit: number;
    offset: number;
  }): Promise<{ rows: PaymentVoucherWithAllocations[]; total: number }> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [];

    if (params.status) {
      conditions.push(eq(paymentVouchers.status, params.status));
    }
    if (params.from) {
      conditions.push(gte(paymentVouchers.payment_date, params.from));
    }
    if (params.to) {
      conditions.push(lte(paymentVouchers.payment_date, params.to));
    }
    if (params.bankAccountId) {
      conditions.push(eq(paymentVouchers.bank_account_id, params.bankAccountId));
    }
    if (params.search) {
      const pattern = `%${params.search}%`;
      conditions.push(
        or(
          like(paymentVouchers.voucher_number, pattern),
          like(paymentVouchers.memo, pattern),
        ) as SQL,
      );
    }

    const where = conditions.length ? and(...conditions) : undefined;

    let listQ = db.select().from(paymentVouchers);
    let countQ = db.select({ value: count() }).from(paymentVouchers);
    if (where) {
      listQ = listQ.where(where);
      countQ = countQ.where(where);
    }

    const rows = await listQ
      .orderBy(desc(paymentVouchers.payment_date), desc(paymentVouchers.id))
      .limit(params.limit)
      .offset(params.offset);
    const totalRows = await countQ;
    const total = Number(totalRows[0]?.value ?? 0);

    if (rows.length === 0) {
      return { rows: [], total };
    }

    const voucherIds = rows.map((r: PaymentVoucher) => r.id);
    const allocations = await this.listAllocationsForVoucherIds(voucherIds);
    const allocMap = new Map<number, PaymentAllocation[]>();
    for (const a of allocations) {
      const list = allocMap.get(a.payment_voucher_id) ?? [];
      list.push(a);
      allocMap.set(a.payment_voucher_id, list);
    }

    const rowsWithAllocations = rows.map((r: PaymentVoucher) => ({
      ...r,
      allocations: allocMap.get(r.id) ?? [],
    }));

    return { rows: rowsWithAllocations, total };
  }

  async sumPostedAllocationsForBill(billId: number, excludeVoucherId?: number): Promise<string> {
    const db = this.getDb() as any;
    const conditions = [
      eq(paymentAllocations.purchase_bill_id, billId),
      eq(paymentVouchers.status, 'posted'),
    ];
    if (excludeVoucherId !== undefined) {
      conditions.push(ne(paymentVouchers.id, excludeVoucherId));
    }
    const rows = await db
      .select({ amount: paymentAllocations.amount })
      .from(paymentAllocations)
      .innerJoin(paymentVouchers, eq(paymentAllocations.payment_voucher_id, paymentVouchers.id))
      .where(and(...conditions));

    let sum = 0n;
    for (const r of rows) {
      sum += toCents(r.amount);
    }
    return fromCents(sum);
  }

  async sumPostedAllocationsForExpense(
    expenseId: number,
    excludeVoucherId?: number,
  ): Promise<string> {
    const db = this.getDb() as any;
    const conditions = [
      eq(paymentAllocations.expense_voucher_id, expenseId),
      eq(paymentVouchers.status, 'posted'),
    ];
    if (excludeVoucherId !== undefined) {
      conditions.push(ne(paymentVouchers.id, excludeVoucherId));
    }
    const rows = await db
      .select({ amount: paymentAllocations.amount })
      .from(paymentAllocations)
      .innerJoin(paymentVouchers, eq(paymentAllocations.payment_voucher_id, paymentVouchers.id))
      .where(and(...conditions));

    let sum = 0n;
    for (const r of rows) {
      sum += toCents(r.amount);
    }
    return fromCents(sum);
  }

  async sumPostedDebitNotesForBill(billId: number): Promise<string> {
    const db = this.getDb() as any;
    const rows = await db
      .select({ total_amount: debitNotes.total_amount })
      .from(debitNotes)
      .where(and(eq(debitNotes.purchase_bill_id, billId), eq(debitNotes.status, 'posted')));

    let sum = 0n;
    for (const r of rows) {
      sum += toCents(r.total_amount);
    }
    return fromCents(sum);
  }

  async findPurchaseBillById(id: number): Promise<PurchaseBill | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(purchaseBills)
      .where(eq(purchaseBills.id, id))
      .limit(1);
    return rows[0] ?? null;
  }

  async findExpenseVoucherById(id: number): Promise<ExpenseVoucher | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(expenseVouchers)
      .where(eq(expenseVouchers.id, id))
      .limit(1);
    return rows[0] ?? null;
  }
}
