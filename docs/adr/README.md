# Architecture Decision Records

Decisions that the specs deliberately left open. Source of the open list:
[`backend-frd.md`](../backend-frd.md) §26 and [`project-context.md`](../project-context.md) §10.

Specs (`backend-frd.md`, `database-entities.md`, `screens/*`) remain the source of truth for
**what** the system does. ADRs record **how** it is built. Where an ADR and a spec conflict,
the spec wins on behaviour and the ADR wins on technology.

## Format

Each record: Status · Context · Decision · Consequences · Alternatives considered.
Statuses: `Proposed` → `Accepted` → (`Superseded by ADR-XXXX` | `Deprecated`).
`Deferred` marks a question deliberately left open with no decision made — a placeholder, not a choice.

ADR-0001–0004, 0007, and 0008 are `Accepted`. ADR-0005 is `Superseded by ADR-0008`. ADR-0006 is `Proposed`.

## Index

| # | Decision | Status | Resolves |
| :-- | :--- | :--- | :--- |
| [0001](./0001-backend-language-and-framework.md) | Backend language & framework — **NestJS / TypeScript** | Accepted | project-context §10.1 |
| [0002](./0002-database-engine-and-data-access.md) | Database engine & ORM — **MySQL 8.4 + Drizzle** | Accepted | FRD §26.2 |
| [0003](./0003-api-style-and-authentication.md) | API style & auth tokens — **REST + opaque server-side tokens (no JWT)** | Accepted | FRD §26.1 |
| [0004](./0004-tenancy-model.md) | Tenancy — **single-tenant, deploy-per-gym** | Accepted | FRD §26.3, project-context §10.3 |
| [0005](./0005-object-storage-and-media.md) | Object storage & media — **deferred placeholder** | Superseded by 0008 | historical deferral |
| [0006](./0006-flutter-state-management-and-routing.md) | Flutter architecture, state & routing — **Clean Architecture + flutter_bloc + go_router** | Proposed | project-context §10.2 |
| [0007](./0007-first-delivery-vertical.md) | First delivery vertical — **Exercise Library** | Accepted | delivery sequencing |
| [0008](./0008-object-storage-and-media.md) | Object storage & MEDIA — **S3-compatible + local disk; signed PUT/GET** | Accepted | FRD §21, Vertical 3 |

## Deliberately not decided yet

| Open item | Source | Why deferred | Decide when |
| :--- | :--- | :--- | :--- |
| Payment gateway vs desk-only POS | FRD §26.4 | `PAY` module is vertical 6+. Desk POS (cash/card/UPI capture) needs no gateway; only member self-pay does. | Before the `PAY` vertical starts |
| Attendance hardware vendor | FRD §26.5 | `ATTN` accepts QR / RFID / biometric / manual. Manual + QR need no vendor. Ingest is one adapter behind a device-credential endpoint. | Before turnstile integration |

## Product decisions, not architecture

FRD §26 items 6–8 are business rules, not technology. They belong in the FRD, not here:

- **§26.6** Whether a partial invoice activates a membership
- **§26.7** Whether a Member may create their own goals (screens currently read-only)
- **§26.8** Push vs SMS vs email channel per `notification_types`

Raise these with the product owner and amend `backend-frd.md` directly.
