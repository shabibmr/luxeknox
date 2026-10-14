# ADR-0010: Couple memberships as two linked rows

**Status:** Accepted

## Context
A membership product covered exactly one member. A couple package is bought by two members together, at one price, with one invoice. The per-member logic (gate check-in, PT eligibility, dashboard, member card) all goes through "the member's active or frozen membership".

## Decision
Each member gets their own `memberships` row. The rows point at each other through `partner_membership_id`, and dates stay identical. Products carry `package_type` (`single` | `couple`). Freezes are twinned through `membership_freezes.paired_freeze_id`.

- One payment, raised against the primary member, at the package's total price less an optional discount.
- Renew, upgrade, cancel, extend and freeze requests/approvals apply to both rows in one transaction; each row gets its own history, audit entry and event.
- Renew/upgrade must keep the same `package_type`.
- A partner's existing single membership is cancelled (`replaced_by_couple`) only on explicit confirmation; a partner already in a couple blocks the sale.
- The server computes the pro-rated replacement credit (`GET /memberships/replacement-preview`).

## Consequences
- Existing per-member readers work for the partner with no change.
- Every lifecycle operation fans out to the partner row; this logic must stay in `MembershipService`.
- The dashboard counts a couple as two active memberships, matching the member count. Revenue is unaffected (one payment).
- Dates can only diverge through a bug, so lifecycle operations must never touch a single row of a linked pair.

## Alternatives considered
- **Group/household table** with members attached: more general, but every per-member reader would need a join and the gate/PT checks would change.
- **One row with two member ids:** breaks the one-row-per-member invariants and unique locker/active constraints.

## Revisit if
Groups larger than two (families), split invoices, or converting a single membership into a couple one are ever required.
