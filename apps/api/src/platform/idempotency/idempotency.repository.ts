import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gt, inArray } from 'drizzle-orm';
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

  async findActiveKeys(keys: string[], now: Date): Promise<Set<string>> {
    if (keys.length === 0) return new Set();
    const db = this.getDb() as any;
    const rows = await db
      .select({ idempotency_key: idempotencyKeys.idempotency_key })
      .from(idempotencyKeys)
      .where(
        and(
          inArray(idempotencyKeys.idempotency_key, keys),
          gt(idempotencyKeys.expires_at, now),
        ),
      );
    return new Set(rows.map((r: { idempotency_key: string }) => r.idempotency_key));
  }

  async recordJobKeys(
    entries: Array<{ key: string; path: string; expiresAt: Date }>,
  ): Promise<void> {
    if (entries.length === 0) return;
    const now = new Date();
    const db = this.getDb() as any;
    const values: NewIdempotencyKeyRow[] = entries.map((e) => ({
      idempotency_key: e.key,
      method: 'JOB',
      path: e.path,
      request_hash: e.key,
      response_status: 200,
      response_body: JSON.stringify({ processed: true }),
      created_at: now,
      expires_at: e.expiresAt,
    }));
    await db.insert(idempotencyKeys).values(values);
  }

  async insert(row: NewIdempotencyKeyRow): Promise<void> {
    const db = this.getDb() as any;
    await db.insert(idempotencyKeys).values(row);
  }
}
