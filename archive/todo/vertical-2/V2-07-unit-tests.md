# V2-07 — Unit tests

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V2-06 |
| **Files** | 2 |

## Files

- `apps/api/src/diet/food.service.spec.ts` (new)
- `apps/api/src/diet/food.controller.spec.ts` (new — thin: guard wiring / status mapping, not
  business logic already covered by the service spec)

## Work

Mock the repository (no live DB). Cover:

- `list`: filter params passed through for updaters; non-updaters forced to
  `is_active` + `is_verified`; pagination meta shape matches V1.
- `getById`: `NotFoundError` for missing id; non-updater cannot read inactive/unverified.
- `create` / `update`: exactly one audit row; invalid Zod rejected; `is_active: false` is a normal
  field update (no separate delete path).

## Done when

`pnpm --filter api test` passes with these specs included; no live database required.
