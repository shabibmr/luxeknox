# Tasks Register: PT Package Includes Gym Membership

Policy: a PT package is bundled with a gym membership of the same duration. Selling or renewing PT creates or extends the membership, so members with no membership can buy PT. Decision record: [ADR-0012](../../adr/0012-pt-includes-membership.md).

**Status values:** `blocked` · `pending` · `in-progress` · `review` · `completed`
`review` = code is written, but not yet verified after the last edit.

Decisions: one inactive `PT-BUNDLE` membership product · PT duration is added on top of an existing membership · no extra charge · frozen membership blocks the sale · a linked couple membership pair is extended together.

## Backend (`apps/api`)

| ID | Task | Status |
| :--- | :--- | :--- |
| PM-01 | Insert the inactive `PT-BUNDLE` membership product in `drizzle/0020_personal_training.sql` | completed |
| PM-02 | `MembershipService.bundleForPt` (create / extend / reject frozen / couple pair once) and `emitEvents` | completed |
| PM-03 | `PtSubscriptionService`: remove the membership gate; call `bundleForPt` inside the sale transaction; emit events after commit | completed |
| PM-04 | Update `pt-subscription.service.spec.ts` (new membership mock; purchase, couple and renew bundling tests) | completed |
| PM-05 | Add `bundleForPt` tests to `membership.service.spec.ts` (8 cases) | completed |
| PM-06 | Full API verification: `vitest run` for the whole app, `tsc --noEmit`, `db:check`, `openapi:check` | completed |
| PM-07 | Reset the local DB (localhost:3308), `api:migrate`, `api:seed`; confirm `PT-BUNDLE` exists with `is_active = 0` | completed |
| PM-08 | Manual API check: PT sale with no membership, with an existing membership, and a couple PT; renew | completed |

PM-08 result (API on :3311 against local MySQL, 2026-10-12): all five cases behave as designed. (1) Single PT, no membership: 201, new `PT-BUNDLE` membership 10-12 → 11-11 (matches the PT). (2) Single PT on a 365-day membership: 201, end 2027-10-12 → 2027-11-12 (30 days added from the day after the old end). (3) Couple PT, neither member had a membership: 201, each got their own membership 10-12 → 11-11; they are not linked to each other (`partner_membership_id` null). (4) Renew single PT: 201, membership end → 12-12, matching the new PT end. (5) Renew couple PT: 201, both memberships → 12-12. Test members (`pm08_*`) remain in the local DB.

PM-06 result: `tsc --noEmit`, `db:check` and `openapi:check` pass (the earlier `_byId` / `_setNextId` errors no longer appear). `vitest run`: 714 passed, 1 failed - `src/sys/settings.controller.spec.ts` "rejects unsupported category query values" (`getAllSettings('not-a-category')` resolves instead of rejecting). That file is unchanged versus `main`, so the failure is outside this work.

PM-04/PM-05 status: `vitest run src/memb src/pt` passed (135 tests). `tsc --noEmit` reports two errors in `pt-subscription.service.spec.ts` at the `_byId` / `_setNextId` mock typings (lines 138-139). They are in code I did not change; PM-06 should confirm they predate this work.

## Flutter (`app`)

| ID | Task | Status |
| :--- | :--- | :--- |
| PM-09 | `canSellPt`: drop the membership requirement; update the dossier call site | completed |
| PM-10 | `SellPtCubit`: partner check keeps only the open-PT rule; remove `GetMembershipsUseCase`; remove the two partner-membership strings | completed |
| PM-11 | Sell PT summary: "includes a gym membership" note (single and couple wording); renew dialog mentions the membership extension | completed |
| PM-12 | Regenerate `injector.config.dart` (build_runner) | completed |
| PM-13 | Update tests: `member_dossier_pt_test`, `sell_pt_cubit_test`, `member_dossier_screen_test` (PT is sellable with no or an expired membership) | completed |
| PM-14 | Re-run `flutter analyze` and `flutter test test/features/pt test/features/people` after the last edits | completed |
| PM-15 | Run the app against the local API: "Add PT" shows for a member with no membership and the sale completes | pending |

PM-13/PM-14: `flutter test test/features/pt test/features/people` gives 190 passed, 1 failed. The failure is `people/data/role_deserialization_test.dart` (`Role.isSystemRole` null in the generated client), outside this change. `flutter analyze` reports 9 issues, none in files this change touches (scheduling, auth, settings, goals).

## Docs

| ID | Task | Status |
| :--- | :--- | :--- |
| PM-16 | Write ADR-0012 and add it to `docs/adr/README.md` | completed |
| PM-17 | Mark ADR-0009 §5, ADR-0011 eligibility and the couple PT plan as superseded; update FRD FR-MEMB-009 | completed |
| PM-18 | `docs/openapi/v1.yaml`: no change needed (no membership requirement is described there) | completed |

## Open items

- Bundled memberships cannot be renewed from the membership screen with their own (inactive) product. Staff pick a real product, or renew the PT. Not changed.
- A single PT sold to one half of a linked couple membership extends the partner's membership too (ADR-0010 forbids touching one row). Needs product sign-off.
- `apps/api/test/pt-couple.e2e.spec.ts` is untracked and was created by another terminal during this session. I have not read it in full; from a grep it sells a gym membership before each PT sale (`sellGymMembership`), which still works but no longer tests the policy. Review it against the new rule once that work lands.
- Nothing is committed yet.
