import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  paymentMethods,
  type NewPaymentMethod,
  type PaymentMethod,
} from '../platform/db/schema/payments';

@Injectable()
export class PaymentMethodRepository extends BaseRepository<
  typeof paymentMethods,
  PaymentMethod,
  NewPaymentMethod
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, paymentMethods);
  }

  async findMany(params: {
    activeOnly: boolean;
    limit: number;
    offset: number;
  }): Promise<{ rows: PaymentMethod[]; total: number }> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [];
    if (params.activeOnly) {
      conditions.push(eq(paymentMethods.is_active, true));
    }
    const where = conditions.length ? and(...conditions) : undefined;

    let listQ = db.select().from(paymentMethods);
    let countQ = db.select({ value: count() }).from(paymentMethods);
    if (where) {
      listQ = listQ.where(where);
      countQ = countQ.where(where);
    }

    const rows = await listQ
      .orderBy(desc(paymentMethods.id))
      .limit(params.limit)
      .offset(params.offset);
    const totalRows = await countQ;
    return { rows, total: Number(totalRows[0]?.value ?? 0) };
  }

  async findByName(name: string): Promise<PaymentMethod | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(paymentMethods)
      .where(eq(paymentMethods.method_name, name))
      .limit(1);
    return rows[0] ?? null;
  }

  async insertMethod(row: NewPaymentMethod): Promise<PaymentMethod> {
    const db = this.getDb() as any;
    const result = await db.insert(paymentMethods).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const created = await this.findById(id);
    if (!created) throw new Error(`Failed to load payment_method ${id}`);
    return created;
  }
}
