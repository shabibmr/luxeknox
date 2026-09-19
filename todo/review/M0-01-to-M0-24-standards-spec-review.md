# Two-axis review — M0-01 … M0-24 implementation

**Scope:** `apps/api/src` + `apps/api/test`, full current tree (code is untracked — no git commit exists to diff against, so this reviews the whole implementation, not a delta).
**Axes:** Standards (does the code follow this repo's documented conventions + Fowler smell baseline) and Spec (does the code do what each `todo/M0-*.md` task asked). Run as separate parallel sub-agent passes per the two-axis process; not merged or reranked against each other.
**Date:** 2026-09-16
**Relation to prior review:** `todo/review/M0-01-to-M0-22-implementation.md` is an earlier bug-hunting pass through M0-22. This review is independent, covers M0-01–M0-24, and does not assume or restate its findings.

---

## Standards

### Hard violations (documented-standard breaches), most severe first

**1. ADR-0004 "All data access goes through a repository layer. No SQL in controllers or services" — bypassed repeatedly.**
`sys/settings.*` follows this correctly (SettingsService → SettingsRepository → BaseRepository), proving the pattern was known, but several files skip it and run raw Drizzle queries directly:
- `auth/auth.service.ts:201-235` (`findUserByIdentifier`, `findUserById`, `findSessionByRefreshTokenHash`) — `this.db.select().from(users)...`
- `auth/auth.guard.ts:115-119` — `this.db.select().from(users)...`
- `auth/me.controller.ts:57-61` — `this.db.select().from(roles)...`
- `rbac/permission-cache.ts:74-97` — raw selects on `roles`, `permissions`, `rolePermissions`

This is exactly the hedge ADR-0004 calls out as "cost close to nothing" precisely so a future tenant predicate has one place to land — it's already been circumvented in the module that will need it first.

**2. ADR-0001 "zod schemas at the edge, inferred types inward" — validation is dead code.**
`main.ts:57` registers `app.useGlobalPipes(new ZodValidationPipe())` with no schema argument; `ZodValidationPipe.transform` (`main.ts:13-16`) short-circuits and returns the value unchanged whenever `this.schema` is undefined — which it always is here. Meanwhile `auth/auth.dto.ts` defines `loginSchema`, `refreshTokenSchema`, and `authResponseSchema`, but none are ever passed to a pipe or called via `.parse`/`.safeParse` anywhere in `src/`. `POST /auth/login` and `/auth/refresh` therefore accept unvalidated request bodies at the one boundary ADR-0001 says must be zod-guarded.

**3. `todo/README.md` locked decision "Search: `utf8mb4_0900_ai_ci`" — silently downgraded.**
`platform/db/migrate.ts:128-133` catches MySQL errno 1273 and rewrites the migration SQL to `utf8mb4_unicode_ci` before re-running it, with only a `console.warn`. That changes accent/case-insensitivity semantics (the exact FR-API-014 guarantee ADR-0002 credits to `0900_ai_ci`) with no gate, test, or operator-visible failure — it just quietly applies a different collation than what shipped in review.

**4. ADR-0003 "argon2id ... remains correct for passwords" — inconsistent hashing.**
`auth/password.ts:10` correctly passes `{ type: argon2.argon2id }`. `platform/db/seed/admin.ts:32` calls `argon2.hash(rawPassword)` with no options — the `argon2` package's default type is `argon2i`, not `argon2id`. The bootstrap Super Admin's password is hashed with a weaker, non-standard variant than every subsequently created user, from duplicated hashing logic that already drifted from the one helper meant to own it.

### Judgement calls (baseline smells)

- **Duplicated Code** — `auth/auth.guard.ts:66-81` and `rbac/permission.guard.ts:21-36` both re-implement the identical "check `IS_PUBLIC_KEY` reflector, then test `PUBLIC_PATH_PATTERNS`" block. Same shape, two files; a change to public-route logic requires touching both guards in lockstep.
- **Duplicated Code / Mysterious Name** — `platform/health/health.controller.ts:26` redeclares `export const DRIZZLE_DB_TOKEN = 'DRIZZLE_DB'` instead of importing the canonical token from `drizzle.module.ts`. It only works because the string literals happen to match; nothing enforces that.
- **Middle Man** — `platform/http/pagination.ts:171-186`: `PaginationHelper.encodeCursor`, `.decodeCursor`, and `.createResponse` are pure one-line delegations to the standalone functions of the same name defined a few lines above in the same file.
- **Speculative Generality** — `rbac/permission-cache.ts:47-67`, `hasPermission`/`hasAllPermissions` are never called; `PermissionGuard` reimplements the same wildcard check inline instead of using them.
- **Speculative Generality / Divergent Change** — `platform/money/money.ts` bundles an unused `formatMoney()` (no callers anywhere) together with an unrelated `IDEMPOTENCY_KEY_HEADER` constant that has nothing to do with money rounding — two unrelated reasons to touch one small file.
- **Dead/duplicated construction path** — `health.controller.ts:33-39`: when `DRIZZLE_DB_TOKEN` isn't injected, the constructor hand-builds its own pool via `createConnectionPool()`/`createDrizzleClient()`, duplicating `DrizzleModule`'s job. Since `DrizzleModule` is `@Global()` and always provides the token, this branch is unreachable in practice — speculative code path.

### Notable positives (no action needed)
Error taxonomy/`GlobalExceptionFilter` matches FR-API-011 exactly; `utcDatetime()`/UTC round-trip tests are solid; refresh-token rotation and family-reuse revocation correctly implement FR-AUTH-004; `row_version`/`roundMoney` helpers match the locked decisions; audit log writes correctly enlist in the ambient transaction.

*Files reviewed span all paths under `auth/`, `rbac/`, `platform/`, `sys/`, `test/` plus standards sources `docs/adr/0001-0004`, `docs/project-context.md`, `todo/README.md`.*

---

## Spec

### Most severe first

**1. (c) M0-11 audit immutability grant is defeated by its own error handling — critical.**
Spec: "Hand-authored SQL. `REVOKE UPDATE, DELETE` on `audit_logs` from the app user." Done-when: "`UPDATE audit_logs` as the app user fails."
`apps/api/drizzle/0002_grants.sql:16-24` wraps the REVOKE in `DECLARE CONTINUE HANDLER FOR 1147 BEGIN END;` (and 1141/1410) and never issues a preceding table-level GRANT, despite its own comment on line 11 saying it should ("Grant all on the table first if needed, so REVOKE doesn't fail"). `docker-compose.yml` sets `MYSQL_DATABASE`/`MYSQL_USER`, which makes MySQL's entrypoint grant `luxeknox`@`%` **database-level** privileges (`mysql.db`), not table-level (`mysql.tables_priv`). A `REVOKE UPDATE, DELETE ON luxeknox.audit_logs FROM 'luxeknox'@'%'` against a db-level grant raises exactly error 1147, which this migration silently swallows. Net effect: the REVOKE never actually applies, the app user retains full UPDATE/DELETE on `audit_logs` via the db-level grant, and the acceptance test ("UPDATE audit_logs as the app user fails") would not pass against the compose setup as configured — the core immutability guarantee (ADR-0002, referenced in the file's own header) is not enforced.

