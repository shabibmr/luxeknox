import { Inject, Injectable } from '@nestjs/common';
import { and, asc, count, desc, eq, exists, gte, like, lte, sql, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import { items, journalEntries, uoms } from '../platform/db/schema/accounting';
import {
  counterSaleLines,
  counterSaleNumberCounters,
  counterSaleTenders,
  counterSales,
  type CounterSale,
  type NewCounterSale,
  type NewCounterSaleLine,
  type NewCounterSaleTender,
} from '../platform/db/schema/inventory';
import { members } from '../platform/db/schema/members';
import { paymentMethods } from '../platform/db/schema/payments';

export interface SaleMemberRow {
  id: number;
  first_name: string;
  last_name: string;
}

export interface SalePaymentMethodRow {
  id: number;
  method_name: string;
  is_active: boolean;
  account_id: number | null;
}

export interface CounterSaleLineRow {
  id: number;
  item_id: number;
  item_name: string;
  uom_code: string;
  quantity: string;
  rate: string;
  discount_amount: string;
  tax_code_id: number | null;
  net_amount: string;
  tax_amount: string;
  unit_cost: string | null;
  cost_amount: string | null;
}

export interface CounterSaleTenderRow {
  id: number;
  payment_method_id: number;
  payment_method_name: string;
  amount: string;
  reference: string | null;
}

export interface CounterSaleListFilter {
  from?: string;
  to?: string;
  memberId?: number;
  itemId?: number;
  search?: string;
}

export type CounterSaleListRow = Omit<CounterSaleDetail, 'lines' | 'tenders'>;

export function counterSaleListWhere(filters: CounterSaleListFilter): SQL | undefined {
  const conditions: SQL[] = [];

  if (filters.from) {
    conditions.push(gte(counterSales.sale_date, filters.from));
  }
  if (filters.to) {
    conditions.push(lte(counterSales.sale_date, filters.to));
  }
  if (filters.memberId != null) {
    conditions.push(eq(counterSales.member_id, filters.memberId));
  }
  const search = filters.search?.trim();
  if (search) {
    conditions.push(like(counterSales.sale_number, `%${search}%`));
  }
  if (filters.itemId != null) {
    conditions.push(
      exists(
        sql`(select 1 from ${counterSaleLines} where ${counterSaleLines.counter_sale_id} = ${counterSales.id} and ${counterSaleLines.item_id} = ${filters.itemId})`,
      ),
    );
  }

  return conditions.length > 0 ? and(...conditions) : undefined;
}

export interface CounterSaleDetail {
  id: number;
  sale_number: string;
  sale_date: string;
  member_id: number | null;
  member_first_name: string | null;
  member_last_name: string | null;
  customer_name: string | null;
  status: string;
  subtotal: string;
  discount_amount: string;
  tax_amount: string;
  total_amount: string;
  cogs_amount: string;
  journal_entry_id: number | null;
  journal_number: string | null;
  row_version: number;
  created_at: Date;
  lines: CounterSaleLineRow[];
  tenders: CounterSaleTenderRow[];
}

@Injectable()
export class CounterSalesRepository extends BaseRepository<
  typeof counterSales,
  CounterSale,
  NewCounterSale
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, counterSales);
  }

  /**
   * Allocate the next counter-sale number under a row lock.
   * Format: `SAL-` + 8 zero-padded digits. Must run inside `runInTransaction`.
   */
  async allocateSaleNumber(): Promise<string> {
    const db = this.getDb() as any;
    const locked = await db.execute(
      sql`SELECT \`next_value\` AS next_value FROM \`counter_sale_number_counters\` WHERE \`id\` = 1 FOR UPDATE`,
    );
    const rows = Array.isArray(locked) ? (Array.isArray(locked[0]) ? locked[0] : locked) : [];
    const next = Number((rows[0] as { next_value?: unknown } | undefined)?.next_value);
    if (!Number.isFinite(next) || next < 1) {
      throw new Error('counter_sale_number_counters is not initialized');
    }
    await db
      .update(counterSaleNumberCounters)
      .set({ next_value: next + 1 })
      .where(eq(counterSaleNumberCounters.id, 1));
    return `SAL-${String(next).padStart(8, '0')}`;
  }

  async findMember(id: number): Promise<SaleMemberRow | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select({
        id: members.id,
        first_name: members.first_name,
        last_name: members.last_name,
      })
      .from(members)
      .where(eq(members.id, id))
      .limit(1);
    return (rows[0] as SaleMemberRow | undefined) ?? null;
  }

  async findPaymentMethod(id: number): Promise<SalePaymentMethodRow | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select({
        id: paymentMethods.id,
        method_name: paymentMethods.method_name,
        is_active: paymentMethods.is_active,
        account_id: paymentMethods.account_id,
      })
      .from(paymentMethods)
      .where(eq(paymentMethods.id, id))
      .limit(1);
    return (rows[0] as SalePaymentMethodRow | undefined) ?? null;
  }

  async insertSale(
    header: NewCounterSale,
    lines: Array<Omit<NewCounterSaleLine, 'counter_sale_id'>>,
    tenders: Array<Omit<NewCounterSaleTender, 'counter_sale_id'>>,
  ): Promise<number> {
    const db = this.getDb() as any;
    const result = await db.insert(counterSales).values(header);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    if (!id) {
      throw new Error('Failed to insert counter sale');
    }
    if (lines.length > 0) {
      await db.insert(counterSaleLines).values(
        lines.map((line) => ({
          ...line,
          counter_sale_id: id,
        })),
      );
    }
    if (tenders.length > 0) {
      await db.insert(counterSaleTenders).values(
        tenders.map((tender) => ({
          ...tender,
          counter_sale_id: id,
        })),
      );
    }
    return id;
  }

  async attachJournal(id: number, journalEntryId: number): Promise<void> {
    const db = this.getDb() as any;
    await db
      .update(counterSales)
      .set({
        journal_entry_id: journalEntryId,
        updated_at: new Date(),
      })
      .where(eq(counterSales.id, id));
  }

  async findDetail(id: number): Promise<CounterSaleDetail | null> {
    const db = this.getDb() as any;
    const headers = await db
      .select({
        id: counterSales.id,
        sale_number: counterSales.sale_number,
        sale_date: counterSales.sale_date,
        member_id: counterSales.member_id,
        member_first_name: members.first_name,
        member_last_name: members.last_name,
        customer_name: counterSales.customer_name,
        status: counterSales.status,
        subtotal: counterSales.subtotal,
        discount_amount: counterSales.discount_amount,
        tax_amount: counterSales.tax_amount,
        total_amount: counterSales.total_amount,
        cogs_amount: counterSales.cogs_amount,
        journal_entry_id: counterSales.journal_entry_id,
        journal_number: journalEntries.journal_number,
        row_version: counterSales.row_version,
        created_at: counterSales.created_at,
      })
      .from(counterSales)
      .leftJoin(members, eq(counterSales.member_id, members.id))
      .leftJoin(journalEntries, eq(counterSales.journal_entry_id, journalEntries.id))
      .where(eq(counterSales.id, id))
      .limit(1);
    const header = headers[0] as Omit<CounterSaleDetail, 'lines' | 'tenders'> | undefined;
    if (!header) return null;

    const lines = (await db
      .select({
        id: counterSaleLines.id,
        item_id: counterSaleLines.item_id,
        item_name: items.name,
        uom_code: uoms.code,
        quantity: counterSaleLines.quantity,
        rate: counterSaleLines.rate,
        discount_amount: counterSaleLines.discount_amount,
        tax_code_id: counterSaleLines.tax_code_id,
        net_amount: counterSaleLines.net_amount,
        tax_amount: counterSaleLines.tax_amount,
        unit_cost: counterSaleLines.unit_cost,
        cost_amount: counterSaleLines.cost_amount,
      })
      .from(counterSaleLines)
      .innerJoin(items, eq(counterSaleLines.item_id, items.id))
      .innerJoin(uoms, eq(items.uom_id, uoms.id))
      .where(eq(counterSaleLines.counter_sale_id, id))
      .orderBy(asc(counterSaleLines.id))) as CounterSaleLineRow[];

    const tenders = (await db
      .select({
        id: counterSaleTenders.id,
        payment_method_id: counterSaleTenders.payment_method_id,
        payment_method_name: paymentMethods.method_name,
        amount: counterSaleTenders.amount,
        reference: counterSaleTenders.reference,
      })
      .from(counterSaleTenders)
      .innerJoin(paymentMethods, eq(counterSaleTenders.payment_method_id, paymentMethods.id))
      .where(eq(counterSaleTenders.counter_sale_id, id))
      .orderBy(asc(counterSaleTenders.id))) as CounterSaleTenderRow[];

    return { ...header, lines, tenders };
  }

  async findMany(
    params: CounterSaleListFilter & { limit: number; offset: number },
  ): Promise<{ rows: CounterSaleListRow[]; total: number }> {
    const db = this.getDb() as any;
    const where = counterSaleListWhere(params);

    let listQ = db
      .select({
        id: counterSales.id,
        sale_number: counterSales.sale_number,
        sale_date: counterSales.sale_date,
        member_id: counterSales.member_id,
        member_first_name: members.first_name,
        member_last_name: members.last_name,
        customer_name: counterSales.customer_name,
        status: counterSales.status,
        subtotal: counterSales.subtotal,
        discount_amount: counterSales.discount_amount,
        tax_amount: counterSales.tax_amount,
        total_amount: counterSales.total_amount,
        cogs_amount: counterSales.cogs_amount,
        journal_entry_id: counterSales.journal_entry_id,
        journal_number: journalEntries.journal_number,
        row_version: counterSales.row_version,
        created_at: counterSales.created_at,
      })
      .from(counterSales)
      .leftJoin(members, eq(counterSales.member_id, members.id))
      .leftJoin(journalEntries, eq(counterSales.journal_entry_id, journalEntries.id));
    let countQ = db.select({ value: count() }).from(counterSales);
    if (where) {
      listQ = listQ.where(where);
      countQ = countQ.where(where);
    }

    const rows = await listQ
      .orderBy(desc(counterSales.sale_date), desc(counterSales.id))
      .limit(params.limit)
      .offset(params.offset);
    const totalRows = await countQ;
    return { rows: rows as CounterSaleListRow[], total: Number(totalRows[0]?.value ?? 0) };
  }
}
