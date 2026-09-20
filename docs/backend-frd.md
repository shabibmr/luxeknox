# Backend Functional Requirements Document (FRD)

**Product:** Gym Management System (LuxeKnox) — MVP  
**Document type:** Backend functional requirements (stack-agnostic)  
**Status:** Draft  
**Date:** 2026-09-16  
**Sources:** [`database-entities.md`](./database-entities.md), [`Entities-List.md`](./Entities-List.md), [`project-context.md`](./project-context.md), [`screens/consolidated-screens.md`](./screens/consolidated-screens.md)

---

## 1. Purpose

This FRD specifies what the backend must do so the Flutter client (Member, Trainer, Admin / Office faces of one app) can run the 44 consolidated MVP screens.

It defines:

- Functional modules and their operations
- Actors, permissions, and data ownership
- Business rules, state machines, and side effects
- Canonical entities and the gaps between the two entity docs
- Resource operations a future API must expose

It does **not** choose a language, framework, database engine, auth vendor, payment gateway, or attendance hardware. Those remain open (see §20).

---

## 2. Scope

| In scope | Out of scope (MVP) |
| :--- | :--- |
| Single-gym operational backend for all three roles | Multi-tenant / multi-branch productisation |
| Identity, RBAC, CRUD, workflows, history, audit | Exact REST vs GraphQL vs RPC contract |
| Domain events that drive notifications | SMS/email provider, FCM/APNS vendor |
| Invoice ledger, POS capture, receipts | PCI-DSS card processing internals |
| Attendance records from QR / RFID / biometric / manual | Hardware firmware or turnstile vendor SDK |
| File metadata + storage URLs for docs, photos, receipts, media | CDN / object-store vendor |
| Report queries that power Admin analytics | BI warehouse, data lake |
| Template + versioned workout and diet plans | Third-party food databases (optional later) |

---

## 3. Module Catalog

These are the backend modules this FRD covers. They follow the entity domains, plus platform modules the screens require but the table list does not name as tables.

| # | Module | Code | What it owns | Primary entities |
| :-: | :--- | :---: | :--- | :--- |
| **0** | Cross-cutting platform | `API` | Authz enforcement, pagination, errors, idempotency, time, audit hook | — |
| **1** | Identity & session | `AUTH` | Login, logout, password, session, account status | `users` |
| **2** | RBAC | `RBAC` | Roles, permissions, staff role assignment | `roles`, `permissions`, `role_permissions` |
| **3** | People & profiles | `PEOPLE` | Member / trainer / employee records and directories | `members`, `trainers`, `employees` |
| **4** | Health & medical | `HEALTH` | Vitals, conditions, history, emergency contacts, member files & ID photos | `member_health`, `health_conditions`, `medical_histories`, `emergency_contacts`, `member_documents`, `member_photos` |
| **5** | Memberships & products | `MEMB` | Package catalog, contracts, freeze, extend, renew, history | `membership_products`, `memberships`, `membership_freezes`, `membership_extensions`, `membership_histories` |
| **6** | Scheduling & availability | `SCHED` | Types, rooms, bookings, waitlist, trainer hours | `schedule_types`, `facilities`, `schedules`, `schedule_participants`, `trainer_availabilities`, `schedule_histories` |
| **7** | Attendance | `ATTN` | Gate check-in/out, session mark, daily aggregates | `attendances`, `attendance_histories` |
| **8** | Billing & payments | `PAY` | Methods, invoices, POS, receipts, dues, refunds | `payment_methods`, `payments`, `payment_receipts`, `payment_histories` |
| **9** | Workout management | `WORK` | Exercise library, plans, versions, live sessions | `exercises`, `workout_plans`, `workout_plan_versions`, `workout_plan_exercises`, `workout_sessions`, `workout_session_exercises` |
| **10** | Diet & nutrition | `DIET` | Food library, plans, meals, intake logs, versions | `foods`, `diet_plans`, `diet_plan_versions`, `diet_plan_meals`, `diet_plan_foods`, `diet_histories` |
| **11** | Goals, progress & measurements | `GOAL` | Metrics, goals, measurements, photos, notes | `goal_metrics`, `goals`, `goal_histories`, `measurements`, `measurement_values`, `progress_photos`, `progress_notes` |
| **12** | Notifications & devices | `NOTIF` | Types, inbox, broadcast, push tokens, delivery | `notification_types`, `notifications`, `user_devices`, `notification_deliveries` |
| **13** | Dashboard snapshots | `DASH` | Role-specific home aggregates (read model) | derived |
| **14** | Reports & analytics | `RPT` | Admin reports; trainer own-performance slice | derived |
| **15** | System configuration & audit | `SYS` | Gym settings, immutable admin audit | `gym_settings`, `audit_logs` |
| **16** | Media & documents | `MEDIA` | Upload, store, signed access for files referenced by other modules | URLs on document / photo / receipt / exercise rows |

**Module 0 is not optional.** Every other module depends on it.

---

## 4. Actors

| Actor | `users.user_type` | Typical role | Access pattern |
| :--- | :--- | :--- | :--- |
| Member | `member` | Member | Own records; contextual actions (book, freeze request, self-pay, log workout/diet) |
| Trainer | `trainer` | Trainer | Own profile + **assigned** clients (`members.assigned_trainer_id`) |
| Employee | `employee` | Receptionist, Manager | Desk operations per assigned role permissions |
| Admin | `admin` | Super Admin / Manager | Gym-wide, subject to role permissions |
| System | — | Jobs / hardware ingest | Internal: expiry jobs, gate events, receipt generation |

Capability legend used in screens (backend must enforce the same):

| Code | Meaning |
| :---: | :--- |
| **F** | Full manage (CRUD / approve) |
| **E** | Create or edit within assigned scope |
| **R** | Read own or assigned-client data |
| **C** | One named action (request freeze, book, mark attendance) |
| **—** | Hidden; API must return 403 / omit from lists |

---

## 5. Cross-cutting platform (`API`)

### 5.1 Conventions

| ID | Requirement |
| :--- | :--- |
| FR-API-001 | Every mutating and sensitive-read call requires an authenticated principal except login, password-reset request, and hardware ingest authenticated by a device credential. |
| FR-API-002 | Authorization is permission-based (`module` + `action`) plus row-level ownership (self / assigned trainer / gym-wide). Role name alone is not sufficient. |
| FR-API-003 | List endpoints support pagination (`limit`, `cursor` or `offset`), sort, and documented filters. Default page size is configurable in `gym_settings`. |
| FR-API-004 | All timestamps persist in UTC. The API accepts and returns ISO-8601. Display timezone is `gym_settings` (`general.timezone`). |
| FR-API-005 | Money uses a minor-unit integer **or** a decimal with a fixed scale, never a float. Currency comes from gym settings. |
| FR-API-006 | Mutations that change membership, schedule, payment, plan, or measurement state write a history row in the same transaction. Silent overwrite is forbidden. |
| FR-API-007 | Admin (and other privileged) mutations write `audit_logs` with actor, action, entity, before/after JSON, IP, timestamp. |
| FR-API-008 | Idempotency: `POST` for payments, check-in, booking, and freeze request accept an `Idempotency-Key`. Replay of the same key + same body returns the original result. |
| FR-API-009 | Optimistic concurrency: update/delete of versioned or high-contention rows (`schedules`, `memberships`, `payments`, plans) require an `updated_at` or version token; mismatch returns 409. |
| FR-API-010 | Soft constraints: users, products, exercises, foods, facilities, and types are deactivated (`status` / `is_active`), not hard-deleted, when referenced by history. |
| FR-API-011 | Error body is uniform: `code`, `message`, `details[]`, `request_id`. Do not leak stack traces. |
| FR-API-012 | Domain events (membership expiring, payment recorded, session cancelled, freeze pending, …) are published in-process or via a queue so Notifications can consume them. The producer does not send push itself. |
| FR-API-013 | File bytes never live in the relational row. Tables store `file_url` (or object key). Access is via short-lived signed URLs (see Media). |
| FR-API-014 | Search is case-insensitive on name, email, phone, membership number, invoice number. |

