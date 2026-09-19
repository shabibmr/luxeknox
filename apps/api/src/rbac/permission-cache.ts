import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { roles, type Role } from '../platform/db/schema/roles';
import { permissions, type Permission } from '../platform/db/schema/permissions';
import { rolePermissions } from '../platform/db/schema/role-permissions';

/**
 * In-memory cache mapping roleId -> Set<string> of permission slugs.
 * Loaded from DB `role_permissions` JOIN `permissions`.
 *
 * Provides invalidation methods on role/permission updates.
 */
@Injectable()
export class PermissionCache {
  private readonly cache = new Map<number, Set<string>>();
  private readonly roleSlugToId = new Map<string, number>();

  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  /**
   * Retrieves permissions for a given roleId.
   * Loads from DB on cache miss.
   *
   * @param roleId Primary key of the role
   */
  async getPermissionsForRole(roleId: number): Promise<Set<string>> {
    const cached = this.cache.get(roleId);
    if (cached) {
      return cached;
    }

    return this.loadPermissionsForRole(roleId);
  }

  /**
   * Checks if a role has the specified permission slug.
   * Special case: '*' or 'all' grants all permissions.
   *
   * @param roleId Primary key of the role
   * @param slug Permission slug to check
   */
  async hasPermission(roleId: number, slug: string): Promise<boolean> {
    const permissions = await this.getPermissionsForRole(roleId);
    if (permissions.has('*') || permissions.has('all')) {
      return true;
    }
    return permissions.has(slug);
  }

  /**
   * Checks if a role has all of the specified permission slugs.
   *
   * @param roleId Primary key of the role
   * @param slugs Permission slugs required
   */
  async hasAllPermissions(roleId: number, slugs: string[]): Promise<boolean> {
    const rolePerms = await this.getPermissionsForRole(roleId);
    if (rolePerms.has('*') || rolePerms.has('all')) {
      return true;
    }
    return slugs.every((s) => rolePerms.has(s));
  }

  /**
   * Loads role permissions from DB and stores in cache.
   */
  private async loadPermissionsForRole(roleId: number): Promise<Set<string>> {
    // 1. Check if the role is super_admin
    const roleRows = await (this.db as any)
      .select()
      .from(roles)
      .where(eq(roles.id, roleId))
      .limit(1);

    const role: Role | undefined = roleRows[0];
    const permSet = new Set<string>();

    if (role) {
      this.roleSlugToId.set(role.slug, role.id);
      if (role.slug === 'super_admin') {
        permSet.add('*');
      }
    }

    // 2. Query permissions through role_permissions join
    const results = await (this.db as any)
      .select({
        slug: permissions.slug,
      })
      .from(rolePermissions)
      .innerJoin(permissions, eq(rolePermissions.permission_id, permissions.id))
      .where(eq(rolePermissions.role_id, roleId));

    for (const row of results) {
      if (row.slug) {
        permSet.add(row.slug);
      }
    }

    this.cache.set(roleId, permSet);
    return permSet;
  }

  /**
   * Invalidates cached permissions for a specific role.
   *
   * @param roleId Primary key of the role
   */
  invalidateRole(roleId: number): void {
    this.cache.delete(roleId);
  }

  /**
   * Invalidates cached permissions for a role by slug.
   *
   * @param roleSlug Slug of the role
   */
  invalidateRoleBySlug(roleSlug: string): void {
    const roleId = this.roleSlugToId.get(roleSlug);
    if (roleId !== undefined) {
      this.cache.delete(roleId);
    }
  }

  /**
   * Clears the entire permissions cache.
   * Used when permissions table or role-permission assignments undergo bulk mutation.
   */
  clear(): void {
    this.cache.clear();
    this.roleSlugToId.clear();
  }

  /**
   * Current number of cached roles.
   */
  get size(): number {
    return this.cache.size;
  }
}
