# Analysis: Vertical 2–3 backend plan vs live repo

**Source analyzed:** `/Users/admin/code/gym/archive/todo/vertical-2-3-backend-plan.md`  
**Note:** Live `todo/` is absent; the whole todo tree currently lives under `archive/todo/`.  
**Compared to:** `docs/backend-frd.md`, `docs/database-entities.md`, `docs/adr/0005`, `docs/adr/0007`, `docs/openapi/v1.yaml`, `apps/api` schema/seed/grants/auth.

---

## Verdict

**Approve with amendments** (not as-is; not a hard block on the verticals themselves).

Direction is sound: V2 = FR-DIET-001 foods only; V3 = PEOPLE + `/me` profile + emergency contacts + MEDIA MVP + HEALTH onboarding subset; MEDIA parallel draft with V2 is correct per ADR-0005/0007. Do **not** explode ticket trees until the amendments below are folded into the plan (and decide whether to restore live `todo/` from archive).

---

## Baseline confirmation

| Claim | True? | Evidence |
| :--- | :---: | :--- |
| No Drizzle `foods` / `members` / `trainers` / `employees` | **True** | `apps/api/src/platform/db/schema/` has identity/RBAC/sessions/settings/exercises only |
| OpenAPI paths for foods/people/media exist | **True** | `docs/openapi/v1.yaml` `/foods`, `/members`, `/trainers`, `/employees`, `/media/*`, `/users/{id}/emergency-contacts` |
| Seed slug mismatch (`diets.*` vs `diet.*`, `*.write` vs create/update, `media.write` vs `media.create`) | **True** | `apps/api/src/platform/db/seed/permissions.ts` + `roles.ts` vs YAML `x-permission` |
| `/me` profile always null | **True** | `apps/api/src/auth/me.controller.ts` hardcodes `profile: null`; e2e expects null |
| Demo trainer/member users without profiles | **True** | `apps/api/src/platform/db/seed/admin.ts` inserts `users` only (`trainer`, `member` emails) |
| Grants script covers new tables | **True** | `apps/api/drizzle/repeatable/grants.sql` grants DML per `information_schema` BASE TABLE |
| Verification DB MariaDB vs ADR MySQL 8.4 | **True (caveat)** | V1 README + `exercises.e2e.spec.ts` note MariaDB JSON-as-TEXT; ADR-0002 targets MySQL 8.4 |
| ADR-0008 exists | **False** | Only trigger text in `docs/adr/0005-object-storage-and-media.md`; no `0008-*.md` |
| `users.profile_id` column | **N/A / misread risk** | `profile_id` lives on **`sessions`**, not `users` (`0001_platform.sql`, `schema/users.ts`) — login stamps session `profile_id` |

---

## Conflicts with docs / OpenAPI / code

### Intentional plan overrides (need explicit FR/OpenAPI amends)

1. **FR-PEOPLE-001** (`docs/backend-frd.md`): onboarding is user+profile+optional photo+waiver+emergency contact **in one transaction**. Plan correctly follows OpenAPI (`MemberCreate` = names/credentials/profile only; photo/waiver/EC follow-up). **FR text is stale** relative to YAML — amend FR or document MVP carve-out in plan locked decisions.
2. **FR-PEOPLE-007**: reassign trainer → audit **+ notifies both trainers**. Plan: **audit only, no NOTIF**. Acceptable for V3 if called out as deferred with NOTIF vertical; otherwise conflicts.
3. **`EmployeeCreate` requires `first_name`/`last_name`** in YAML; `docs/database-entities.md` `employees` key-attrs omit names. Plan’s “add columns” is right; entities doc must update in V3-02.
4. **`foods`**: FR-DIET-001 browse “verified+active”; soft-deactivate convention lists `foods.is_active`; entities key-attrs and YAML `Food`/`FoodWrite` **omit `is_active`**. V2-01 amend is required and correct.

### OpenAPI contract gaps the plan underplays

