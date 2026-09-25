import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, gte, lte, lt, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../db/drizzle.module';
import type { DrizzleDb } from '../db/client';
import { auditLogs, type AuditLog } from '../db/schema/audit-logs';

export interface AuditLogFilterParams {
  actorUserId?: number;
  entityName?: string;
  entityId?: number;
  action?: string;
  from?: string;
  to?: string;
  cursorId?: number;
  limit: number;
}

export interface AuditLogFilterResult {
  rows: AuditLog[];
  total: number;
}

@Injectable()
export class AuditLogRepository extends BaseRepository<typeof auditLogs, AuditLog, typeof auditLogs.$inferInsert> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, auditLogs);
  }

  private buildConditions(params: Omit<AuditLogFilterParams, 'limit'>): SQL | undefined {
    const conditions: SQL[] = [];

    if (params.actorUserId !== undefined) {
      conditions.push(eq(auditLogs.actor_user_id, params.actorUserId));
    }
    if (params.entityName) {
      conditions.push(eq(auditLogs.entity_name, params.entityName));
    }
    if (params.entityId !== undefined) {
      conditions.push(eq(auditLogs.entity_id, params.entityId));
    }
    if (params.action) {
      conditions.push(eq(auditLogs.action, params.action));
    }
    if (params.from) {
      conditions.push(gte(auditLogs.created_at, new Date(params.from)));
    }
    if (params.to) {
      conditions.push(lte(auditLogs.created_at, new Date(params.to)));
    }
    if (params.cursorId !== undefined) {
      conditions.push(lt(auditLogs.id, params.cursorId));
    }

    if (conditions.length === 0) {
      return undefined;
    }
    return conditions.length === 1 ? conditions[0] : and(...conditions);
  }

  /** Append-only audit trail, newest first, keyset-paginated on `id`. */
  async findManyFiltered(params: AuditLogFilterParams): Promise<AuditLogFilterResult> {
    const countWhere = this.buildConditions({ ...params, cursorId: undefined });
    const [countResult] = await (this.getDb() as any).select({ count: count() }).from(auditLogs).where(countWhere);

    const where = this.buildConditions(params);
    const rows = await (this.getDb() as any)
      .select()
      .from(auditLogs)
      .where(where)
      .orderBy(desc(auditLogs.id))
      .limit(params.limit + 1);

    return { rows, total: countResult?.count ?? 0 };
  }
}
