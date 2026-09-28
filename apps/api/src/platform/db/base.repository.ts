import { Inject, Injectable } from '@nestjs/common';
import { eq, and, type SQL } from 'drizzle-orm';
import type { PgTable, TableConfig } from 'drizzle-orm/pg-core';
import { DRIZZLE_DB_TOKEN } from './drizzle.module';
import { getAmbientTransaction, type AnyTransaction } from './transaction-context';
import type { DrizzleDb } from './client';

/**
 * Abstract BaseRepository providing standard CRUD operations and ambient transaction
 * awareness for Drizzle PostgreSQL tables.
 *
 * Repositories extending BaseRepository automatically participate in any ambient
 * transaction managed by `runInTransaction()` without manual transaction passing.
 */
@Injectable()
export abstract class BaseRepository<
  TTable extends PgTable<TableConfig>,
  TSelect = TTable['$inferSelect'],
  TInsert = TTable['$inferInsert'],
> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    protected readonly db: DrizzleDb,
    protected readonly table: TTable,
  ) {}

  /**
   * Returns the ambient transaction if executing within a `runInTransaction` scope,
   * otherwise returns the root Drizzle database instance.
   */
  public getDb(): DrizzleDb | AnyTransaction {
    const ambientTx = getAmbientTransaction();
    if (ambientTx) {
      return ambientTx;
    }
    return this.db;
  }

  /**
   * Returns a condition filtering for active records if the underlying table has an
   * `is_active` or `status` column.
   *
   * Subclasses can override or extend this logic for specific domain rules.
   */
  protected getActiveCondition(): SQL | undefined {
    const tableColumns = this.table as Record<string, any>;
    if (tableColumns.is_active) {
      return eq(tableColumns.is_active, true);
    }
    if (tableColumns.isActive) {
      return eq(tableColumns.isActive, true);
    }
    if (tableColumns.status) {
      return eq(tableColumns.status, 'active');
    }
    return undefined;
  }

  /**
   * Finds a single entity by its primary key ID.
   *
   * @param id Primary key ID
   * @param activeOnly If true, filters by active status/is_active if applicable
   */
  async findById(id: number | bigint, activeOnly = false): Promise<TSelect | null> {
    const tableColumns = this.table as Record<string, any>;
    if (!tableColumns.id) {
      throw new Error(`Table ${this.table._.name} does not have an 'id' column`);
    }

    const conditions: SQL[] = [eq(tableColumns.id, id)];

    if (activeOnly) {
      const activeCond = this.getActiveCondition();
      if (activeCond) {
        conditions.push(activeCond);
      }
    }

    const query = this.getDb()
      .select()
      .from(this.table as any)
      .where(conditions.length === 1 ? conditions[0] : and(...conditions))
      .limit(1);

    const rows = await query;
    return (rows[0] as TSelect) ?? null;
  }

  /**
   * Finds a single entity matching the specified condition.
   *
   * @param condition SQL condition expression
   * @param activeOnly If true, also filters by active status/is_active if applicable
   */
  async findOne(condition: SQL, activeOnly = false): Promise<TSelect | null> {
    const conditions: SQL[] = [condition];

    if (activeOnly) {
      const activeCond = this.getActiveCondition();
      if (activeCond) {
        conditions.push(activeCond);
      }
    }

    const query = this.getDb()
      .select()
      .from(this.table as any)
      .where(conditions.length === 1 ? conditions[0] : and(...conditions))
      .limit(1);

    const rows = await query;
    return (rows[0] as TSelect) ?? null;
  }

  /**
   * Inserts a new record into the table, returning the generated id via RETURNING
   * (node-postgres has no `insertId` — that was mysql2-specific).
   *
   * @param values Record data to insert
   */
  async create(values: TInsert): Promise<{ id: number }[]> {
    const tableColumns = this.table as Record<string, any>;
    return (this.getDb() as any)
      .insert(this.table)
      .values(values)
      .returning({ id: tableColumns.id });
  }

  /**
   * Updates records matching the specified condition.
   *
   * @param condition SQL condition expression
   * @param values Record data to update
   */
  async update(condition: SQL, values: Partial<TInsert>): Promise<void> {
    await this.getDb().update(this.table as any).set(values as any).where(condition);
  }

  /**
   * Deletes records matching the specified condition.
   *
   * Note: For soft deletion, use `update` with `status: 'inactive'` or `is_active: false`.
   *
   * @param condition SQL condition expression
   */
  async delete(condition: SQL): Promise<void> {
    await this.getDb().delete(this.table as any).where(condition);
  }
}
