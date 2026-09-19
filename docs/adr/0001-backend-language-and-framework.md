# ADR-0001 — Backend language & framework

| | |
| :--- | :--- |
| **Status** | Accepted |
| **Date** | 2026-09-16 |
| **Resolves** | `project-context.md` §10 — "Backend stack (API, auth provider, DB engine)" |
| **Related** | [ADR-0002](./0002-database-engine-and-data-access.md), [ADR-0003](./0003-api-style-and-authentication.md) |

## Context

The backend must deliver 16 modules over 55 relational tables (`backend-frd.md` §3). The shape
of the work is not exotic — it is CRUD, workflow state machines, and reporting — but four FRD
requirements constrain the choice:

- **FR-API-006 / FR-API-007** — history and audit rows are written *in the same transaction* as the
  mutation. The framework needs first-class transaction scoping across a request, not per-call
  autocommit.
- **FR-API-002** — authorization is `module` + `action` permission *plus* row-level ownership. This
  wants a declarative guard/interceptor layer, not hand-rolled checks in 200 handlers.
- **FR-API-012** — domain events are published in-process or via a queue; producers never send push
  themselves. This wants a built-in event bus with a clean upgrade path to a real broker.
- **NFR-006** — seven recurring jobs (membership expiry, freeze end, auto-checkout, attendance
  rollup, reminders ×2, receipt generation).

Load is explicitly modest: NFR-002 sets the bar at "hundreds of members, not millions", p95 < 2s for
check-in and POS. **Raw throughput is not a differentiator between any candidate.** Developer
throughput and structural fit are.

Two signals from the repo itself: `.gitignore` already reserves `node_modules/` and `dist/`
("for when app code lands here"), and the configured MCP servers are Hostinger VPS / hosting —
implying a self-managed Linux VPS deployment rather than a serverless platform.

## Decision

**NestJS on TypeScript (Node.js LTS), deployed as a single process on a Hostinger VPS behind a
reverse proxy.**

Structure maps 1:1 onto the FRD:

| FRD concept | NestJS construct |
| :--- | :--- |
| Module catalog §3 (`AUTH`, `RBAC`, `PEOPLE`, …) | One `@Module()` per code, same names |
| FR-API-002 permission + row scope | `@RequirePermission('exercises.update')` decorator + `PermissionGuard`, then a per-module scope check |
| FR-API-011 uniform error body | Global `ExceptionFilter` emitting `code` / `message` / `details[]` / `request_id` |
| FR-API-006 same-transaction history | `AsyncLocalStorage` transaction context; repositories enlist in the ambient transaction |
| FR-API-012 domain events | `@nestjs/event-emitter` in-process for MVP; swap the emitter for BullMQ without touching producers |
| NFR-006 jobs | `@nestjs/schedule` for cron, BullMQ for retryable work |
| NFR-007 observability | Interceptor stamping `request_id`, Pino structured logs |

Supporting choices:

| Concern | Choice |
| :--- | :--- |
| Validation | `zod` schemas at the edge, inferred types inward |
| API contract | `@nestjs/swagger` → OpenAPI 3.1 → generated Dart client (see [ADR-0003](./0003-api-style-and-authentication.md)) |
| Tests | Vitest for unit; Supertest + Testcontainers MySQL for module integration tests |
| CI | Lint, typecheck, unit, integration, migration check on every PR |

## Consequences

**Positive**

- One language across backend and tooling; the Flutter client gets a *generated* Dart client from
  the same OpenAPI document, so the API contract cannot silently drift.
- The module/guard/interceptor structure is the FRD's own structure, so "which file does FR-RBAC-003
  live in" has an obvious answer for every requirement ID.
- Large hiring pool and ecosystem for the boring parts (PDF receipts, cron, queues).

**Negative**

- NestJS carries decorator/DI ceremony that a small team can find heavy. Mitigation: no custom
  providers beyond what the table above needs.
- Node is single-threaded per process. Irrelevant at NFR-002 load, but the PDF receipt generation
  job (NFR-006) is CPU-bound and **must** run in a worker, not the request process.
- TypeScript types vanish at runtime — hence `zod` at every boundary, not `class-validator` alone.

**Neutral**

- Dart/Flutter developers will not be able to move onto backend work without learning the stack.
  Accepted: the alternative (Dart backend) trades this for much worse data-layer tooling.

## Alternatives considered

| Option | Why not |
| :--- | :--- |
| **Dart (Serverpod / Dart Frog)** | One language across the whole product is genuinely attractive. Rejected because the migration, query-builder, reporting and job ecosystems are immature relative to a 55-table schema with an immutable financial ledger (NFR-003, NFR-004). The shared-language win does not pay for hand-rolling that. |
| **Python / FastAPI + SQLAlchemy** | Strong contender — arguably better for the `RPT` analytics module (§19) later. Rejected on the `.gitignore` signal and on a single-language-tooling preference. **Flip to this if the team is Python-first.** |
| **PHP / Laravel** | Excellent fit for gym CRUD + POS + RBAC (Spatie), likely the fastest to first release. Rejected for the same team-language reason; would be the pick for a PHP-first team. |
| **Go** | Meets every NFR with room to spare, but generates the most boilerplate per CRUD endpoint, and there are ~200 of them in §24. Performance is not the constraint here. |

## Open input that would change this

**Team language proficiency is the dominant decision driver and is not recorded anywhere in the
specs.** If the team's strongest language is Python or PHP, flip to FastAPI or Laravel — the rest of
the ADRs (MySQL, REST, opaque tokens, tenancy, the Flutter stack) hold unchanged, because they were chosen
on requirement fit rather than on this framework.
