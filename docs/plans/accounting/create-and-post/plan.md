# Create-and-post, edit and delete for five transactions

**Branch:** `feat/accounting`
**Task lists:** [tasks-backend.md](./tasks-backend.md), [tasks-frontend.md](./tasks-frontend.md)
**Precedent for create-and-post:** purchase bills (commits `a29fb82` API, `87ac714` Flutter, `0e82728` client serializers). That change also removed bill update, which this plan restores in a new form.

## Scope

**In scope now (5 types):** expense vouchers, payment vouchers, purchase bills, counter sales, journal vouchers.

**Deferred (2 types):** fund transfers and debit notes. They keep their current draft-then-post behaviour and their current permissions (`accounting.payments_write` and `accounting.purchases_write`). Their tasks are parked as `[>]` at the end of the backend list. Nothing in this plan may break them.

## Goal

1. One call creates a transaction and posts it. No draft step, no separate post call.
2. A posted transaction can be edited. The edit corrects the ledger as well as the document.
3. A posted transaction can be deleted. Delete reverses the ledger and keeps the record as `void`.
4. Each of the five types has four permissions: create, read, update and delete.

## Current state

| Transaction | Create | Edit | Delete | Flutter screens |
|---|---|---|---|---|
| Expense voucher | `POST` makes a draft | `PATCH` on drafts only | none | list, form, detail (with Post) |
| Payment voucher | `POST` makes a draft | `PATCH` on drafts only | none | list, form, detail (with Post) |
| Purchase bill | `POST` creates and posts | removed in `a29fb82` | none | list, form, detail |
| Counter sale | `POST /inventory/counter-sales` creates and posts (stock issue, COGS, tenders) | none | none | **none exist** (planned as INV-082, not started) |
| Journal voucher | `POST` posts on create | none | `POST /:id/reverse` only | list, form, detail |

## Decisions

1. **Create posts.** For expenses and payment vouchers, `create()` validates, then in one `runInTransaction` inserts the row as `draft` and calls the existing `post()`. A post failure rolls back the insert. `draft` stays as an internal transient status, so there is no schema change. Purchase bills, counter sales and journals already behave this way.
2. **Edit is an amendment, not a mutation.** `PATCH /:id` on a posted record runs in one transaction:
   1. Check the guards (decision 3).
   2. Reverse the original journal with the existing `reverseJournal`.
   3. Update the document header and lines.
   4. Post a new journal from the updated document.
   5. Store the new `journal_entry_id` and bump `row_version`.

   The original entry and its reversal stay in the ledger as the audit trail. The document shows current values only. Any failure rolls the whole edit back.
3. **Edit guards.**
   - The period of the original date and the period of the new date must both be open.
   - The request carries the `row_version` it was loaded with. A mismatch returns a conflict.
   - A `void` record cannot be edited.
   - **Purchase bills:** with posted payment allocations or debit notes against the bill, the vendor cannot change and the new total cannot fall below what is settled. Stock received on the bill is reversed and received again in the same transaction. The edit is rejected if issued stock would go negative.
   - **Payment vouchers:** new allocations may only target posted bills with enough open balance. The voucher's own previous allocations count as released.
   - **Counter sales:** a sale with a sales return cannot be edited, because returns point at sale lines. Stock issued by the sale is put back at its original cost, then the new lines are issued at the current cost. COGS and the journal are recomputed. Tenders must still equal the new total.
   - **Journals:** only manual journals are editable. Entries made by other modules are edited through their own document.
4. **Delete is a soft delete.** `DELETE /:id` on a posted record runs in one transaction: guards from decision 3, reverse the journal (and put back or remove stock where the type moved stock), set `status = 'void'`, bump `row_version`. The row stays so the audit trail and document numbers survive. Void records show in lists under a status filter, cannot be edited, and are excluded from balances and reports.
   - A bill with posted allocations or debit notes cannot be deleted until those are removed.
   - Deleting a payment voucher releases its allocations.
   - A counter sale with a sales return cannot be deleted.
   - For manual journals, `DELETE /:id` performs the existing reversal and replaces `POST /:id/reverse`.
