# F-08 — Expand `super_admin` slugs on `GET /me`

| | |
| :--- | :--- |
| **Status** | todo |
| **Severity** | medium |
| **Depends** | F-06 |
| **Files** | 4 |

## Why

`permission-cache.ts:85-87` puts the literal string `'*'` into the permission set for `super_admin`, and `me.controller.ts:66-67` returns that set verbatim as `slugs`.

So a Super Admin's `GET /me` responds `slugs: ["*"]`. Any client doing the obvious thing — `slugs.includes('settings.read')` to decide whether to render a settings screen — gets `false` for the one account that can do everything. The Flutter shell in the next module is exactly that client.

The sentinel itself is fine as a guard fast-path (`permission.guard.ts:59`); leaking it over the wire is not. Keep the fast path, expand what is published.

## Files

- `apps/api/src/rbac/permission-cache.ts`
- `apps/api/src/auth/me.controller.ts`
- `apps/api/src/rbac/permission.guard.spec.ts`
- `apps/api/src/auth/me.controller.spec.ts`

## Steps

1. In `PermissionCache.loadPermissionsForRole`, when the role is `super_admin`, load the whole catalog alongside the sentinel (`permissionRepository.findAllSlugs()` comes from F-06):
   ```ts
   if (role) {
     this.roleSlugToId.set(role.slug, role.id);
     if (role.slug === 'super_admin') {
       permSet.add(WILDCARD_SLUG);
       for (const slug of await this.permissionRepository.findAllSlugs()) {
         permSet.add(slug);
       }
     }
   }
   ```
2. Name the sentinel at the top of the file so it stops being a bare string in four places:
   ```ts
   export const WILDCARD_SLUG = '*';
   ```
   Use it in `hasPermission`, `hasAllPermissions` and `permission.guard.ts:59`. Leave the legacy `'all'` check alone if it is still referenced; if `rg "'all'" apps/api/src` shows nothing seeds or grants it, delete that arm too.
3. Add the published-view accessor to `PermissionCache`:
   ```ts
   /** Permission slugs for a role as published to clients — never includes the wildcard sentinel. */
   async getResolvedSlugs(roleId: number): Promise<string[]> {
     const slugs = await this.getPermissionsForRole(roleId);
     return Array.from(slugs).filter((s) => s !== WILDCARD_SLUG).sort();
   }
   ```
4. In `me.controller.ts`, replace lines 66-67 with `const slugs = await this.permissionCache.getResolvedSlugs(currentUser.roleId);`.
5. Tests:
   - `me.controller.spec.ts`: a Super Admin response contains `settings.read` and does **not** contain `'*'`.
   - `permission.guard.spec.ts`: a `super_admin` role still passes `@RequirePermission('anything.not.seeded')` — the wildcard fast path must survive the change.
6. The permission catalog is seeded once and Module 0 has no role or permission CRUD, so the extra read happens on first cache miss per role only. No TTL or invalidation work here — that is explicitly out of Module 0.

## Done when

- `GET /v1/me` as the bootstrap Super Admin returns a `slugs` array containing every seeded slug and no `"*"`.
- `GET /v1/me` as a Member returns exactly that role's granted slugs, unchanged from today.
- A Super Admin still passes a `@RequirePermission` check for a slug that is not in `role_permissions`.
- `pnpm --filter api test` and `test:e2e` pass.
