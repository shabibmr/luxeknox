import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, gte, inArray, lt, lte, sql } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import { members } from '../platform/db/schema/members';
import {
  ptSubscriptionChanges,
  ptSubscriptions,
  type NewPtSubscription,
  type NewPtSubscriptionChange,
  type PtSubscription,
  type PtSubscriptionChange,
} from '../platform/db/schema/personal-training';
import { schedules } from '../platform/db/schema/scheduling';

/** Statuses that hold a trainer slot / count as "the member's current PT". */
export const OPEN_PT_STATUSES = ['scheduled', 'active'] as const;

/** JSON columns can come back as a string on some MySQL/MariaDB drivers — normalise on read. */
function normalizeRow(row: PtSubscription): PtSubscription {
  const weekdays =
    typeof row.weekdays === 'string' ? (JSON.parse(row.weekdays) as number[]) : row.weekdays;
  return { ...row, weekdays: (weekdays ?? []).map(Number) };
}

@Injectable()
export class PtSubscriptionRepository extends BaseRepository<
  typeof ptSubscriptions,
  PtSubscription,
  NewPtSubscription
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, ptSubscriptions);
  }

  override async findById(id: number | bigint): Promise<PtSubscription | null> {
    const row = await super.findById(id);
    return row ? normalizeRow(row) : null;
  }

  async insertSubscription(values: NewPtSubscription): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateSubscription(id: number, values: Partial<NewPtSubscription>): Promise<void> {
    await this.update(eq(ptSubscriptions.id, id), values);
  }

  async listForMember(memberId: number): Promise<PtSubscription[]> {
    const db = this.getDb() as any;
    const rows = (await db
      .select()
      .from(ptSubscriptions)
      .where(eq(ptSubscriptions.member_id, memberId))
      .orderBy(desc(ptSubscriptions.start_date))) as PtSubscription[];
    return rows.map(normalizeRow);
  }

  /** Open (scheduled/active) subscriptions for a member whose date range intersects [from, to]. */
  async findOpenOverlappingForMember(
    memberId: number,
    from: string,
    to: string,
  ): Promise<PtSubscription[]> {
    const db = this.getDb() as any;
    const rows = (await db
      .select()
      .from(ptSubscriptions)
      .where(
        and(
          eq(ptSubscriptions.member_id, memberId),
          inArray(ptSubscriptions.status, [...OPEN_PT_STATUSES]),
          lte(ptSubscriptions.start_date, to),
          gte(ptSubscriptions.end_date, from),
        ),
      )) as PtSubscription[];
    return rows.map(normalizeRow);
  }

  /** True when `trainerId` holds a currently active PT with `memberId` (drives trainer write access). */
  async hasActiveForMemberAndTrainer(memberId: number, trainerId: number): Promise<boolean> {
    const db = this.getDb() as any;
    const rows = await db
      .select({ id: ptSubscriptions.id })
      .from(ptSubscriptions)
      .where(
        and(
          eq(ptSubscriptions.member_id, memberId),
          eq(ptSubscriptions.trainer_id, trainerId),
          eq(ptSubscriptions.status, 'active'),
        ),
      )
      .limit(1);
    return rows.length > 0;
  }

  /** True when the member has any currently active PT (with any trainer). */
  async hasActiveForMember(memberId: number): Promise<boolean> {
    const db = this.getDb() as any;
    const rows = await db
      .select({ id: ptSubscriptions.id })
      .from(ptSubscriptions)
      .where(and(eq(ptSubscriptions.member_id, memberId), eq(ptSubscriptions.status, 'active')))
      .limit(1);
    return rows.length > 0;
  }

  /**
   * Serialises concurrent PT sales for the same member so two staff cannot both pass the
   * "no other open PT" check. Lock the member before the trainer to keep a single lock order.
   * Must run inside `runInTransaction`.
   */
  async lockMember(memberId: number): Promise<void> {
    const db = this.getDb() as any;
    await db.execute(sql`SELECT \`id\` FROM \`members\` WHERE \`id\` = ${memberId} FOR UPDATE`);
  }

  /**
   * Serialises concurrent PT assignments against the same trainer (`SELECT … FOR UPDATE`)
   * so two staff members cannot both pass the free-slot check. Must run inside
   * `runInTransaction`.
   */
  async lockTrainer(trainerId: number): Promise<void> {
    const db = this.getDb() as any;
    await db.execute(sql`SELECT \`id\` FROM \`trainers\` WHERE \`id\` = ${trainerId} FOR UPDATE`);
  }

  /** scheduled → active once start_date has arrived. */
  async activateDue(today: string): Promise<number[]> {
    const db = this.getDb() as any;
    const due = (await db
      .select({ id: ptSubscriptions.id })
      .from(ptSubscriptions)
      .where(and(eq(ptSubscriptions.status, 'scheduled'), lte(ptSubscriptions.start_date, today)))) as {
      id: number;
    }[];
    const ids = due.map((r) => r.id);
    if (ids.length > 0) {
      await db
        .update(ptSubscriptions)
        .set({ status: 'active', updated_at: new Date() })
        .where(inArray(ptSubscriptions.id, ids));
    }
    return ids;
  }

  /** active → completed once end_date has passed. */
  async completeDue(today: string): Promise<number[]> {
    const db = this.getDb() as any;
    const due = (await db
      .select({ id: ptSubscriptions.id })
      .from(ptSubscriptions)
      .where(
        and(
          inArray(ptSubscriptions.status, [...OPEN_PT_STATUSES]),
          lt(ptSubscriptions.end_date, today),
        ),
      )) as { id: number }[];
    const ids = due.map((r) => r.id);
    if (ids.length > 0) {
      await db
        .update(ptSubscriptions)
        .set({ status: 'completed', updated_at: new Date() })
        .where(inArray(ptSubscriptions.id, ids));
    }
    return ids;
  }

  async insertChange(values: NewPtSubscriptionChange): Promise<void> {
    await (this.getDb() as any).insert(ptSubscriptionChanges).values(values);
  }

  async listChanges(subscriptionId: number): Promise<PtSubscriptionChange[]> {
    const db = this.getDb() as any;
    return (await db
      .select()
      .from(ptSubscriptionChanges)
      .where(eq(ptSubscriptionChanges.pt_subscription_id, subscriptionId))
      .orderBy(
        desc(ptSubscriptionChanges.created_at),
        desc(ptSubscriptionChanges.id),
      )) as PtSubscriptionChange[];
  }

  /** Open subscriptions with at least one change that has taken effect by `today`. */
  async listOpenWithEffectiveChanges(today: string): Promise<PtSubscription[]> {
    const db = this.getDb() as any;
    const due = (await db
      .selectDistinct({ id: ptSubscriptions.id })
      .from(ptSubscriptions)
      .innerJoin(
        ptSubscriptionChanges,
        eq(ptSubscriptionChanges.pt_subscription_id, ptSubscriptions.id),
      )
      .where(
        and(
          inArray(ptSubscriptions.status, [...OPEN_PT_STATUSES]),
          lte(ptSubscriptionChanges.effective_date, today),
        ),
      )) as { id: number }[];
    if (due.length === 0) return [];
    const rows = (await db
      .select()
      .from(ptSubscriptions)
      .where(
        inArray(
          ptSubscriptions.id,
          due.map((r) => r.id),
        ),
      )) as PtSubscription[];
    return rows.map(normalizeRow);
  }

  /** Generated, still-scheduled occurrences of a subscription starting at or after `from`. */
  async findFutureOccurrenceIds(subscriptionId: number, from: Date): Promise<number[]> {
    const db = this.getDb() as any;
    const rows = (await db
      .select({ id: schedules.id })
      .from(schedules)
      .where(
        and(
          eq(schedules.pt_subscription_id, subscriptionId),
          eq(schedules.status, 'scheduled'),
          gte(schedules.start_time, from),
        ),
      )) as { id: number }[];
    return rows.map((r) => r.id);
  }

  /** Member display names keyed by PT subscription id (for "occupied by" in the grid). */
  async memberNamesForSubscriptions(ids: number[]): Promise<Map<number, string>> {
    const out = new Map<number, string>();
    if (ids.length === 0) return out;
    const db = this.getDb() as any;
    const rows = (await db
      .select({
        id: ptSubscriptions.id,
        first_name: members.first_name,
        last_name: members.last_name,
      })
      .from(ptSubscriptions)
      .innerJoin(members, eq(members.id, ptSubscriptions.member_id))
      .where(inArray(ptSubscriptions.id, ids))) as {
      id: number;
      first_name: string;
      last_name: string;
    }[];
    for (const r of rows) out.set(r.id, `${r.first_name} ${r.last_name}`.trim());
    return out;
  }
}
