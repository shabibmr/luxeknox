import { Inject, Injectable } from '@nestjs/common';
import { eq, or } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { users, type User, type NewUser } from '../platform/db/schema/users';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

@Injectable()
export class UserRepository extends BaseRepository<typeof users, User, NewUser> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, users);
  }

  /** Finds a user by email or phone number. */
  async findByIdentifier(identifier: string): Promise<User | null> {
    const trimmed = identifier.trim();
    const normalizedEmail = trimmed.toLowerCase();
    return this.findOne(or(eq(users.email, normalizedEmail), eq(users.phone_number, trimmed))!);
  }
}