### 5.2 Standard error codes

| HTTP | `code` | When |
| :---: | :--- | :--- |
| 400 | `validation_error` | Field/schema failure |
| 401 | `unauthenticated` | Missing or expired session |
| 403 | `forbidden` | Permission or row-scope failure |
| 404 | `not_found` | Unknown id (or hidden by scope — do not leak existence of out-of-scope rows to Member/Trainer) |
| 409 | `conflict` | Version mismatch, double booking, duplicate membership number |
| 422 | `business_rule` | Freeze quota exceeded, class full, PT sessions exhausted, membership inactive |
| 429 | `rate_limited` | Login / check-in / broadcast abuse |

---

## 6. Identity & session (`AUTH`)

**Entities:** `users`

### 6.1 Data

| Field | Rules |
| :--- | :--- |
| `email` | Unique when present; required for staff/admin; member may use phone as primary identifier |
| `phone_number` | Unique when present; E.164 |
| `password_hash` | Never returned. Password set on create or invite |
| `user_type` | `member` \| `trainer` \| `employee` \| `admin` |
| `status` | `active` \| `inactive` \| `suspended` |

### 6.2 Requirements

| ID | Requirement |
| :--- | :--- |
| FR-AUTH-001 | Login with email **or** phone + password. Success returns a session (access token + refresh token, or equivalent) and the principal: `user_id`, `user_type`, role, permission slugs, profile id. |
| FR-AUTH-002 | Reject login when `status` is not `active`. Message must not distinguish “unknown user” vs “wrong password”. |
| FR-AUTH-003 | Logout revokes the current session (and optionally all sessions). |
| FR-AUTH-004 | Refresh rotates the refresh credential. Reuse of a rotated refresh token revokes the family. |
| FR-AUTH-005 | Change-password requires current password. Completes by invalidating other sessions. |
| FR-AUTH-006 | Password-reset: request by email/phone; time-limited one-time token; consume once. |
| FR-AUTH-007 | `GET /me` returns the current user + role profile summary (member/trainer/employee) used by every app header. |
| FR-AUTH-008 | Creating a person (member/trainer/employee/admin) always creates a `users` row first, then the role-profile row, in one transaction. |
| FR-AUTH-009 | One `users` row has **at most one** of `members`, `trainers`, `employees`. `user_type` must match that profile. Super Admin may exist as `admin` without an employee row. |
| FR-AUTH-010 | Suspend / deactivate is Admin-only (`users.update` + `users.suspend`). Suspended users cannot authenticate. Existing tokens are revoked. |

### 6.3 Business rules

| ID | Rule |
| :--- | :--- |
| BR-AUTH-001 | Email and phone uniqueness is gym-global. |
| BR-AUTH-002 | Member self-service may update email/phone on profile; uniqueness still applies. |
| BR-AUTH-003 | Failed login attempts are rate-limited per identifier and per IP. |

---

## 7. RBAC (`RBAC`)

**Entities:** `roles`, `permissions`, `role_permissions`

### 7.1 Permission model

A permission is `module` + `action` with a stable `slug` (example: `memberships.approve`).

Canonical actions: `create`, `read`, `update`, `delete`, `approve`, `export`, `broadcast`.

### 7.2 System roles (seed)

| Role | Notes |
| :--- | :--- |
| Super Admin | All permissions. `is_system_role = true`. Cannot be deleted. |
| Manager | Gym-wide operations except destructive system-role edits |
| Receptionist | Members, memberships, POS, attendance override, schedules; no settings/roles |
| Trainer | Assigned-client + own calendar/plans |
| Member | Self only |

### 7.3 Requirements

| ID | Requirement |
| :--- | :--- |
| FR-RBAC-001 | List / get roles and their permissions. Super Admin (or `roles.read`) only for the matrix editor. |
| FR-RBAC-002 | Create custom roles. Clone from an existing role. |
| FR-RBAC-003 | Attach/detach permissions on a non-system role. System roles: permission set is immutable except by Super Admin, and only if explicitly allowed later; MVP: system roles are read-only. |
| FR-RBAC-004 | Assign exactly one role to an employee (Staff Directory). Trainer and Member have implied roles matching `user_type`; Admin may still attach a named role for employees who also train (MVP: keep `user_type` single). |
| FR-RBAC-005 | Seed the permission catalog from modules in §3. Unknown slugs are rejected. |
| FR-RBAC-006 | `GET /me` includes the resolved permission slug list so the client can hide chrome; **server still enforces**. |

### 7.4 Default permission matrix (MVP)

| Module | Member | Trainer | Receptionist | Manager / Admin |
| :--- | :---: | :---: | :---: | :---: |
| Own profile | E | E | E | F |
| Other member profile | — | R assigned | F | F |
| Health | E self | R assigned | F | F |
| Memberships | R self + C freeze/book pay | R assigned | F | F |
| Packages | R active catalog | — | F | F |
| Schedule | R/C self | E assigned | F | F |
| Attendance | C pass + R self | E session + R assigned | F | F |
| Payments | R self + C self-pay | R assigned summary | F | F |
| Workout / diet plans | R assigned + E live/log | E clients | R | F templates |
| Goals / measurements | R/E as screens | E assigned | F | F |
| Notifications | R self | R self + C assigned | R | F broadcast |
| Staff / roles / settings / audit | — | — | — | F |
| Reports | — | R own PT | R limited | F |

---

## 8. People & profiles (`PEOPLE`)

**Entities:** `members`, `trainers`, `employees`  
**Screens:** Profile, Edit Profile, Members Directory, Member Dossier, Staff Directory, My Trainer

### 8.1 Member

