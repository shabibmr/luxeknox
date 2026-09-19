import { describe, it, expect, vi, beforeEach } from 'vitest';
import { AuditService } from './audit.service';
import { auditLogs } from '../db/schema/audit-logs';
import { runInTransaction } from '../db/transaction-context';
import type { DrizzleDb } from '../db/client';

describe('AuditService', () => {
  let mockDb: any;
  let auditService: AuditService;

  beforeEach(() => {
    mockDb = {
      insert: vi.fn().mockReturnThis(),
      values: vi.fn().mockResolvedValue([]),
    };
    auditService = new AuditService(mockDb as DrizzleDb<any>);
  });

  it('records an audit entry via root db when not in a transaction', async () => {
    const entry = {
      actorUserId: 1,
      action: 'UPDATE_ROLE',
      entityName: 'users',
      entityId: 10,
      beforeState: { role: 'member' },
      afterState: { role: 'admin' },
      ipAddress: '127.0.0.1',
    };

    await auditService.recordAudit(entry);

    expect(mockDb.insert).toHaveBeenCalledWith(auditLogs);
    expect(mockDb.values).toHaveBeenCalledWith(
      expect.objectContaining({
        actor_user_id: 1,
        action: 'UPDATE_ROLE',
        entity_name: 'users',
        entity_id: 10,
        before_state: { role: 'member' },
        after_state: { role: 'admin' },
        ip_address: '127.0.0.1',
        created_at: expect.any(Date),
      }),
    );
  });

  it('records an audit entry via ambient transaction when in runInTransaction', async () => {
    const mockTx = {
      insert: vi.fn().mockReturnThis(),
      values: vi.fn().mockResolvedValue([]),
    };

    mockDb.transaction = vi.fn().mockImplementation(async (callback: (tx: any) => Promise<any>) => {
      return callback(mockTx);
    });

    await runInTransaction(mockDb, async () => {
      await auditService.recordAudit({
        actorUserId: 2,
        action: 'DELETE_PLAN',
        entityName: 'plans',
        entityId: 5,
      });
    });

    // Verify insert happened on the mockTx, not mockDb
    expect(mockTx.insert).toHaveBeenCalledWith(auditLogs);
    expect(mockTx.values).toHaveBeenCalledWith(
      expect.objectContaining({
        actor_user_id: 2,
        action: 'DELETE_PLAN',
        entity_name: 'plans',
        entity_id: 5,
        before_state: null,
        after_state: null,
        ip_address: null,
      }),
    );
    expect(mockDb.insert).not.toHaveBeenCalled();
  });
});
