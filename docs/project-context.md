# Project Context — Gym Management System (MVP)

> **Purpose of this file:** Single onboarding / agent context for the gym product. Prefer this over re-reading every spec. Deep detail lives in the linked docs below.

**Repo status (as of this doc):** Specification-first. The workspace currently contains product docs under `docs/`; application source is not yet scaffolded here.

---

## 1. What We Are Building

A **multi-role gym management suite** covering day-to-day member experience, trainer coaching workflows, and full office/admin operations.

| Dimension | Decision |
| :--- | :--- |
| **Product** | Gym Management System MVP |
| **Client platform** | **Flutter** (mobile, tablet, desktop) |
| **Apps / personas** | Member · Trainer · Admin / Office |
| **UI strategy** | **44 consolidated core screens** shared across roles (not 141 duplicated role screens) |
| **Nav strategy** | Exactly **5 top-level tabs** per role; everything else is nested routes, modals, or sheets |
| **Data model** | Relational DB, **56 tables**, unified `users` + role profile extensions + history/versioning |

Remote repo reference from pull history: `https://github.com/shabibmr/luxeknox` (`main`).

---

## 2. Roles & Product Focus

| Role | Primary job | Top-level tabs |
| :--- | :--- | :--- |
| **Member** | Daily routines: check-in, workouts, meals, bookings, progress, membership self-service | `Home` · `Membership` · `Schedule` · `Progress` · `Profile` |
| **Trainer** | Client roster, calendar, workout/diet plans, session attendance, progress coaching | `Home` · `Members` · `Schedule` · `Plans` · `Profile` |
| **Admin / Office** | 360° ops: members, packages, POS billing, staff, hardware attendance, reports, settings | `Dashboard` · `Members` · `Memberships` · `Payments` · `More` |

**User types on identity:** `member` | `trainer` | `employee` | `admin` (see `users.user_type`).

**RBAC:** `roles` → `permissions` → `role_permissions`. Named roles in specs include Super Admin, Manager, Receptionist, Trainer, Member.

---

## 3. Architecture Principles (Non-Negotiable for MVP)

1. **One codebase, role-adaptive UI** — Shared screens; capability checks toggle edit vs read-only vs hidden (`F` / `E` / `R` / `C` / `—` in the consolidated matrix).
2. **Unified identity** — Central `users` table; profile extensions: `members`, `trainers`, `employees`.
3. **History & audit** — Explicit history tables for memberships, schedules, payments, measurements; `audit_logs` for admin mutations.
4. **Template + versioning** — Workout and diet plans support gym templates (`member_id` null / `is_template`) and version snapshots when customized.
5. **Shallow chrome, deep stacks** — 5 root tabs; detail/forms as pushes, modal sheets, or side drawers (tablet/desktop).
6. **Feature-first Flutter layout** (from consolidated screens spec):

```text
lib/features/{dashboard,profile,membership,schedule,attendance,
              payments,workouts,diet,progress,notifications}/...
```

---

## 4. Domain Map (Entities)

High-level groups (full attribute lists: [`database-entities.md`](./database-entities.md), name list: [`Entities-List.md`](./Entities-List.md)):

| Domain | Core entities |
| :--- | :--- |
| **Identity & RBAC** | User, Role, Permission, Role Permission, Employee, Member, Trainer |
| **Health** | Member Health, Health Condition, Medical History, Emergency Contact, Member Document, Member Photo |
| **Membership** | Membership Product, Membership, Membership History, Membership Freeze, Membership Extension |
| **Attendance** | Attendance, Attendance History *(methods: QR, RFID, biometric, manual)* |
| **Payments** | Payment Method, Payment (invoice/txn), Payment Receipt, Payment History |
| **Schedule** | Schedule Type, Facility, Schedule, Schedule Participant, Trainer Availability, Schedule History |
| **Workout** | Exercise, Workout Plan, Workout Plan Version, Workout Plan Exercise, Workout Session, Workout Session Exercise |
| **Diet** | Food, Diet Plan, Diet Plan Version, Diet Plan Meal, Diet Plan Food, Diet History |
| **Goals / Progress** | Goal Metric, Goal, Goal History, Measurement, Measurement Values, Progress Photo, Progress Note |
| **Notifications** | Notification Type, Notification, User Device, Notification Delivery |
| **System** | Gym Setting, Audit Log |

**Key relationships to remember:**

- Member ↔ assigned Trainer (`members.assigned_trainer_id`)
- Membership ↔ Product; freezes/extensions hang off membership
- Schedules ↔ type, facility, optional trainer, many participants
- Plans (workout/diet) ↔ optional member + trainer; **line items hang off versions**; sessions/logs are execution layer
- Payments: invoice header + history rows for tenders/refunds; usually tied to member (+ optional membership)
- Schedules in a recurring series share `series_id`

---

## 5. Screens Snapshot

| Source | Count |
| :--- | ---: |
| Gross role screen references | 141 |
| **Consolidated reusable screens** | **~44–46** (matrix + admin-only staff/reports/settings) |
| Member-oriented views (role catalog) | ~36 |
| Trainer-oriented views | ~35 |
| Admin-oriented views | ~70 |

**Module order in consolidated matrix:** Dashboard → Profile/Health → Membership → Schedule → Attendance → Payments → Workout → Diet → Goals/Progress → Notifications → Admin (Staff, Reports, Settings).

Access legend: **F** full · **E** edit/manage in scope · **R** read/self · **C** contextual action · **—** hidden.

Canonical matrix: [`screens/consolidated-screens.md`](./screens/consolidated-screens.md).

---

## 6. Navigation & Presentation Patterns