**2. (a) Session-cache staleness window not addressed for permission/role changes — minor, but worth flagging.**
`PermissionCache` (`apps/api/src/rbac/permission-cache.ts`) has no TTL and no wiring to auto-invalidate; it's fine for M0-22 scope (no role-CRUD endpoints exist yet, correctly out-of-module per README), so this is not a defect, just worth noting for the next module that adds role mutation.

**3. (b) `PUBLIC_PATH_PATTERNS` scope creep beyond spec's allowlist.**
M0-22 spec: "Public allowlist: health, ready, login, refresh, settings/public." `apps/api/src/auth/auth.guard.ts:41-54` adds unprefixed duplicates (`/health`, `/ready`, `/auth/login`, `/auth/refresh`, `/settings/public`) plus `/v1/docs(\/.*)?` and `/docs(\/.*)?`. The Swagger docs exemption is reasonable (M0-06 mounts Swagger at `/v1/docs` and it must be reachable unauthenticated), but it's not in the M0-22 spec's explicit list and is scope creep against that task, even if harmless.

**4. (c) `/me` `slugs` array can contain the literal string `'*'` rather than expanded permission slugs.**
`apps/api/src/rbac/permission-cache.ts:85-87` special-cases `super_admin` by inserting the sentinel `'*'` into the permission set instead of the full catalog of permission slugs; `me.controller.ts:66-67` returns that set verbatim as `slugs`. M0-23 says "`GET /me` returns user, role, slugs" without specifying expansion, so this is a judgment call rather than a clear violation, but a client reading `slugs` to check membership (`slugs.includes('settings.read')`) would get a false negative for Super Admin — worth a spec clarification.

### Everything else checked out
Verified and spec-conformant: `token.ts` (opaque `gk_at_`/`gk_rt_`, SHA-256 hex hashing, no logging), `password.ts` (argon2id explicit), `auth.service.ts` refresh-reuse detection (revokes whole family only when the reused token was previously revoked — correct semantics), `session.cache.ts` (60s TTL, per-hash/family/user invalidation), `auth.guard.ts`/`permission.guard.ts` (401 on missing/invalid token, 403 via `ForbiddenError`, principal built from session row not token, slugs from `PermissionCache` not token), `login-throttle.ts` (sliding window, per-identifier and per-IP, resets on success), schema files (`users.ts`, `sessions.ts`, `schema/index.ts` exports all 7 tables, unique-where-not-null via MySQL unique-index NULL semantics), `0001_platform.sql` (matches locked decisions: `BIGINT UNSIGNED AUTO_INCREMENT`, `DATETIME(3)`, `utf8mb4_0900_ai_ci`), `seed/admin.ts` (idempotent via `onDuplicateKeyUpdate`, env-driven, no `employees` row), `exception.filter.ts`/`codes.ts` (uniform `{code, message, details, request_id}`, no stack leakage to client, `request_id` fallback to `'pending'`), `settings.service.ts` (sole reader of `gym_settings`, no upsert, seeded defaults), `pagination.ts` (cursor on created_at+id, offset mode, default limit sourced from `SettingsService`, capped at `MAX_PAGE_SIZE`).

**Not independently re-verified in depth:** M0-19 audit/events/money service internals, M0-24 CI workflow/OpenAPI dump content, and the e2e test suite — file structure matches the spec's file list but content wasn't line-by-line diffed against FRD §5.2 codes or the exact e2e scenario list, given the review budget.

---

## Summary

- **Standards:** 4 hard violations, 6 judgement-call smells. Worst: **ADR-0004 repository-layer bypass** — `auth.service.ts`, `auth.guard.ts`, `me.controller.ts`, and `permission-cache.ts` all run raw Drizzle queries instead of going through a repository, in the same module that will need a tenant predicate first.
- **Spec:** 4 findings. Worst: **M0-11 audit-log immutability grant is silently defeated** — the `REVOKE UPDATE, DELETE` in `0002_grants.sql` fails with MySQL error 1147 against the compose setup's database-level grant and is swallowed by a continue handler, so the app user can still mutate `audit_logs` and the task's own acceptance test would fail.