| ID | Requirement |
| :--- | :--- |
| FR-PEOPLE-001 | Admin creates a member (onboarding wizard): user + member profile + optional photo + waiver document + emergency contact, one transaction. **MVP carve-out (Vertical 3):** OpenAPI multi-step — `POST /members` creates user+profile only; emergency contact, waiver/photo media are follow-up routes (not one mega-TX). |
| FR-PEOPLE-002 | `membership_number` is unique, immutable after issue, generated by the backend. |
| FR-PEOPLE-003 | Member directory (Admin): search name/phone/email/number; filter `users.status`, membership status, assigned trainer, joined-date range; export if `members.export`. |
| FR-PEOPLE-004 | Trainer “My Members”: only rows where `assigned_trainer_id` = current trainer. Same search/filter subset (goal, plan status, expiry, attendance frequency). |
| FR-PEOPLE-005 | Member dossier (get-by-id) returns profile plus links/counts: membership, health flags, attendance last check-in, outstanding balance, active workout/diet, next schedule. Payload is **scoped** by role. |
| FR-PEOPLE-006 | Member may update: phone, email, address, photo. May **not** update: membership_number, joined_date, assigned_trainer_id, notes, status. |
| FR-PEOPLE-007 | Admin may update all member fields including `assigned_trainer_id`, `notes`, `joined_date`. Reassigning trainer writes audit + notifies both trainers. |
| FR-PEOPLE-008 | Trainer capacity: assigning a client when `trainers.max_clients_capacity` is set and current assigned active members ≥ capacity returns 422 unless Admin overrides with reason. |

### 8.2 Trainer

| ID | Requirement |
| :--- | :--- |
| FR-PEOPLE-009 | Admin CRUD trainers: bio, specializations, hourly_rate, max_clients_capacity, is_active, user credentials. |
| FR-PEOPLE-010 | Public/member “My Trainer” returns assigned trainer: name, bio, specializations, rating, working hours (from availability). No hourly_rate, no other clients. |
| FR-PEOPLE-011 | Trainer self-edit: phone, emergency contacts, photo, bio, credentials text. Cannot edit hourly_rate or capacity. |
| FR-PEOPLE-012 | Trainer directory lists load (assigned active member count), status, specializations. |
| FR-PEOPLE-013 | Deactivating a trainer (`is_active=false`) blocks new bookings; existing future schedules remain until Admin reassigns or cancels. |

### 8.3 Employee

| ID | Requirement |
| :--- | :--- |
| FR-PEOPLE-014 | Admin CRUD employees: job_title, department, hire_date, emergency_contact, status (`active`, `on_probation`, `suspended`, `terminated`). |
| FR-PEOPLE-015 | Assign role (FR-RBAC-004) from employee profile. |
| FR-PEOPLE-016 | Terminated / suspended employees cannot authenticate. |

### 8.4 Business rules

| ID | Rule |
| :--- | :--- |
| BR-PEOPLE-001 | `assigned_trainer_id` must reference an active trainer. |
| BR-PEOPLE-002 | Member cannot read another member’s profile. |
| BR-PEOPLE-003 | Trainer cannot read an unassigned member (404). |
| BR-PEOPLE-004 | Profile photo change sets `member_photos.is_current_avatar` (or trainer equivalent via user avatar on `member_photos` / trainer profile photo URL). |

---

## 9. Health & medical (`HEALTH`)

**Entities:** `member_health`, `health_conditions`, `medical_histories`, `emergency_contacts`, `member_documents`, `member_photos`

Health data is **sensitive**. Extra audit on Admin reads of medical rows is required (FR-HEALTH-010).

| ID | Requirement |
| :--- | :--- |
| FR-HEALTH-001 | Member health is upsert-by-member: blood group, height, baseline weight, allergies, dietary preferences, physician. One current row per member. |
| FR-HEALTH-002 | Member and Admin may write health; Trainer is read-only for assigned clients. |
| FR-HEALTH-003 | `health_conditions` is an Admin-maintained catalog (Asthma, Hypertension, Diabetes, …) with `risk_level` and `contraindications`. |
| FR-HEALTH-004 | Medical history items: title, description, optional `condition_id`, diagnosed_date, clearance_status, document_url. Member creates own; Admin full; Trainer read assigned. |
| FR-HEALTH-005 | Emergency contacts hang off `user_id` (members **and** staff). At most one `is_primary=true` per user. Member/Admin write; Trainer read assigned member contacts. |
| FR-HEALTH-006 | Member documents: types `id_proof`, `waiver`, `medical_cert` (extensible). Upload via Media. Admin may verify (`verified_by_user_id`, `verified_at`). Trainer may read medical_cert / waiver for assigned clients, not identity proofs unless Admin grants later (MVP: trainer sees health-clearance docs only). |
| FR-HEALTH-007 | Member photos: gallery + current avatar flag. Used by attendance feed for visual verify. |
| FR-HEALTH-008 | Dossier health summary includes: allergies, high-risk conditions, uncleared medical items, primary emergency contact. |
| FR-HEALTH-009 | Admin CRUD on `health_conditions`. |
| FR-HEALTH-010 | Every Admin read/write of `member_health` and `medical_histories` writes `audit_logs`. |

### 9.1 Business rules

| ID | Rule |
| :--- | :--- |
| BR-HEALTH-001 | Trainer must not receive identity-proof files in API responses. |
| BR-HEALTH-002 | Unverified medical_cert does not block check-in in MVP unless `gym_settings.attendance.require_medical_clearance` is true. |

---

## 10. Memberships & products (`MEMB`)

**Entities:** `membership_products`, `memberships`, `membership_freezes`, `membership_extensions`, `membership_histories`

### 10.1 Product catalog

| ID | Requirement |
| :--- | :--- |
| FR-MEMB-001 | Admin CRUD membership products: name, code (unique), description, duration_days, base_price, tax_percentage, max_freeze_days, pt_sessions_included, access_facilities JSON, is_active. |
| FR-MEMB-002 | Member catalog lists **active** products only. Trainer has no catalog API. |
| FR-MEMB-003 | Archiving (`is_active=false`) hides the product from sales; existing memberships keep their product snapshot of terms via history, not by mutating past contracts. |
| FR-MEMB-004 | Product detail for Admin includes active subscriber count. |

### 10.2 Membership contract

| Field | Meaning |
| :--- | :--- |
| `status` | `active` \| `expired` \| `frozen` \| `cancelled` |
| `remaining_pt_sessions` | Decremented on completed PT attendance (see SCHED/ATTN) |
| `locker_number` | Optional; unique among **active** memberships |
| `auto_renew` | Flag; actual charging is Admin/POS or later gateway |

| ID | Requirement |
| :--- | :--- |
| FR-MEMB-005 | Assign membership: Admin selects member + product + start_date. Backend computes `end_date = start_date + duration_days` (freeze later extends). Sets `remaining_pt_sessions = product.pt_sessions_included`. Status `active`. History action `created`. |
| FR-MEMB-006 | A member may have **at most one** `active` or `frozen` membership. Assigning another requires the current one to be expired/cancelled, or an explicit upgrade/renew flow. |
| FR-MEMB-007 | Member and assigned trainer may read the current contract (plan name, dates, remaining days, remaining PT, access facilities, locker for member/admin only). Trainer does not see pricing. |
| FR-MEMB-008 | Admin directory: filter Active / Expiring (7/15/30 days) / Expired / Frozen / Cancelled. |
| FR-MEMB-009 | Renew: Admin (or member self-pay success) creates a continuation. If current is still active, new start is day after current end (or configurable overlap). History `renewed`. PT sessions add or reset per product rule (default: **add** remaining + new included). |
| FR-MEMB-010 | Upgrade: Admin switches product; writes history `upgraded` with old/new end dates and product ids in notes/payload. |
| FR-MEMB-011 | Cancel: Admin only. Status `cancelled`. History `cancelled`. Does not auto-refund (refund is PAY). |
| FR-MEMB-012 | Expiry job: when `end_date < today` (gym TZ) and status `active`, set `expired`, history `expired`, emit `membership_expiry`. Frozen memberships do not expire until freeze ends and remaining days elapse. |
| FR-MEMB-013 | Membership history list is chronological and immutable to clients (append-only). |

