# Create, edit and delete: backend tasks

**Plan:** [plan.md](./plan.md)
**Markers:** `[ ]` todo, `[~]` doing, `[x]` done and verified, `[!]` blocked, `[>]` later (deferred, not part of this delivery). This file is the status source.
**Paths** are under `apps/api/src/` unless stated. `acct/` and `inv/` are the module folders.
**Amend** means the flow in plan decision 2. **Delete** means plan decision 4.
**Types in scope:** expenses, journals, purchase bills, payment vouchers, counter sales.

## B0 Shared support

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-B01 | `[ ]` | Add an amend helper to `acct/accounting-posting.service.ts` (or a small `amend-posting.ts`): given a document's current `journal_entry_id`, reverse it, then post the replacement lines and return the new entry. Reuse `reverseJournal` and `postJournal`. Both run inside the caller's transaction | — | Unit test: balances net to the new lines, and the original, reversal and new entries are all kept |
| CP-B02 | `[ ]` | Add the guard helper: both dates in open periods, `row_version` match (a shared conflict error otherwise), status not `void` | CP-B01 | Unit test per guard |
| CP-B03 | `[ ]` | Add the delete helper: guards, reverse the journal, set `void`, bump `row_version`. Reject an already void record with a clear error | CP-B01, CP-B02 | Unit test: balances return to the pre-create values |
| CP-B04 | `[ ]` | Expose `journal_entries` (original, reversal, current, in order) on each in-scope document DTO | CP-B01 | DTO returns the chain |
| CP-B05 | `[ ]` | Make sure void records are excluded from balances, AP, GST and other reports, and that every in-scope list has a `status` filter that includes `void` | CP-B03 | Report specs show void records excluded |

## B1 Expense vouchers

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-B06 | `[ ]` | `acct/expenses.service.ts`: `create()` inserts the draft then calls `post()` in the same transaction | — | One call returns a `posted` expense |
| CP-B07 | `[ ]` | `update()` on a posted expense uses amend, including line and tax changes. The update DTO carries `row_version` | CP-B02, CP-B06 | Editing lines, tax or account changes balances correctly |
| CP-B08 | `[ ]` | `remove()` uses the delete helper | CP-B03, CP-B06 | Delete voids the expense and nets the ledger |
| CP-B09 | `[ ]` | `acct/expenses.controller.ts`: delete `POST :id/post`. Keep `PATCH :id`, add `DELETE :id`. Keep `@UseIdempotency()` on `POST`. Update summaries | CP-B07, CP-B08 | Controller exposes list, get, create, patch, delete |
| CP-B10 | `[ ]` | Specs for service and controller. Cover: control account rejected on create and on amend, no orphan row after a failed post, amend and delete balances, locked period, stale version, replayed delete | CP-B09 | Specs pass |

## B2 Journal vouchers

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-B11 | `[ ]` | `acct/journal.service.ts`: add `update()` for manual journals only, using amend. Reject entries whose `source_type` is not manual with a message naming the owning document type | CP-B02 | Manual journal edit nets correctly. Non-manual rejected |
| CP-B12 | `[ ]` | Add `remove()` for manual journals, performing the existing reversal. Remove `reverse()` from the service surface | CP-B03 | Delete reverses and marks the entry void |
| CP-B13 | `[ ]` | `acct/journal.controller.ts`: add `PATCH :id` and `DELETE :id`. Remove `POST :id/reverse`. Add `@UseIdempotency()` to `POST` if missing | CP-B11, CP-B12 | Controller exposes list, get, create, patch, delete |
| CP-B14 | `[ ]` | Specs: balanced lines required, locked period, non-manual source, stale version, reversal through delete, no double reversal | CP-B13 | Specs pass |

## B3 Purchase bills

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-B15 | `[ ]` | `acct/purchase-bills.service.ts`: add `update()` using amend. Take the removed update code from `a29fb82^` as a starting point. Recompute lines and tax with `processLines` | CP-B02 | Edit changes total and journal correctly |
| CP-B16 | `[ ]` | Downstream guards on edit: reject a vendor change when posted allocations or debit notes exist. Reject a new total below the settled amount. Keep the supplier invoice uniqueness check, excluding this bill | CP-B15 | One test per rule |
| CP-B17 | `[ ]` | Stock on amend: reverse the original stock receipts for tracked lines and receive the new quantities in the same transaction. Reject if issued stock would go negative | CP-B15 | Stock on hand matches the new quantities. Negative case rejected |
| CP-B18 | `[ ]` | `remove()`: reject when posted allocations or debit notes exist. Reverse stock receipts, rejecting if issued stock would go negative | CP-B03, CP-B17 | Guards tested. Stock restored |
| CP-B19 | `[ ]` | `acct/purchase-bills.controller.ts`: add `PATCH :id` and `DELETE :id`. `POST` stays create-and-post | CP-B15, CP-B18 | Controller exposes list, get, create, patch, delete |
| CP-B20 | `[ ]` | Specs: amend balances, downstream guards, stock, locked period, stale version, delete guards | CP-B16, CP-B19 | Specs pass |