5. **Remove the post endpoint.** Delete `POST /:id/post` from expenses and payment vouchers. Keep `post()` as an internal service method used by create and by amend.
6. **Payment vouchers need allocations at create**, because posting requires at least one. The form collects them before submit.
7. **Idempotency.** Every create endpoint has `@UseIdempotency()` and the `Idempotency-Key` header. `PATCH` and `DELETE` are made safe by `row_version`: a replay fails the version check instead of repeating the change.
8. **Permissions: four per type, 20 slugs.** Slugs are `<module>.<type>.<action>` with actions `create`, `read`, `update`, `delete`:
   - `accounting.expenses.*`, `accounting.payment_vouchers.*`, `accounting.purchase_bills.*`, `accounting.journals.*`
   - `inventory.counter_sales.*`

   Mapping: `POST` needs create, `GET` list and detail need read, `PATCH` needs update, `DELETE` needs delete. Seed all 20 on the admin role.
   - **Removed:** `accounting.expenses_write` and `accounting.journals_write`, which only these types used.
   - **Kept for now:** `accounting.purchases_write` (still used by debit notes) and `accounting.payments_write` (still used by fund transfers). Remove them when those two types are done.
   - **Kept:** `inventory.sales_write` (sales returns), `inventory.read` (items, stock, overview), `accounting.read` (reports, chart of accounts, periods, go-live status), `accounts_write`, `vendors_write`, `periods_close`, `posting_toggle`.
   - No compatibility aliases, since the app is in development.
9. **Flutter.** One form serves create and edit per type. The detail screen shows Edit on posted records when the user has the type's `update` permission and the period is open, and Delete with the `delete` permission. Server rule failures show inline and keep the user's input. A version conflict reloads the record. The detail screen lists the linked journal entries (original, reversal, current).
10. **Counter sale screens are built once, here.** INV-082 in the inventory plan already covers the sale screen, list and detail. This plan takes over that screen work and adds edit and delete, so the screens are not built twice. Mark INV-082 as moved here when work starts.
11. **No migration or compatibility code.** The app is in development. Reset the local DB. Existing draft rows are dropped with it.

## Order of work

1. Shared amend and delete helpers, built inside the expense voucher work (the simplest type).
2. Backend per type: expenses, journals, purchase bills, payment vouchers, counter sales.
3. Permissions seed, then update controllers.
4. `docs/openapi/v1.yaml` with `openapi:dump` and `openapi:check`, then regenerate `packages/api_client`.
5. Flutter per type in the same order. Counter sales last, since the screens are new.
6. Cross-cutting checks and docs.

## Risks

- **Amend correctness.** The ledger must net to the new values after an edit, and reports must not double count. Every amend and delete test asserts account balances before and after, not only status.
- **Downstream links.** Bills with payments, debit notes or stock, and sales with returns, are the hard cases. Decision 3 lists the rules. Each rule needs a test.
- **Counter sale cost changes on edit.** Re-issuing stock at the current cost can change COGS compared with the original sale. That is intended, and the journal shows both the reversal and the new cost.
- **Concurrency.** Two edits, or a payment against a bill during its edit. Covered by `row_version` and by re-checking balances inside the transaction.
- **Payment voucher form is the largest change to an existing screen.** Counter sales is the largest overall, because it is a whole new feature.
- **Deferred types share code.** Fund transfers and debit notes use the same posting service and the old permission slugs. Keep those slugs, and run their existing specs after every shared change.
- **Generated client drift.** `serializers.g.dart` kept a stale `PurchaseBillUpdate` after `0e82728`. Confirm after regenerating that no post operation remains for expenses and payment vouchers and that update models match the contract.
- **Existing tests assert the draft flow.** Rewrite them. Keep the post-time rule coverage.

## Verification

- API: `pnpm --filter api test`, including `phase4-purchases-expenses-money-out.spec.ts` and the counter sale specs.
- Contract: `pnpm --filter api openapi:check`.
- Flutter: `flutter test test/features/accounting` and the new inventory feature tests.
- Manual: with a local build pointed at the local API (check the Firestore API URL first so the build does not hit production), create, edit and delete one of each type. Confirm the trial balance reflects each step, and that a read-only user sees no create, edit or delete controls.
