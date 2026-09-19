# ADR-0003 — API style & authentication

| | |
| :--- | :--- |
| **Status** | Accepted |
| **Date** | 2026-09-16 |
| **Revision** | Replaces the JWT-access-token draft of this record (never accepted — amended in place rather than superseded). Both tokens are now opaque. See *Alternatives considered*. |
| **Resolves** | `backend-frd.md` §26.1 — "API style (REST / RPC) and auth tokens (JWT vs opaque)" |
| **Related** | [ADR-0001](./0001-backend-language-and-framework.md), [ADR-0002](./0002-database-engine-and-data-access.md) |

## Context

`backend-frd.md` §24 already enumerates the operations as **resources with verbs** — `POST /auth/login`,
`GET /members/:id`, `POST /memberships/:id/freeze`. The API style question is therefore largely
settled by the spec's own shape; what remains is to ratify it and fix the token model.

The token model is genuinely constrained, and four requirements make most naive designs illegal:

- **FR-AUTH-004** — "Refresh rotates the refresh credential. **Reuse of a rotated refresh token
  revokes the family.**" Reuse detection requires server-side state.
- **FR-AUTH-010** — suspending a user revokes existing tokens **immediately**.
- **FR-AUTH-005** — change-password invalidates all *other* sessions.
- **FR-API-001** — hardware ingest authenticates by a **device credential**, not a user session.

Every one of these is a statement about *server-held session state*. That is the decisive fact for
the token format.

There is also a build-vs-buy question the specs imply but do not state. **FR-AUTH-008** requires that
creating a person writes the `users` row and the role-profile row **in one transaction**. An external
identity provider owning the user record turns that into a distributed transaction with no rollback
story — the exact failure mode where a member exists in Auth0 but not in the gym database.

## Decision

### API style

**REST over JSON, resource-oriented, exactly as `backend-frd.md` §24 lists it.**

| Concern | Decision |
| :--- | :--- |
| Contract | OpenAPI 3.1, generated from code via `@nestjs/swagger`, committed to the repo |
| Client | Dart client **generated** from that OpenAPI document into the Flutter app; never hand-written |
| Versioning | URL prefix `/v1`. Additive changes only within a version |
| Pagination | Cursor-based on `(created_at, id)` for feeds (attendance, notifications, audit); offset permitted for admin tables that need page numbers. Default page size from `gym_settings` (FR-API-003) |
| Errors | Uniform `{ code, message, details[], request_id }` (FR-API-011) with the §5.2 code table as the single source |
| Idempotency | `Idempotency-Key` header on payments, check-in, booking, freeze request (FR-API-008). Keys stored with a hash of the request body and the original response; replay returns the stored response |
| Non-CRUD actions | Sub-resource POST, not RPC verbs: `POST /memberships/:id/freeze`, `POST /schedules/:id/participants` |

Actions that are genuinely commands (freeze, approve, check-in) are modelled as sub-resources rather
than forced into pure CRUD. This matches §24 and avoids inventing a `PATCH` whose semantics depend on
which field changed.

### Authentication

**Self-hosted identity in our own `users` table. No JWT. Both tokens are opaque random strings,
stored hashed server-side and validated against the `sessions` table on every request.**

| Token | Form | TTL | Notes |
| :--- | :--- | :--- | :--- |
| **Access** | Opaque 256-bit random, `gk_at_<base64url>` | **30 min**, not sliding | SHA-256 hashed at rest; looked up per request |
| **Refresh** | Opaque 256-bit random, `gk_rt_<base64url>` | 30 days, sliding | Rotated on every use; reuse of a consumed token revokes the whole family (FR-AUTH-004) |
| **Device** | Long-lived API key per turnstile/reader, hashed at rest, scoped to `attendance.ingest` only | — | FR-API-001 hardware path. Never a user session |

**Why no JWT.** A JWT's only real advantage is stateless verification — and this system is not
permitted to verify statelessly. FR-AUTH-010 and FR-AUTH-005 require revocation to take effect
immediately, which means every request must consult server state no matter what the token contains.
The JWT draft of this record acknowledged that and bolted on a `users.token_version` claim checked
against a cached counter on each request. That design pays the full cost of asymmetric signing, key
rotation, JWKS, and clock-skew handling **and still does a lookup per request**. Removing the JWT
removes the ceremony and keeps the property that mattered.

**Token storage and validation:**

