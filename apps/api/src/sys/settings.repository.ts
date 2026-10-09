import { Inject, Injectable } from '@nestjs/common';
import { sql } from 'drizzle-orm';
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

  /**
   * Upserts a batch atomically. If any write fails, the transaction rolls back
   * all preceding writes so callers never observe a partially applied settings
   * form. The caller refreshes its cache only after this promise succeeds.
   */
  async upsertMany(items: Array<{ setting_key: string; setting_value: string }>): Promise<GymSetting[]> {
    const db = this.getDb() as any;
    const now = new Date();

    await db.transaction(async (tx: any) => {
      for (const item of items) {
        await tx
          .insert(gymSettings)
          .values({
            setting_key: item.setting_key,
            setting_value: item.setting_value,
            created_at: now,
            updated_at: now,
          })
          .onDuplicateKeyUpdate({
            set: {
              setting_value: sql`VALUES(\`setting_value\`)`,
              updated_at: now,
            },
          });
      }
    });

    return this.findAll();
  }
}
