# Backend plan (amended): Vertical 2 Food Library + Vertical 3 PEOPLE

**Location:** `archive/todo/vertical-2-3-backend-plan.md` (live `todo/` is archived). Explode tickets to `archive/todo/vertical-2/` and `archive/todo/vertical-3/` unless `todo/` is restored first. Analysis: `archive/todo/vertical-2-3-backend-plan-analysis.md`.

---

## What changed vs the first draft

1. **Do not serialize MEDIA before PEOPLE.** Profile CRUD has no file dependency. MEDIA is only for documents/photos. Emergency contacts are `/users/{id}/emergency-contacts`.
2. **Implement OpenAPI, not a mega-create.** `MemberCreate` is names + credentials + profile. Photo/waiver/emergency contact are follow-up routes. FR-AUTH-008’s transaction is user+profile insert only.
3. **GET `/members/{id}` returns `MemberDossier`.** Extra fields (membership, balance, check-in, schedule) must be **nullable** in YAML; V3 returns null.
4. **Trainer `is_active=false` does not block login.** FR-PEOPLE-013 only blocks new assignments. Auth block is `users.status` and employee terminate/suspend.
5. **Trainer/member do not create foods.** FR-DIET-001 is Admin CRUD + browse. Do not grant `diet.create` to trainers. Do **not** map legacy `diets.write` → food mutate.
6. **Permission work is additive.** Controllers use OpenAPI slugs. Dual-seed `*.write` and `*.create|update` (and `health.update`/`health.approve`) until roles map to both.
7. **`/media/*` is `x-status: deferred`.** Flip to `mvp` only when ADR-0008 ships (V3-11). Documents/photos flip at V3-13b/c. Flip `medical-histories` (+ conditions catalog) to `deferred` in V3-01.
8. **`EmployeeCreate` has `first_name`/`last_name`.** Add columns on `employees`; update `docs/database-entities.md` in V3-02.
9. **New V3 platform pattern:** row-level 404 scoping (BR-PEOPLE-002/003) via a shared helper.
10. **FR carve-outs (MVP):** FR-PEOPLE-001 is multi-step (OpenAPI), not one mega-TX with photo/waiver/EC. FR-PEOPLE-007 NOTIF on reassign is deferred to NOTIF vertical; V3 is audit only.
11. **`profile_id` lives on `sessions`, not `users`.** Login must resolve and stamp session `profile_id` when a profile row exists (V3-03/V3-09).
12. **Pre-split fat tickets:** V3-05 → 05a/05b/05c; V3-13 → 13a/13b/13c. Health schema (V3-12) depends on V3-02 only, not MEDIA.

## Goal

Backend only. Flutter/client regen after mvp openapi dump/compare (not module-0-only `openapi:check`).

| Vertical | Scope |
| :--- | :--- |
| **V2** | `/v1/foods` FR-DIET-001 |
| **V3** | Members + Trainers + Employees + `/me` profile + emergency contacts + MEDIA MVP + HEALTH onboarding files |

## Baseline

Module 0 + V1 exercises done. No `foods`/`members`/`trainers`/`employees` in Drizzle. OpenAPI paths exist. Seed slug mismatches:

- `diets.*` vs YAML `diet.*`
- `members.write` / `trainers.write` / `employees.write` vs `*.create|update`
- `media.write` vs `media.create`
- `health.write` vs YAML `health.update` / `health.approve` (also dual-seed)

`/me` profile is hardcoded null. Demo trainer/member have no profile rows. `profile_id` is on **sessions**. Grants script already covers new tables. Verification DB is MariaDB 10.4 vs ADR MySQL 8.4 (JSON-as-TEXT footgun). ADR-0008 does not exist yet (trigger in ADR-0005).

## Locked decisions

