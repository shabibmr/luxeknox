# V1-08 — `ExerciseController` + module wiring

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V1-07 |
| **Files** | 3 |

## Files

- `apps/api/src/work/exercise.controller.ts` (new)
- `apps/api/src/work/work.module.ts` (finish wiring — controller in the `controllers` array)
- `apps/api/src/app.module.ts` (import `WorkModule`)

## Work

Four routes, matching `docs/openapi/v1.yaml` operation-for-operation — same shape as
`SettingsController`/`AuthController` (`RequirePermission`, `ZodValidationPipe`, `@nestjs/swagger`
decorators):

| Route | `operationId` | Guard | Body |
| :--- | :--- | :--- | :--- |
| `GET /exercises` | `listExercises` | `exercises.read` | — (query: `limit`, `offset`, `q`, `primary_muscle_group`, `equipment_needed`, `difficulty_level`) |
| `POST /exercises` | `createExercise` | `exercises.create` | `ExerciseWrite` |
| `GET /exercises/{id}` | `getExercise` | `exercises.read` | — |
| `PATCH /exercises/{id}` | `updateExercise` | `exercises.update` | `ExerciseWrite` |

- `@ApiTags('Exercises')` or `('WORK')` — match whichever tag convention `docs/openapi/v1.yaml` uses
  (`tags: [WORK]`) so the dumped tag doesn't drift.
- Response DTOs (`ExerciseResponseDto`, `ExercisePageResponseDto`) with `@ApiProperty` on every
  field, field names snake_case, mirroring `HealthResponseDto`'s pattern in
  `apps/api/src/platform/health/health.controller.ts`.
- No `@Public()` — every route requires a Bearer token (unlike `GET /settings/public`).

## Done when

- All four routes respond with the correct status codes for: happy path, 401 (no token), 403 (wrong
  role), 404 (`GET`/`PATCH` on missing id), 400/422 (invalid body).
- `pnpm --filter api openapi:dump` produces these four paths with the exact `operationId`s above —
  cross-check against V1-11.
