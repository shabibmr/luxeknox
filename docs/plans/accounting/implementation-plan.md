# Accounting module implementation plan

**Status:** Accepted.
**Register:** [tasks-register.md](./tasks-register.md) is the status source. Update markers there as work moves.
**Worktree:** `E:\work\gym-checkouts\accounting` on `feat/accounting`.
**Date:** 2026-10-12.

## Goal

Add double-entry books for one gym. Member sales stay on the existing payments module. Accounting posts journals from those invoices and receipts, and adds the documents the counter does not have: chart of accounts, periods, vendors, purchase bills, expense vouchers, money-out payments, credit notes, debit notes, and month-end revenue recognition.

Inventory, bank reconciliation, payroll, and fixed assets are named in the register as later work. They are not part of this delivery.

## Decisions locked by this plan

1. **Accrual.** An issued member invoice debits accounts receivable. A collection debits bank or cash and credits receivable. A prepaid membership or personal-training term credits unearned revenue. A monthly job moves that month's share into income.
2. **The general ledger is the posted journal lines.** Reports query `journal_lines`. There is no second ledger table.
3. **Posted journals are immutable.** A correction is a reversing journal. Draft source documents can be edited. Posted ones cannot.
4. **One source, one journal.** Unique `(source_type, source_id)` on `journal_entries`. Replaying a post returns the original journal.
5. **Books start at go-live.** Historical `payments` rows are not backfilled. The opening balances are one manual journal dated the day before go-live. A setting `accounting.posting_enabled` gates automatic posts. While it is `false`, payments behave exactly as they do today.
6. **Single gym.** No `gym_id`. ADR-0004 stands.
7. **Money.** `DECIMAL(12,2)` stored as strings. All arithmetic goes through `toCents`, `addMoney`, `subMoney`, `cmpMoney`, and `roundMoney` in `apps/api/src/platform/money/money.ts`. Tax is computed per line, half-up to 2dp. Document total equals the sum of rounded lines.
8. **Currency.** The existing `gym_settings.currency` (default `INR`). No multi-currency.
9. **Tax.** Seed an exempt code at 0% and an intra-state GST 18% code that splits into CGST 9% and SGST 9%, plus an IGST 18% code. The server computes tax. Client-supplied tax amounts are ignored, matching FR-PAY-005.
10. **Parties.** Members remain the sales party. Vendors are new. A walk-in sale stays a member sale in `payments`.
11. **Accounts receivable and accounts payable** are the open sales invoices and unpaid bills sitting on control accounts. They are not extra balance tables.
12. **Admin and super_admin** receive every new permission. Other roles receive none until someone grants them.

## What already exists

Use these. Do not replace them.

| Piece | Where |
|---|---|
| Member invoice | `payments` in `apps/api/src/platform/db/schema/payments.ts`. Status `pending`, `partial`, `paid`, `refunded`. |
| Tender, refund, adjustment | `payment_histories` (`payment_received`, `refunded`, `adjusted`). |
| Printed receipt | `payment_receipts`. This is a PDF, not the accounting receipt voucher. |
| Number counters | `invoice_number_counters`, `receipt_number_counters`. New sequences follow that single-row pattern. |
| Payment methods | `payment_methods` (`is_digital`, `is_active`). |
| Money helpers | `apps/api/src/platform/money/money.ts`. |
| Tax and currency settings | `tax_rate_percent` default `18.00`, `currency` default `INR`, in `apps/api/src/sys/settings.dto.ts`. |
| Pay module | `apps/api/src/pay/`. Imported by membership, PT, notifications, and dashboard. |
| Jobs | `JobRunnerService.register` in `apps/api/src/job/job-runner.service.ts`. |
| Audit | `apps/api/src/platform/audit/`. |
| Permissions seed | `apps/api/src/platform/db/seed/permissions.ts` and `roles.ts`. |
| Flutter payments | `app/lib/features/payments/` with `@LazySingleton` datasources and `@injectable` cubits. Admin routes in `app/lib/core/router/admin_routes.dart`. |
| Migrations | Next file is `apps/api/drizzle/0025_accounting.sql`. Two files already share the `0024` prefix. |

