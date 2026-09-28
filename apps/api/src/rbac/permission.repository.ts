import { Inject, Injectable } from '@nestjs/common';
import { count, eq, inArray } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { permissions, type Permission, type NewPermission } from '../platform/db/schema/permissions';
import { rolePermissions } from '../platform/db/schema/role-permissions';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

@Injectable()
export class PermissionRepository extends BaseRepository<
  typeof permissions,
  Permission,
  NewPermission
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, permissions);
  }

  /** Permission slugs granted to a role via role_permissions. */
  async findSlugsByRoleId(roleId: number): Promise<string[]> {
    const rows = await (this.getDb() as any)
      .select({ slug: permissions.slug })
      .from(rolePermissions)
      .innerJoin(permissions, eq(rolePermissions.permission_id, permissions.id))
      .where(eq(rolePermissions.role_id, roleId));
    return rows.map((r: { slug: string }) => r.slug).filter(Boolean);
  }

  /** Every permission slug in the catalog. */
  async findAllSlugs(): Promise<string[]> {
    const rows = await (this.getDb() as any).select({ slug: permissions.slug }).from(permissions);
    return rows.map((r: { slug: string }) => r.slug).filter(Boolean);
  }

  /** Full permission rows granted to a role via role_permissions. */
  async findManyByRoleId(roleId: number): Promise<Permission[]> {
    const rows = await (this.getDb() as any)
      .select({ permission: permissions })
      .from(rolePermissions)
      .innerJoin(permissions, eq(rolePermissions.permission_id, permissions.id))
      .where(eq(rolePermissions.role_id, roleId));
    return rows.map((r: { permission: Permission }) => r.permission);
  }

  /** Permission rows matching the given ids (used to validate a permission_ids write payload). */
  async findManyByIds(ids: number[]): Promise<Permission[]> {
    if (ids.length === 0) {
      return [];
    }
    return (this.getDb() as any).select().from(permissions).where(inArray(permissions.id, ids));
  }

  async findManyPaged(limit: number, offset: number): Promise<{ rows: Permission[]; total: number }> {
    const db = this.getDb();
    const [countResult] = await (db as any).select({ count: count() }).from(permissions);
    const rows = await (db as any).select().from(permissions).limit(limit).offset(offset);
    return { rows, total: countResult?.count ?? 0 };
  }
}
