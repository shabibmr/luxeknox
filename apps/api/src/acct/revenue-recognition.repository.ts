import { Inject, Injectable } from '@nestjs/common';
import { and, eq, inArray } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  revenueRecognitionLines,
  revenueRecognitionSchedules,
  type NewRevenueRecognitionLine,
  type NewRevenueRecognitionSchedule,
  type RevenueRecognitionLine,
  type RevenueRecognitionSchedule,
} from '../platform/db/schema/accounting';
import { payments } from '../platform/db/schema/payments';
import { NotFoundError } from '../platform/errors/app-error';

@Injectable()
export class RevenueRecognitionRepository extends BaseRepository<
  typeof revenueRecognitionSchedules,
  RevenueRecognitionSchedule,
  NewRevenueRecognitionSchedule
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, revenueRecognitionSchedules);
  }

  async insertSchedule(
    row: NewRevenueRecognitionSchedule,
  ): Promise<RevenueRecognitionSchedule> {
    const db = this.getDb() as any;
    const result = await db.insert(revenueRecognitionSchedules).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const created = await this.findById(id);
    if (!created) {
      throw new Error(`Failed to load revenue recognition schedule ${id}`);
    }
    return created;
  }

  async findByPaymentId(paymentId: number): Promise<RevenueRecognitionSchedule | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(revenueRecognitionSchedules)
      .where(eq(revenueRecognitionSchedules.payment_id, paymentId))
      .limit(1);
    return rows[0] ?? null;
  }

  async findOpenOrPausedSchedules(): Promise<RevenueRecognitionSchedule[]> {
    const db = this.getDb() as any;
    return db
      .select()
      .from(revenueRecognitionSchedules)
      .where(inArray(revenueRecognitionSchedules.status, ['open', 'paused']));
  }

  async findByMembershipId(
    membershipId: number,
    statuses?: ('open' | 'paused' | 'closed')[],
  ): Promise<RevenueRecognitionSchedule[]> {
    const db = this.getDb() as any;
    const conditions = [eq(payments.membership_id, membershipId)];
    if (statuses && statuses.length > 0) {
      conditions.push(inArray(revenueRecognitionSchedules.status, statuses));
    }
    const rows = await db
      .select({
        id: revenueRecognitionSchedules.id,
        payment_id: revenueRecognitionSchedules.payment_id,
        unearned_account_id: revenueRecognitionSchedules.unearned_account_id,
        income_account_id: revenueRecognitionSchedules.income_account_id,
        total_amount: revenueRecognitionSchedules.total_amount,
        recognized_amount: revenueRecognitionSchedules.recognized_amount,
        starts_on: revenueRecognitionSchedules.starts_on,
        ends_on: revenueRecognitionSchedules.ends_on,
        recognized_through: revenueRecognitionSchedules.recognized_through,
        status: revenueRecognitionSchedules.status,
        paused_from: revenueRecognitionSchedules.paused_from,
      })
      .from(revenueRecognitionSchedules)
      .innerJoin(payments, eq(revenueRecognitionSchedules.payment_id, payments.id))
      .where(and(...conditions));
    return rows;
  }

  async findByPtSubscriptionId(
    ptSubscriptionId: number,
    statuses?: ('open' | 'paused' | 'closed')[],
  ): Promise<RevenueRecognitionSchedule[]> {
    const db = this.getDb() as any;
    const conditions = [eq(payments.pt_subscription_id, ptSubscriptionId)];
    if (statuses && statuses.length > 0) {
      conditions.push(inArray(revenueRecognitionSchedules.status, statuses));
    }
    const rows = await db
      .select({
        id: revenueRecognitionSchedules.id,
        payment_id: revenueRecognitionSchedules.payment_id,
        unearned_account_id: revenueRecognitionSchedules.unearned_account_id,
        income_account_id: revenueRecognitionSchedules.income_account_id,
        total_amount: revenueRecognitionSchedules.total_amount,
        recognized_amount: revenueRecognitionSchedules.recognized_amount,
        starts_on: revenueRecognitionSchedules.starts_on,
        ends_on: revenueRecognitionSchedules.ends_on,
        recognized_through: revenueRecognitionSchedules.recognized_through,
        status: revenueRecognitionSchedules.status,
        paused_from: revenueRecognitionSchedules.paused_from,
      })
      .from(revenueRecognitionSchedules)
      .innerJoin(payments, eq(revenueRecognitionSchedules.payment_id, payments.id))
      .where(and(...conditions));
    return rows;
  }

  async updateSchedule(
    id: number,
    row: Partial<NewRevenueRecognitionSchedule>,
  ): Promise<RevenueRecognitionSchedule> {
    const db = this.getDb() as any;
    await db
      .update(revenueRecognitionSchedules)
      .set(row)
      .where(eq(revenueRecognitionSchedules.id, id));
    const updated = await this.findById(id);
    if (!updated) {
      throw new NotFoundError(`Revenue recognition schedule ${id} was not found`);
    }
    return updated;
  }

  async insertLine(row: NewRevenueRecognitionLine): Promise<RevenueRecognitionLine> {
    const db = this.getDb() as any;
    const result = await db.insert(revenueRecognitionLines).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const rows = await db
      .select()
      .from(revenueRecognitionLines)
      .where(eq(revenueRecognitionLines.id, id))
      .limit(1);
    const created = rows[0];
    if (!created) {
      throw new Error(`Failed to load revenue recognition line ${id}`);
    }
    return created;
  }

  async findLineByScheduleAndPeriod(
    scheduleId: number,
    periodId: number,
  ): Promise<RevenueRecognitionLine | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(revenueRecognitionLines)
      .where(
        and(
          eq(revenueRecognitionLines.schedule_id, scheduleId),
          eq(revenueRecognitionLines.accounting_period_id, periodId),
        ),
      )
      .limit(1);
    return rows[0] ?? null;
  }

  async countLinesForPeriod(periodId: number): Promise<number> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(revenueRecognitionLines)
      .where(eq(revenueRecognitionLines.accounting_period_id, periodId));
    return rows.length;
  }

  async findLinesByPeriod(periodId: number): Promise<RevenueRecognitionLine[]> {
    const db = this.getDb() as any;
    return db
      .select()
      .from(revenueRecognitionLines)
      .where(eq(revenueRecognitionLines.accounting_period_id, periodId));
  }

  async updateLine(
    id: number,
    row: Partial<NewRevenueRecognitionLine>,
  ): Promise<RevenueRecognitionLine> {
    const db = this.getDb() as any;
    await db
      .update(revenueRecognitionLines)
      .set(row)
      .where(eq(revenueRecognitionLines.id, id));
    const rows = await db
      .select()
      .from(revenueRecognitionLines)
      .where(eq(revenueRecognitionLines.id, id))
      .limit(1);
    const updated = rows[0];
    if (!updated) {
      throw new NotFoundError(`Revenue recognition line ${id} was not found`);
    }
    return updated;
  }
}