5. **`MemberDossier` extras not nullable** in YAML (`membership`, `outstanding_balance`, `last_check_in`, `next_schedule` lack `nullable: true`). Plan says they must be nullable — bury this in V3-05 is risky; needs a dedicated YAML amend before/with members GET.
6. **`MemberCreate.required`** is only `[first_name, last_name]`; plan wants email-or-phone + password required — correct Zod+YAML amend, but not a numbered ticket (folded into V3-05).
7. **`/media/*` and member documents/photos are `x-status: deferred`**; health/medical-histories/emergency-contacts are **`mvp`**. Plan defers medical_histories/conditions but leaves YAML `mvp` — **openapi parity / client regen will still expect those routes** unless flipped to `deferred` or implemented.
8. **HEALTH permissions mismatch (missing from plan baseline):** YAML uses `health.update` / `health.approve`; seed has `health.write` / `health.pii_read` only (`permissions.ts`). V3-08/V3-13 will 403 unless V3-01 dual-seeds **health.*** too — plan text only highlights diet/members/media.
9. **Trainer/member roles currently get `diets.write` and `media.write`** (`roles.ts`). Plan correctly withholds `diet.create` from trainers; dual-seed must **not** map legacy `diets.write` → food mutate, and must strip inappropriate grants when adding `diet.read` only.

### ADR alignment

10. **ADR-0007** sequence Food Library → PEOPLE/MEDIA — plan matches.
11. **ADR-0005** forbids BLOB/ad-hoc upload; plan’s signed PUT + StorageService + ADR-0008 ticket matches the revisit trigger (member waiver/ID at V3).

---

## Dependency / sequencing issues

| Issue | Detail |
| :--- | :--- |
| **Graph vs table: V3-12** | ASCII: `V3-02 + V3-11 → V3-12`. Table: V3-12 depends **only V3-02**. Table is correct (schema needs no storage). **ASCII wrongly serializes health schema behind MEDIA.** |
| **MEDIA parallel** | Locked decision allows ADR draft ∥ V2; register starts V3-10 at V2 exit — OK. Ensure draft work isn’t blocked on V2 exit in human process. |
| **V3-08 deps** | Depends V3-03 only; emergency contacts need **row scoping** (BR-PEOPLE-*) and **health.*** perms → should depend V3-01 + likely V3-04. |
| **V3-09 after 05/06/07** | Good. Must also set **session `profile_id` on login** when profile rows exist (today login can pass null). |
| **V3-05 YAML amends** | OpenAPI contract changes mixed into fattest domain ticket — sequencing hazard for Flutter client regen and parallel V3-06/07. |
| **Documents/photos status flip** | Plan flips `/media/*` at V3-11; V3-13 must also flip `/members/{id}/documents|photos` deferred→mvp or parity stays inconsistent. |
| **openapi:check** | `check-openapi-parity.ts` only enforces **`module-0`** ops today. V2-09/V3-16 “openapi:check” needs the V1-11-style mvp dump/compare scope spelled out. |

V2 graph (`01∥02∥03 → 04 → 05 → 06 → 07∥08 → 09`) is consistent and mirrors V1.

---

## Ticket sizing risks (≤7 files)