### 10.3 Freeze

| ID | Requirement |
| :--- | :--- |
| FR-MEMB-014 | Member submits freeze request: start_date, end_date, reason. Status `pending`. Notify Admin. |
| FR-MEMB-015 | Admin approve / reject. Approve: status `approved`, membership `frozen`, `end_date` shifted by approved days, history `frozen`. Reject: status `rejected`, membership unchanged. |
| FR-MEMB-016 | Admin may create a freeze directly (already approved). |
| FR-MEMB-017 | Freeze days count toward `product.max_freeze_days` (sum of approved freeze days on this membership). Exceeding quota → 422. |
| FR-MEMB-018 | Overlapping freezes on the same membership are rejected. |
| FR-MEMB-019 | Freeze end job: on `end_date`, membership returns `active` if still within (shifted) contract dates, else `expired`. |

### 10.4 Extension

| ID | Requirement |
| :--- | :--- |
| FR-MEMB-020 | Admin grants extension: `days_extended`, reason. Adds days to `end_date`. History row. Member cannot self-extend. |

### 10.5 Business rules

| ID | Rule |
| :--- | :--- |
| BR-MEMB-001 | Bookings and gate check-in require membership `active` (frozen members cannot check in or book unless settings allow “frozen view-only”). |
| BR-MEMB-002 | Grace period (`gym_settings.membership.grace_period_days`) keeps access after `end_date` without changing status until grace elapses; then expire. |
| BR-MEMB-003 | Renewal reminder events fire at thresholds in settings (e.g. 14 and 7 days). |
| BR-MEMB-004 | `locker_number` conflict → 409. |

---

## 11. Scheduling & availability (`SCHED`)

**Entities:** `schedule_types`, `facilities`, `schedules`, `schedule_participants`, `trainer_availabilities`, `schedule_histories`

### 11.1 Masters

| ID | Requirement |
| :--- | :--- |
| FR-SCHED-001 | Admin CRUD `schedule_types` (1-on-1 PT, Studio Class, Open Gym Slot): name, color_code, default_duration_minutes, requires_trainer. |
| FR-SCHED-002 | Admin CRUD `facilities`: name, capacity, location_details, is_active. Inactive rooms cannot take new schedules. |

### 11.2 Availability

| ID | Requirement |
| :--- | :--- |
| FR-SCHED-003 | Trainer sets recurring weekly windows (`day_of_week` 0–6, start/end, `is_recurring=true`) and date-specific overrides (`override_date`, `is_available` true/false for block-outs). |
| FR-SCHED-004 | Admin may edit any trainer’s availability. |
| FR-SCHED-005 | Member slot picker returns **open** intervals: trainer available, no overlapping booked schedule, within booking lead-time, membership allows PT. |
| FR-SCHED-006 | Availability matrix (Admin): all trainers × day, booked vs free. |

### 11.3 Schedules

| `schedules.status` | Meaning |
| :--- | :--- |
| `scheduled` | Future or not yet started |
| `ongoing` | Started |
| `completed` | Ended / closed |
| `cancelled` | Cancelled |

| ID | Requirement |
| :--- | :--- |
| FR-SCHED-007 | Create schedule: type, facility, optional trainer (required if type.requires_trainer), title, start/end, max_capacity (default facility.capacity), notes. Admin: any; Trainer: self as trainer + assigned member as participant; Member: self-book into an existing class **or** create PT booking per settings. |
| FR-SCHED-008 | Recurring class series: Admin may create N occurrences (same weekday/time). Each occurrence is its own `schedules` row with a shared `series_id` (add column if missing — see §19). Cancel-one vs cancel-series. |
| FR-SCHED-009 | Edit: time, trainer substitute, facility, capacity, notes. Capacity cannot drop below current booked count. History `updated` / `rescheduled`. |
| FR-SCHED-010 | Cancel schedule: status `cancelled`; participants `cancelled`; history; notify participants. PT sessions are **not** consumed. |
| FR-SCHED-011 | Calendar queries: Member = own participations; Trainer = own trainer_id; Admin = all. Filters: date range, type, facility, trainer, status. |
| FR-SCHED-012 | Detail includes roster: participant, booking_status, attended, member avatar. |

### 11.4 Participants & waitlist

| `booking_status` | Meaning |
| :--- | :--- |
| `booked` | Holds a seat |
| `waitlisted` | Ordered waitlist |
| `cancelled` | Released |

| ID | Requirement |
| :--- | :--- |
| FR-SCHED-013 | Book: if booked_count < max_capacity → `booked`; else if waitlist enabled → `waitlisted`; else 422 `class_full`. |
| FR-SCHED-014 | Member cancel own booking if now < start − `cancellation_cutoff`. After cutoff: 422 unless Admin overrides. |
| FR-SCHED-015 | On booked cancel, promote first waitlisted to `booked` and notify. |
| FR-SCHED-016 | PT booking requires remaining_pt_sessions > 0 (or Admin override). Decrement happens on **session attendance complete**, not on book (BR-SCHED-003). |
| FR-SCHED-017 | Double-book same member overlapping time → 409. Double-book same trainer overlapping → 409. Facility overlap when capacity is 1 (or exclusive rooms) → 409. |
| FR-SCHED-018 | Member max concurrent future bookings: `gym_settings.schedule.max_booking_slots_per_member`. |
| FR-SCHED-019 | Booking lead time: cannot book closer than `min_lead_minutes` or further than `max_lead_days`. |
| FR-SCHED-020 | Trainer marks session start (`ongoing`) and complete (`completed`). History `attendance` / `completed`. |
| FR-SCHED-021 | Schedule history is append-only: created, updated, rescheduled, cancelled, attendance marked. |

### 11.5 Business rules

| ID | Rule |
| :--- | :--- |
| BR-SCHED-001 | Frozen or expired members cannot book. |
| BR-SCHED-002 | Inactive trainers cannot be assigned to new schedules. |
| BR-SCHED-003 | `remaining_pt_sessions` decrements when a PT participant is marked `attended=true` on a completed/ongoing PT schedule; increment back if attendance is cleared by Admin. |
| BR-SCHED-004 | Waitlist order is FIFO by `booked_at`. |

---

## 12. Attendance (`ATTN`)

**Entities:** `attendances`, `attendance_histories`  
Session attendance also updates `schedule_participants.attended` (SCHED). Keep gate attendance and session attendance distinct.

### 12.1 Gate check-in / out