`payments` has header totals and no lines. The sales bridge posts from the header. Purchase bills and expenses do have lines.

## Out of scope

- Stock items, warehouses, goods receipts, stock movements. The `items` row has `inventory_tracked` default `false` so a later module can turn it on.
- Bank statement import and reconciliation.
- Payroll runs, payslips, and statutory deductions. Salaries can be recorded as an expense voucher.
- Fixed assets and depreciation.
- Budgets, cost centres, multi-currency, multi-gym.
- Member-facing accounting screens. Members keep the payments ledger.
- Rewriting POS. POS still writes `payments` and `payment_histories`.

## Posting rules

Every automatic post runs in the same database transaction as the source write. A post into a locked period fails the whole transaction. A journal with unequal debits and credits fails. A line with both a debit and a credit, or with neither, fails. Amounts are positive `DECIMAL(12,2)`. The side is the column, not the sign.

### Member invoice (`payments` insert, status `pending`)

When `accounting.posting_enabled` is `true`:

| Line | Account |
|---|---|
| Debit total | Accounts receivable |
| Debit discount | Sales discounts (`4900`), when discount is greater than zero |
| Credit tax | The tax code's output accounts. Until a line-level tax code exists, use the gym default code from `accounting.default_tax_code` |
| Credit net of tax | Unearned membership (`2200`) when `membership_id` is set. Unearned PT (`2210`) when `pt_subscription_id` is set and `membership_id` is null. Other sales revenue (`4200`) otherwise |

`source_type = sales_invoice`, `source_id = payments.id`.

A product with `income_account_id` set uses that account instead of the default earned-revenue account. Unearned vs earned is still decided by whether the sale has a term (membership or PT). A day-pass or retail sale credits the income account directly.

### Collection (`payment_histories.action = payment_received`)

Debit the cash or bank account linked from `payment_methods.account_id`. Credit accounts receivable. `source_type = sales_receipt`, `source_id = payment_histories.id`.

A missing `account_id` on an active method blocks the post with a clear error once posting is enabled. Seeding must set the link before the flag is turned on.

### Refund (`payment_histories.action = refunded`)

Write a credit note linked to the invoice, then post it.

| Line | Account |
|---|---|
| Debit | The same unearned or income account the invoice credited, in proportion to the refund vs the invoice net |
| Debit | Output tax, in proportion to the refund vs the invoice tax |
| Credit | Accounts receivable when the invoice is not fully collected. Bank or cash when the refund pays money back |

The first ship supports a full refund of the remaining net paid. Partial refunds use the same proportion rule. A refund larger than net paid is already rejected by FR-PAY-012 and must stay rejected.

### Purchase bill (posted)

Credit accounts payable for the total. Debit each line's expense or asset account for the net. Debit input tax for the tax. `source_type = purchase_bill`.

### Expense voucher (posted)

Same as a bill when a vendor is set and the voucher is on credit. A cash expense debits the expense account and credits the chosen bank or cash account directly, with no payable. `source_type = expense_voucher`.

### Payment voucher (money out)

Debit accounts payable for each allocation. Credit bank or cash for the voucher total. An allocation cannot exceed the bill's open balance. The sum of allocations equals the voucher total. `source_type = payment_voucher`.

### Debit note

Debit accounts payable. Credit the bill line accounts and input tax. `source_type = debit_note`.

### Recognition

For each unearned credit, write `revenue_recognition_schedules` for the membership or PT term: start date, end date, total net, amount already recognized. The monthly job `accounting.recognize_revenue` posts, for each open schedule, that month's straight-line share: debit unearned, credit the income account (`4000`, `4100`, or the product `income_account_id`). The last month takes the remainder so the schedule ends at zero. `source_type = revenue_recognition`, `source_id = schedule line id`. The job is safe to run twice in the same month.

