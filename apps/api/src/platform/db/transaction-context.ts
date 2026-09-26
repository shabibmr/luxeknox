import { AsyncLocalStorage } from 'node:async_hooks';
import type { ExtractTablesWithRelations } from 'drizzle-orm';
import type { MySqlTransaction } from 'drizzle-orm/mysql-core';
import type { AppSchema, DrizzleDb } from './client';

/**
 * Type alias for any active Drizzle MySQL transaction.
 */
export type AnyTransaction = MySqlTransaction<any, any, AppSchema, ExtractTablesWithRelations<AppSchema>>;

/**
 * Node.js AsyncLocalStorage store holding the active ambient transaction if within a `runInTransaction` scope,
 * or null otherwise.
 */
export const transactionStorage = new AsyncLocalStorage<AnyTransaction | null>();

/**
 * Returns the ambient transaction instance if execution is currently inside an active
 * `runInTransaction` scope, or null / undefined if none is active.
 */
export function getAmbientTransaction(): AnyTransaction | null {
  return transactionStorage.getStore() ?? null;
}

/**
 * Executes a callback within a transactional context.
 *
 * If an ambient transaction is already active in the current AsyncLocalStorage context,
 * `workFn` joins the existing ambient transaction without opening a nested transaction.
 *
 * If no ambient transaction exists, a new transaction is started via `db.transaction(...)`.
 * The active transaction instance is bound to the AsyncLocalStorage store for the duration
 * of `workFn`.
 *
 * Automatic commit occurs when `workFn` resolves successfully; automatic rollback occurs
 * if `workFn` throws an error or rejects.
 *
 * @param db Root Drizzle database instance
 * @param workFn Asynchronous callback receiving the transaction
 */
export async function runInTransaction<T>(
  db: DrizzleDb,
  workFn: (tx: AnyTransaction) => Promise<T>,
): Promise<T> {
  const currentTx = getAmbientTransaction();
  if (currentTx) {
    // Already in transaction, join ambient transaction
    return workFn(currentTx);
  }

  return db.transaction(async (tx) => {
    return transactionStorage.run(tx as unknown as AnyTransaction, async () => {
      return workFn(tx as unknown as AnyTransaction);
    });
  });
}
