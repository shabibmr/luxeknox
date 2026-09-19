# Vertical 1 — Exercise Library — Todo

Backend implementation of the first feature vertical (`docs/adr/0007-first-delivery-vertical.md`,
now **Accepted**). Builds on Module 0's spine (`todo/README.md`, completed) and its fix register
(`todo/fixes/`, in progress — this vertical does not block on any remaining fix except where a
ticket below says so).

**Scope:** `exercises` — admin CRUD (FR-WORK-001), member/trainer browse & search (FR-WORK-002).
Screens 29 (Exercise Library) + 30 (Exercise Details). Routes `/admin/workout-library`,
`/trainer/plans/exercises/:id`.

**Out of scope** (ADR-0007, explicit): `workout_plans`, `workout_plan_versions`,
`workout_plan_exercises`, `workout_sessions`, `workout_session_exercises` — all of FRD §14.2 and
§14.3. Do not add columns, endpoints, or permissions for those here.

**Rule:** each task touches at most 7 files (same rule as Module 0).
**Rule:** each task lands green — `pnpm --filter api lint typecheck test` passes before the next
task starts.

**Status:** completed and verified live against a real MariaDB server. One open item: the
least-privilege grants (`todo/fixes/F-03-...md`) were deliberately not applied to that server — see
"Live database" below.

## The contract already exists — implement against it, do not invent one

`docs/openapi/v1.yaml` already specifies `GET/POST /exercises` and `GET/PATCH /exercises/{id}`
(`x-status: mvp`, tag `WORK`) — schemas `Exercise`, `ExerciseWrite`, `ExercisePage`, permissions
`exercises.read` / `exercises.create` / `exercises.update`. This is not a draft: `packages/api_client`
was already generated from it and the Flutter Exercise Library screens (`flutter-todo/vertical-1-flutter-tasks.md`,
partially executed per `flutter-review/tasks.md`) already consume those generated models. Per
`docs/openapi/README.md`, **"a dump that drifts is a bug."** Every ticket below that touches the
HTTP surface must match that file's `operationId`s, field names, status codes, and permission slugs
exactly — field names, error shapes, and permission slugs are frozen by it, not by this register.

`docs/openapi/v1.yaml` is not being deleted. See `todo/fixes/F-14-e2e-ci-gaps.md` (amended) for why
the earlier "drop the YAML" plan was wrong.

## Locked decisions

| Topic | Decision | Source |
| :--- | :--- | :--- |
| Pagination wire shape | `{ data, meta: { limit, offset, cursor, next_cursor, has_more, total } }`, snake_case | `v1.yaml` `PageMeta` — current `PaginationHelper` emits `{ total?, cursor, hasMore }` camelCase and must change ([V1-03](./V1-03-pagination-contract-parity.md)) |
| Permission slugs | New, granular: `exercises.read` / `exercises.create` / `exercises.update`. Additive to existing `workouts.*` (reserved for the plans/sessions verticals, not touched here) | `v1.yaml` `x-permission` on each operation |
| Delete | No hard delete, no `DELETE` endpoint. `PATCH /exercises/{id}` with `is_active: false` deactivates | `v1.yaml` (`PATCH` only), `database-entities.md` soft-deactivate convention |
| `equipment_needed` | Single string, **not** an array. The Flutter client already assumes this (`flutter-review/implementation-plan.md` finding J2) | `v1.yaml` `Exercise`/`ExerciseWrite` schemas |
| `secondary_muscles` | Array of strings (JSON column) | `v1.yaml` schemas, `database-entities.md` |
| Search | Case-insensitive `q` param (FR-API-014), backed by `utf8mb4_0900_ai_ci` (already the required collation project-wide) | FRD, ADR-0002 |
| Media | `video_url` / `gif_url` stay plain external HTTPS strings. No upload, no signed URL — ADR-0005 is still Deferred | ADR-0005 |
| Audit | `POST`/`PATCH` write an `audit_logs` row (FR-API-007), reusing the M0-19 audit helper | `docs/backend-frd.md` |