| ID | Requirement |
| :--- | :--- |
| FR-ATTN-001 | Create attendance: `user_id`, `check_in_time`, `method` (`qr_code` \| `rfid` \| `biometric` \| `manual_override`), optional `gate_identifier`. |
| FR-ATTN-002 | Member digital pass: backend issues a short-lived signed token / rotating code bound to `user_id` + membership_number. Gate validates token, then FR-ATTN-001. |
| FR-ATTN-003 | Hardware ingest (RFID/biometric) authenticates with a device credential, maps hardware id → `user_id`, then FR-ATTN-001. |
| FR-ATTN-004 | Manual override: Admin/Receptionist; requires `verified_by_user_id`. |
| FR-ATTN-005 | Check-out: update open attendance (`check_out_time` null). Auto-checkout job after `gym_settings.attendance.auto_checkout_minutes`. |
| FR-ATTN-006 | Reject check-in when membership not entitled (BR-MEMB-001), user not `active`, or daily max check-ins exceeded. |
| FR-ATTN-007 | Open check-in already exists → 409 (or treat as checkout if settings `toggle_on_second_scan=true`). |
| FR-ATTN-008 | Member history: own rows. Trainer: assigned members. Admin: all, filter date, user_type, gate. Live “today’s feed” is the same query with `check_in_time` today, newest first. |
| FR-ATTN-009 | Member summary: visit count, streak, last check-in, calendar heatmap for a month. |
| FR-ATTN-010 | Nightly job upserts `attendance_histories` for the date: total_member_checkins, total_trainer_checkins, peak_hour, peak_count. |

### 12.2 Session attendance (trainer)

| ID | Requirement |
| :--- | :--- |
| FR-ATTN-011 | Trainer/Admin sets `schedule_participants.attended` and `marked_at` (present / no-show). Does **not** by itself create a gate `attendances` row. |
| FR-ATTN-012 | Marking present on PT applies BR-SCHED-003. |

### 12.3 Business rules

| ID | Rule |
| :--- | :--- |
| BR-ATTN-001 | Trainers and employees may check in at the gate (staff clock). Staff do not need a membership. |
| BR-ATTN-002 | Occupancy = count of rows with check-in today and null checkout (minus auto-closed). |
| BR-ATTN-003 | Duplicate hardware events within a debounce window (settings, default 60s) are ignored via idempotency. |

---

## 13. Billing & payments (`PAY`)

**Entities:** `payment_methods`, `payments`, `payment_receipts`, `payment_histories`

`payments` is the **invoice + settlement** record (one row may be paid in installments via history).

| `payments.status` | Meaning |
| :--- | :--- |
| `pending` | Issued, nothing collected |
| `partial` | `amount_paid` < `total_amount` |
| `paid` | Settled |
| `refunded` | Fully refunded (partial refund keeps `partial` or a dedicated `partially_refunded` — MVP: history rows + status `refunded` only when amount_paid net ≤ 0) |

### 13.1 Requirements

| ID | Requirement |
| :--- | :--- |
| FR-PAY-001 | Admin CRUD `payment_methods` (Cash, Card, UPI, Bank Transfer): `is_digital`, `is_active`. Inactive methods cannot be used on new payments. |
| FR-PAY-002 | Record payment / POS: member_id, optional membership_id / product to assign, line amounts: subtotal, tax_amount, discount_amount, total_amount, amount_paid, payment_method_id, transaction_reference, cashier_user_id. Backend generates unique `invoice_number`. |
| FR-PAY-003 | Split tender: multiple methods on one invoice via `payment_histories` rows (`payment_received` each) summing to `amount_paid`. |
| FR-PAY-004 | Discount requires permission `payments.discount` (Manager/Admin). Receptionist discount may be capped in settings. |
| FR-PAY-005 | Tax = round(subtotal × product or gym tax %). Client-supplied tax is ignored; server computes. |
| FR-PAY-006 | If POS includes a new/renew membership, run MEMB assign/renew **in the same transaction** after payment row is `paid` or accepted `partial` per policy (default: membership activates only when `paid` unless settings allow partial). |
| FR-PAY-007 | Member self-pay: creates/settles own outstanding invoice via digital method; `cashier_user_id` null. Gateway webhook marks paid idempotently. |
| FR-PAY-008 | Ledger: Admin all; Member own; Trainer assigned-member **summary** (has_outstanding boolean, last paid date) — no full line items. |
| FR-PAY-009 | Outstanding dues: `status in (pending, partial)` and remaining > 0. Admin list filterable; Member sees own with pay-now. |
| FR-PAY-010 | Payment detail: invoice, taxes, discount, method, cashier, membership link, history of receipts/refunds/adjustments. |
| FR-PAY-011 | On paid (and on each collection), generate `payment_receipts` (`receipt_number`, pdf url via Media). Member download; Admin print/share. |
| FR-PAY-012 | Refund / adjust: Admin; history action `refunded` / `adjusted`; update amounts and status; audit. Refund cannot exceed net paid. |
| FR-PAY-013 | Daily collection and method breakdown queries for dashboard/reports. |
| FR-PAY-014 | Invoice numbers and receipt numbers are monotonic per gym and never reused. |

### 13.2 Business rules

| ID | Rule |
| :--- | :--- |
| BR-PAY-001 | `total_amount = subtotal + tax_amount − discount_amount` (≥ 0). |
| BR-PAY-002 | `amount_paid` ≤ `total_amount` except adjustments documented in history. |
| BR-PAY-003 | Member cannot edit historical payments. |
| BR-PAY-004 | Trainer never sees other trainers’ or gym-wide revenue. |

---

## 14. Workout management (`WORK`)

**Entities:** `exercises`, `workout_plans`, `workout_plan_versions`, `workout_plan_exercises`, `workout_sessions`, `workout_session_exercises`

**Template rule:** `is_template = true` and `member_id` null → gym master. Assigned plans have `member_id` set and `is_template = false`.

### 14.1 Exercise library

| ID | Requirement |
| :--- | :--- |
| FR-WORK-001 | Admin CRUD exercises: name, primary_muscle_group, secondary_muscles, equipment_needed, instructions, video_url, gif_url, difficulty_level, is_active. |
| FR-WORK-002 | Member/Trainer search/browse active exercises (muscle, equipment, difficulty). Detail includes media URLs. |

### 14.2 Plans & versions

| ID | Requirement |
| :--- | :--- |
| FR-WORK-003 | Trainer creates a plan for an assigned member, or a personal draft. Admin creates templates and any member plan. |
| FR-WORK-004 | Plan fields: title, description, target_goal, difficulty, duration_weeks, status `draft` \| `active` \| `archived`. |
| FR-WORK-005 | Plan exercises attach to **`workout_plan_version_id`** (not the plan root): day_number, exercise_id, order_index, target_sets, target_reps, target_weight_kg, rest_seconds, notes. |
| FR-WORK-006 | Publishing draft → `active`. A member may have multiple archived plans but **one** `active` assigned plan (MVP). Activating another archives the previous. |
| FR-WORK-007 | Editing an `active` plan writes `workout_plan_versions` (version_number++, changelog) **before** mutating exercises. Member-facing reads use current version. |
| FR-WORK-008 | Assign template → copy to a new member plan (not a live alias). Copy includes exercises. |
| FR-WORK-009 | Member lists own assigned/archived. Trainer lists clients + drafts. Admin lists templates + all. |
| FR-WORK-010 | Member cannot mutate plan structure. |

### 14.3 Live session & history

