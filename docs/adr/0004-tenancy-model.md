# ADR-0004 — Tenancy model

| | |
| :--- | :--- |
| **Status** | Accepted |
| **Date** | 2026-09-16 |
| **Resolves** | `backend-frd.md` §26.3, `project-context.md` §10 — "Multi-tenant vs single-gym deployment model" |
| **Related** | [ADR-0002](./0002-database-engine-and-data-access.md) |

## Context

`backend-frd.md` §2 puts "Multi-tenant / multi-branch productisation" explicitly **out of scope**, and
§26.3 records "Multi-gym tenancy (MVP = one gym)" as open. The real question is not whether to build
multi-tenancy now — it is whether to **pay for it now** by carrying a `gym_id` discriminator on all
55 tables against a future that may never arrive.

The cost of carrying it speculatively is not trivial:

- `gym_id` joins every unique constraint. The six partial unique indexes in
  [ADR-0002](./0002-database-engine-and-data-access.md) each gain a column; so do the uniqueness
  rules on `membership_number` (FR-PEOPLE-002), email/phone (BR-AUTH-001 — which the FRD calls
  "gym-**global**"), invoice number, and product code.
- Every query needs a tenant predicate, and every *missed* predicate is a cross-tenant data leak —
  the highest-severity bug class in the product, introduced before there is a second tenant to leak to.
- `gym_settings` (FR-SYS) becomes per-tenant, which changes currency, timezone, and booking-rule
  resolution everywhere.

The cost of *not* carrying it is a migration later. Notably, that migration is mechanical
(`ALTER TABLE … ADD COLUMN gym_id`, backfill one constant, extend indexes) — it is tedious, not
architecturally dangerous, and it is only needed if the product actually pivots to SaaS.

## Decision

**Single-tenant. No `gym_id` column anywhere. One database per gym. Deploy-per-gym if a second gym
appears before a deliberate multi-tenant rework.**

Two cheap hedges, taken now because they cost close to nothing:

1. **All data access goes through a repository layer.** No SQL in controllers or services. If a
   tenant predicate ever has to be injected, there is exactly one layer to change, and it can be
   made structurally impossible to bypass.
2. **`gym_settings` is read through a single `SettingsService`**, never by direct table access. This
   is the one table guaranteed to become per-tenant first, and this makes that change a one-file
   edit.

Explicitly **not** doing: speculative `gym_id` columns, schema-per-tenant, or per-tenant database
users and views. None earn their complexity against a spec that rules multi-tenancy out of scope.

### Revisit trigger

Reopen this ADR when **either** is true:

- A second gym or branch is committed to, with a date — not merely discussed.
- A requirement appears for cross-gym reporting, shared membership, or a single member visiting
  multiple branches. Deploy-per-gym cannot satisfy any of these, and that is the point at which the
  migration must be planned rather than improvised.

### Migration path when triggered

1. Add `gym_id` with a default of the existing single gym; backfill; make it `NOT NULL`.
2. Extend every unique index and partial unique index to include `gym_id`. **Re-decide
   BR-AUTH-001** — "gym-global" email/phone uniqueness becomes ambiguous the moment there are two gyms.
3. Inject the tenant predicate at the repository layer. **Note that MySQL has no row-level security**
   ([ADR-0002](./0002-database-engine-and-data-access.md)), so there is no engine-level net beneath a
   missed predicate. The substitute is weaker and must be deliberate: the predicate is applied in one
   base repository that every query goes through, plus a test that fails if any query builder bypasses
   it. If that guarantee is not convincing at the time, per-tenant database users with tenant-scoped
   views are the fallback.
4. Make `gym_settings` per-tenant via `SettingsService`.

## Consequences

**Positive**

- Simpler schema, simpler queries, simpler indexes throughout the MVP.
- The highest-severity bug class in a multi-tenant system — cross-tenant leakage — cannot occur,
  because there is no tenant dimension to get wrong.
- Per-gym database means per-gym backup, restore, and blast radius, which suits NFR-004's ledger
  recovery requirement well.

**Negative**

- Deploy-per-gym does not scale operationally past a handful of gyms. Ten gyms means ten MySQL
  instances, ten backup schedules, ten migration runs. **This is the ceiling, and it is the reason
  the revisit trigger above is written in terms of commitment rather than speculation.**
- If the product does pivot to SaaS, the migration lands on a schema with real production data,
  which is more work than having carried the column from day one.

**Neutral**

- This is a reversible decision with a known, mechanical migration. It is not a one-way door, which
  is precisely why deferring is the right call.

## Alternatives considered

| Option | Why not |
| :--- | :--- |
| **`gym_id` discriminator now, single database** | The standard "just in case" hedge. Rejected: it taxes all 55 tables and every unique constraint, and introduces cross-tenant leak risk, to serve a future the spec explicitly excludes. |
| **Schema-per-tenant** | Reasonable middle ground for tens of tenants. Rejected as strictly more operational complexity than deploy-per-gym at a tenant count of one. |
| **Row-level security from the start** | Excellent defence-in-depth — but it defends a boundary that does not exist yet, and MySQL does not offer it natively anyway ([ADR-0002](./0002-database-engine-and-data-access.md)). Listed above as step 3 of the migration, with the weaker substitute available there. |
