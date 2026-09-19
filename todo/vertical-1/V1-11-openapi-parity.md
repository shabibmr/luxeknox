# V1-11 — OpenAPI parity verification

| | |
| :--- | :--- |
| **Status** | completed, verified live |
| **Depends** | V1-08 |
| **Files** | 1 |

## Why

`docs/openapi/v1.yaml`'s `/exercises` section was written before any code existed and is already
what `packages/api_client` was generated from. This ticket is the check that the real implementation
didn't drift from it — the concrete, vertical-scoped version of what `todo/fixes/F-14-e2e-ci-gaps.md`
(amended by V1-02) wants generalized into CI later.

## Files

- `docs/openapi/v1.json` (regenerated, not hand-edited)

## Work

1. `pnpm --filter api openapi:dump`.
2. Compare the four `/exercises*` operations in the fresh `v1.json` against `docs/openapi/v1.yaml`:
   same `operationId`s, same request/response field names (snake_case), same status codes listed,
   same permission behavior (`x-permission` isn't emitted by `@nestjs/swagger` natively — verify the
   *guard* enforces the documented slug even though the dump won't show `x-permission` literally).
3. Fix any drift in the Nest side (controller/DTOs), not in `v1.yaml` — the YAML is the frozen
   contract this vertical was scoped against (register-level "Locked decisions").
4. Confirm `packages/api_client`'s already-generated `Exercise`/`ExerciseWrite`/`ExercisePage`
   models (`packages/api_client/lib/src/model/exercise*.dart`) still match — if step 3 required no
   changes to `v1.yaml`, the Flutter client needs no regeneration.

## Done when

- No field/status/operationId drift between the dumped `v1.json` and `v1.yaml`'s `/exercises`
  section.
- `packages/api_client` was not regenerated (or, if it was, it produced no diff) — Vertical 1 backend
  work does not force a Flutter-side change.

## Execution note

`pnpm --filter api openapi:dump` (and, it turns out, any live `NestFactory.create(AppModule)` —
verified by isolating it to the pre-Vertical-1 Module 0 module graph, which fails identically) does
not complete in this environment: the process exits without printing a stack trace and without
reaching the script's `.catch()` output. This is a pre-existing environment limitation (same reason
F-03's live migration/e2e checks and this register's V1-10 e2e run couldn't be verified live either),
not something introduced by this vertical.

Found and fixed one real bug while diagnosing: `apps/api/scripts/dump-openapi.ts` called
`process.exit(1)` directly inside its `.catch()`, which on Windows can terminate the process before
the preceding `console.error` finishes an async stdout/stderr flush — so a real failure prints
nothing. Changed to `process.exitCode = 1` (natural exit, stdio flushes first). This fix stands
regardless of the environment issue and should make future failures of this script diagnosable.

Parity was instead verified by manual, field-by-field comparison against `docs/openapi/v1.yaml`
(paths, methods, status codes, schema field names, and — added specifically for this — explicit
`operationId` on all four `@ApiOperation()` calls in `exercise.controller.ts`, matching
`listExercises`/`createExercise`/`getExercise`/`updateExercise` exactly; no other Module 0 controller
sets `operationId` explicitly, so this one improves on precedent rather than matching it).

## Live verification (2026-09-19)

`pnpm --filter api openapi:dump` (via `db:migrate` env against the real reachable MariaDB — see
V1-05's note) succeeded on retry; the earlier silent-crash symptom did not recur, so treat it as
transient in this environment rather than a real blocker, though the `process.exitCode` fix above
still stands regardless.

Comparing the fresh `docs/openapi/v1.json` against `v1.yaml`'s `/exercises` section found one real,
fixable drift: `GET /exercises`, `GET /exercises/{id}`, and `PATCH /exercises/{id}` dumped with
`parameters: []` — the six list-query filters and the `id` path param were invisible to
`@nestjs/swagger` because they were read via a generic `@Query()`/`@Param('id', ParseIntPipe)`
without explicit `@ApiQuery()`/`@ApiParam()` decorators. Added both to `exercise.controller.ts`;
re-dumped and confirmed all six query params (`limit`, `offset`, `q`, `primary_muscle_group`,
`equipment_needed`, `difficulty_level`) and the `id` path param now appear with matching
names/types/`required`. `operationId`s (`listExercises`/`createExercise`/`getExercise`/
`updateExercise`) and tags (`WORK`) matched on first dump, no changes needed there.

Not fixed, judged non-breaking: response schemas (`ExerciseResponseDto`, `ExercisePageMetaDto`) dump
with more fields in `required` than `v1.yaml`'s `Exercise`/`PageMeta` strictly mandate (e.g. `v1.yaml`
only requires `[id, name, is_active]` on `Exercise`; the dump requires all of them). This is because
the implementation always returns every field, even as `null` — a stricter superset of the contract,
not a violation of it, and arguably more accurate to actual runtime behavior. Left as-is.

`packages/api_client` was not regenerated — it's built from `v1.yaml`, which this vertical didn't
modify.
