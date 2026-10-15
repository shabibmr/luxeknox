# Inventory Lite — plan

**Status:** Draft. **Tasks:** [tasks.md](./tasks.md). **Full plan (later phases):** [../inventory/implementation-plan.md](../inventory/implementation-plan.md), [contract](../inventory/contract.md).
**Date:** 2026-10-15.

## Goal

A small first slice of the inventory module: an item master that can be searched, **purchase entry** (vendor bills with item lines that bring stock in), and counter sales that take stock out. Everything else in the full plan waits, but the **database is built once, in full**, so later phases need no schema change.

## In scope

| Area | What |
|---|---|
| Database | Every table and column in the full plan (migration + seed). |
| Items | Extended `items` table, read API, Flutter datamodel, search widget. |
| Stock ledger (core) | Stock in and stock out at weighted-average cost, in `item_stock` and `stock_movements`. No reports. |
| Purchase entry | Item lines on purchase bills: defaults from the item, 3-decimal quantity, stock-in and Inventory debit on post, and the Flutter entry form. |
| Counter sales | `counter_sales`, `counter_sale_lines`, `counter_sale_tenders`: create, get, list. Tracked lines issue stock and post COGS. |

## Not in scope (tables exist, no code)

Sales returns, stock adjustments (so no opening-stock entry yet), debit-note lines and purchase returns, stock and purchase reports, reorder alerts. No Flutter screens except the search widget and the purchase entry form. Debit notes against bills with tracked lines are refused until purchase returns land.

## Decisions

1. **Schema is complete, behaviour is small.** All tables from the full plan go into the migration, including the ones with no code yet. Edit `0025_accounting.sql` in place for `items` / `purchase_bill_lines` changes (app is in dev, no compat work). New tables go in the next free migration number (`0026` is taken, so `0027_inventory.sql`), with `schema/inventory.ts`.
2. **UOMs and categories are DB only.** Tables and seed rows exist. No API, no Flutter. Items carry `uom_id` and `category_id`; the item read response returns `uom_code`, `uom_decimal_places`, `category_name` as plain fields.
3. **Item writes stay in `/accounting/items`.** Extend its DTOs with the new columns; no route move. Item reads come from the new `/inventory/items` (list with `search` by name or SKU, get by id). No Flutter item form. Items are created through the API or seed.
4. **Services and packages are not touched.** Membership/package sales and their UI already exist. A counter sale line can be any active item; there is no special service handling.
5. **A counter sale is created and posted in one call**, in one transaction, via the existing `AccountingPostingService`. Journal: debit each tender's payment-method account, credit item income account per line (net), credit tax component output accounts. **For tracked lines it also issues stock at the current average cost, freezes `unit_cost` / `cost_amount` on the line, and adds Dr COGS (`5050`) / Cr Inventory (`1400`).** Untracked and service lines have no COGS (`cost_amount` null). This replaces the earlier "no COGS, no stock movement" rule, because purchases now bring stock in and on-hand would otherwise only grow.
6. **Server computes totals.** Rates default to `item.sale_rate`, tax to the item's tax code. Tenders must sum to the total or the call is refused (`422 tender_total_mismatch`). Arithmetic follows the contract's line and total rules (`mulQtyRate`, half-up).
7. **Permissions:** seed all four `inventory.*` slugs now (`read`, `masters_write`, `sales_write`, `adjust`), granted to `super_admin` and `admin`. Only `read` and `sales_write` are used in this slice.
8. **Flutter is data + one widget.** Datamodels, repository read functions, and `ItemSearchField` (a picker the sale and bill forms can reuse). No new routes, no More hub tile.

9. **Stock ledger core.** A small `inv` stock service with `receive` and `issue`, called inside the caller's transaction. Weighted-average cost: `item_stock` holds quantity and value; receiving adds the line's net value; issuing takes `quantity × average cost` (the last issue to empty stock takes the remaining value, so no residue). Every call writes a `stock_movements` row. **No negative stock:** an issue above on-hand is refused (`insufficient_stock`). Only `inventory_tracked` items touch the ledger.
10. **Purchase entry reuses purchase bills.** No second document. Bills stay at `/accounting/purchase-bills` (create, patch, post) and `purchases_write` stays the permission. Changes:
    - An item line takes defaults from the item: description = name, rate = `purchase_rate`, tax = the item's tax code. The client may override rate and tax.
    - `account_id` is optional on item lines. For a tracked item the server sets it to `item.inventory_account_id` and ignores any client value. For an untracked item it defaults to `item.expense_account_id`. Lines with no item still require `account_id`.
    - Quantity allows 3 decimals but is limited by the item's UOM `decimal_places`. Line amounts use `mulQtyRate` (integer maths, half-up), replacing `Number(qty) * Number(rate)`.
    - Optional supplier invoice number, unique per vendor among non-void bills (add the column in `0025` if it is not there yet).
