import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { roles, type Role } from '../platform/db/schema/roles';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

@Injectable()
export class RoleRepository extends BaseRepository<typeof roles, Role, typeof roles.$inferInsert> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, roles);
  }

  async findBySlug(slug: string): Promise<Role | null> {
    return this.findOne(eq(roles.slug, slug));
  }
}
