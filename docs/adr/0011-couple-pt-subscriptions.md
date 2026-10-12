# ADR-0011: Couple PT as two linked subscriptions sharing one session

**Status:** Accepted

## Context
Couple memberships already use two linked rows (ADR-0010). PT packages still covered one member and one trainer slot. The gym needs **Couple PT**: two members buy PT together, train in the same hour with the same trainer, and keep dates, trainer and slot identical for the whole lifecycle.

A trainer-hour can hold only one `schedules` row (overlap is the busy check), so a couple PT cannot emit one session row per member.

## Decision
Each member gets their own `pt_subscriptions` row. The rows point at each other through `partner_subscription_id`. Products carry `package_type` (`single` | `couple`). The primary row (`is_primary = true`) owns the invoice and the generated sessions.

- **Shared session:** one `schedules` row per occurrence, `max_capacity = 2`, two `schedule_participants`, `pt_subscription_id` = primary. Title reads `PT · A & B`.
- **Billing:** one payment against the primary member at the package total less an optional discount.
- **Lifecycle:** renew, reassign trainer and change slot (and the shared replan they use) apply to both rows in one transaction. Renew keeps the same `package_type` and bills the primary. The client's `row_version` guards only the acted-on row; the partner is re-read server-side.
- **Eligibility:** each member needs an active, unexpired gym membership (ADR-0009 §5). It does not have to be a couple membership. A partner who already has an open overlapping PT blocks the sale (no replace-and-credit flow yet; PT has no cancel operation to build it on).
- **Schedule grid:** `GET /pt/schedule-grid` accepts optional `partner_member_id`; a cell is occupied when either member is busy. Re-plan resolves the partner from the subscription when the query omits it.

## Consequences
- Existing per-member readers (trainer access, dossier summary, one-open-PT rule, `assigned_trainer_id`) keep working for the partner.
- Every lifecycle operation must fan out to both rows or neither; divergence is a bug.
- Session tools go through `occurrenceOwnerId(sub)` so partner-row callers still exclude/regenerate the shared sessions.
- Capacity 2 must not admit a third booker on a couple PT session.

## Alternatives considered
- **One subscription with two member ids:** breaks per-member readers and the one-open-PT invariant.
- **Two session rows per hour:** fights the trainer-busy overlap model and double-books the trainer hour.
- **Group/household table:** more general, but every PT reader and the schedule grid would need new joins.

## Revisit if
Groups larger than two, split invoices, converting single ↔ couple on renew, or replacing a partner's existing PT (needs a cancel + credit operation) are required.
