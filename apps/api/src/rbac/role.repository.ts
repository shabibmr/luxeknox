import { Inject, Injectable } from '@nestjs/common';
import { count, eq } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { roles, type Role } from '../platform/db/schema/roles';
import { rolePermissions } from '../platform/db/schema/role-permissions';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

export interface RolePageResult {
  rows: Role[];
  total: number;
}

@Injectable()
export class RoleRepository extends BaseRepository<typeof roles, Role, typeof roles.$inferInsert> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, roles);
  }

  async findBySlug(slug: string): Promise<Role | null> {
    return this.findOne(eq(roles.slug, slug));
  }

  async findManyPaged(limit: number, offset: number): Promise<RolePageResult> {
    const db = this.getDb();
    const [countResult] = await (db as any).select({ count: count() }).from(roles);
    const rows = await (db as any).select().from(roles).limit(limit).offset(offset);
    return { rows, total: countResult?.count ?? 0 };
  }

  /** Replaces the full permission set for a role in one delete+insert pass. */
  async replacePermissions(roleId: number, permissionIds: number[]): Promise<void> {
    const db = this.getDb();
    await (db as any).delete(rolePermissions).where(eq(rolePermissions.role_id, roleId));
    if (permissionIds.length > 0) {
      const now = new Date();
      await (db as any)
        .insert(rolePermissions)
        .values(permissionIds.map((permission_id) => ({ role_id: roleId, permission_id, created_at: now })));
    }
  }
}
