import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  ptProgressReviews,
  type NewPtProgressReview,
  type PtProgressReview,
} from '../platform/db/schema/personal-training';

@Injectable()
export class PtProgressReviewRepository extends BaseRepository<
  typeof ptProgressReviews,
  PtProgressReview,
  NewPtProgressReview
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, ptProgressReviews);
  }

  async insertReview(values: NewPtProgressReview): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateReview(id: number, values: Partial<NewPtProgressReview>): Promise<void> {
    const db = this.getDb() as any;
    await db.update(ptProgressReviews).set(values).where(eq(ptProgressReviews.id, id));
  }

  async findReviewById(id: number): Promise<PtProgressReview | null> {
    return this.findOne(eq(ptProgressReviews.id, id));
  }
}
