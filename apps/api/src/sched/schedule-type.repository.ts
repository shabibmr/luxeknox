import { Inject, Injectable } from '@nestjs/common';
import { count, eq } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import {
  scheduleTypes,
  type NewScheduleType,
  type ScheduleType,
} from '../platform/db/schema/scheduling';

@Injectable()
export class ScheduleTypeRepository extends BaseRepository<
  typeof scheduleTypes,
  ScheduleType,
  NewScheduleType
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, scheduleTypes);
  }

  async findMany(limit: number, offset: number): Promise<{ rows: ScheduleType[]; total: number }> {
    const db = this.getDb() as any;
    const [rows, countRows] = await Promise.all([
      db.select().from(scheduleTypes).limit(limit).offset(offset),
      db.select({ value: count() }).from(scheduleTypes),
    ]);
    return {
      rows: rows as ScheduleType[],
      total: Number(countRows[0]?.value ?? 0),
    };
  }

  async findByName(name: string): Promise<ScheduleType | null> {
    return this.findOne(eq(scheduleTypes.name, name));
  }

  async insertType(values: NewScheduleType): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateType(id: number, values: Partial<NewScheduleType>): Promise<void> {
    await this.update(eq(scheduleTypes.id, id), values);
  }
}
