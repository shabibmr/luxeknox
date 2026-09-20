# V3-15 — Unit test matrix

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-13c |
| **Files** | ≤7 |

## Why

Consolidate behaviour that is easy to miss in e2e: row-scope 404, capacity override, employee
terminate/session revoke, dual-seed permission resolution, membership_number immutability /
allocation, specializations normalize, primary EC uniqueness.

## Files

- Specs next to services/helpers already created (batch additions; stay ≤7 files touched)
- Prefer extending existing `*.spec.ts` over new dump files

## Work — required cases

| Case | Expect |
| :--- | :--- |
| Member reads other member | 404 |
| Trainer reads unassigned member | 404 |
| Trainer reads assigned member | ok |
| Assign over capacity without override | 422 |
| Assign over capacity with admin override | ok + audit |
| Assign inactive trainer | 422 |
| Patch membership_number | rejected |
| Employee terminate/suspend | user non-authable + sessions revoked |
| Dual-seed | PermissionGuard accepts OpenAPI slug; legacy write alone does not satisfy create if controller asks create |
| Specializations / Money outbound | normalize |
| EC second primary | previous cleared / unique enforced |

## Done when

- Matrix covered in unit tests; `pnpm --filter api test` green.