### Manual journal and opening balances

`source_type = manual` or `opening_balance`. At least two lines. Balanced. The opening journal is dated the day before go-live and may include cash, bank, receivable, payable, unearned, and owner's capital.

### Period lock

`accounting_periods.status` is `open` or `locked`. Close sets `locked`, stamps `closed_at` and `closed_by_user_id`, and requires a balanced trial balance through that period (debits equal credits). Unlock is a separate permission and writes an audit row. The current open period is the only period that accepts posts, plus any earlier period that is still `open`.

## Data model

All new tables live in `apps/api/src/platform/db/schema/accounting.ts`, exported from `schema/index.ts`. Primary keys are `bigint unsigned` autoincrement. Timestamps use `utcDatetime`. Mutable headers carry `row_version`. Money columns are `decimal(12, 2)`.

| Table | Role |
|---|---|
| `accounts` | Code, name, `account_type` (`asset`, `liability`, `equity`, `income`, `expense`), `parent_id`, `is_active`, `is_bank`, `is_control`, `control_role` (`ar`, `ap`, `unearned_membership`, `unearned_pt`, `output_cgst`, `output_sgst`, `output_igst`, `input_tax`, `discounts`, null) |
| `fiscal_years` | Label, `starts_on`, `ends_on` |
| `accounting_periods` | `fiscal_year_id`, month start, month end, status |
| `tax_codes` | Name, `rate_percent`, active flag |
| `tax_code_components` | `tax_code_id`, name, `rate_percent`, `output_account_id`, `input_account_id` |
| `vendors` | Name, phone, email, `gstin`, active flag |
| `items` | Name, `item_kind` (`service`, `goods`), `inventory_tracked` default false, `income_account_id`, `expense_account_id`, `tax_code_id`, active flag |
| `journal_entries` | Number, date, period, `source_type`, `source_id`, memo, `posted_at`, `posted_by_user_id`, `reverses_journal_id` |
| `journal_lines` | `journal_entry_id`, `account_id`, debit, credit, memo, optional `member_id`, `vendor_id` |
| `purchase_bills` | Vendor, bill number, dates, status (`draft`, `posted`, `void`), totals, `journal_entry_id` |
| `purchase_bill_lines` | Item or account, description, qty, rate, tax code, net, tax |
| `expense_vouchers` | Payee text or `vendor_id`, date, `paid_from_account_id` nullable, status, totals, `journal_entry_id` |
| `expense_voucher_lines` | Account, description, amount, tax code |
| `payment_vouchers` | Date, `bank_account_id`, total, memo, status, `journal_entry_id` |
| `payment_allocations` | `payment_voucher_id`, `purchase_bill_id` or `expense_voucher_id`, amount |
| `credit_notes` | `payment_id`, date, reason, totals, status, `journal_entry_id` |
| `debit_notes` | `purchase_bill_id`, date, reason, totals, status, `journal_entry_id` |
| `revenue_recognition_schedules` | `payment_id`, unearned account, income account, `total_amount`, `recognized_amount`, `starts_on`, `ends_on` |
| `revenue_recognition_lines` | Schedule, period, amount, `journal_entry_id` |

Alter, do not rebuild:

| Column | Table |
|---|---|
| `account_id` nullable FK to `accounts` | `payment_methods` |
| `income_account_id` nullable FK to `accounts` | membership products and PT products |

Counters, same shape as `invoice_number_counters`: journal, purchase bill, expense, payment voucher, credit note, debit note.

Seeded account codes:

