# F-09 — Single public-path allowlist matching M0-22

| | |
| :--- | :--- |
| **Status** | todo |
| **Severity** | medium |
| **Depends** | — |
| **Files** | 5 |

## Why

M0-22 specifies the allowlist exactly: "health, ready, login, refresh, settings/public." `auth.guard.ts:42-55` carries twelve patterns — each spec entry twice (prefixed and bare) plus `/v1/docs` and `/docs`.

Two problems:

1. **Unauthenticated surface that nobody decided on.** The bare forms are dead weight: `setGlobalPrefix('v1')` is applied in `main.ts:55` and in `test/helpers/mysql.ts:39`, so Express `request.path` always carries the prefix. The `/docs` entries are also unnecessary — `SwaggerModule.setup()` registers on the underlying Express instance, not through Nest's router, so `APP_GUARD` never runs for it. Every unneeded pattern is a line someone could widen by accident.
2. **The check is duplicated across both guards.** `auth.guard.ts:68-82` and `permission.guard.ts:23-36` implement the same "reflector, then pattern list" logic, and `permission.guard.ts:9` imports the list from `auth.guard.ts`, coupling `rbac/` to `auth/` for a constant.

## Files

- `apps/api/src/auth/public-paths.ts` (new)
- `apps/api/src/auth/public-paths.spec.ts` (new)
- `apps/api/src/auth/auth.guard.ts`
- `apps/api/src/rbac/permission.guard.ts`
- `apps/api/src/rbac/permission.guard.spec.ts`

## Steps

1. Create `apps/api/src/auth/public-paths.ts` holding the list *and* the shared decision, so neither guard reimplements it:
   ```ts
   import type { ExecutionContext } from '@nestjs/common';
   import type { Reflector } from '@nestjs/core';
   import type { Request } from 'express';
   import { IS_PUBLIC_KEY } from './public.decorator';

   /**
    * Routes reachable without a Bearer token (M0-22).
    * Paths carry the `v1` global prefix because `setGlobalPrefix('v1')` always runs.
    */
   export const PUBLIC_PATH_PATTERNS: readonly RegExp[] = [
     /^\/v1\/health\/?$/,
     /^\/v1\/ready\/?$/,
     /^\/v1\/auth\/login\/?$/,
     /^\/v1\/auth\/refresh\/?$/,
     /^\/v1\/settings\/public\/?$/,
   ];

   export function isPublicRequest(reflector: Reflector, context: ExecutionContext): boolean {
     const decorated = reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
       context.getHandler(),
       context.getClass(),
     ]);
     if (decorated) {
       return true;
     }

     const request = context.switchToHttp().getRequest<Request>();
     const path = request.path || request.url?.split('?')[0] || '';
     return PUBLIC_PATH_PATTERNS.some((pattern) => pattern.test(path));
   }
   ```
2. In `auth.guard.ts`: delete the `PUBLIC_PATH_PATTERNS` export (lines 39-55) and replace lines 68-82 with:
   ```ts
   if (isPublicRequest(this.reflector, context)) {
     return true;
   }
   const request = context.switchToHttp().getRequest<Request>();
   ```
   (the handler still needs `request` further down for headers and for attaching `request.user`).
3. In `permission.guard.ts`: replace lines 22-36 with the same two-line call, and change the import on line 9 to `import { isPublicRequest } from '../auth/public-paths';`. `IS_PUBLIC_KEY` is no longer imported here.
4. Point every other importer at the new module:
   ```
   rg "PUBLIC_PATH_PATTERNS" apps/api
   ```
5. Write `public-paths.spec.ts` as a table test. The negative cases matter more than the positive ones:
   ```ts
   it.each(['/v1/health', '/v1/ready', '/v1/auth/login', '/v1/auth/refresh', '/v1/settings/public'])(
     'treats %s as public', (p) => expect(PUBLIC_PATH_PATTERNS.some((r) => r.test(p))).toBe(true));

   it.each(['/v1/settings', '/v1/me', '/v1/auth/logout', '/v1/settings/public/extra', '/health'])(
     'treats %s as protected', (p) => expect(PUBLIC_PATH_PATTERNS.some((r) => r.test(p))).toBe(false));
   ```
6. Confirm the docs exemption really was unnecessary before you rely on the reasoning: start the app and `curl -i http://localhost:3000/v1/docs` with no `Authorization` header. If it returns 401 instead of the Swagger page, add `/^\/v1\/docs(\/.*)?$/` back **with a comment explaining why**, and record it as an amendment in `todo/M0-22-guards-rbac.md`.

## Done when

- `PUBLIC_PATH_PATTERNS` is defined in exactly one file and has five entries (or six, with a justified docs entry).
- `rg "IS_PUBLIC_KEY" apps/api/src` matches only `public.decorator.ts` and `public-paths.ts`.
- `rbac/` no longer imports from `auth/auth.guard`.
- `GET /v1/settings` without a token is still 401 and `GET /v1/settings/public` is still 200 — both already covered by `test/settings.e2e.spec.ts:51,80`.
- `pnpm --filter api test` and `test:e2e` pass.
