import { Inject, Injectable } from '@nestjs/common';
import { count, eq } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { facilities, type Facility, type NewFacility } from '../platform/db/schema/scheduling';

@Injectable()
export class FacilityRepository extends BaseRepository<typeof facilities, Facility, NewFacility> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, facilities);
  }

  async findMany(limit: number, offset: number): Promise<{ rows: Facility[]; total: number }> {
    const db = this.getDb() as any;
    const [rows, countRows] = await Promise.all([
      db.select().from(facilities).limit(limit).offset(offset),
      db.select({ value: count() }).from(facilities),
    ]);
    return {
      rows: rows as Facility[],
      total: Number(countRows[0]?.value ?? 0),
    };
  }

  async findByName(name: string): Promise<Facility | null> {
    return this.findOne(eq(facilities.name, name));
  }

  async insertFacility(values: NewFacility): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateFacility(id: number, values: Partial<NewFacility>): Promise<void> {
    await this.update(eq(facilities.id, id), values);
  }
}
