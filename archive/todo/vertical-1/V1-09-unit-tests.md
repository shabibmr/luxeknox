# V1-09 — Unit tests

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V1-07, V1-08 |
| **Files** | 2 |

## Files

- `apps/api/src/work/exercise.service.spec.ts` (new)
- `apps/api/src/work/exercise.controller.spec.ts` (new — thin, mirrors `me.controller.spec.ts`'s
  scope: guard wiring and status mapping, not business logic already covered by the service spec)

## Work

Mock the repository (no live DB — matches every other `*.spec.ts` in this codebase). Cover:

- `list`: filter params passed through correctly; `activeOnly` flips on caller capability;
  pagination meta shape matches V1-03.
- `getById`: throws `NotFoundError` for a missing id.
- `create`/`update`: writes exactly one audit row; rejects invalid Zod input; `update` with
  `is_active: false` is indistinguishable from any other field update (no special-cased "delete"
  path to test separately).

## Done when

`pnpm --filter api test` passes with these specs included, no live database required.
