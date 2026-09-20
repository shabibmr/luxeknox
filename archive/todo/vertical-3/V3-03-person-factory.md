# V3-03 — Person factory (user + profile TX)

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-02 |
| **Files** | ≤7 |

## Why

FR-AUTH-008: creating a member, trainer, employee, or admin always inserts a `users` login row
then the matching profile in **one transaction**. FR-AUTH-009: at most one profile per users row;
`user_type` must match. Login must later stamp `sessions.profile_id` (implemented in V3-09) —
this ticket defines the resolve contract.

## Files

- `apps/api/src/people/person.factory.ts` (new) — or `platform/people/` if preferred
- `apps/api/src/people/person.factory.spec.ts` (new)
- Possibly thin repos used only by the factory (count toward file budget)
- Touch existing `user.repository.ts` only if needed for shared insert helpers

## Work

- Factory API (sketch): `createPerson({ userType, credentials, profile })` inside `db.transaction`:
  1. Insert `users` (email and/or phone, password_hash, status active, user_type).
  2. Insert matching profile (`members` | `trainers` | `employees`) with `user_id`.
  3. For members: allocate `membership_number` via V3-02 counter design inside the same TX.
  4. For employees: assign role (role_permissions / users.role — follow existing RBAC model;
     OpenAPI `EmployeeCreate.role_id`).
- Reject mismatched `user_type` vs profile kind (FR-AUTH-009).
- Never return `password_hash`.
- Export a pure helper `resolveProfileId(userId, userType) → number | null` for login (V3-09
  wires it); do not change login behaviour yet unless trivial and tested.
- Unit-test: TX rolls back if profile insert fails; membership_number uniqueness under concurrent
  mock if feasible; user_type mismatch throws.

## Done when

- Factory creates user+profile atomically for member/trainer/employee.
- Specs cover rollback + type match.
- Login still works unchanged (profile_id stamping deferred to V3-09).
- lint/typecheck/test green.
