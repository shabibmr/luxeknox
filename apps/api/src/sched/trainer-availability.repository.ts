import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import {
  trainerAvailabilities,
  type NewTrainerAvailability,
  type TrainerAvailability,
} from '../platform/db/schema/scheduling';

@Injectable()
export class TrainerAvailabilityRepository extends BaseRepository<
  typeof trainerAvailabilities,
  TrainerAvailability,
  NewTrainerAvailability
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, trainerAvailabilities);
  }

  async findByTrainerId(trainerId: number): Promise<TrainerAvailability[]> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(trainerAvailabilities)
      .where(eq(trainerAvailabilities.trainer_id, trainerId));
    return rows as TrainerAvailability[];
  }

  async replaceForTrainer(
    trainerId: number,
    slots: NewTrainerAvailability[],
  ): Promise<TrainerAvailability[]> {
    const db = this.getDb() as any;
    await db.delete(trainerAvailabilities).where(eq(trainerAvailabilities.trainer_id, trainerId));
    if (slots.length > 0) {
      await db.insert(trainerAvailabilities).values(slots);
    }
    return this.findByTrainerId(trainerId);
  }
}
