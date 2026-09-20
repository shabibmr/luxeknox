# V3-06 — Trainers API

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V3-04 |
| **Files** | ≤7 |

## Why

OpenAPI: `GET/POST /trainers`, `GET/PATCH /trainers/{id}`, `GET /trainers/{id}/members`.
`trainers.is_active=false` must **not** block login (auth is `users.status`); it only gates new
assignments (V3-05c).

## Files

- `apps/api/src/people/trainer.repository.ts`
- `apps/api/src/people/trainer.service.ts`
- `apps/api/src/people/trainer.dto.ts`
- `apps/api/src/people/trainer.controller.ts`
- Wire into `PeopleModule`
- Shared outbound normalize helper for `specializations` (mirror
  `work/normalize-secondary-muscles.ts` — MariaDB JSON-as-TEXT safe)

## Work

- Create via person factory (`user_type=trainer`).
- `hourly_rate` as Money string outbound (platform money helper).
- `specializations`: accept array in; persist MariaDB-safe; normalize on read.
- List/get/patch with `trainers.read|create|update`.
- `GET /trainers/{id}/members`: members with `assigned_trainer_id`; permission `members.read`;
  row-scope (trainer sees own roster only unless admin).
- Soft-deactivate via `is_active` on patch — no DELETE.
- Audit on create/update.

## Done when

- CRUD + roster route live; inactive trainer still authable (covered later in e2e).
- Specializations round-trip on MariaDB.
- lint/typecheck/test green.