| Topic | Decision |
| :--- | :--- |
| Sequence | V2 complete before V3 domain. ADR-0008 may be drafted in parallel with V2. |
| Todo tree | Work under `archive/todo/` until live `todo/` is restored. |
| Foods visibility | Non-updaters: `is_active AND is_verified`. No DELETE. |
| `foods.is_active` | Add column + YAML `Food`/`FoodWrite` + optional list query `is_verified`/`is_active`. |
| Food perms | `diet.read/create/update`. Admin all; trainer+member **read only**. Keep `diets.*` for later plans; do not grant food mutate via `diets.write`. |
| Person create | users then profile in one TX. Zod requires email-or-phone + password; amend YAML required (V3-05a). |
| FR-PEOPLE-001 | MVP = OpenAPI multi-step (create → EC → media attach). Not one TX with photo/waiver/EC. Amend FR or note carve-out in docs with V3-05a. |
| FR-PEOPLE-007 | Reassign: audit only in V3; NOTIF deferred. |
| Names on employees | `first_name`, `last_name` columns + entities doc in V3-02. |
| `membership_number` | `M` + 8-digit sequence, unique, immutable. V3-02 designs concurrency-safe counter/TX (MariaDB-safe); immutability tested in V3-05b. |
| Assign trainer | Active trainer; capacity 422 unless admin override. Reassign: audit only, no NOTIF. |
| Row scoping | Member→other member 404; trainer→unassigned 404. |
| Dossier | Extra fields null until MEMB/ATTN/PAY/SCHED. List filters that need MEMB are ignored/null in V3. |
| Status | `users.status` = auth. `trainers.is_active` = assignment gate. Employee terminate/suspend → user non-authable + revoke sessions. |
| Session profile | On login, resolve profile id for `user_type` and stamp `sessions.profile_id`. |
| MEDIA | Signed PUT then attach key. Local disk + S3 interface. Purposes: avatar, id_proof, waiver, medical_cert. No BLOB. |
| OpenAPI status | V3-01: `medical-histories` (+ conditions) → `deferred`. V3-11: `/media/*` → `mvp`. V3-13b/c: documents/photos → `mvp`. |
| HEALTH in V3 | emergency_contacts, member_health, documents, photos. Defer conditions catalog and medical_histories. |
| Money / JSON | `hourly_rate` Money string; specializations outbound-normalize like secondary_muscles (MariaDB TEXT-safe in e2e). |
| Task rule | ≤7 files; lint/typecheck/test green before next ticket. |
| openapi parity | V2-09 / V3-16 extend dump/compare beyond module-0 to new mvp ops (V1-11 style). |

## Task register — Vertical 2 (`archive/todo/vertical-2/` when exploded)

Graph: V2-01 ∥ V2-02 ∥ V2-03 → V2-04 → V2-05 → V2-06 → V2-07 ∥ V2-08 → V2-09.

| ID | Depends | Work |
| :--- | :--- | :--- |
| V2-01 | — | YAML `is_active` + list filters on `Food`/`FoodWrite` |
| V2-02 | — | Seed `diet.read/create/update`; admin all; trainer/member **read only** (strip mutate via `diets.write`) |
| V2-03 | — | `foods` schema + `0003_foods.sql` |
| V2-04 | V2-03 | FoodRepository |
| V2-05 | V2-04, V2-01 | FoodService + Zod + audit |
| V2-06 | V2-05, V2-02 | FoodController + DietModule |
| V2-07 | V2-06 | Unit tests |
| V2-08 | V2-06 | foods e2e (trainer POST 403; browse verified+active) |
| V2-09 | V2-08 | mvp openapi dump/compare for foods (not module-0-only check) |

V2 exit: live CRUD; hide inactive/unverified; faster than V1 or stop.

## Task register — Vertical 3 (`archive/todo/vertical-3/` when exploded)

```
V2 exit → V3-01 perms (+ medical-histories deferred)
       → V3-02 schema → V3-03 factory → V3-04 scope
       → V3-05a members YAML → V3-05b members CRUD → V3-05c assign-trainer
       → V3-06 trainers ∥ V3-07 employees ∥ V3-08 emergency contacts
       → V3-09 /me + seed profiles + session profile_id
V2 exit → V3-10 ADR-0008 → V3-11 media (/media/* mvp)
V3-02 → V3-12 health/documents/photos schema   ← NOT blocked on V3-11
V3-11 + V3-12 → V3-13a member_health → V3-13b documents → V3-13c photos
V3-09 + V3-13c → V3-14..16 tests + openapi
```

