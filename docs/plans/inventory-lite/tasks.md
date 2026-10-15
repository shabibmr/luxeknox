# Inventory Lite — task register

**Plan:** [plan.md](./plan.md). **Updated:** 2026-10-15.
**Markers:** `[ ]` todo, `[~]` doing, `[x]` done, `[!]` blocked, `[>]` later. Change the marker here only.
Start a task when every ID in *Needs* is `[x]`.

## A. Database

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IL-01 | `[ ]` | Edit `schema/accounting.ts` + `0025_accounting.sql` in place: `items` new columns (`sku`, `hsn_sac`, `category_id`, `uom_id`, `sale_rate`, `purchase_rate`, `reorder_level`, `inventory_account_id`, `cogs_account_id`, `row_version`, timestamps), `uoms`, `item_categories`, `purchase_bill_lines.quantity` to `decimal(14,3)`, `debit_note_lines`, `inventory` control role | — | Migrate from empty works on `localhost:3308` |
| IL-02 | `[ ]` | New `schema/inventory.ts` (export in `schema/index.ts`) and `0027_inventory.sql`: `item_stock`, `stock_movements`, `counter_sales`, `counter_sale_lines`, `counter_sale_tenders`, `sales_returns` (+lines, tenders), `stock_adjustments` (+lines), three number counters. Add the new `JOURNAL_SOURCE_TYPES` | IL-01 | Drift check clean; table list matches the full plan |
| IL-03 | `[ ]` | Seed: UOMs, accounts `1400/4250/5050/5960`, `INV` permissions to `super_admin` and `admin`. Backfill existing items with `PCS` | IL-01 | Seed twice, no duplicates; existing items have a `uom_id` |

## B. Backend

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IL-10 | `[ ]` | `mulQtyRate` in `platform/money/money.ts` (integer maths, half-up) with spec | — | Spec covers 3-decimal qty and `.005` rounding |
| IL-11 | `[ ]` | Extract the tax component split into `acct/tax-lines.ts` (tax code + side) | — | `member-sales-bridge.spec.ts` unchanged and green |
| IL-12 | `[ ]` | Extend `/accounting/items` DTO, repository and service with the new item columns; validate `uom_id` and tracked rules | IL-01 | Create/update with new fields works; existing specs pass |
| IL-13 | `[ ]` | `inv` module skeleton imported in `app.module.ts`; item read endpoints (list with search by name or SKU, get) | IL-03, IL-12 | List returns `uom_code`, `category_name`; SKU search works |
| IL-14 | `[ ]` | Counter sale create: `SaleWrite` zod DTO, defaults, server totals, tender check, number `SAL-…`, journal in the same transaction, idempotency | IL-02, IL-10, IL-11, IL-13 | Journal balances; tender mismatch gives 422; same key returns same sale |
| IL-15 | `[ ]` | Counter sale `get` and `list` | IL-14 | Lists omit lines/tenders; `get` has lines, tenders, journal number |
| IL-16 | `[ ]` | Unit and e2e tests for IL-12 to IL-15 | IL-15 | `vitest run src/inv src/acct src/platform/money` green |
| IL-17 | `[ ]` | `openapi:dump`, regenerate `packages/api_client`, `openapi:check` | IL-15 | Check passes; `INVApi` generated |

## C. Flutter

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IL-20 | `[ ]` | Freezed entities `Item`, `CounterSale`, `SaleLine`, `Tender` | IL-17 | Field names match the contract |
| IL-21 | `[ ]` | Datasource on `INVApi`, mappers, repository (`searchItems`, `getItem`, `listCounterSales`, `getCounterSale`, `createCounterSale`); register in `register_module.dart`; regenerate injector | IL-20 | Repository tests pass with a mocked client |
| IL-22 | `[ ]` | `ItemSearchField`: debounced search by name or SKU, with the shared `App*` loading/empty/error widgets | IL-21 | Widget test: typing shows results, selecting returns the item |

## Later (tables exist, no code)

| ID | Status | Task |
|---|---|---|
| IL-90 | `[>]` | UOM and category API and screens |
| IL-91 | `[>]` | Item form screen; move item writes to `/inventory/items` |
| IL-92 | `[>]` | Stock ledger, COGS on sales, no-negative-stock rule, purchase bill inventory hook |
| IL-93 | `[>]` | Sales returns, debit-note lines, stock adjustments |
| IL-94 | `[>]` | Reports, overview, counter sale screen |

## Waves

| Wave | Tasks |
|---|---|
| 1 | IL-01, IL-10, IL-11 |
| 2 | IL-02, IL-03, IL-12 |
| 3 | IL-13, then IL-14, then IL-15 |
| 4 | IL-16, IL-17 |
| 5 | IL-20, then IL-21, then IL-22 |