| ID | Requirement |
| :--- | :--- |
| FR-WORK-011 | Member (or trainer coaching) starts a session: optional workout_plan_id, trainer_id, started_at. Status implicit via completed_at null. |
| FR-WORK-012 | Log sets: exercise_id, set_number, reps_completed, weight_lifted_kg, rpe_score, is_completed. |
| FR-WORK-013 | Complete session: completed_at, duration_minutes, total_volume_kg (server-computed Σ reps×weight), client_feedback_rating, notes. |
| FR-WORK-014 | Only one in-progress session per member. |
| FR-WORK-015 | Workout history: sessions for member (self / assigned / all). Include volume and PRs (max weight per exercise). |
| FR-WORK-016 | Admin has **no** live tracker endpoint requirement (screen “—”); Admin still reads history. |

### 14.4 Business rules

| ID | Rule |
| :--- | :--- |
| BR-WORK-001 | Trainer may only mutate plans where `member_id` is assigned to them, or drafts they created. |
| BR-WORK-002 | Templates are Admin-owned; trainers may **copy** templates to clients, not edit the master (unless permission `workout_templates.update`). |
| BR-WORK-003 | `Entities-List.md` “Workout History” is **not** a separate table; it is `workout_sessions` + version log. |

---

## 15. Diet & nutrition (`DIET`)

**Entities:** `foods`, `diet_plans`, `diet_plan_versions` *(added — see §19)*, `diet_plan_meals`, `diet_plan_foods`, `diet_histories`

Mirrors Workout: templates vs assigned, version on edit, member logs adherence.

| ID | Requirement |
| :--- | :--- |
| FR-DIET-001 | Admin CRUD foods: name, serving_unit, serving_size, calories, protein/carbs/fat/fiber grams, is_verified. Member/Trainer browse verified+active. |
| FR-DIET-002 | Create diet plan: title, member_id or template, trainer_id, daily_calorie_target, protein/carbs/fat targets, status. |
| FR-DIET-003 | Meals attach to **`diet_plan_version_id`**: meal_name, scheduled_time, target_calories, notes. Foods: food_id, quantity, serving_unit. Server can compute meal calories from foods. |
| FR-DIET-004 | One active assigned diet per member (MVP). Template copy-on-assign. |
| FR-DIET-005 | Edit of active plan writes `diet_plan_versions` (changelog, version_number) before mutating meals/foods. |
| FR-DIET-006 | Member daily log `diet_histories`: logged_date (unique per member), diet_plan_id, total_calories_consumed, adherence_score, water_intake_ml, member_notes. Upsert by date. |
| FR-DIET-007 | Trainer reads assigned clients’ logs; Admin all; Member own. |
| FR-DIET-008 | Member cannot mutate plan structure; can only write diet_histories. |

### 15.1 Business rules

| ID | Rule |
| :--- | :--- |
| BR-DIET-001 | `adherence_score` may be client-supplied or computed (calories vs target). If computed, document formula in settings (`diet.adherence_formula`). |
| BR-DIET-002 | Unverified foods are hidden from Member pickers unless Admin marks verified. |

---

## 16. Goals, progress & measurements (`GOAL`)

**Entities:** `goal_metrics`, `goals`, `goal_histories`, `measurements`, `measurement_values`, `progress_photos`, `progress_notes`

`Entities-List.md` “Measurement Type” = `goal_metrics`. “Measurement History” = `measurement_values` (plus parent `measurements`). “Goal Version / History” = `goal_histories`.

### 16.1 Metrics & goals

| ID | Requirement |
| :--- | :--- |
| FR-GOAL-001 | Admin CRUD `goal_metrics`: name, unit_of_measure (`kg`, `lbs`, `cm`, `in`, `%`), category (`body_composition`, `circumference`, `strength`), is_active. |
| FR-GOAL-002 | Trainer/Admin create/edit goals for a member: metric_id, baseline_value, target_value, current_value, start_date, target_date, status `in_progress` \| `achieved` \| `abandoned`. |
| FR-GOAL-003 | Member reads own goals; may not create in MVP (screen: Member **R**, Trainer **E**). |
| FR-GOAL-004 | Recording a measurement that matches a goal metric appends `goal_histories` and updates `goals.current_value`. If current meets target (direction depends on baseline vs target), status → `achieved`. |
| FR-GOAL-005 | Manual goal check-in: recorded_value, recorded_date, notes. |

### 16.2 Measurements

| ID | Requirement |
| :--- | :--- |
| FR-GOAL-006 | Create measurement session: member_id, recorded_by_user_id, recorded_at, notes + array of `{metric_id, value}`. Member and assigned trainer may create; Admin any. |
| FR-GOAL-007 | History: sessions + values, charts by metric over time. Scope: self / assigned / all. |
| FR-GOAL-008 | Settings may mark metrics mandatory per session; missing mandatory → 422. |

### 16.3 Photos & notes

| ID | Requirement |
| :--- | :--- |
| FR-GOAL-009 | Progress photos: pose `front` \| `side` \| `back`, taken_date, is_private, photo_url. Member upload own. Trainer **read** assigned (even if private). Admin moderate (delete / hide). |
| FR-GOAL-010 | Comparison query: two dates × poses for a member. |
| FR-GOAL-011 | Progress notes: `note_type` `member_note` \| `trainer_assessment`. Author is current user. Member writes member_note; trainer writes trainer_assessment on assigned; Admin both. List is a single chronological stream. |
| FR-GOAL-012 | Private photos never appear in Admin “vault” lists for users without `progress_photos.moderate`. Super Admin has it. |

### 16.4 Business rules

| ID | Rule |
| :--- | :--- |
| BR-GOAL-001 | Trainer cannot write notes or measurements for unassigned members. |
| BR-GOAL-002 | Member cannot read another member’s photos/notes. |
| BR-GOAL-003 | Goal `current_value` is denormalized; source of truth for charts is histories + measurement_values. |

---

## 17. Notifications & devices (`NOTIF`)

**Entities:** `notification_types`, `notifications`, `user_devices`, `notification_deliveries`

### 17.1 Types & automation

Seed `type_code` values: `membership_expiry`, `session_reminder`, `payment_due`, `announcement`, `freeze_pending`, `booking_confirmed`, `booking_cancelled`, `session_waitlist_promoted`, `trainer_assigned`, `broadcast`.

| ID | Requirement |
| :--- | :--- |
| FR-NOTIF-001 | Admin CRUD notification types and `template_text` with placeholders. |
| FR-NOTIF-002 | Domain events in §5 create a `notifications` row + `notification_deliveries` per recipient. |
| FR-NOTIF-003 | Automation toggles live in `gym_settings` (category `notification`): expiry, dues, birthdays, session reminders (offset minutes). |

### 17.2 Inbox, devices, broadcast

| ID | Requirement |
| :--- | :--- |
| FR-NOTIF-004 | Inbox: deliveries for current user, newest first, unread count. Mark read (`is_read`, `read_at`). Mark all read. |
| FR-NOTIF-005 | Detail includes title, message, `data_payload` (entity type/id for deep link). |
| FR-NOTIF-006 | Register / rotate / delete `user_devices` (device_token, platform `ios` \| `android` \| `web`, last_active_at). Unregister on logout. |
| FR-NOTIF-007 | Dispatcher sends push to registered devices; records `delivered_at` or failure on the delivery row. |
| FR-NOTIF-008 | Admin broadcast: audience `all_members` \| `expiring_members` \| `all_trainers` \| `staff` \| `user_ids[]`. Creates one notification + N deliveries. Permission `notifications.broadcast`. |
| FR-NOTIF-009 | Trainer broadcast: **assigned clients only**. Audience user_ids not assigned → 403. |
| FR-NOTIF-010 | Broadcast history (Admin): sent list, delivery counts, timestamps. |
| FR-NOTIF-011 | Admin may list all deliveries for support; Member/Trainer only self. |