| ID | Depends | Work |
| :--- | :--- | :--- |
| V3-01 | V2 exit | Dual-seed OpenAPI slugs + role×slug matrix: `diet.*`, `members\|trainers\|employees.create\|update`, `media.create`, **`health.update` (+ `health.approve` if verify-doc in scope)** alongside legacy `*.write`. Flip YAML `medical-histories` (+ conditions) to `deferred`. Do not map `diets.write` → food mutate; trainer/member get `diet.read` only. |
| V3-02 | V3-01 | `trainers`, `employees` (`first_name`/`last_name`), `members` + `0004_people.sql`; **membership_number** concurrency-safe sequence design; update `docs/database-entities.md`. |
| V3-03 | V3-02 | Person factory (TX user+profile); FR-AUTH-009 `user_type` match; contract for login to stamp `sessions.profile_id`. |
| V3-04 | V3-03 | Row-scope helper (404) for BR-PEOPLE-002/003. |
| V3-05a | V3-04 | YAML only: `MemberCreate` required (email-or-phone + password); `MemberDossier` extras `nullable: true`; FR-PEOPLE-001 carve-out note in FR or plan-linked doc. |
| V3-05b | V3-05a | Members list/create/get/patch; dossier nulls for MEMB/ATTN/PAY/SCHED fields; membership_number immutability. |
| V3-05c | V3-05b | Assign/reassign trainer; capacity 422 + admin override; audit only (no NOTIF). |
| V3-06 | V3-04 | Trainers API; specializations outbound-normalize (MariaDB-safe). |
| V3-07 | V3-04 | Employees API + `/role` + `/status`; terminate/suspend → non-authable + revoke sessions. |
| V3-08 | V3-01, V3-04 | Emergency contacts (`/users/{id}/emergency-contacts`); scoped 404; health perms from V3-01. |
| V3-09 | V3-05b, V3-06, V3-07 | `/me` profile non-null; seed demo member/trainer/employee profiles; login stamps `sessions.profile_id`. |
| V3-10 | V2 exit | ADR-0008 (storage); may draft in parallel with V2. |
| V3-11 | V3-10, V3-02 | StorageService + `/media/*` flip to `mvp`; signed PUT/GET; purpose authz. |
| V3-12 | V3-02 | health/documents/photos schema `0005` (no MEDIA dependency). |
| V3-13a | V3-11, V3-12 | `member_health` nested routes. |
| V3-13b | V3-13a | Member documents routes; flip path `x-status` deferred→mvp; BR-HEALTH-001 on GET. |
| V3-13c | V3-13b | Member photos routes; flip path `x-status` deferred→mvp. |
| V3-14 | V3-09, V3-13c | Onboarding e2e (create → login profile_id → EC → signed PUT waiver). |
| V3-15 | V3-13c | Unit matrix (scope 404, capacity, terminate, dual-seed, membership_number). |
| V3-16 | V3-14 | e2e + mvp openapi dump/compare for people/media/health ops. |

## Out of V2/V3

Diet/workout plans, MEMB/ATTN/PAY/SCHED, role editor, password reset, dual user_type, members.export, medical_histories, conditions catalog, progress photos, receipt PDFs, hosted exercise clips, FR-PEOPLE-007 trainer-reassign notifications.

## Verification

- V2: admin CRUD; trainer POST 403; browse verified+active only; dual-seed does not grant trainer food mutate.
- V3: create member → login with session `profile_id`; trainer 404 unassigned; employee terminate blocks login; waiver via signed PUT; trainer cannot fetch id_proof; membership_number unique/immutable; capacity 422 + admin override; EC primary uniqueness; `/me` non-null for demo profiles; medical-histories absent from mvp parity; documents/photos mvp after V3-13.
- CI: lint, typecheck, db:check, unit, e2e, **mvp openapi dump/compare** (extend beyond module-0).
