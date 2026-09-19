# ADR-0007 — First delivery vertical

| | |
| :--- | :--- |
| **Status** | Accepted |
| **Date** | 2026-09-16 |
| **Resolves** | Delivery sequencing — which module is built first, end to end |
| **Related** | [ADR-0001](./0001-backend-language-and-framework.md) … [ADR-0006](./0006-flutter-state-management-and-routing.md) |

## Context

The repo is specification-only. Something has to be built first, and the first vertical does more
than ship a feature — it fixes the patterns every later module copies: the permission guard, the
transaction/history wrapper, the error envelope, the repository layer, the role-adaptive screen, the
generated client.

Choosing a module with domain dependencies means inventing those patterns *while* fighting business
rules. So the criterion is: **no outbound domain dependencies, but enough surface to exercise the
cross-cutting conventions and the role-adaptive UI thesis.**

Dependency survey across the 16 modules:

| Module | Outbound domain FKs | Assessment |
| :--- | :--- | :--- |
| `WORK` §14.1 — `exercises` | **none** | Leaf. All three roles, media URLs, search |
| `DIET` §15 — `foods` | none | Leaf. Same shape, no media |
| `MEMB` §10.1 — `membership_products` | none | Leaf, but pulls in money/tax conventions (FR-API-005) |
| `SYS` settings, `HEALTH` conditions catalog | none | Leaf, but admin-only — no member/trainer surface |
| `PEOPLE` | AUTH, HEALTH, MEDIA, MEMB | Hub — everything depends on *it* |
| `MEMB` contracts, `SCHED`, `ATTN`, `PAY`, `GOAL` | `PEOPLE` + history tables | Heavy |
| `WORK` / `DIET` plans | exercises/foods + `PEOPLE` + versioning | Downstream of the leaves |

`backend-frd.md` §3 is explicit that **"Module 0 is not optional. Every other module depends on it."**
No vertical is truly standalone.

## Decision

**A thin platform spine, then the Exercise Library (screens 29 + 30) as the first feature vertical.**

### Prerequisite spine — not a feature, but unavoidable

| Piece | Minimum scope |
| :--- | :--- |
| `API` | Auth middleware, `PermissionGuard`, pagination, uniform error body, request-scoped transaction, `request_id` |
| `AUTH` | Login, refresh, logout, `GET /me` (FR-AUTH-001, 003, 004, 007) |
| `RBAC` | Seeded permission catalog + 5 system roles (FR-RBAC-005, 002) |
| Flutter shell | 5-tab `StatefulShellRoute` per role, auth redirect, `SessionCubit` + `Capabilities`, `get_it` wiring, generated client, and the `core/` error mapper — see [ADR-0006](./0006-flutter-state-management-and-routing.md) |

### The vertical — Exercise Library

`exercises` has **zero outbound foreign keys** (`database-entities.md` §`exercises`): name, muscle
groups, equipment, instructions, media URLs, difficulty, `is_active`.

| | |
| :--- | :--- |
| **Backend** | FR-WORK-001 (Admin CRUD), FR-WORK-002 (browse/search by muscle, equipment, difficulty) |
| **Screens** | 29 Exercise Library (`R` Member / `R` Trainer / `F` Admin), 30 Exercise Details |
| **Routes** | `/admin/workout-library`, `/trainer/plans/exercises/:id` (`navigation-architecture.md`) |
| **Out of scope** | Plans, versions, sessions, templates — all of `WORK` §14.2 and §14.3 |

### Why this one

1. **It proves the core architectural bet.** Screen 29 is `R` / `R` / `F` across the three roles —
   the only trivial domain that exercises all three access levels. If "one screen, capability
   decorators" (`project-context.md` §3.1) does not hold, we find out on a 9-column table rather
   than on the POS terminal.
2. **It exercises nearly every cross-cutting convention** with no business rules: pagination and
   filters (FR-API-003), case-insensitive search (FR-API-014), soft deactivate (FR-API-010), signed
   media URLs (FR-API-013), uniform errors (FR-API-011), audit on admin mutation (FR-API-007).
3. **It skips the hard ones.** No history rows (FR-API-006), no versioning, no idempotency, no
   optimistic concurrency, no money. Those arrive with `MEMB` and `PAY`, on patterns already proven.
4. **Nothing is throwaway.** The Workout Plan Builder's exercise picker
   (`trainer-app-screens.md` — "Add Exercises") and the Live Session Tracker both consume it.

### Sequence after it

| # | Vertical | Rationale |
| :-: | :--- | :--- |
| 2 | **Food Library** (`DIET` §15, screen 36) | Structurally identical, no media. A cheap regression test that vertical 1's patterns are genuinely reusable rather than one-offs. Should be dramatically faster than vertical 1 — **if it is not, the patterns are wrong, and that is the signal to fix them before the hub lands.** |
| 3 | **`PEOPLE` / Members** | The hub. Unblocks everything else. Introduces the row-level scoping rules (BR-PEOPLE-002/003), and is where the deferred `MEDIA` question comes due for document capture — [ADR-0005](./0005-object-storage-and-media.md). **Budget for it in this vertical, not vertical 1.** |
| 4+ | `MEMB` → `ATTN` → `PAY` → `SCHED` → plans → `GOAL` → `NOTIF` → `RPT` | Follows the dependency order above; `MEMB` introduces history rows and money, `PAY` introduces idempotency and the ledger |

## Consequences

**Positive**

- The riskiest architectural assumption (role-adaptive screens) is tested in week one, on a domain
  where being wrong costs almost nothing.
- Vertical 2 is a designed, explicit checkpoint on pattern reusability.
- Every cross-cutting convention gets a reference implementation before any business logic depends
  on it.

**Negative**

- **The Exercise Library has near-zero business value on its own.** Nobody's gym runs better because
  the exercise catalogue shipped. Stakeholders expecting a visible member-facing win first will not
  see one until vertical 3. This needs saying out loud before work starts, not after.
- The spine is a real chunk of work sitting in front of the first feature, and it is easy to gold-plate.
  Keep it to the minimum table above; it can be extended when a later module actually needs more.

**Neutral**

- Because `exercises` has no dependents until the plan builder (vertical 6+), a mistake here is cheap
  to correct — which is the whole point of going first.

## Alternatives considered

| Option | Why not |
| :--- | :--- |
| **Food Library first** | Equally dependency-free and marginally simpler. The original argument against it — that it would leave `MEDIA` unproven — lapsed when `MEDIA` was deferred ([ADR-0005](./0005-object-storage-and-media.md)), so the two are now near-interchangeable. Exercise Library keeps the slot on the weaker but still valid grounds that it has a richer filter surface (muscle group, equipment, difficulty) to exercise the search and pagination conventions, and it is the better *second* vertical precisely because it repeats the first. |
| **Membership Products Catalog** | Also FK-free, and closer to business value. Rejected because it immediately pulls in money, tax, and currency conventions (FR-API-005), and a package catalogue with no purchase flow invites scope creep straight into `MEMB` contracts. |
| **`PEOPLE` / Members first** | The most business value, and the usual instinct. Rejected: it depends on AUTH, HEALTH, MEDIA, and MEMB, so the cross-cutting patterns would be invented under pressure, inside the module everything else inherits from. |
| **Auth + shell alone as "vertical 1"** | Ships nothing a user can see and leaves the role-adaptive thesis untested. Folded into this ADR as the prerequisite spine instead. |
