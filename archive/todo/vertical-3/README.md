# Vertical 3 — PEOPLE (+ MEDIA MVP + HEALTH onboarding) — Todo

Backend implementation of the third feature vertical (`docs/adr/0007-first-delivery-vertical.md`).
Builds on Module 0 + Vertical 1 + Vertical 2 (`archive/todo/vertical-2/`). Source plan:
`archive/todo/vertical-2-3-backend-plan.md` (V3 section). Analysis companion:
`archive/todo/vertical-2-3-backend-plan-analysis.md`.

**Location:** tickets live under `archive/todo/vertical-3/` (live `todo/` is archived).

**Scope:** Members + Trainers + Employees + `/me` profile + emergency contacts + MEDIA MVP
(signed PUT/GET) + HEALTH onboarding subset (`member_health`, documents, photos).

Contract: `docs/openapi/v1.yaml` — PEOPLE / HEALTH / MEDIA paths with OpenAPI slugs
`members.*` / `trainers.*` / `employees.*` / `health.*` / `media.*` / `roles.update`.

**Out of scope:** diet/workout plans, MEMB / ATTN / PAY / SCHED domain APIs, role editor UI,
password reset flows, dual `user_type`, `members.export`, `medical_histories`,
`health_conditions` catalog, progress photos, receipt PDFs, hosted exercise clips,
FR-PEOPLE-007 trainer-reassign notifications (audit only in V3).

**Rule:** each task touches at most 7 files (same rule as Module 0 / V1 / V2).
**Rule:** each task lands green — `pnpm --filter api lint typecheck test` passes before the next
task starts.

**Status:** completed — V3-01…V3-16.

## Locked decisions

| Topic | Decision | Source |
| :--- | :--- | :--- |
| Sequence | V2 complete before V3 domain. ADR-0008 may draft in parallel | plan |
| Person create | `users` then profile in **one TX** (FR-AUTH-008); no profile without login | FR-AUTH-008/009 |
| FR-PEOPLE-001 | MVP = OpenAPI multi-step (create → EC → media attach), not mega-TX | plan carve-out |
| FR-PEOPLE-007 | Reassign: audit only; NOTIF deferred | plan |
| `membership_number` | `M` + 8-digit sequence, unique, immutable; MariaDB-safe counter | plan |
| Employees names | `first_name` / `last_name` columns + entities doc | plan, EmployeeCreate |
| Row scoping | Member→other member 404; trainer→unassigned 404 (BR-PEOPLE-002/003) | plan |
| Dossier | MEMB/ATTN/PAY/SCHED extras **nullable** in YAML; V3 returns null | plan |
| Status | `users.status` = auth; `trainers.is_active` = assignment gate only | plan |
| Employee terminate/suspend | user non-authable + revoke sessions | OpenAPI, plan |
| Session profile | Login stamps `sessions.profile_id` when profile exists | plan |
| MEDIA | Signed PUT then attach key; local disk + S3 interface; no BLOB | ADR-0005 trigger → ADR-0008 |
| Purposes | `avatar`, `id_proof`, `waiver`, `medical_cert`; BR-HEALTH-001 on id_proof | ADR-0005, plan |
| OpenAPI status | V3-01: medical-histories + conditions → `deferred`. V3-11: `/media/*` → `mvp`. V3-13b/c: documents/photos → `mvp` | plan |
| Permission work | Additive dual-seed OpenAPI slugs alongside legacy `*.write` | plan |
| Money / JSON | `hourly_rate` Money string; specializations outbound-normalize (MariaDB TEXT-safe) | plan |
| openapi parity | V3-16 mvp dump/compare for people/media/health — not module-0-only | plan, V1-11/V2-09 |
| Task rule | ≤7 files; lint/typecheck/test green before next | plan |

## Graph

```
V2 exit → V3-01 perms (+ medical-histories/conditions deferred)
       → V3-02 schema → V3-03 factory → V3-04 scope
       → V3-05a members YAML → V3-05b members CRUD → V3-05c assign-trainer
       → V3-06 trainers ∥ V3-07 employees ∥ V3-08 emergency contacts
       → V3-09 /me + seed profiles + session profile_id
V2 exit → V3-10 ADR-0008 → V3-11 media (/media/* mvp)
V3-02 → V3-12 health/documents/photos schema   ← NOT blocked on V3-11
V3-11 + V3-12 → V3-13a member_health → V3-13b documents → V3-13c photos
V3-09 + V3-13c → V3-14..16 tests + openapi
```

Plan shorthand:
`V3-01 → V3-02 → V3-03 → V3-04 → V3-05a → V3-05b → V3-05c;`
`V3-06 ∥ V3-07 ∥ V3-08 after V3-04;`
`V3-09 after 05b+06+07;`
`V3-10 ∥ early path;`
`V3-12 after V3-02 (not MEDIA);`
`V3-11 after V3-10+V3-02;`
`V3-13* after V3-11+V3-12;`
`V3-14..16 last.`

## Checklist

- [x] [V3-01](./V3-01-permissions-seed-yaml-status.md) Dual-seed OpenAPI slugs + medical-histories/conditions deferred
- [x] [V3-02](./V3-02-schema-migration.md) `members` / `trainers` / `employees` + `0004_people.sql`
- [x] [V3-03](./V3-03-person-factory.md) Person factory (TX user+profile)
- [x] [V3-04](./V3-04-row-scope.md) Row-scope helper (404)
- [x] [V3-05a](./V3-05a-members-yaml.md) MemberCreate / MemberDossier YAML amends
- [x] [V3-05b](./V3-05b-members-crud.md) Members list/create/get/patch
- [x] [V3-05c](./V3-05c-assign-trainer.md) Assign/reassign trainer
- [x] [V3-06](./V3-06-trainers-api.md) Trainers API
- [x] [V3-07](./V3-07-employees-api.md) Employees API + role + status
- [x] [V3-08](./V3-08-emergency-contacts.md) Emergency contacts
- [x] [V3-09](./V3-09-me-profile-seed.md) `/me` profile + demo seeds + session `profile_id`
- [x] [V3-10](./V3-10-adr-0008.md) ADR-0008 object storage
- [x] [V3-11](./V3-11-media-api.md) StorageService + `/media/*` mvp
- [x] [V3-12](./V3-12-health-schema.md) health/documents/photos schema `0005`
- [x] [V3-13a](./V3-13a-member-health.md) `member_health` nested routes
- [x] [V3-13b](./V3-13b-member-documents.md) Member documents + flip x-status
- [x] [V3-13c](./V3-13c-member-photos.md) Member photos + flip x-status
- [x] [V3-14](./V3-14-onboarding-e2e.md) Onboarding e2e
- [x] [V3-15](./V3-15-unit-matrix.md) Unit matrix
- [x] [V3-16](./V3-16-e2e-openapi-parity.md) e2e + mvp openapi dump/compare

## Exit

Create member → login with session `profile_id`; trainer 404 on unassigned; employee terminate
blocks login; waiver via signed PUT; trainer cannot fetch `id_proof`; `membership_number`
unique/immutable; capacity 422 + admin override; EC primary uniqueness; `/me` non-null for demo
profiles; medical-histories absent from mvp parity; documents/photos mvp after V3-13.

## Out of Vertical 3

`diet_plans` / workout plans, MEMB / ATTN / PAY / SCHED APIs, `medical_histories`,
`health_conditions`, dual employee+trainer profiles, Flutter client regen (optional follow-up).
