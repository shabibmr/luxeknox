import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, inArray, sql, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import { members } from '../platform/db/schema/members';
import {
  invoiceNumberCounters,
  paymentHistories,
  paymentReceipts,
  payments,
  receiptNumberCounters,
  type NewPayment,
  type NewPaymentHistory,
  type NewPaymentReceipt,
  type Payment,
  type PaymentHistory,
  type PaymentReceipt,
} from '../platform/db/schema/payments';

export type PaymentListScope =
  | { type: 'all' }
  | { type: 'self'; memberProfileId: number }
  | { type: 'trainer'; trainerProfileId: number };

@Injectable()
export class PaymentRepository extends BaseRepository<typeof payments, Payment, NewPayment> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, payments);
  }

  /**
   * PAY-003: allocate next invoice number under row lock.
   * Format: INV + 8 zero-padded digits.
   */
  async allocateInvoiceNumber(): Promise<string> {
    const db = this.getDb() as any;
    const locked = await db.execute(
      sql`SELECT \`next_value\` AS next_value FROM \`invoice_number_counters\` WHERE \`id\` = 1 FOR UPDATE`,
    );
    const rows = Array.isArray(locked) ? (Array.isArray(locked[0]) ? locked[0] : locked) : [];
    const next = Number((rows[0] as { next_value?: unknown } | undefined)?.next_value);
    if (!Number.isFinite(next) || next < 1) {
      throw new Error('invoice_number_counters is not initialized');
    }
    await db
      .update(invoiceNumberCounters)
      .set({ next_value: next + 1 })
      .where(eq(invoiceNumberCounters.id, 1));
    return `INV${String(next).padStart(8, '0')}`;
  }

  /**
   * PAY-011: allocate next receipt number under row lock.
   * Format: RCP + 8 zero-padded digits.
   */
  async allocateReceiptNumber(): Promise<string> {
    const db = this.getDb() as any;
    const locked = await db.execute(
      sql`SELECT \`next_value\` AS next_value FROM \`receipt_number_counters\` WHERE \`id\` = 1 FOR UPDATE`,
    );
    const rows = Array.isArray(locked) ? (Array.isArray(locked[0]) ? locked[0] : locked) : [];
    const next = Number((rows[0] as { next_value?: unknown } | undefined)?.next_value);
    if (!Number.isFinite(next) || next < 1) {
      throw new Error('receipt_number_counters is not initialized');
    }
    await db
      .update(receiptNumberCounters)
      .set({ next_value: next + 1 })
      .where(eq(receiptNumberCounters.id, 1));
    return `RCP${String(next).padStart(8, '0')}`;
  }

  async insertPayment(row: NewPayment): Promise<Payment> {
    const db = this.getDb() as any;
    const result = await db.insert(payments).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const created = await this.findById(id);
    if (!created) throw new Error(`Failed to load payment ${id}`);
    return created;
  }

  async updatePayment(
    id: number,
    values: Partial<NewPayment> & { row_version: number },
  ): Promise<Payment> {
    const db = this.getDb() as any;
    await db.update(payments).set(values).where(eq(payments.id, id));
    const updated = await this.findById(id);
    if (!updated) throw new Error(`Failed to load payment ${id}`);
    return updated;
  }

  async insertHistory(row: NewPaymentHistory): Promise<PaymentHistory> {
    const db = this.getDb() as any;
    const result = await db.insert(paymentHistories).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const rows = await db.select().from(paymentHistories).where(eq(paymentHistories.id, id)).limit(1);
    return rows[0];
  }

  async listHistories(paymentId: number): Promise<PaymentHistory[]> {
    const db = this.getDb() as any;
    return db
      .select()
      .from(paymentHistories)
      .where(eq(paymentHistories.payment_id, paymentId))
      .orderBy(desc(paymentHistories.timestamp), desc(paymentHistories.id));
  }

  async insertReceipt(row: NewPaymentReceipt): Promise<PaymentReceipt> {
    const db = this.getDb() as any;
    const result = await db.insert(paymentReceipts).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const rows = await db.select().from(paymentReceipts).where(eq(paymentReceipts.id, id)).limit(1);
    return rows[0];
  }

  async findReceiptByPaymentId(paymentId: number): Promise<PaymentReceipt | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(paymentReceipts)
      .where(eq(paymentReceipts.payment_id, paymentId))
      .limit(1);
    return rows[0] ?? null;
  }

  private buildScopeConditions(scope: PaymentListScope): SQL[] {
    if (scope.type === 'self') {
      return [eq(payments.member_id, scope.memberProfileId)];
    }
    if (scope.type === 'trainer') {
      return [eq(members.assigned_trainer_id, scope.trainerProfileId)];
    }
    return [];
  }

  async findManyFiltered(params: {
    memberId?: number;
    status?: string;
    statuses?: string[];
    outstandingOnly?: boolean;
    scope: PaymentListScope;
    limit: number;
    offset: number;
  }): Promise<{ rows: Payment[]; total: number }> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [...this.buildScopeConditions(params.scope)];
    if (params.memberId != null) conditions.push(eq(payments.member_id, params.memberId));
    if (params.status) conditions.push(eq(payments.status, params.status));
    if (params.statuses?.length) conditions.push(inArray(payments.status, params.statuses));
    if (params.outstandingOnly) {
      conditions.push(sql`${payments.total_amount} - ${payments.amount_paid} > 0`);
    }
    const where = conditions.length ? and(...conditions) : undefined;
    const needsMemberJoin = params.scope.type === 'trainer';

    let listQ = db.select({ payment: payments }).from(payments);
    let countQ = db.select({ value: count() }).from(payments);
    if (needsMemberJoin) {
      listQ = listQ.innerJoin(members, eq(payments.member_id, members.id));
      countQ = countQ.innerJoin(members, eq(payments.member_id, members.id));
    }
    if (where) {
      listQ = listQ.where(where);
      countQ = countQ.where(where);
    }
    const rows = await listQ
      .orderBy(desc(payments.payment_date), desc(payments.id))
      .limit(params.limit)
      .offset(params.offset);
    const totalRows = await countQ;
    return {
      rows: rows.map((r: { payment: Payment }) => r.payment),
      total: Number(totalRows[0]?.value ?? 0),
    };
  }

  /**
   * DSH-007 / PAY-017 (minimal): today's collected revenue.
   * Sums `payment_received` history amounts with `timestamp` in [dayStart, dayEnd);
   * invoice_count is distinct payment_id in that window.
   */
  async getRevenueToday(
    dayStart: Date,
    dayEnd: Date,
  ): Promise<{ total_amount: string; invoice_count: number }> {
    const db = this.getDb() as any;
    const rows = await db
      .select({
        total_amount: sql<string>`COALESCE(SUM(${paymentHistories.amount}), 0)`,
        invoice_count: sql<number>`COUNT(DISTINCT ${paymentHistories.payment_id})`,
      })
      .from(paymentHistories)
      .where(
        and(
          eq(paymentHistories.action, 'payment_received'),
          sql`${paymentHistories.timestamp} >= ${dayStart}`,
          sql`${paymentHistories.timestamp} < ${dayEnd}`,
        ),
      );
    const totalRaw = rows[0]?.total_amount ?? '0';
    const total =
      typeof totalRaw === 'string' ? totalRaw : Number(totalRaw).toFixed(2);
    return {
      total_amount: Number(total).toFixed(2),
      invoice_count: Number(rows[0]?.invoice_count ?? 0),
    };
  }
}
