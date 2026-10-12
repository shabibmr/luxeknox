# ADR-0012: A PT package includes a gym membership of the same duration

**Status:** Accepted
**Supersedes in part:** ADR-0009 §5 (membership gate) and the eligibility rule in ADR-0011.

## Context
PT sales required the member to already hold an active, unexpired gym membership. Policy changed: PT is bundled with membership. Selling PT adds a membership of the same duration, so a member with no membership can buy PT.

## Decision
Every PT sale and renewal bundles a membership, in the same transaction as the PT rows (`MembershipService.bundleForPt`):

- **No active membership** (none, expired, cancelled): a new membership is created for the PT period (`start_date` to the PT `end_date`). It points at a catalog-hidden product, `PT-BUNDLE` ("PT Bundled"), seeded in migration `0020`. The product is inactive, so it is never offered for a normal membership sale, and it has `max_freeze_days = 0`.
- **Active membership:** it is extended by the PT package's `duration_days`, continuing from the day after its end date (from today if it has lapsed), the same way a renewal does. The product is kept. History records `renewed`; audit records `via: pt_bundle`.
- **Frozen membership:** the sale is rejected until it is unfrozen.
- **Linked couple membership (ADR-0010):** both rows of the pair are extended together, once, even when both members buy a couple PT. A single PT sold to one half of a couple pair therefore extends the partner's membership too.
- **Price:** the membership is included in the PT price. No separate payment is created. `pt_subscriptions.membership_id` points at the created or extended membership.
- **Couple PT:** each of the two members gets a membership (created or extended) independently. The bundled memberships are not linked as a couple membership.

The PT sale no longer checks for a membership; it fails only if the bundling fails (for example, a frozen membership), and nothing is written in that case.

## Consequences
- PT revenue is not split between PT and membership; membership counts include PT-bundled members.
- A bundled membership cannot be renewed from the membership screen with its current product (inactive). Staff pick a real product, or renew the PT, which extends the membership again.
- Because the membership always covers the PT period, "PT runs past the membership end" cannot happen for new sales.

## Revisit if
The gym wants bundled memberships priced or reported separately, per-PT-product membership tiers (a membership product linked to each PT product), or freezes on bundled memberships.
