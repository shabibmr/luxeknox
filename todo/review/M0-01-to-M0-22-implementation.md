# Caveman review — M0-01 … M0-22 implementation

**Scope:** `apps/api` code covering Module 0 tasks through M0-22 (auth guard / RBAC).  
**Style:** one finding per line — location, problem, fix.  
**Date:** 2026-09-16

**Verdict:** Auth spine is not production-safe yet. Session cache `id: 0`, missing global guards, and access-token TTL not enforced are ship blockers.

---

## Security (read these)

**Access TTL vs `expires_at`.** ADR-0003: access = 30 min, refresh = 30 days. Schema has one `expires_at`, and login sets it to `now + 30d`. `AuthGuard` only checks that field, so a stolen `gk_at_*` works for ~30 days while clients trust `expiresIn: 1800`. Fix: store/check `access_expires_at` (or equivalent) at 30 min; keep session/refresh expiry at 30 days.

**Guards never bind.** `AuthGuard` / `PermissionGuard` are not `APP_GUARD`. Until then every non-self-checking route is public, including future `/me` and `/settings`.

**Cached `session.id = 0`.** After login, cache stores `id: 0`. Refresh/logout within the 60s TTL call `revokeSession(0)` (no-op). Old DB row stays live → refresh rotation and reuse detection fail.

---

## Auth / sessions / RBAC

`auth.service.ts:L175`: 🔴 bug: cache writes `id: 0` after insert. Return `insertId` from `createSession` and cache the real id.

`auth.service.ts:L156-166`: 🔴 bug: `expires_at` = refresh TTL only; access never expires at 30m. Add `access_expires_at` (or dual check) and enforce in `AuthGuard` + `findActiveByAccessTokenHash`.

`auth.service.ts:L81-92`: 🔴 bug: refresh prefers cache; with `id: 0` revoke is a no-op and old refresh stays valid. Fix id first; also revoke-by-hash as belt-and-suspenders.

`session.repository.ts:L56-58`: 🔴 bug: `createSession` returns `void`. Return inserted `Session` / `insertId`.

`auth.module.ts:L10-27`: 🔴 bug: no `APP_GUARD` for `AuthGuard`. Register `{ provide: APP_GUARD, useClass: AuthGuard }`.

`app.module.ts:L8-12`: 🔴 bug: no `RbacModule` / `PermissionGuard` / `PermissionCache`. Wire module + second `APP_GUARD`.

`permission.guard.ts:L44-47`: 🟡 risk: missing `@RequirePermission` ⇒ allow any authenticated user. OK only if every sensitive route is annotated; document or default-deny.

`auth.guard.ts:L41-54`: 🟡 risk: dual `/v1/...` and bare paths paper over prefix confusion. Pick one path shape matching Nest `request.path` after `setGlobalPrefix`.

`auth.service.ts:L59-62`: 🟡 risk: inactive users get `"Account is not active"` vs `"Invalid credentials"` — account-state oracle. Use same message as bad password.

`auth.service.ts:L202-207`: 🟡 risk: email/phone lookup is case-sensitive; throttle lowercases. Normalize email with `.toLowerCase()` before query.

`login-throttle.ts:L64-70`: 🟡 risk: success clears IP bucket — one good login resets shared-IP lockout. Clear identifier only.

`auth.controller.ts:L41-48`: 🟡 risk: trusts first `x-forwarded-for` hop with no proxy trust config. Gate on `app.set('trust proxy')` or ignore header unless configured.

`auth.controller.ts:L87-97`: 🔵 nit: logout re-parses Bearer instead of `@CurrentUser` / guard. Fine until guard is global; then reuse principal.

`password.ts:L20-22`: 🟡 risk: `argon2.verify` throws on malformed hash → 500. Catch and return false / 401.

`current-user.decorator.ts:L14-16`: 🟡 risk: returns `undefined` when unauthenticated. Prefer throw `UnauthorizedError` so handlers do not silently see empty user.

---

## HTTP / validation / bootstrap

`main.ts:L57`: 🔴 bug: `new ZodValidationPipe()` has no schema — `loginSchema` / `refreshTokenSchema` never run. Pipe per-route with schema, or schema registry by DTO metadata.

`main.ts:L55-75`: ❓ q: `setGlobalPrefix('v1')` + `SwaggerModule.setup('v1/docs', ...)` — confirm final URL is `/v1/docs` not `/v1/v1/docs`.

`main.ts:L53`: 🔵 nit: `enableCors()` wide open. Restrict origins before any non-local deploy.

---

## Platform DB / health / settings

`health.module.ts:L8-14`: 🟡 risk: second pool via local `DRIZZLE_DB` provider; never `pool.end()`. Inject global `DRIZZLE_DB_TOKEN` from `DrizzleModule`; delete local factory.

`health.controller.ts:L26`: 🔵 nit: redeclares `DRIZZLE_DB_TOKEN` — import from `drizzle.module.ts`.

`client.ts:L33-35`: 🟡 risk: hardcoded fallbacks `user2grey` / `user2grey` disagree with compose `luxeknox`. Fail fast if env missing; no silent wrong defaults.

`client.ts:L19-27`: 🟡 risk: `DATABASE_URL` path sets `timezone` but not session `transaction_isolation`. Align with compose `READ-COMMITTED` via `init` or URL params.

`seed/admin.ts:L17-18`: 🟡 risk: default bootstrap password in source. Require env in non-dev; refuse seed if unset.

`seed/admin.ts:L46-54`: 🟡 risk: re-seed resets admin password via `onDuplicateKeyUpdate`. Skip password update when user exists, or gate behind flag.

`pagination.ts:L97-100`: 🔴 bug: `SettingsService` `@Optional` and `PlatformModule` does not import `SysModule` — defaults never read `gym_settings`. Import `SysModule` (or forwardRef) so `PaginationHelper` gets real page size.

`settings.service.ts:L53-59`: 🟡 risk: `getSetting` bypasses full cache warm; mixed cache/DB views after partial reads. Always `refreshCache()` on first miss or only serve from cache.

`0002_grants.sql:L24`: 🟡 risk: `REVOKE` only if mysql.user=`luxeknox`; no explicit `GRANT INSERT, SELECT`. Verify app user can insert audit rows and cannot update/delete.

`migrate.ts:L125-137`: 🟡 risk: collation fallback mutates SQL mid-flight; drift vs ADR `utf8mb4_0900_ai_ci`. Fail on wrong MySQL version instead.

`base.repository.ts:L121-123`: 🟡 risk: `create` discards `insertId` — forces every caller into the session `id: 0` footgun. Return insert result.

---

## Money / misc

`money.ts:L15`: 🟡 risk: `number.toString()` before round (IEEE-754). Accept `string` only in public API, or decimal lib.

`money.ts:L1-2`: 🔵 nit: idempotency header types live in `money.ts`. Move to `idempotency.ts`.

`permission-cache.ts:L85-87`: ❓ q: `super_admin` gets `*` in code — confirm seed does not also rely on explicit slug grants alone.

`auth.service.spec.ts` / cache path: 🟡 risk: refresh tests mock repo id `99` and skip cache-hit-with-id-0. Add test: login → cached refresh → `revokeSession` called with real id.

---

## Fix order

1. Return real session id from create + cache it
2. Enforce access TTL
3. Register both guards as `APP_GUARD`
4. Wire Zod schemas on auth bodies
5. Connect `PaginationHelper` ↔ `SettingsService`