11. **Posting a bill with tracked lines** runs in the posting transaction: debit Inventory (the line net), `receive` stock for the line at `net_amount`, then input tax and AP as before. A locked period, unbalanced journal or refused movement rolls everything back. Replaying a post returns the original journal and does not receive stock twice.
12. **Purchase returns wait.** A debit note against a bill that has tracked lines is refused (`debit_note_tracked_deferred`) until debit-note lines (IL-93) can issue the stock back. Service-only bills keep working.
13. **Flutter purchase entry is the existing bill form, upgraded.** The vendor list, bill list and detail screens already exist (ACC-095). The form gains `ItemSearchField` per line, item defaults, UOM suffix on quantity, and hides the account picker for tracked items. Actions: **Save draft** and **Save & post** (create, then post with its own idempotency key).

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

**Changed accounting endpoints (purchase entry)**, per the contract's purchase-bill rows:

| Method and path | Change |
|---|---|
| `POST /accounting/purchase-bills`, `PATCH /accounting/purchase-bills/:id` | Line `account_id` optional for item lines, server-set for tracked items. `quantity` 3dp, UOM-limited. Item defaults. Optional `supplier_invoice_no`. |
| `POST /accounting/purchase-bills/:id/post` | Tracked lines debit Inventory and receive stock. |
| `GET /accounting/purchase-bills`, `GET …/:id` | Lines add `item_name`, `uom_code`, `inventory_tracked`, `returned_quantity` (always `0` in this slice). |
| `POST /accounting/debit-notes` | Refused with `debit_note_tracked_deferred` for bills with tracked lines. |

Related fixes from the accounting code review (see `../accounting/review-remediation-plan.md`): bill line amounts switch to `mulQtyRate`, and 3dp quantity stops being truncated to 2dp.

## Flutter (`app/lib/features/inventory/`)

- `domain/entities`: `Item`, `CounterSale`, `SaleLine`, `Tender`.
- `data`: datasource on generated `INVApi`, mappers, repository with `searchItems`, `getItem`, `listCounterSales`, `getCounterSale`, `createCounterSale`.
- `presentation/widgets/item_search_field.dart`: debounced search by name or SKU, returns an `Item`.
- The old `features/accounting/domain/entities/item.dart` is left alone for now.
- **Purchase entry** (`features/accounting/presentation/screens/purchase_bill_form_screen.dart` and its cubit): `ItemSearchField` per line, defaults from the item, UOM suffix on quantity, account picker hidden for tracked items, live line and bill totals (display only, the server decides), **Save draft** and **Save & post**. `PurchaseBillLine` gains `itemName`, `uomCode`, `inventoryTracked`. The detail screen shows item, quantity with UOM, and the journal number after posting.

## Verification

- Migrate from empty and seed twice on `localhost:3308`; no duplicates; drift check clean.
- `pnpm --filter api exec vitest run src/inv src/acct src/platform/money`.
- e2e: create a tracked item, post a bill for 10 at 100 and another for 5 at 130 (on-hand 15, average cost 110, Inventory `1400` = 1650 net), then sell 2 with split tenders: the journal balances, COGS = 220, on-hand 13, a tender mismatch is refused, selling 14 is refused with `insufficient_stock`.
- Purchase entry: a 3-decimal quantity on a `KG` item is accepted and on a `PCS` item refused; a client-sent `account_id` on a tracked line is ignored; posting twice receives stock once; a locked period rolls back journal and stock; a debit note against a tracked bill is refused; a service-only bill posts as before.
- `pnpm --filter api openapi:dump`, regenerate `packages/api_client`, `openapi:check` passes.
- `flutter analyze` and a widget test for `ItemSearchField`.

## Risks

- Migration number clash: confirm `0027` is still free when starting.
- IL-14 is already done without stock-out and COGS. IL-31 reworks it, and its specs change.
- No opening-stock entry in this slice (adjustments are later). The first stock comes from purchase bills, and an existing opening `1400` balance in the go-live journal will not match `item_stock`. Do not turn on the `opening_stock_mismatch` check (INV-054) yet.
- Purchase returns and voiding a posted bill with stock are not handled. A posted bill with tracked lines cannot be reversed in this slice.
- Average cost uses the line's net value, so a tax-inclusive purchase rate must be entered net. The form states "rate excludes tax".
- Existing items need a default `uom_id` because the column is not null (seed backfills `PCS`).
