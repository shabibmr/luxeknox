import { Inject, Injectable } from '@nestjs/common';
import { DRIZZLE_DB_TOKEN } from '../db/drizzle.module';
import { getAmbientTransaction } from '../db/transaction-context';
import type { DrizzleDb } from '../db/client';
import { auditLogs } from '../db/schema/audit-logs';

export interface RecordAuditEntry {
  actorUserId?: number | null;
  action: string;
  entityName: string;
  entityId?: number | null;
  beforeState?: unknown;
  afterState?: unknown;
  ipAddress?: string | null;
}

/**
 * Audit service providing append-only recording to `audit_logs`.
 *
 * Automatically participates in any ambient transaction (from `runInTransaction`),
 * or uses the root database connection.
 * Modifications and deletions are strictly disallowed.
 */
@Injectable()
export class AuditService {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  /**
   * Appends an audit log entry to `audit_logs`.
   * Never updates or deletes any audit record.
   */
  async recordAudit(entry: RecordAuditEntry): Promise<void> {
    const executor = getAmbientTransaction() ?? this.db;

    await (executor as any).insert(auditLogs).values({
      actor_user_id: entry.actorUserId ?? null,
      action: entry.action,
      entity_name: entry.entityName,
      entity_id: entry.entityId ?? null,
      before_state: entry.beforeState !== undefined ? entry.beforeState : null,
      after_state: entry.afterState !== undefined ? entry.afterState : null,
      ip_address: entry.ipAddress ?? null,
      created_at: new Date(),
    });
  }
}
