import { describe, it, expect, vi } from 'vitest';
import { runInTransaction, getAmbientTransaction, transactionStorage } from './transaction-context';
import { BaseRepository } from './base.repository';
import { users, type User, type NewUser } from './schema/users';
import { roles, type Role, type NewRole } from './schema/roles';
import type { DrizzleDb } from './client';

// Concrete repository implementations for testing BaseRepository and ambient transaction enlisting
class UserRepository extends BaseRepository<typeof users, User, NewUser> {
  constructor(db: DrizzleDb<any>) {
    super(db, users);
  }
}

class RoleRepository extends BaseRepository<typeof roles, Role, NewRole> {
  constructor(db: DrizzleDb<any>) {
    super(db, roles);
  }
}

describe('TransactionContext and BaseRepository', () => {
  it('returns null when outside of a transaction context', () => {
    expect(getAmbientTransaction()).toBeNull();
  });

  it('asserts two repository operations executed inside runInTransaction share the exact same transaction instance', async () => {
    const mockTx = {
      select: vi.fn().mockReturnThis(),
      from: vi.fn().mockReturnThis(),
      where: vi.fn().mockReturnThis(),
      limit: vi.fn().mockResolvedValue([]),
      insert: vi.fn().mockReturnThis(),
      values: vi.fn().mockResolvedValue([]),
      update: vi.fn().mockReturnThis(),
      set: vi.fn().mockReturnThis(),
      delete: vi.fn().mockReturnThis(),
      _isMockTx: true,
      id: 'tx_mock_12345',
    } as any;

    const mockDb = {
      select: vi.fn(),
      insert: vi.fn(),
      transaction: vi.fn().mockImplementation(async (callback: (tx: any) => Promise<any>) => {
        return callback(mockTx);
      }),
    } as unknown as DrizzleDb<any>;

    const userRepo = new UserRepository(mockDb);
    const roleRepo = new RoleRepository(mockDb);

    // Before transaction, repositories return the root db
    expect(userRepo.getDb()).toBe(mockDb);
    expect(roleRepo.getDb()).toBe(mockDb);

    let capturedUserTx: any;
    let capturedRoleTx: any;
    let capturedAmbientTx: any;

    const result = await runInTransaction(mockDb, async (tx) => {
      capturedAmbientTx = getAmbientTransaction();

      // Inside runInTransaction, repositories' getDb() should resolve to the ambient transaction
      capturedUserTx = userRepo.getDb();
      capturedRoleTx = roleRepo.getDb();

      // Exercise repository operations inside the transaction
      await userRepo.findById(1);
      await roleRepo.findById(1);

      return 'success';
    });

    expect(result).toBe('success');

    // Both repos and ambient context shared the exact same transaction instance
    expect(capturedAmbientTx).toBe(mockTx);
    expect(capturedUserTx).toBe(mockTx);
    expect(capturedRoleTx).toBe(mockTx);
    expect(capturedUserTx).toBe(capturedRoleTx);

    // Verify calls were dispatched to the transaction, not the root db
    expect(mockTx.select).toHaveBeenCalledTimes(2);
    expect(mockDb.select).not.toHaveBeenCalled();

    // After transaction completes, transactionStorage context clears
    expect(getAmbientTransaction()).toBeNull();
    expect(userRepo.getDb()).toBe(mockDb);
    expect(roleRepo.getDb()).toBe(mockDb);
  });

  it('joins existing ambient transaction when nested runInTransaction is called', async () => {
    const mockTx = {
      _isMockTx: true,
      id: 'tx_parent',
    } as any;

    let transactionCalls = 0;
    const mockDb = {
      transaction: vi.fn().mockImplementation(async (callback: (tx: any) => Promise<any>) => {
        transactionCalls++;
        return callback(mockTx);
      }),
    } as unknown as DrizzleDb<any>;

    const userRepo = new UserRepository(mockDb);

    await runInTransaction(mockDb, async (parentTx) => {
      expect(userRepo.getDb()).toBe(mockTx);
      expect(parentTx).toBe(mockTx);

      // Call nested runInTransaction
      await runInTransaction(mockDb, async (childTx) => {
        expect(childTx).toBe(mockTx);
        expect(userRepo.getDb()).toBe(mockTx);
      });
    });

    // Outer transaction called once; nested call re-used the ambient transaction without calling db.transaction again
    expect(transactionCalls).toBe(1);
    expect(getAmbientTransaction()).toBeNull();
  });

  it('rolls back and propagates errors when workFn throws', async () => {
    const mockTx = { _isMockTx: true } as any;
    const mockDb = {
      transaction: vi.fn().mockImplementation(async (callback: (tx: any) => Promise<any>) => {
        return callback(mockTx);
      }),
    } as unknown as DrizzleDb<any>;

    const customError = new Error('Database mutation failed');

    await expect(
      runInTransaction(mockDb, async () => {
        expect(getAmbientTransaction()).toBe(mockTx);
        throw customError;
      }),
    ).rejects.toThrow(customError);

    expect(getAmbientTransaction()).toBeNull();
  });

  it('filters active records when activeOnly is specified', async () => {
    const mockTx = {
      select: vi.fn().mockReturnThis(),
      from: vi.fn().mockReturnThis(),
      where: vi.fn().mockReturnThis(),
      limit: vi.fn().mockResolvedValue([{ id: 1, status: 'active' }]),
    } as any;

    const mockDb = {
      transaction: vi.fn().mockImplementation(async (cb) => cb(mockTx)),
    } as unknown as DrizzleDb<any>;

    const userRepo = new UserRepository(mockDb);

    await runInTransaction(mockDb, async () => {
      const user = await userRepo.findById(1, true);
      expect(user).toEqual({ id: 1, status: 'active' });
      expect(mockTx.where).toHaveBeenCalled();
    });
  });
});
