import { Inject, Injectable } from '@nestjs/common';
import { and, asc, count, eq, inArray, like, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  accounts,
  type Account,
  type NewAccount,
} from '../platform/db/schema/accounting';

@Injectable()
export class AccountsRepository extends BaseRepository<
  typeof accounts,
  Account,
  NewAccount
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, accounts);
  }

  async findByName(name: string): Promise<Account | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(accounts)
      .where(eq(accounts.name, name))
      .limit(1);
    return rows[0] ?? null;
  }

  async findByControlRole(role: string): Promise<Account | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(accounts)
      .where(eq(accounts.control_role, role))
      .limit(1);
    return rows[0] ?? null;
  }

  async findByIds(ids: number[]): Promise<Account[]> {
    if (ids.length === 0) return [];
    const db = this.getDb() as any;
    return db
      .select()
      .from(accounts)
      .where(inArray(accounts.id, ids));
  }

  async insertAccount(row: NewAccount): Promise<Account> {
    const db = this.getDb() as any;
    const result = await db.insert(accounts).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const created = await this.findById(id);
    if (!created) {
      throw new Error(`Failed to load account ${id}`);
    }
    return created;
  }

  async updateAccount(id: number, values: Partial<NewAccount>): Promise<Account> {
    const db = this.getDb() as any;
    await db.update(accounts).set(values).where(eq(accounts.id, id));
    const updated = await this.findById(id);
    if (!updated) {
      throw new Error(`Failed to load account ${id}`);
    }
    return updated;
  }

  async findMany(params: {
    accountType?: string;
    isActive?: boolean;
    search?: string;
    limit: number;
    offset: number;
  }): Promise<{ rows: Account[]; total: number }> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [];

    if (params.accountType) {
      conditions.push(eq(accounts.account_type, params.accountType));
    }
    if (params.isActive !== undefined) {
      conditions.push(eq(accounts.is_active, params.isActive));
    }
    if (params.search) {
      const pattern = `%${params.search}%`;
      conditions.push(like(accounts.name, pattern));
    }

    const where = conditions.length ? and(...conditions) : undefined;

    let listQ = db.select().from(accounts);
    let countQ = db.select({ value: count() }).from(accounts);
    if (where) {
      listQ = listQ.where(where);
      countQ = countQ.where(where);
    }

    const rows = await listQ
      .orderBy(asc(accounts.name), asc(accounts.id))
      .limit(params.limit)
      .offset(params.offset);
    const totalRows = await countQ;

    return { rows, total: Number(totalRows[0]?.value ?? 0) };
  }
}
