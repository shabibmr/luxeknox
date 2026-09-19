# Task Checklist: Module 0 Spine Completion & M0-24 Finalization

- [x] 1. Enforce access token 30-minute TTL in `auth.guard.ts` and `session.repository.ts` <!-- id: 1 -->
- [x] 2. Wire Zod request body validation on `AuthController` login and refresh routes <!-- id: 2 -->
- [x] 3. Harden password verification in `password.ts` and login throttle isolation in `login-throttle.ts` <!-- id: 3 -->
- [x] 4. Connect `PaginationHelper` to `SettingsService` via `PlatformModule` import of `SysModule` <!-- id: 4 -->
- [x] 5. Clean up duplicate `DRIZZLE_DB_TOKEN` in `health.controller.ts` <!-- id: 5 -->
- [x] 6. Update unit tests in `auth.service.spec.ts` for real session ID and access TTL <!-- id: 6 -->
- [x] 7. Verify OpenAPI dump and format alignment in `scripts/dump-openapi.ts` <!-- id: 7 -->
- [x] 8. Run full verification suite (`test`, `typecheck`, `test:e2e`, `openapi:dump`) <!-- id: 8 -->
- [x] 9. Update `todo/M0-24-e2e-openapi-ci.md` and `todo/README.md` to completed <!-- id: 9 -->
