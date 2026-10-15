# Inventory Lite — plan

**Status:** Draft. **Tasks:** [tasks.md](./tasks.md). **Full plan (later phases):** [../inventory/implementation-plan.md](../inventory/implementation-plan.md), [contract](../inventory/contract.md).
**Date:** 2026-10-15.

## Goal

A small first slice of the inventory module: an item master that can be searched, and counter sales recorded as documents. Everything else in the full plan waits, but the **database is built once, in full**, so later phases need no schema change.

## In scope

| Area | What |
|---|---|
| Database | Every table and column in the full plan (migration + seed). |
| Items | Extended `items` table, read API, Flutter datamodel, search widget. |
| Counter sales | `counter_sales`, `counter_sale_lines`, `counter_sale_tenders`: create, get, list. |

## Not in scope (tables exist, no code)

Stock ledger (`item_stock`, `stock_movements`), sales returns, stock adjustments, debit-note lines, reports, COGS, negative-stock checks, reorder alerts. No Flutter screens except the search widget.

## Decisions

1. **Schema is complete, behaviour is small.** All tables from the full plan go into the migration, including the ones with no code yet. Edit `0025_accounting.sql` in place for `items` / `purchase_bill_lines` changes (app is in dev, no compat work). New tables go in the next free migration number (`0026` is taken, so `0027_inventory.sql`), with `schema/inventory.ts`.
2. **UOMs and categories are DB only.** Tables and seed rows exist. No API, no Flutter. Items carry `uom_id` and `category_id`; the item read response returns `uom_code`, `uom_decimal_places`, `category_name` as plain fields.
3. **Item writes stay in `/accounting/items`.** Extend its DTOs with the new columns; no route move. Item reads come from the new `/inventory/items` (list with `search` by name or SKU, get by id). No Flutter item form. Items are created through the API or seed.
4. **Services and packages are not touched.** Membership/package sales and their UI already exist. A counter sale line can be any active item; there is no special service handling.
5. **A counter sale is created and posted in one call**, in one transaction, via the existing `AccountingPostingService`. Journal: debit each tender's payment-method account, credit item income account per line (net), credit tax component output accounts. No COGS and no stock movement yet, so `cogs_amount` and line `unit_cost` / `cost_amount` stay `0` / null.
6. **Server computes totals.** Rates default to `item.sale_rate`, tax to the item's tax code. Tenders must sum to the total or the call is refused (`422 tender_total_mismatch`). Arithmetic follows the contract's line and total rules (`mulQtyRate`, half-up).
7. **Permissions:** seed all four `inventory.*` slugs now (`read`, `masters_write`, `sales_write`, `adjust`), granted to `super_admin` and `admin`. Only `read` and `sales_write` are used in this slice.
8. **Flutter is data + one widget.** Datamodels, repository read functions, and `ItemSearchField` (a picker the sale and bill forms can reuse). No new routes, no More hub tile.

## Data model

Follow the full plan's [Data model](../inventory/implementation-plan.md#data-model) section exactly. Seed accounts `1400`, `4250`, `5050`, `5960`; UOMs `PCS BOX PKT BTL KG G LTR ML`. Add `inventory` to `ACCOUNT_CONTROL_ROLES`; add `counter_sale`, `counter_sale_return`, `stock_adjustment` to `JOURNAL_SOURCE_TYPES`.

## API (module `apps/api/src/inv/`)

| Method and path | Permission | Notes |
|---|---|---|
| `GET /inventory/items?search&item_kind&category_id&is_active&inventory_tracked` | `inventory.read` | `Item` list per contract (`stock` omitted for now) |
| `GET /inventory/items/:id` | `inventory.read` | |
| `POST /inventory/sales` | `inventory.sales_write` | `SaleWrite`, `Idempotency-Key`, returns posted `CounterSale` |
| `GET /inventory/sales?from&to&member_id&item_id&search` | `inventory.read` | lists omit lines and tenders |
| `GET /inventory/sales/:id` | `inventory.read` | with lines, tenders, journal number |

Shapes: use `Item`, `SaleLine`, `Tender`, `CounterSale`, `SaleWrite` from the [contract](../inventory/contract.md). Return `returns: []` and `returned_quantity: 0`.

## Flutter (`app/lib/features/inventory/`)

- `domain/entities`: `Item`, `CounterSale`, `SaleLine`, `Tender`.
- `data`: datasource on generated `INVApi`, mappers, repository with `searchItems`, `getItem`, `listCounterSales`, `getCounterSale`, `createCounterSale`.
- `presentation/widgets/item_search_field.dart`: debounced search by name or SKU, returns an `Item`.
- The old `features/accounting/domain/entities/item.dart` is left alone for now.

## Verification

- Migrate from empty and seed twice on `localhost:3308`; no duplicates; drift check clean.
- `pnpm --filter api exec vitest run src/inv src/acct src/platform/money`.
- e2e: create an item, sell 2 with split tenders, check the journal balances and a tender mismatch is refused.
- `pnpm --filter api openapi:dump`, regenerate `packages/api_client`, `openapi:check` passes.
- `flutter analyze` and a widget test for `ItemSearchField`.

## Risks

- Migration number clash: confirm `0027` is still free when starting.
- Sale journals without COGS leave Inventory value untouched. Fine while nothing is tracked; revisit when stock movements land.
- Existing items need a default `uom_id` because the column is not null (seed backfills `PCS`).
