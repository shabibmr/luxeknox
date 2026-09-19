# Implementation Plan: Complete Module 0 Spine & Finalize M0-24

Finish Module 0 implementation in `todo/` by addressing the security and architectural findings in `todo/review/M0-01-to-M0-22-implementation.md`, completing `M0-24-e2e-openapi-ci.md`, verifying all test suites and OpenAPI dumps, and transitioning Module 0 to completed status.

## User Review Required

> [!IMPORTANT]
> This plan addresses the critical security findings from the code review (access token 30-minute TTL enforcement, Zod body validation on auth endpoints, IP throttle preservation, and `SettingsService` connection to `PaginationHelper`) and completes task `M0-24` (Integration, OpenAPI, CI).

- **Breaking Changes:** None. All changes harden existing endpoints and align with ADR-0003.
- **Rollback Strategy:** Git revert if needed; zero schema changes required for this phase.

---

## Proposed Changes

### 1. Access Token TTL Enforcement (ADR-0003 & Review Finding 2)

#### [MODIFY] [auth.guard.ts](file:///E:/work/gym/apps/api/src/auth/auth.guard.ts)
- Enforce the 30-minute access token lifespan:
  - Check `session.created_at + 1800s <= now` in addition to `session.expires_at <= now` (which is the 30-day session/refresh expiry).
  - If expired, drop from `sessionCache` and throw `UnauthorizedError('Session has expired or been revoked')`.

#### [MODIFY] [session.repository.ts](file:///E:/work/gym/apps/api/src/auth/session.repository.ts)
- In `findActiveByAccessTokenHash`, add condition `gt(sessions.created_at, minCreatedAt)` where `minCreatedAt = now - 1800s`.

---

### 2. Request Body Validation via Zod Pipes (Review Finding 4)

#### [MODIFY] [auth.controller.ts](file:///E:/work/gym/apps/api/src/auth/auth.controller.ts)
- Apply `new ZodValidationPipe(loginSchema)` to `dto: LoginDto` in `@Post('login')`.
- Apply `new ZodValidationPipe(refreshTokenSchema)` to `dto: RefreshTokenDto` in `@Post('refresh')`.
- Import `ZodValidationPipe` from `../main` (or dedicated pipe module).

---

### 3. Password Verification & Throttle Hardening (Review Findings)

#### [MODIFY] [password.ts](file:///E:/work/gym/apps/api/src/auth/password.ts)
- Wrap `argon2.verify(hash, password)` in a try/catch block returning `false` on malformed hash to prevent unexpected 500 crashes.

#### [MODIFY] [login-throttle.ts](file:///E:/work/gym/apps/api/src/auth/login-throttle.ts)
- In `recordSuccess(identifier, _ipAddress)`, only clear `idKey` to prevent a valid login from wiping out an IP-level rate-limit lockout.

#### [MODIFY] [auth.service.ts](file:///E:/work/gym/apps/api/src/auth/auth.service.ts)
- Normalize `identifier` by trimming and lowercasing for email lookup.

---

### 4. Dependency Injection & Service Wiring (Review Findings 5 & Health)

#### [MODIFY] [platform.module.ts](file:///E:/work/gym/apps/api/src/platform/platform.module.ts)
- Import `SysModule` so `SettingsService` is provided to `PaginationHelper` for default page size resolution.

#### [MODIFY] [health.controller.ts](file:///E:/work/gym/apps/api/src/platform/health/health.controller.ts)
- Import `DRIZZLE_DB_TOKEN` directly from `../db/drizzle.module` instead of declaring a duplicate constant.

---

### 5. Test Suite & OpenAPI Alignment

#### [MODIFY] [auth.service.spec.ts](file:///E:/work/gym/apps/api/src/auth/auth.service.spec.ts)
- Update mock `createSession` to resolve with a numeric ID (`101`) instead of `undefined`.
- Add test coverage verifying access token expiration behavior.

#### [MODIFY] [scripts/dump-openapi.ts](file:///E:/work/gym/apps/api/scripts/dump-openapi.ts)
- Align OpenAPI spec generation with server URL `/v1` matching `docs/openapi/v1.yaml`.

---

### 6. Todo Tracking Updates

#### [MODIFY] [todo/M0-24-e2e-openapi-ci.md](file:///E:/work/gym/todo/M0-24-e2e-openapi-ci.md)
- Update status to `completed`.

#### [MODIFY] [todo/README.md](file:///E:/work/gym/todo/README.md)
- Mark task M0-24 as checked: `- [x] [M0-24](./M0-24-e2e-openapi-ci.md) Integration, OpenAPI, CI`.
- Update Module 0 overall status from `pending` to `completed`.

---

## Verification Plan

### Automated Tests
1. **Unit tests:**
   ```bash
   pnpm --filter api test
   ```
2. **Typecheck:**
   ```bash
   pnpm --filter api typecheck
   ```
3. **E2E tests:**
   ```bash
   pnpm --filter api test:e2e
   ```
4. **OpenAPI dump:**
   ```bash
   pnpm --filter api openapi:dump
   ```

### Manual Verification
- Verify that sending an invalid login body (e.g. `{ identifier: "" }`) triggers a `400 VALIDATION_FAILED`.
- Verify that a session with `created_at` older than 30 minutes is rejected by `AuthGuard`.
