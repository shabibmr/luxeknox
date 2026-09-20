import { Inject, Injectable } from '@nestjs/common';
import { BaseRepository } from '../platform/db/base.repository';
import { gymSettings, type GymSetting, type NewGymSetting } from '../platform/db/schema/gym-settings';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

@Injectable()
export class SettingsRepository extends BaseRepository<typeof gymSettings, GymSetting, NewGymSetting> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, gymSettings);
  }

  /**
   * Retrieves all gym settings records.
   */
  async findAll(): Promise<GymSetting[]> {
    return (this.getDb() as any).select().from(this.table);
  }
}