### 17.3 Business rules

| ID | Rule |
| :--- | :--- |
| BR-NOTIF-001 | Do not notify deactivated users. |
| BR-NOTIF-002 | Session reminder is skipped if schedule is cancelled. |
| BR-NOTIF-003 | Duplicate event_id + type + user must not create two deliveries (idempotent consumers). |

---

## 18. Dashboard snapshots (`DASH`)

No dedicated tables. Read models composed from other modules. Cache allowed; freshness target ≤ 60s for occupancy/revenue-today.

| ID | Requirement |
| :--- | :--- |
| FR-DASH-001 | **Member home:** membership status + days remaining; today’s schedules; attendance streak / last check-in; today’s workout card (active plan day); next meal; primary goal progress. |
| FR-DASH-002 | **Trainer home:** today’s sessions; assigned member count (active vs inactive); pending tasks (plans to renew, unlogged sessions, measurements due); this-week client milestone count. |
| FR-DASH-003 | **Admin home:** member totals (total/active/inactive/new this month); membership active/expiring/expired; today’s revenue + month collections + receivables; live occupancy + peak; trainers on duty + sessions today; today’s master schedule; expiring 7/14 days; recent payments. |
| FR-DASH-004 | Each widget is a section in one `GET /dashboard` response **or** individually fetchable; unauthorized sections are omitted, not 403 for the whole call. |

---

## 19. Reports & analytics (`RPT`)

Derived queries. Export CSV/PDF when `reports.export`. Trainer only `reports.read_own`.

| ID | Report | Parameters | Metrics (minimum) |
| :--- | :--- | :--- | :--- |
| FR-RPT-001 | Members | date range | acquisition, active vs inactive, churn, demographics (gender/age bucket) |
| FR-RPT-002 | Memberships | date range, product | package mix, avg duration, renewal conversion, freeze count |
| FR-RPT-003 | Attendance | date range | footfall, peak-hour heatmap, avg visit duration, member vs trainer |
| FR-RPT-004 | Payments / revenue | date range | gross, tax, discounts, by method, outstanding aging |
| FR-RPT-005 | Trainers | date range, trainer_id | sessions delivered, ratings, client retention, PT revenue (Admin) |
| FR-RPT-006 | Workouts | date range | most assigned plans, exercise popularity, session completion rate |
| FR-RPT-007 | Diets | date range | plan mix, adherence averages |
| FR-RPT-008 | Progress | date range | goals achieved, aggregate weight change (Admin) |
| FR-RPT-009 | Trainer own slice | implicit trainer | FR-RPT-005 without revenue if not permitted; own sessions + retention only |

| ID | Requirement |
| :--- | :--- |
| FR-RPT-010 | All reports honor gym timezone day boundaries. |
| FR-RPT-011 | Member has no report APIs (only personal summaries in ATTN/GOAL/DASH). |

---

## 20. System configuration & audit (`SYS`)

**Entities:** `gym_settings`, `audit_logs`

### 20.1 Settings

Key/value with `category`: `general`, `membership`, `attendance_gate`, `booking_rules`, `billing`, `workout`, `diet`, `notification`, `measurement`.

| ID | Requirement |
| :--- | :--- |
| FR-SYS-001 | Get settings by category or all. Admin `settings.update`; others may read a **public** subset (operating hours, timezone, units, cancellation cutoff) for client UX. |
| FR-SYS-002 | Upsert by `setting_key`. Validate known keys; reject unknown in MVP (strict catalog). |
| FR-SYS-003 | Seed keys (non-exhaustive): gym name/address/phone/tax id/logo; operating hours; currency; timezone; date format; grace_period_days; max_freeze default; renewal_reminder_days; max_checkins_per_day; auto_checkout_minutes; toggle_on_second_scan; booking lead min/max; cancellation_cutoff_minutes; max_booking_slots_per_member; waitlist_enabled; tax_percentage; discount_cap; default rest timer; weight unit; adherence_formula; mandatory measurement metric ids; notification channel toggles. |
| FR-SYS-004 | Changing settings writes audit_logs. |

### 20.2 Audit

| ID | Requirement |
| :--- | :--- |
| FR-SYS-005 | `audit_logs` is append-only. No update/delete API. |
| FR-SYS-006 | Admin query: filter actor, entity_name, entity_id, action, time range. |
| FR-SYS-007 | Captured for: people, RBAC, memberships, payments, settings, document verify, progress photo moderate, attendance override, schedule cancel/reassign. |

---

## 21. Media & documents (`MEDIA`)

| ID | Requirement |
| :--- | :--- |
| FR-MEDIA-001 | Upload: authenticated user requests an upload slot (content-type, size, purpose). Backend returns a signed PUT and the future object key. |
| FR-MEDIA-002 | Max size and allowed MIME per purpose (avatar, id_proof, waiver, medical_cert, progress_photo, receipt_pdf, exercise_media). |
| FR-MEDIA-003 | Download via short-lived GET URL. Enforce the same row-level rules as the parent entity. |
| FR-MEDIA-004 | Delete: Admin or owner where screens allow; orphan keys are garbage-collected. Receipt PDFs are not deletable by members. |
| FR-MEDIA-005 | Virus/content scan is optional; MVP at least rejects oversize and bad MIME. |

---

## 22. Entity reconciliation

Canonical **physical** tables: [`database-entities.md`](./database-entities.md) (**55 tables**). Product checklist: [`Entities-List.md`](./Entities-List.md). Those two are aligned. Aliases:

| Product name | Physical table |
| :--- | :--- |
| Workout History | `workout_sessions` (no extra table) |
| Measurement Type | `goal_metrics` |
| Measurement History | `measurement_values` |
| Goal Version / History | `goal_histories` |

Line items hang off **versions** (`workout_plan_exercises.workout_plan_version_id`, `diet_plan_meals.diet_plan_version_id`). Recurring classes share `schedules.series_id`.

---

## 23. State machines (summary)

```text
users.status:          active → suspended → active
                       active → inactive
memberships.status:    active ⇄ frozen → active
                       active → expired
                       active|frozen|expired → cancelled
membership_freezes:    pending → approved | rejected
schedules.status:      scheduled → ongoing → completed
                       scheduled|ongoing → cancelled
schedule_participants: booked ⇄ waitlisted → cancelled
                       booked → (attended true/false)
payments.status:       pending → partial → paid
                       pending|partial|paid → refunded (net)
workout/diet plans:    draft → active → archived
goals.status:          in_progress → achieved | abandoned
```

---

## 24. Resource operations (logical API)

Transport-agnostic. Grouped by module. All scoped as in the module text.

