# ADR-0010 — Accounting ledger for one gym

| | |
| :--- | :--- |
| **Status** | **Accepted** |
| **Date** | 2026-10-12 |
| **Amended** | 2026-10-14 — decisions 13 and 14 |
| **Resolves** | Double-entry books beside member sales; chart, periods, purchases, expenses, recognition |
| **Related** | [ADR-0004](./0004-tenancy-model.md), [implementation plan](../plans/accounting/implementation-plan.md), FR-PAY-005, FR-PAY-012 |
| **Supersedes** | — |

## Context

The gym already invoices members on `payments` and records tenders on `payment_histories`. That covers the front desk. It does not give a chart of accounts, fiscal periods, vendors, purchase bills, expense vouchers, money-out payments, credit or debit notes, or month-end recognition of prepaid membership and personal-training income.

Staff need double-entry books for one gym without replacing POS or rewriting the payments module. Inventory, bank reconciliation, payroll, and fixed assets stay later work.

## Decision

1. **Accrual.** An issued member invoice debits accounts receivable. A collection debits bank or cash and credits receivable. A prepaid membership or personal-training term credits unearned revenue. A monthly job moves that month's share into income.
2. **The general ledger is the posted journal lines.** Reports query `journal_lines`. There is no second ledger table.
3. **Posted journals are immutable.** A correction is a reversing journal. Draft source documents can be edited. Posted ones cannot.
4. **One source, one journal.** Unique `(source_type, source_id)` on `journal_entries`. Replaying a post returns the original journal.
5. **Books start at go-live.** Historical `payments` rows are not backfilled. Opening balances are one manual journal dated the day before go-live. Setting `accounting.posting_enabled` gates automatic posts. While it is `false`, payments behave exactly as they do today.
6. **Single gym.** No `gym_id`. ADR-0004 stands.
7. **Money.** `DECIMAL(12,2)` stored as strings. All arithmetic goes through `toCents`, `addMoney`, `subMoney`, `cmpMoney`, and `roundMoney` in `apps/api/src/platform/money/money.ts`. Tax is computed per line, half-up to 2dp. Document total equals the sum of rounded lines.
8. **Currency.** The existing `gym_settings.currency` (default `INR`). No multi-currency.
9. **Tax.** Seed an exempt code at 0% and an intra-state GST 18% code that splits into CGST 9% and SGST 9%, plus an IGST 18% code. The server computes tax. Client-supplied tax amounts are ignored, matching FR-PAY-005.
10. **Parties.** Members remain the sales party. Vendors are new. A walk-in sale stays a member sale in `payments`.
11. **Accounts receivable and accounts payable** are the open sales invoices and unpaid bills sitting on control accounts. They are not extra balance tables.
12. **Admin and super_admin** receive every new permission. Other roles receive none until someone grants them.
13. **Recognition follows the term.** Revenue is prorated by day and posted once a month. A freeze, extension, upgrade, renewal, or cancellation re-plans the remaining schedule. Unearned revenue left on a cancelled term with no refund moves to forfeited income (`4300`).
14. **Go-live carries unearned revenue forward.** Memberships and PT terms still running at go-live get recognition schedules for their unexpired share. The opening journal's `2200` and `2210` balances must equal those schedules before posting can be enabled.

## Consequences

- New tables live in `apps/api/src/platform/db/schema/accounting.ts`. Member sales keep posting through `PaymentService` into `AccountingPostingService` when posting is enabled.
- Turning posting on before every active payment method has an `account_id` fails the next collection; the settings toggle must refuse until those links exist.
- Header-level tax on `payments` cannot split CGST and SGST from a client amount. The sales bridge uses `accounting.default_tax_code` and recomputes. A rounding gap versus stored `payments.tax_amount` posts to account `5950` when the amounts differ.
- Posted recognition is never edited. A re-plan moves only the unrecognized remainder, and a schedule records how far it has posted in `recognized_through`. A freeze pauses the schedule from `paused_from` and posts nothing for frozen days.
- Closing a period that still has draft bills does not post them. The lock response lists draft document counts.
- Inventory, bank statement reconciliation, payroll, fixed assets, budgets, and historical payment backfill are out of this ADR; they are named as later tasks in the accounting register.

## Alternatives considered

- **Cash-basis books.** Rejected. Prepaid memberships and PT terms need unearned revenue and monthly recognition.
- **Separate AR/AP subledgers with their own balances.** Rejected. Open invoices and unpaid bills already exist; control accounts plus reports are enough for one gym.
- **Backfill journals for every historical payment at go-live.** Rejected for v1. Opening journal plus `accounting.posting_enabled` is simpler and avoids double-counting if a backfill runs later.
- **Multi-currency or multi-gym ledger.** Rejected. Currency stays on `gym_settings`; tenancy stays ADR-0004.