| Concern | Decision |
| :--- | :--- |
| Hashing | **SHA-256, not argon2id.** These are 256 bits of CSPRNG output, so there is no dictionary to attack and no work factor needed. Argon2 per request would be a self-inflicted denial of service. Argon2id remains correct for *passwords*, which are low-entropy. |
| Lookup | Indexed on the token hash in `sessions`. The row carries `user_id`, `user_type`, `profile_id`, `family_id`, `expires_at`, `revoked_at` — i.e. everything the JWT claims used to carry, returned in the same round trip that authorizes the request. |
| Cache | Token hash → session row, in-process, 60 s TTL, **invalidated synchronously on suspend, logout, logout-everywhere, and password change** so FR-AUTH-010's "immediately" is literal. |
| Prefix | The `gk_at_` / `gk_rt_` prefixes exist so tokens are recognizable to secret-scanning and log-scrubbing rules. Tokens are never logged, and `request_id` is what appears in traces. |
| Transport | `Authorization: Bearer`. Never a query parameter — query strings land in access logs. |

**Permission slugs are resolved per request** from a cached role→permission map, never carried in the
token. Embedding them would make FR-RBAC-003 (permission edits) and FR-AUTH-010 (suspension) take up
to a full token lifetime to take effect. The cache is invalidated on any role or permission mutation.

`GET /me` (FR-AUTH-007) returns user + role profile + **resolved permission slug list** so the client
can hide chrome. Per FR-RBAC-006 and NFR-001, this is a UI convenience only — **the server
re-checks every operation regardless**.

Rate limiting (BR-AUTH-003, 429 in §5.2) applies per identifier *and* per IP on login, and
separately on check-in and broadcast.

## Consequences

**Positive**

- FR-AUTH-004's reuse-detection and FR-AUTH-010's immediate revocation are satisfied by the same
  mechanism that authenticates the request, rather than by a counter bolted onto a stateless token.
- No signing keys to generate, rotate, distribute, or leak; no JWKS endpoint; no clock-skew class of
  bug; no `alg: none` / algorithm-confusion class of bug. A meaningful reduction in security surface.
- Tokens are opaque, so nothing about the user leaks to anyone who captures one, and the client
  cannot start depending on claims it decoded locally — a common source of client/server drift.
- FR-AUTH-008's single-transaction person creation stays a local database transaction.
- A generated Dart client means a breaking API change fails the Flutter build, not production.

**Negative**

- **Every authenticated request now depends on the database (or its cache).** At the single-gym load
  of NFR-002 this is one indexed lookup against a hot cache and is not a concern; but it does mean
  the API cannot serve authenticated traffic while the database is down, where a JWT design could
  have served reads from other sources. Given [ADR-0001](./0001-backend-language-and-framework.md)'s
  single process and [ADR-0004](./0004-tenancy-model.md)'s single deployment, there is no such
  other source anyway.
- If the API is ever scaled to multiple instances, the 60 s in-process cache becomes a per-instance
  revocation delay. The fix at that point is a shared cache (Redis), not a return to JWTs — record
  this as the trigger.
- The `sessions` table takes a write on every refresh and a read on every request. Negligible at
  NFR-002 load; it is the first table to watch if that assumption changes.
- We own password hashing (argon2id), reset-token lifecycle, and rate limiting rather than renting
  them. This is well-trodden but it is real security-sensitive code that needs review.
- No social login or SSO for free. Nothing in the specs asks for it; adding it later means an
  identity-link table, not a rewrite.

**Neutral**

- REST rather than GraphQL means the member dossier (FR-PEOPLE-005), which aggregates membership,
  health flags, attendance, balance, plans, and next schedule, is a purpose-built composite endpoint.
  That is the right call anyway — the payload must be **role-scoped** server-side, which is harder to
  guarantee under a general-purpose graph.

## Alternatives considered

| Option | Why not |
| :--- | :--- |
| **JWT access token + opaque refresh** *(the initial draft of this record)* | The conventional answer, and the one first proposed here. Displaced by team direction, and the review that followed found the direction was right: the requirements forbid stateless verification, so the JWT's one advantage was unavailable, leaving only its costs. The honest remaining loss is that a future multi-service split would have gotten cheap inter-service verification for free. |
| **Stateless JWT refresh tokens** | Simplest possible design, and directly non-compliant with FR-AUTH-004 and FR-AUTH-010. Rejected on requirements, not taste. |
| **GraphQL** | Attractive for the dossier and dashboard aggregates. Rejected because FR-API-002's row-level scoping has to be enforced per field-resolver path, which is a much larger authorization surface for a three-role app where the payload shapes are already known and fixed. |
| **Auth0 / Firebase Auth / Supabase Auth** | Breaks FR-AUTH-008's single transaction; also puts member PII in a third party for a single-gym product. Genuine saving on password/reset plumbing, not enough to outweigh it. |
| **Session cookies only** | Fine for web; the primary client is a Flutter mobile app where bearer tokens are the natural fit and cookie handling is friction. |
| **Permissions embedded in the token** | Saves a cached lookup per request; costs up to a full token lifetime of stale authorization after a suspend or a role edit. Wrong trade for an app where suspension is a security action — and with opaque tokens there is nowhere to embed them anyway. |