## Graph

```
V1-01 accept ADR-0007 ─┐
V1-02 fix F-14's plan ─┤ (docs only, both done)
                       │
V1-03 pagination parity ─┐
V1-04 permissions seed ──┤
                         ├─ V1-07 service ─ V1-08 controller ─┬─ V1-09 unit tests
V1-05 schema + migration ─ V1-06 repository ┘                 ├─ V1-10 e2e tests
                                                                └─ V1-11 openapi parity
```

V1-03, V1-04, and V1-05 have no prerequisites and may run in parallel.

## Checklist

- [x] [V1-01](./V1-01-accept-adr-0007.md) Accept ADR-0007
- [x] [V1-02](./V1-02-fix-f14-openapi-plan.md) Correct F-14's OpenAPI-artifact plan
- [x] [V1-03](./V1-03-pagination-contract-parity.md) Pagination contract parity
- [x] [V1-04](./V1-04-permissions-seed.md) Seed `exercises.*` permissions
- [x] [V1-05](./V1-05-schema-migration.md) `exercises` schema + migration (verified live)
- [x] [V1-06](./V1-06-repository.md) `ExerciseRepository`
- [x] [V1-07](./V1-07-service-dto.md) `ExerciseService` + DTOs
- [x] [V1-08](./V1-08-controller-module.md) `ExerciseController` + module wiring
- [x] [V1-09](./V1-09-unit-tests.md) Unit tests (124/124 passing)
- [x] [V1-10](./V1-10-e2e-tests.md) E2E tests (verified live, 13/13 — see ticket's Live verification note)
- [x] [V1-11](./V1-11-openapi-parity.md) OpenAPI parity (verified live, drift found and fixed — see ticket's Live verification note)

## Live database

No Docker in this environment, but a real, reachable MariaDB 10.4.22 server was available (user2grey/
user2grey, the only user, with `GRANT ALL PRIVILEGES ON *.*` — not a scoped app user; see chat for
the fuller risk discussion before it was used). Used to verify V1-05, V1-10, and V1-11 for real —
migration applied, 13/13 exercises e2e pass, 24/26 full e2e pass (the 2 failures are F-03's
audit-log-immutability tests, expected since grants were deliberately skipped), and a live
`openapi:dump` found and fixed real query/path-parameter drift (see V1-11).

**Deliberately not done:** `todo/fixes/F-03-least-privilege-db-user.md`'s grants script
(`drizzle/repeatable/grants.sql`) was not run against this server — it has one unrestricted user, not
a separate scoped app user, so there is nothing for the script to meaningfully restrict, and running
it risked masking that gap rather than fixing it. `.env`/`apps/api/.env` were updated to this
server's real credentials (documented inline) with `DB_ADMIN_USER` intentionally equal to `DB_USER`.
This is also why this server is MariaDB, not MySQL 8.4 (ADR-0002) — `todo/fixes/F-04-collation-fail-fast.md`
(still open) would, once implemented, refuse to migrate against it at all.

Also fixed while diagnosing an earlier silent failure (unrelated to this DB, since it also occurred
against Module 0's app graph with no DB touched, and did not recur on retry — see V1-11):
`apps/api/scripts/dump-openapi.ts` called `process.exit(1)` in its error handler, which on Windows
can drop a `console.error` before it flushes. Changed to `process.exitCode = 1`.

## Out of Vertical 1

`workout_plans`, `workout_plan_versions`, `workout_plan_exercises`, `workout_sessions`,
`workout_session_exercises` (ADR-0007 — vertical 6+). `MEDIA` uploads (ADR-0005, still Deferred).
`PEOPLE` / Members (ADR-0007 — vertical 3, the hub). `DIET` / Food Library (ADR-0007 — vertical 2).
