import { Injectable } from '@nestjs/common';
import { RoleRepository } from './role.repository';
import { PermissionRepository } from './permission.repository';

/** Sentinel used as the guard fast-path for super_admin; never published to clients. */
export const WILDCARD_SLUG = '*';

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
    private readonly roleRepository: RoleRepository,
    private readonly permissionRepository: PermissionRepository,
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

  /** Permission slugs for a role as published to clients — never includes the wildcard sentinel. */
  async getResolvedSlugs(roleId: number): Promise<string[]> {
    const slugs = await this.getPermissionsForRole(roleId);
    return Array.from(slugs)
      .filter((s) => s !== WILDCARD_SLUG)
      .sort();
  }

  /**
   * Checks if a role has the specified permission slug.
   * Special case: WILDCARD_SLUG grants all permissions.
   */
  async hasPermission(roleId: number, slug: string): Promise<boolean> {
    const permissions = await this.getPermissionsForRole(roleId);
    if (permissions.has(WILDCARD_SLUG)) {
      return true;
    }
    return permissions.has(slug);
  }

  /**
   * Loads role permissions from DB and stores in cache.
   */
  private async loadPermissionsForRole(roleId: number): Promise<Set<string>> {
    const role = await this.roleRepository.findById(roleId);
    const permSet = new Set<string>();

    if (role) {
      this.roleSlugToId.set(role.slug, role.id);
      if (role.slug === 'super_admin') {
        permSet.add(WILDCARD_SLUG);
        for (const slug of await this.permissionRepository.findAllSlugs()) {
          permSet.add(slug);
        }
      }
    }

    const slugs = await this.permissionRepository.findSlugsByRoleId(roleId);
    for (const slug of slugs) {
      permSet.add(slug);
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