| Code | Name | Type |
|---|---|---|
| 1000 | Cash | asset, bank |
| 1010 | Bank | asset, bank |
| 1100 | Accounts receivable | asset, control `ar` |
| 1300 | Input tax | asset, control `input_tax` |
| 2000 | Accounts payable | liability, control `ap` |
| 2100 | Output CGST | liability |
| 2110 | Output SGST | liability |
| 2120 | Output IGST | liability |
| 2200 | Unearned membership revenue | liability |
| 2210 | Unearned personal training revenue | liability |
| 3000 | Owner's capital | equity |
| 3100 | Retained earnings | equity |
| 4000 | Membership revenue | income |
| 4100 | Personal training revenue | income |
| 4200 | Other sales | income |
| 4900 | Sales discounts | income (debit balance) |
| 5000 | Rent | expense |
| 5100 | Utilities | expense |
| 5200 | Salaries | expense |
| 5300 | Supplies | expense |
| 5400 | Repairs and maintenance | expense |
| 5900 | General expense | expense |

Settings keys, added to the settings catalogue:

| Key | Default |
|---|---|
| `accounting.posting_enabled` | `false` |
| `accounting.fiscal_year_start_month` | `4` |
| `accounting.default_tax_code` | slug of the seeded GST 18% code |

## API

New Nest module `apps/api/src/acct/`, imported from `app.module.ts`. Same shape as `pay`: controller, zod DTO, repository, service, module. Repositories are the only SQL. Services call `runInTransaction`.

Permissions, module `ACCT`:

| Slug | Use |
|---|---|
| `accounting.read` | Accounts, journals, documents, reports |
| `accounting.accounts_write` | Chart of accounts, tax codes, items |
| `accounting.vendors_write` | Vendors |
| `accounting.purchases_write` | Bills and debit notes |
| `accounting.expenses_write` | Expense vouchers |
| `accounting.payments_write` | Payment vouchers |
| `accounting.journals_write` | Manual journals and opening balances |
| `accounting.periods_close` | Lock and unlock a period |
| `accounting.posting_toggle` | Flip `accounting.posting_enabled` |

Routes, all under `/accounting`:

- `GET/POST /accounts`, `PATCH /accounts/:id` (no delete; deactivate)
- `GET/POST /tax-codes`, `PATCH /tax-codes/:id`
- `GET/POST /vendors`, `PATCH /vendors/:id`
- `GET/POST /items`, `PATCH /items/:id`
- `GET /fiscal-years`, `GET /periods`, `POST /periods/:id/lock`, `POST /periods/:id/unlock`
- `GET/POST /journals`, `GET /journals/:id`, `POST /journals/:id/reverse`
- `GET/POST /purchase-bills`, `GET /purchase-bills/:id`, `POST /purchase-bills/:id/post`
- `GET/POST /expenses`, `GET /expenses/:id`, `POST /expenses/:id/post`
- `GET/POST /payment-vouchers`, `GET /payment-vouchers/:id`, `POST /payment-vouchers/:id/post`
- `GET/POST /credit-notes`, `POST /credit-notes/:id/post`
- `GET/POST /debit-notes`, `POST /debit-notes/:id/post`
- `GET /reports/trial-balance?from&to`
- `GET /reports/profit-and-loss?from&to`
- `GET /reports/balance-sheet?as_of`
- `GET /reports/day-book?date`
- `GET /reports/open-items?kind=ar|ap`

`POST` of money documents accepts `Idempotency-Key`, same interceptor as payments. List endpoints use the existing pagination DTO. Optimistic concurrency uses `row_version` and returns 409.

Reports:

- Trial balance: every account with movement or a non-zero balance in the range, debit and credit columns, totals equal.
- Profit and loss: income and expense accounts between the dates.
- Balance sheet: asset, liability, and equity as of a date. Current-year earnings is income minus expense since the fiscal year start, shown under equity, so the sheet balances.
- Day book: journals on one date.
- Open items: invoices with `total_amount > amount_paid` for AR. Bills whose allocations are less than the total for AP.

After the controllers exist, run `pnpm --filter api openapi:dump` and regenerate `packages/api_client`. `openapi:check` must pass.

