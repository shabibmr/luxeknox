# Phase 4 stubs — Couple PT linked lifecycle

Scope (user chose stubs-only): CP-08/09/10 assuming partner helpers; skip CP-07 purchase.

## Already present
- Schema: `partner_subscription_id`, `is_primary`, `package_type`
- Repo CP-04: `setPartner`, `findPartner`, `lockMembers`, `occurrenceOwnerId`

## [MODIFY] `apps/api/src/pt/pt-subscription.service.ts`
- `loadPartner(sub)` / `assertSamePackageType(current, target)`
- `resolvePair(sub)` → `{ primary, partner }` (caller may be either side)
- **renew**: type match; if partner, create two linked rows (bill primary, each `renewed_from_id`), shared sessions on primary; single path unchanged
- **replan** (via reassignTrainer/changeSlot): resolve pair; cancel/regen once on `occurrenceOwnerId`; bump/change/audit both rows; update `assigned_trainer_id` for both when effective

## [MODIFY] `apps/api/src/pt/pt-subscription.service.spec.ts`
- Couple renew happy path + type mismatch + renew from partner side
- Couple reassign/changeSlot updates both
- Status transitions move both rows

## [MODIFY] `apps/api/src/pt/pt-access.service.spec.ts`
- Both members get `full` while active, `read_only` after end

## [MODIFY] `docs/plans/1210-couple-pt-packages/TASKS.md`
- Mark CP-08/09/10 completed (note stubs; purchase still Phase 3)

## Out of scope
- CP-07 purchase, CP-05 multi-member conflicts API shape beyond what replan needs, Flutter/OpenAPI
