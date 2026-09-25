import { Inject, Injectable } from '@nestjs/common';
import { desc, eq } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import {
  progressNotes,
  type NewProgressNote,
  type ProgressNote,
} from '../platform/db/schema/goals';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

@Injectable()
export class ProgressNoteRepository extends BaseRepository<
  typeof progressNotes,
  ProgressNote,
  NewProgressNote
> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, progressNotes);
  }

  async findManyByMemberId(
    memberId: number,
    options?: { limit?: number; offset?: number },
  ): Promise<{ rows: ProgressNote[]; total: number }> {
    const query = this.db
      .select()
      .from(progressNotes)
      .where(eq(progressNotes.member_id, memberId))
      .orderBy(desc(progressNotes.created_at));

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
}