### AUTH
- `POST /auth/login` `POST /auth/logout` `POST /auth/refresh`
- `POST /auth/password/change` `POST /auth/password/forgot` `POST /auth/password/reset`
- `GET /me`

### RBAC
- `GET/POST /roles` `GET/PATCH /roles/{id}` `PUT /roles/{id}/permissions`
- `GET /permissions`

### PEOPLE
- `GET/POST /members` `GET/PATCH /members/{id}` `POST /members/{id}/assign-trainer`
- `GET/POST /trainers` `GET/PATCH /trainers/{id}` `GET /trainers/{id}/members`
- `GET/POST /employees` `GET/PATCH /employees/{id}` `PUT /employees/{id}/role` `POST /employees/{id}/status`

### HEALTH
- `GET/PUT /members/{id}/health`
- `GET/POST /health-conditions` `PATCH /health-conditions/{id}`
- `GET/POST /members/{id}/medical-histories` `PATCH/DELETE /members/{id}/medical-histories/{id}`
- `GET/POST /users/{id}/emergency-contacts` `PATCH/DELETE .../{id}`
- `GET/POST /members/{id}/documents` `POST .../{id}/verify` `DELETE .../{id}`
- `GET/POST /members/{id}/photos` `POST .../{id}/avatar`

### MEMB
- `GET/POST /membership-products` `GET/PATCH /membership-products/{id}`
- `GET/POST /memberships` `GET /memberships/{id}` `GET /memberships/{id}/history`
- `POST /memberships/{id}/renew` `POST /memberships/{id}/upgrade` `POST /memberships/{id}/cancel`
- `GET/POST /memberships/{id}/freezes` `POST /freezes/{id}/approve` `POST /freezes/{id}/reject`
- `POST /memberships/{id}/extensions`

### SCHED
- `GET/POST /schedule-types` `GET/POST /facilities`
- `GET/PUT /trainers/{id}/availability`
- `GET/POST /schedules` `GET/PATCH /schedules/{id}` `POST /schedules/{id}/cancel`
- `POST /schedules/{id}/participants` `DELETE /schedules/{id}/participants/{id}`
- `POST /schedules/{id}/start` `POST /schedules/{id}/complete`
- `GET /schedules/{id}/history`

### ATTN
- `GET /attendance/pass` `POST /attendances/check-in` `POST /attendances/{id}/check-out`
- `GET /attendances` `GET /attendances/summary`
- `POST /schedules/{id}/participants/{id}/mark`
- `GET /attendance-histories`

### PAY
- `GET/POST /payment-methods`
- `GET/POST /payments` `GET /payments/{id}` `GET /payments/outstanding`
- `POST /payments/{id}/refund` `POST /payments/{id}/adjust`
- `GET /payments/{id}/receipt`

### WORK
- `GET/POST /exercises` `GET/PATCH /exercises/{id}`
- `GET/POST /workout-plans` `GET/PATCH /workout-plans/{id}` `POST /workout-plans/{id}/publish`
- `POST /workout-plans/{id}/assign` `GET /workout-plans/{id}/versions`
- `PUT /workout-plans/{id}/exercises`
- `POST /workout-sessions` `POST /workout-sessions/{id}/sets` `POST /workout-sessions/{id}/complete`
- `GET /workout-sessions`

### DIET
- `GET/POST /foods` `GET/PATCH /foods/{id}`
- `GET/POST /diet-plans` `GET/PATCH /diet-plans/{id}` `POST /diet-plans/{id}/publish`
- `POST /diet-plans/{id}/assign` `GET /diet-plans/{id}/versions`
- `PUT /diet-plans/{id}/meals`
- `PUT /members/{id}/diet-logs/{date}` `GET /members/{id}/diet-logs`

### GOAL
- `GET/POST /goal-metrics` `PATCH /goal-metrics/{id}`
- `GET/POST /members/{id}/goals` `GET/PATCH /goals/{id}` `POST /goals/{id}/check-ins`
- `GET/POST /members/{id}/measurements` `GET /measurements/{id}`
- `GET/POST /members/{id}/progress-photos` `DELETE /progress-photos/{id}`
- `GET/POST /members/{id}/progress-notes`

### NOTIF
- `GET /notifications` `GET /notifications/{id}` `POST /notifications/{id}/read` `POST /notifications/read-all`
- `POST /notifications/broadcast` `GET /notifications/broadcasts`
- `GET/POST /devices` `DELETE /devices/{id}`

### DASH / RPT / SYS / MEDIA
- `GET /dashboard`
- `GET /reports/{type}`
- `GET/PUT /settings` `GET /audit-logs`
- `POST /media/uploads` `GET /media/{key}`

---

## 25. Non-functional requirements (backend)

| ID | Requirement |
| :--- | :--- |
| NFR-001 | Authorization is enforced on every operation in §24; client hiding is not security. |
| NFR-002 | Check-in and POS record must succeed in < 2s p95 under gym-day load (hundreds of members, not millions). |
| NFR-003 | History and audit rows are immutable. |
| NFR-004 | Backups: daily full, point-in-time for the ledger (`payments*`, `memberships*`). |
| NFR-005 | PII (health, documents, progress photos, passwords) encrypted at rest; access logged. |
| NFR-006 | Jobs: membership expiry, freeze end, auto-checkout, attendance_histories rollup, session reminders, renewal reminders, receipt generation. |
| NFR-007 | Observability: request_id on every response; structured logs; metrics for check-in, payment, 5xx. |

---

## 26. Open decisions (not blocked for this FRD)

These do not change the functional modules. Resolve in ADRs at implementation:

1. **Resolved** — API style and auth tokens: REST + opaque server-side tokens (no JWT). See [ADR-0003](./adr/0003-api-style-and-authentication.md).
2. **Resolved** — Database engine: MySQL 8.4 + Drizzle ORM. See [ADR-0002](./adr/0002-database-engine-and-data-access.md).
3. **Resolved** — Multi-gym tenancy: Single-tenant, deploy-per-gym (MVP = one gym). See [ADR-0004](./adr/0004-tenancy-model.md).
4. Payment gateway vs desk-only POS.
5. Attendance hardware vendor.
6. Whether partial invoices activate membership.
7. Whether Member may create goals (screens currently read-only).
8. Push vs SMS vs email channels per `notification_types`.

---

## 27. Requirement index

| Prefix | Module | Count (approx.) |
| :--- | :--- | :--- |
| FR-API / NFR | Platform | 14 + 7 |
| FR-AUTH | Identity | 10 |
| FR-RBAC | RBAC | 6 |
| FR-PEOPLE | People | 16 |
| FR-HEALTH | Health | 10 |
| FR-MEMB | Memberships | 20 |
| FR-SCHED | Schedule | 21 |
| FR-ATTN | Attendance | 12 |
| FR-PAY | Payments | 14 |
| FR-WORK | Workout | 16 |
| FR-DIET | Diet | 8 |
| FR-GOAL | Goals | 12 |
| FR-NOTIF | Notifications | 11 |
| FR-DASH | Dashboard | 4 |
| FR-RPT | Reports | 11 |
| FR-SYS | Settings & audit | 7 |
| FR-MEDIA | Media | 5 |

Business rules use `BR-*` in the same modules.

---

*End of backend FRD draft.*