## Flutter

New feature `app/lib/features/accounting/` with `data`, `domain`, and `presentation`, matching `features/payments`. Generated client only. `@LazySingleton` repositories, `@injectable` cubits. Admin shell only.

Screens:

- Accounting home: cash, bank, open AR, open AP, current period.
- Chart of accounts list and form.
- Journal list, detail, and manual entry.
- Vendor list and form.
- Purchase bill list, form, detail, post.
- Expense list, form, detail, post.
- Payment voucher list, form, post.
- Credit note and debit note detail.
- Trial balance, profit and loss, balance sheet, day book.
- Period list with lock.

Add an Accounting destination to the admin shell in `admin_routes.dart` and the route constants. Hide it when the principal lacks `accounting.read`.

Strings live in `accounting_strings.dart`. Money display uses the existing currency formatter. Empty, loading, and error states use the shared widgets.

## File map

**New**

- `docs/adr/0010-accounting-ledger.md` — records the twelve decisions above.
- `apps/api/src/platform/db/schema/accounting.ts`
- `apps/api/drizzle/0025_accounting.sql`
- `apps/api/src/platform/db/seed/accounting.ts`
- `apps/api/src/acct/` — module, posting service, document services, report service, controllers, DTOs, repositories, specs.
- `app/lib/features/accounting/` — feature slice.
- Widget tests beside the new screens.

**Modify**

- `apps/api/src/platform/db/schema/index.ts` — export accounting.
- `apps/api/src/platform/db/schema/payments.ts` — `payment_methods.account_id`.
- Membership product and PT product schema — `income_account_id`.
- `apps/api/src/platform/db/seed/index.ts`, `permissions.ts`, `roles.ts`.
- `apps/api/src/sys/settings.dto.ts` — three accounting keys.
- `apps/api/src/pay/payment.service.ts` — call the posting port after invoice insert, collection, and refund. The port is a no-op while posting is disabled.
- `apps/api/src/app.module.ts` — import `AcctModule`.
- `apps/api/src/job/` — register `accounting.recognize_revenue` on the existing monthly schedule pattern.
- `docs/openapi/v1.yaml` and `packages/api_client/` via the generators.
- `docs/Entities-List.md` and `docs/database-entities.md` — add the accounting section.
- `app/lib/core/router/admin_routes.dart` and the route constants.

## Verification

Backend, from the repo root:

- `pnpm --filter api exec vitest run src/acct`
- `pnpm --filter api exec vitest run src/pay/payment.service.spec.ts`
- `pnpm --filter api openapi:check`

The posting spec must cover: a balanced membership invoice, a collection, a full refund, a cash expense, a bill plus payment voucher, a rejected unbalanced journal, a rejected post into a locked period, a second post of the same source returning the original journal, and a recognition run that leaves the schedule at zero after the term.

Flutter:

- `dart analyze` on `app/lib/features/accounting`
- The new widget tests

Database is MySQL 8.4 on `localhost:3308`. Apply the migration with the repo's existing migrate script. Do not use Docker for the database.

## Risks

- Turning posting on before every active payment method has an `account_id` will fail the next collection. The toggle endpoint must refuse to enable posting until that is true.
- Header-level tax on `payments` cannot split CGST and SGST from a client amount. The bridge uses `accounting.default_tax_code` and recomputes. A one-rupee rounding gap versus the stored `payments.tax_amount` is posted to `5900` only when the recomputed tax differs, and the spec must show that gap explicitly.
- Closing a period that still has draft bills does not post them. The lock response lists draft document counts so the operator can see them.
- `PayModule` is already in a `forwardRef` cycle with membership and notifications. The posting port must be a one-way call from `PaymentService` into `AcctModule`, with `AcctModule` importing `PayModule` only if it must read payments. Prefer `AcctModule` exporting `AccountingPostingService` and `PayModule` importing `AcctModule`.