## B4 Payment vouchers

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-B21 | `[ ]` | `acct/payment-vouchers.service.ts`: `create()` requires at least one allocation, inserts, then calls `post()` in the same transaction | — | One call returns a `posted` voucher |
| CP-B22 | `[ ]` | Re-verify open bill balances once under the transaction so concurrent creates cannot over-allocate | CP-B21 | Concurrent-create test fails before the change and passes after |
| CP-B23 | `[ ]` | `update()` on a posted voucher uses amend. Release the voucher's old allocations, then validate the new ones against open balances, in the same transaction | CP-B02, CP-B22 | Re-pointing an allocation updates both bills' open balances |
| CP-B24 | `[ ]` | `remove()` uses the delete helper and releases all allocations so bill balances go back up | CP-B03, CP-B22 | Bill open balances restored |
| CP-B25 | `[ ]` | `acct/payment-vouchers.controller.ts`: delete `POST :id/post`. Keep `PATCH :id`, add `DELETE :id`, add `@UseIdempotency()` and the header to `POST`. Make `allocations` required and non-empty in the create and update schemas | CP-B23, CP-B24 | Empty allocations rejected at validation |
| CP-B26 | `[ ]` | Specs: no allocations, over-allocation, bill not posted, replayed key, amend re-allocation, amend to a bill with insufficient balance, stale version, delete restores balances | CP-B25 | Specs pass |

## B5 Counter sales

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-B27 | `[ ]` | Confirm `POST /inventory/counter-sales` has `@UseIdempotency()` and the header. Add if missing | — | Replay of the same key returns the same sale |
| CP-B28 | `[ ]` | `inv/stock.service.ts`: add `reverseIssue(sourceType, sourceId)` that puts issued stock back at the original unit cost and records the movement. Needed by amend and delete | — | Stock on hand and value return to the pre-sale values |
| CP-B29 | `[ ]` | `inv/counter-sales.service.ts`: add `update()` using amend. In one transaction: guards, `reverseIssue`, replace lines and tenders, re-issue stock at the current cost, recompute COGS, check tenders equal the new total, reverse and repost the journal, bump `row_version`. Reuse `prepareLines`, `prepareTenders` and `buildJournalLines` | CP-B02, CP-B28 | Edit changes totals, COGS and the journal correctly |
| CP-B30 | `[ ]` | Guard: reject edit and delete when a sales return exists for the sale. The message names the return numbers | CP-B29 | Test for both operations |
| CP-B31 | `[ ]` | `remove()`: guards, `reverseIssue`, reverse the journal, set `void` | CP-B03, CP-B28, CP-B30 | Delete restores stock and nets the ledger |
| CP-B32 | `[ ]` | Add the update DTO (`CounterSaleUpdate`) with `row_version`. `inv/counter-sales.controller.ts`: add `PATCH :id` and `DELETE :id`. `POST` and the list and get routes stay | CP-B29, CP-B31 | Controller exposes list, get, create, patch, delete |
| CP-B33 | `[ ]` | Specs: amend with quantity, price and tender changes, tracked and untracked items, stock insufficient on re-issue, tender mismatch, locked period, stale version, return blocks edit and delete, delete restores stock | CP-B32 | Specs pass |
| CP-B34 | `[ ]` | Check that GST summary and the inventory overview exclude void sales and use amended values | CP-B05, CP-B33 | Report specs pass |

