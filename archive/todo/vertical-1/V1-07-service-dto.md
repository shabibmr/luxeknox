# V1-07 — `ExerciseService` + DTOs

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V1-03, V1-06 |
| **Files** | 3 |

## Files

- `apps/api/src/work/exercise.service.ts` (new)
- `apps/api/src/work/exercise.dto.ts` (new — Zod schemas mirroring `ExerciseWrite`)
- `apps/api/src/work/exercise.dto.spec.ts` (new, or fold into V1-09's spec file — implementer's call)

## Work

- `exercise.dto.ts`: `exerciseWriteSchema` (Zod) — `name` required non-empty string;
  `primary_muscle_group`, `equipment_needed`, `instructions`, `difficulty_level` optional strings;
  `secondary_muscles` optional `string[]`; `video_url`/`gif_url` optional, validated as `https?://`
  URLs; `is_active` optional boolean. Field names **snake_case**, matching the wire contract exactly
  — do not camelCase at the DTO boundary (the existing `ZodValidationPipe` validates the raw request
  body, before any mapping).
- `exercise.service.ts`:
  - `list(query)`: resolve pagination via `PaginationHelper` (V1-03's shape), call
    `ExerciseRepository.findManyFiltered`, `activeOnly: true` unless caller has
    `exercises.update`-level access (admin sees inactive rows too — confirm against FR-WORK-001/002
    before deviating; if FRD doesn't say, default to admin-sees-all, matching the `F` capability).
  - `getById(id)`: `NotFoundError` (uniform error envelope, `apps/api/src/platform/errors/`) if
    missing.
  - `create(dto)`: insert, then write an `audit_logs` row via the M0-19 audit helper
    (`apps/api/src/platform/audit/`) — action `exercise.created`, actor from `@CurrentUser`.
  - `update(id, dto)`: same audit pattern, action `exercise.updated`. This is also how deactivation
    happens (`dto.is_active = false`) — no separate delete/deactivate method.

## Done when

- Zod schema rejects a request missing `name` and accepts a minimal `{ name }` payload.
- Service methods have no raw SQL (delegate to the repository).
- Every mutation writes exactly one audit row.
