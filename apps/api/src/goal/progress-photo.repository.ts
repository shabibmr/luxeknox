import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, inArray, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import {
  progressPhotos,
  type NewProgressPhoto,
  type ProgressPhoto,
} from '../platform/db/schema/goals';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

export interface ProgressPhotoFilterOptions {
  pose?: string;
  includePrivate?: boolean;
  limit?: number;
  offset?: number;
}

@Injectable()
export class ProgressPhotoRepository extends BaseRepository<
  typeof progressPhotos,
  ProgressPhoto,
  NewProgressPhoto
> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, progressPhotos);
  }

  async findManyByMemberId(
    memberId: number,
    options?: ProgressPhotoFilterOptions,
  ): Promise<{ rows: ProgressPhoto[]; total: number }> {
    const conditions: SQL[] = [eq(progressPhotos.member_id, memberId)];

    if (options?.pose) {
      conditions.push(eq(progressPhotos.pose, options.pose));
    }
    if (options?.includePrivate === false) {
      conditions.push(eq(progressPhotos.is_private, false));
    }

    const where = and(...conditions);

    const query = this.db
      .select()
      .from(progressPhotos)
      .where(where)
      .orderBy(desc(progressPhotos.taken_date), desc(progressPhotos.created_at));

    if (options?.limit) {
      query.limit(options.limit);
    }
    if (options?.offset) {
      query.offset(options.offset);
    }

    const rows = await query;
    return {
      rows,
      total: rows.length,
    };
  }

  async findComparisonByDates(
    memberId: number,
    date1: string,
    date2: string,
    includePrivate: boolean,
  ): Promise<ProgressPhoto[]> {
    const conditions: SQL[] = [
      eq(progressPhotos.member_id, memberId),
      inArray(progressPhotos.taken_date, [date1, date2]),
    ];

    if (!includePrivate) {
      conditions.push(eq(progressPhotos.is_private, false));
    }

    return this.db
      .select()
      .from(progressPhotos)
      .where(and(...conditions))
      .orderBy(desc(progressPhotos.taken_date));
  }

  async deleteById(id: number): Promise<void> {
    await this.delete(eq(progressPhotos.id, id));
  }
}