| Ticket | Risk | Why |
| :--- | :--- | :--- |
| **V3-05** | **High** | Members list/create/get dossier/patch + assign-trainer + YAML required/nullable amends + DTOs/module — easily controller/service/repo/dto/module/yaml/tests. Plan says “split if >7” but doesn’t pre-split. |
| **V3-13** | **High** | member_health + documents + photos nested routes + BR-HEALTH-001 filtering + OpenAPI status flips. |
| **V3-01** | **Medium** | permissions.ts + roles.ts + possibly docs; dual-seed matrix across diet/people/media/**health** is easy to get wrong. |
| **V3-02** | **Medium** | three profile tables + employees name columns + membership_number uniqueness + migration `0004` + entities doc. |
| **V3-03** | **Medium** | TX factory, credentials validation, `user_type` match (FR-AUTH-009), session profile stamping contract. |
| **V3-07** | **Medium** | CRUD + `/role` + `/status` + terminate→revoke sessions (FR-PEOPLE-016). |
| **V3-11** | **Medium** | ADR impl: StorageService, local+S3 interface, signed PUT/GET, authz by purpose. |
| **V2-*** | **Low–OK** | Same shape as completed V1; V2-01 YAML-only is right. |

---

## Risks / gaps (beyond sizing)

1. **No ticket for `membership_number` strategy** (`M`+8-digit sequence, concurrency-safe). Buried in V3-02/V3-05 — race/uniqueness risk on MariaDB/MySQL without a counter table or transactional lock plan.
2. **Dual-seed hazard:** controllers use OpenAPI slugs; leftover `*.write` on roles can over-grant if any code path checks write, or under-grant if only write is seeded on a role. Need an explicit matrix: Admin all granular; trainer/member `diet.read` only; map create/update ↔ write for people/media/health during transition.
3. **Specializations JSON** on MariaDB: same TEXT-vs-JSON footgun as `secondary_muscles` — plan mentions outbound normalize but no ticket note for e2e/MariaDB.
4. **Verification criteria thin:** missing dual-seed regression, membership_number immutability, capacity 422+override, EC primary uniqueness, `/me` non-null for demo profiles, documents deferred→mvp flip, medical-histories explicitly out of parity.
5. **FR-PEOPLE-003/004 filters** (membership status, etc.) partially blocked until MEMB — plan should mark dossier/list fields null/ignored explicitly to avoid scope creep in V3-05.
6. **members.export** out of scope — good; ensure V3-01 doesn’t seed it as required.

---

## Recommended amendments (numbered)

1. **Fix V3 ASCII graph:** `V3-12` depends on `V3-02` only; `V3-13` depends on `V3-11 + V3-12` (keep table; fix diagram).
2. **Expand V3-01** to dual-seed `health.update` (+ `health.approve` if verify-doc in scope) alongside `health.write`; same pattern as media/people/diet. Publish a role×slug matrix in the ticket.
3. **Pre-split V3-05** before explode: e.g. V3-05a YAML amends (MemberCreate required, MemberDossier nullables); V3-05b Members CRUD; V3-05c assign-trainer + capacity.
4. **Pre-split V3-13:** health row vs documents vs photos (BR-HEALTH-001 on documents GET).
5. **Add explicit OpenAPI status ticket (or V3-10/11 acceptance):** flip `/media/*` and documents/photos to `mvp`; flip `medical-histories` (+ conditions if present) to `deferred` to match “Out of V2/V3”.
6. **Document FR carve-outs** in locked decisions / tiny docs ticket: FR-PEOPLE-001 multi-step vs one TX; FR-PEOPLE-007 NOTIF deferred.
7. **V3-02 acceptance:** employees `first_name`/`last_name`; foods already handled in V2; update `database-entities.md` in same ticket as schema.
8. **Add membership_number sequence design** to V3-02 or V3-03 (table/counter, TX, immutability tests).
9. **V3-08 depends on V3-04 (+ V3-01)** for scoped 404 and health perms.
10. **Clarify V2-09/V3-16:** extend parity beyond module-0 (dump compare for new mvp ops), matching V1-11 practice — `openapi:check` alone is insufficient today.
11. **Decide live `todo/` vs `archive/todo/`** before exploding `vertical-2/` and `vertical-3/` ticket trees.
12. **Login/`profile_id`:** V3-03/V3-09 must resolve profile id into sessions on login (users table has no `profile_id`).

---

## Ready-to-explode?

**No.**

Why: internal graph/table contradiction on V3-12; HEALTH permission gap absent from V3-01; fat tickets not pre-split; FR/OpenAPI deferrals (medical-histories, PEOPLE-001/007) unresolved; plan currently only under `archive/todo/`. After amendments 1–12, explode V2 first (safe), then V3.

---

## Verdict line

**Approve with 12 amendments** — strong backbone, not ticket-ready as written.