| Pattern | Usage |
| :--- | :--- |
| **Root tabs** | Mobile bottom bar; tablet/desktop rail or drawer — always 5 items |
| **Nested stack** | Detail screens with AppBar back within the active tab |
| **Modal / sheet** | Quick forms, wizards, POS, freeze request, session check-off |
| **Adaptive dashboard** | Same screen shell; widgets differ by role |

Route sketches (prefixes differ by app): see [`screens/navigation-architecture.md`](./screens/navigation-architecture.md).

Examples:

- Member: `/home`, `/membership`, `/schedule/:id`, `/progress/goal/:id`, `/profile/health`
- Trainer: `/trainer/members/:id`, `/trainer/plans/workouts/create`, `/trainer/schedule/availability`
- Admin: `/admin/members/:id`, `/admin/payments/record`, `/admin/settings/:category`

---

## 7. Capability Highlights by Role

**Member**

- Digital attendance pass (QR/barcode)
- Self-book PT / classes; cancel within rules
- Start live workout tracker; log diet adherence
- Request membership freeze; browse packages / pay dues
- Own health, documents, goals, progress photos

**Trainer**

- Assigned-client dossier (health read, goals/measurements edit)
- Availability + session calendar; mark session attendance
- Build/edit workout & diet plans for clients
- Limited broadcast to assigned clients; own performance slice of reports

**Admin / Office**

- Member onboarding 360° dossier
- Package CRUD, renew/freeze/extend approvals
- POS (cash/card/UPI/split/discount), receipts, outstanding dues
- Staff/trainers/employees + roles
- Master exercise/food libraries & plan templates
- Attendance hardware feed / override, gym settings, full analytics & audit

---

## 8. Documentation Index

| Document | Use when you need… |
| :--- | :--- |
| [`project-context.md`](./project-context.md) | **This file** — product + architecture orientation |
| [`Entities-List.md`](./Entities-List.md) | Quick entity checklist by domain |
| [`database-entities.md`](./database-entities.md) | Tables, key attributes, screen linkages |
| [`backend-frd.md`](./backend-frd.md) | Backend functional requirements (modules, rules, logical APIs) |
| [`screens/README.md`](./screens/README.md) | Screen doc map & role summaries |
| [`screens/consolidated-screens.md`](./screens/consolidated-screens.md) | De-duplicated screen matrix + Flutter feature tree |
| [`screens/navigation-architecture.md`](./screens/navigation-architecture.md) | Tab trees, routes, UX presentation rules |
| [`screens/member-app-screens.md`](./screens/member-app-screens.md) | Member-only screen catalog |
| [`screens/trainer-app-screens.md`](./screens/trainer-app-screens.md) | Trainer-only screen catalog |
| [`screens/admin-app-screens.md`](./screens/admin-app-screens.md) | Admin/office screen catalog |
| [`adr/README.md`](./adr/README.md) | **Architecture decisions** — stack, database, API, tenancy, storage, Flutter packages, delivery order |
| [`openapi/v1.yaml`](./openapi/v1.yaml) | Shared REST `/v1` contract (OpenAPI 3.1) for Nest and Flutter |

---

## 9. Implementation Guardrails (for future code)

When scaffolding or implementing:

1. Prefer **shared feature screens** with role/permission decorators over three copies of the same page.
2. Keep **5-tab shells** per role; do not promote secondary features to root nav.
3. Persist **history/version** on membership, schedule, payment, plan, and measurement changes — do not overwrite silently.
4. Treat workout/diet **templates** as first-class (`is_template` / null member) distinct from assigned member plans.
5. Attendance and POS are **admin-critical**; member/trainer surfaces are scoped subsets of the same entities.
6. Update this context file when product decisions (roles, nav, entity set, platform) change.

---

## 10. Open / Implicit Gaps

Specs define product and data shape. Technology gaps ADR 0001–0004 are **Accepted** (see [`adr/`](./adr/README.md)); remaining items are Deferred or Proposed:

| Gap | Record | Decision / Status |
| :--- | :--- | :--- |
| Backend stack | [ADR-0001](./adr/0001-backend-language-and-framework.md) | **Accepted** — NestJS / TypeScript |
| DB engine | [ADR-0002](./adr/0002-database-engine-and-data-access.md) | **Accepted** — MySQL 8.4 + Drizzle |
| API style & auth provider | [ADR-0003](./adr/0003-api-style-and-authentication.md) | **Accepted** — REST + opaque server-side tokens (no JWT) |
| Multi-tenant vs single-gym | [ADR-0004](./adr/0004-tenancy-model.md) | **Accepted** — Single-tenant, deploy-per-gym |
| Object storage / media | [ADR-0005](./adr/0005-object-storage-and-media.md) | **Deferred** — no uploads in MVP |
| Flutter architecture, state / routing | [ADR-0006](./adr/0006-flutter-state-management-and-routing.md) | **Proposed** — Clean Architecture + flutter_bloc + go_router |
| What to build first | [ADR-0007](./adr/0007-first-delivery-vertical.md) | **Proposed** — Exercise Library |

Still deliberately open: **object storage / `MEDIA`**, **payment gateway** and **attendance hardware
vendor** — none is needed before the `PEOPLE`, `PAY` and `ATTN` verticals respectively
(see [`adr/README.md`](./adr/README.md)).

**MVP descope to confirm with the product owner:** no file uploads means no member document/waiver
capture, no avatars, and no progress photos until vertical 3 — see [ADR-0005](./adr/0005-object-storage-and-media.md).

Keep MVP screen + entity contracts as the source of truth; ADRs govern technology only.
