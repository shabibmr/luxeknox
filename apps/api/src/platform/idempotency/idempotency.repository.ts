import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gt } from 'drizzle-orm';
import type { DrizzleDb } from '../db/client';
import { DRIZZLE_DB_TOKEN } from '../db/drizzle.module';
import {
  idempotencyKeys,
  type IdempotencyKeyRow,
  type NewIdempotencyKeyRow,
} from '../db/schema/idempotency';
import { getAmbientTransaction } from '../db/transaction-context';

export interface IdempotencyLookup {
  idempotencyKey: string;
  method: string;
  path: string;
}

@Injectable()
export class IdempotencyRepository {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  private getDb() {
    return getAmbientTransaction() ?? this.db;
  }

  async findActive(lookup: IdempotencyLookup, now: Date): Promise<IdempotencyKeyRow | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(idempotencyKeys)
      .where(
        and(
          eq(idempotencyKeys.idempotency_key, lookup.idempotencyKey),
          eq(idempotencyKeys.method, lookup.method),
          eq(idempotencyKeys.path, lookup.path),
          gt(idempotencyKeys.expires_at, now),
        ),
      )
      .limit(1);
    return rows[0] ?? null;
  }

  async insert(row: NewIdempotencyKeyRow): Promise<void> {
    const db = this.getDb() as any;
    await db.insert(idempotencyKeys).values(row);
  }
}
