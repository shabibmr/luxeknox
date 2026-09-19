# Module 0 — Todo

Platform spine for LuxeKnox. AUTH/RBAC/SYS boot stubs only. No Flutter, MEDIA, Exercise Library, or domain tables.

**Rule:** each task touches at most 7 files.

**Status:** completed

## Locked decisions

| Topic | Decision |
| :--- | :--- |
| Engine | MySQL 8.4, `mysql2`, Drizzle `mysql-core` |
| PK | `BIGINT UNSIGNED AUTO_INCREMENT` |
| Time | `DATETIME(3)` UTC, `utcDatetime()`, pool `time_zone = '+00:00'` |
| Money | `DECIMAL(12,2)` helper only |
| Auth | Opaque `gk_at_` / `gk_rt_`, SHA-256 in `sessions` |
| Search | `utf8mb4_0900_ai_ci` |
| Lock | `row_version` helper, unused until MEMB |
| Files | No upload, no `BLOB`, no `StorageService` |
| Isolation | `READ-COMMITTED` |

## Graph

```
T01 ADRs ─┬─ T02 catalog ─ T03 context
          │
          └─ T04 workspace ─ T05 nest pkg ─ T06 bootstrap
                                  │
                     T07 mysql compose ─ T08 drizzle cfg
                                  │
              T09 schema identity ─ T10 schema session/sys ─ T11 migration ─ T12 seed
                                  │
                     T13 errors ─ T14 request_id ─ T15 health
                                  │
                     T16 tx + repos ─ T17 settings ─ T18 pagination
                                  │
                     T19 audit + events
                                  │
                     T20 tokens + sessions ─ T21 auth HTTP ─ T22 guard + RBAC
                                  │
                     T23 /me + settings GET ─ T24 e2e + CI + OpenAPI
```

T13–T15 may overlap T08–T12. T01–T03 are docs-only and may run first.

## Checklist

- [x] [M0-01](./M0-01-accept-adrs.md) Accept ADRs 0001–0004
- [x] [M0-02](./M0-02-catalog.md) Catalog: sessions + engine conventions
- [x] [M0-03](./M0-03-context-frd.md) Context and FRD open items
- [x] [M0-04](./M0-04-workspace.md) Workspace root
- [x] [M0-05](./M0-05-nest-package.md) Nest package skeleton
- [x] [M0-06](./M0-06-bootstrap.md) Bootstrap `/v1`
- [x] [M0-07](./M0-07-mysql-compose.md) MySQL 8.4 compose
- [x] [M0-08](./M0-08-drizzle-utc.md) Drizzle client and UTC helper
- [x] [M0-09](./M0-09-schema-identity.md) Schema: identity
- [x] [M0-10](./M0-10-schema-session-sys.md) Schema: sessions, settings, audit
- [x] [M0-11](./M0-11-migration.md) SQL migration + grants
- [x] [M0-12](./M0-12-seed.md) Seed Super Admin and catalog
- [x] [M0-13](./M0-13-errors.md) Uniform errors
- [x] [M0-14](./M0-14-request-id.md) `request_id` interceptor
- [x] [M0-15](./M0-15-health.md) Health and ready
- [x] [M0-16](./M0-16-tx-repository.md) Transaction context and base repository
- [x] [M0-17](./M0-17-settings-service.md) SettingsService
- [x] [M0-18](./M0-18-pagination.md) Pagination helper
- [x] [M0-19](./M0-19-audit-events-helpers.md) Audit, events, money, row_version
- [x] [M0-20](./M0-20-tokens-sessions.md) Opaque tokens and session store
- [x] [M0-21](./M0-21-auth-http.md) Login, refresh, logout
- [x] [M0-22](./M0-22-guards-rbac.md) Auth guard and PermissionGuard
- [x] [M0-23](./M0-23-me-settings-http.md) `GET /me` and settings reads
- [x] [M0-24](./M0-24-e2e-openapi-ci.md) Integration, OpenAPI, CI

## Out of Module 0

Flutter shell, Exercise Library, MEDIA, password reset, role CRUD, settings upsert, PEOPLE tables, idempotency store, BullMQ, Redis, JWT.

Exercise Library backend work is planned in [`todo/vertical-1/`](./vertical-1/README.md) (ADR-0007).
