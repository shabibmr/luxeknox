# F-06 — Role/Permission repositories: remove raw SQL from `/me` and the cache

| | |
| :--- | :--- |
| **Status** | completed |
| **Severity** | high |
| **Depends** | F-05 |
| **Blocks** | F-08 |
| **Files** | 6 |

## Why

Same ADR-0004 breach as F-05, in the RBAC path:

- `permission-cache.ts:74-97` — a raw select on `roles`, then a raw `innerJoin` across `role_permissions` and `permissions`.
- `me.controller.ts:57-61` — a controller reaching straight into the database. ADR-0004 names controllers explicitly.

`me.controller.ts` is the worse of the two: a controller holding a `DrizzleDb` makes the boundary look optional to everyone who reads it next.

## Files

- `apps/api/src/rbac/role.repository.ts` (new)
- `apps/api/src/rbac/permission.repository.ts` (new)
- `apps/api/src/rbac/permission-cache.ts`
- `apps/api/src/rbac/rbac.module.ts`
- `apps/api/src/auth/me.controller.ts`
- `apps/api/src/auth/me.controller.spec.ts`

## Steps

1. Create `apps/api/src/rbac/role.repository.ts`:
   ```ts
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
   ```
2. Create `apps/api/src/rbac/permission.repository.ts`. It owns the join that currently lives in the cache, plus the full-catalog read F-08 will need:
   ```ts
   @Injectable()
   export class PermissionRepository extends BaseRepository<typeof permissions, Permission, typeof permissions.$inferInsert> {
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
   }
   ```
   Use `this.getDb()`, never `this.db`, so these queries join an ambient transaction like every other repository call (`base.repository.ts:31-37`).
3. Rewrite `PermissionCache` to depend on the two repositories instead of the database:
   - Constructor becomes `constructor(private readonly roleRepository: RoleRepository, private readonly permissionRepository: PermissionRepository) {}`.
   - In `loadPermissionsForRole` (lines 72-107): replace the raw role select with `await this.roleRepository.findById(roleId)` and the raw join with `await this.permissionRepository.findSlugsByRoleId(roleId)`, then `for (const slug of slugs) permSet.add(slug)`.
   - Delete the `DRIZZLE_DB_TOKEN`, `DrizzleDb`, `eq`, `permissions`, `rolePermissions` and `roles` imports left behind.
   - Leave the `roleSlugToId` bookkeeping and the `'*'` behaviour exactly as they are — F-08 changes that deliberately, this task must not.
4. In `rbac.module.ts`, add `RoleRepository` and `PermissionRepository` to `providers` and to `exports` (`MeController` lives in `AuthModule`, which already imports `RbacModule`).
5. In `me.controller.ts`: drop the `@Inject(DRIZZLE_DB_TOKEN) private readonly db` parameter, add `private readonly roleRepository: RoleRepository`, and replace lines 56-63 with:
   ```ts
   const role = await this.roleRepository.findById(currentUser.roleId);
   ```
   Remove the `eq`, `roles`, `DRIZZLE_DB_TOKEN` and `DrizzleDb` imports; keep `type Role` only if still referenced.
6. Update `me.controller.spec.ts`: replace the fake `db` with `{ findById: vi.fn().mockResolvedValue(roleFixture) }` as the `RoleRepository` double.

## Done when

- `rg "\.select\(\)\.from\(|innerJoin" apps/api/src/rbac apps/api/src/auth` matches only the two new repository files.
- No controller in `apps/api/src` injects `DRIZZLE_DB_TOKEN`: `rg "DRIZZLE_DB_TOKEN" apps/api/src --glob "*.controller.ts"` returns nothing.
- `pnpm --filter api test` and `test:e2e` pass unchanged — pure refactor.