## B6 Permissions (plan decision 8)

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-B35 | `[ ]` | `platform/db/seed/permissions.ts`: add 20 slugs. Accounting: `accounting.{expenses,payment_vouchers,purchase_bills,journals}.{create,read,update,delete}`. Inventory: `inventory.counter_sales.{create,read,update,delete}`. Clear descriptions. Remove `accounting.expenses_write` and `accounting.journals_write`. **Keep** `accounting.purchases_write` and `accounting.payments_write` (debit notes and fund transfers still use them) and `inventory.sales_write` (returns) | — | Seed lists the 20 new slugs. Kept slugs are untouched |
| CP-B36 | `[ ]` | `platform/db/seed/roles.ts`: grant the 20 to the admin role in place of the two removed slugs. Decide what other seeded roles get and record it in the plan. Default: create, read, update for an accountant role, read only for a viewer, delete for admin only | CP-B35 | Role seed reflects the decision |
| CP-B37 | `[ ]` | Controllers: set `@RequirePermission` per route as `.read`, `.create`, `.update`, `.delete` for the five types. Debit note and fund transfer controllers are not touched | CP-B35 | Each in-scope route maps to exactly one new slug |
| CP-B38 | `[ ]` | Search `apps/api` for `expenses_write` and `journals_write` (including the go-live opening balance path and the sales bridge) and move them to the new slugs. Opening balances keep working for admin | CP-B35 | `grep` finds none outside seed history |
| CP-B39 | `[ ]` | Permission specs for each of the five controllers: only `.read` gets 403 on create, update and delete. `.update` without `.delete` cannot delete. Update existing specs that name the old slugs | CP-B37 | Specs pass |
| CP-B40 | `[ ]` | Check that the endpoint that sends the current user's permissions to the app returns the new slugs for admin | CP-B35 | Response includes the 20 slugs |
| CP-B41 | `[ ]` | Reset the local DB and re-seed. No migration for the removed slugs | CP-B36 | A fresh DB has the new slugs and no `expenses_write` or `journals_write` |

## B7 Contract and cross-cutting

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-B42 | `[ ]` | Update `acct/phase4-purchases-expenses-money-out.spec.ts` to the create-posts, amend and delete flows for expenses and payment vouchers | CP-B06, CP-B21 | Spec passes |
| CP-B43 | `[ ]` | Run `pnpm --filter api openapi:dump`, commit `docs/openapi/v1.yaml`, run `openapi:check`. Removed: `postExpense`, `postPaymentVoucher`, journal reverse. Added: `PATCH` and `DELETE` for the five types, `journal_entries` on the DTOs, the new permissions in descriptions. Debit note and fund transfer operations stay as they are | CP-B09, CP-B13, CP-B19, CP-B25, CP-B32 | Parity check passes |
| CP-B44 | `[ ]` | Regenerate `packages/api_client`. Confirm no post operation remains for expenses and payment vouchers, update models exist for the five types, and `serializers.g.dart` matches the contract. Delete tests of removed operations | CP-B43 | `dart analyze packages/api_client` is clean. Frontend is unblocked |
| CP-B45 | `[ ]` | Search `apps/api` for other callers of the services' `post()` and `update()` (sales bridge, revenue recognition, seeds, scripts) and fix any that break | CP-B10, CP-B14, CP-B20, CP-B26, CP-B33 | Only expected internal calls remain |
| CP-B46 | `[ ]` | Ledger integrity spec: create, edit and delete one of each of the five types, then assert the trial balance equals the expected values and total debits equal total credits | CP-B45 | Spec passes |
| CP-B47 | `[ ]` | Regression: run the existing fund transfer and debit note specs unchanged | CP-B45 | They pass without edits |
| CP-B48 | `[ ]` | Run the full API suite and typecheck | CP-B42, CP-B46, CP-B47 | `pnpm --filter api test` and `tsc --noEmit` pass |
| CP-B49 | `[ ]` | Update `docs/plans/accounting/implementation-plan.md`, `tasks-register.md`, the inventory plan (mark INV-082 as moved to this plan) and the ADR where they describe draft-then-post or immutable posted records | CP-B48 | Docs match |

## B8 Deferred: fund transfers and debit notes

Parked. Start these only when asked. Each follows the same pattern as expenses.

| ID | Status | Task | Depends on | Done when |
|---|---|---|---|---|
| CP-B50 | `[>]` | Fund transfers: create posts, `PATCH` amends, `DELETE` voids, drop `POST :id/post`. Move to own four permissions. Remove `accounting.payments_write` once nothing uses it | CP-B48 | Same checks as expenses |
| CP-B51 | `[>]` | Debit notes: create posts, add `PATCH` and `DELETE`, drop `POST :id/post`. Amount must not exceed the bill's open balance, with this note's old amount released. Move to own four permissions. Remove `accounting.purchases_write` once nothing uses it | CP-B48 | Same checks as expenses |
