import { Inject, Injectable } from '@nestjs/common';
import { and, count, eq } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import {
  emergencyContacts,
  type EmergencyContact,
  type NewEmergencyContact,
} from '../platform/db/schema/members';

@Injectable()
export class EmergencyContactRepository extends BaseRepository<
  typeof emergencyContacts,
  EmergencyContact,
  NewEmergencyContact
> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, emergencyContacts);
  }

  async findByUserId(
    userId: number,
    limit: number,
    offset: number,
  ): Promise<{ rows: EmergencyContact[]; total: number }> {
    const db = this.getDb() as any;
    const where = eq(emergencyContacts.user_id, userId);

    const [rows, countRows] = await Promise.all([
      db.select().from(emergencyContacts).where(where).limit(limit).offset(offset),
      db.select({ value: count() }).from(emergencyContacts).where(where),
    ]);

    return {
      rows: rows as EmergencyContact[],
      total: Number(countRows[0]?.value ?? 0),
    };
  }

  async findByIdForUser(contactId: number, userId: number): Promise<EmergencyContact | null> {
    return this.findOne(
      and(eq(emergencyContacts.id, contactId), eq(emergencyContacts.user_id, userId))!,
    );
  }

  async insertContact(values: NewEmergencyContact): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async updateContact(id: number, values: Partial<NewEmergencyContact>): Promise<void> {
    await this.update(eq(emergencyContacts.id, id), values);
  }

  async deleteContact(id: number): Promise<void> {
    await this.delete(eq(emergencyContacts.id, id));
  }

  /** Clears is_primary on all contacts for the user (call inside TX before setting a new primary). */
  async clearPrimaryForUser(userId: number): Promise<void> {
    await this.update(eq(emergencyContacts.user_id, userId), {
      is_primary: false,
      updated_at: new Date(),
    });
  }
}
