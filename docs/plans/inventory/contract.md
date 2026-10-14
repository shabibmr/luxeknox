# Inventory API contract

**Plan:** [implementation-plan.md](./implementation-plan.md)
**Backend tasks:** [tasks-backend.md](./tasks-backend.md)
**Frontend tasks:** [tasks-frontend.md](./tasks-frontend.md)
**Status:** Draft. INV-003 freezes it.
**Date:** 2026-10-13.

This file is the agreement between the API (`apps/api/src/inv/`, plus the accounting changes) and the Flutter feature (`app/lib/features/inventory/`).

- Before INV-070, the frontend codes its domain entities and repository interface against this file.
- After INV-070, the generated `packages/api_client` is the source of truth, and it must match this file.
- **Change rule.** Change the file before the code. A change after INV-003 needs a note in both task files on the affected tasks.

## Conventions

These are the API's existing rules. Nothing here is new.

| Topic | Rule |
|---|---|
| Base path | `/v1`. Every path below is relative to it |
| Auth | `Authorization: Bearer <access token>` |
| OpenAPI tag | `INV`. The generated client is `INVApi`. Changed accounting endpoints stay on `ACCTApi` |
| Casing | JSON fields are `snake_case` |
| IDs | Integers (int64) |
| Money | String with 2 decimals, e.g. `"1180.00"` |
| Quantity | String with up to 3 decimals, e.g. `"2.500"`. The server rejects more decimals than the item's UOM allows |
| Unit cost | String with 4 decimals, e.g. `"412.5000"` |
| Dates | `YYYY-MM-DD`. Timestamps are ISO 8601 UTC |
| Lists | `{ "data": [...], "meta": { "limit", "offset", "cursor", "next_cursor", "has_more", "total?" } }`. Query: `cursor`, `limit`, or `page` / `offset` |
| Idempotency | Header `Idempotency-Key` (8–128 chars) on every `POST` that creates a document. A replay returns the first response. Reusing a key with a different body returns `409` |
| Concurrency | `PATCH` and `POST …/post` bodies carry `row_version`. A mismatch returns `409 conflict` |
| Totals | Always computed by the server. Client-sent net, tax, or totals are not accepted |

### Line and total arithmetic

There is no quote endpoint. The client computes totals before a sale or return, and the server recomputes them on create. Both sides must implement these rules exactly. `round_half_up(x, 2)` rounds to 2 decimals, and `.005` goes up.

| Value | Rule |
|---|---|
| Line `gross` | `round_half_up(quantity × rate, 2)` |
| Line `net_amount` | `gross − discount_amount`. The discount cannot exceed the gross |
| Line `tax_amount` | `round_half_up(net_amount × tax_code.rate_percent / 100, 2)`. Per line, on the code's total rate. No tax code means `0.00` |
| Line `line_total` | `net_amount + tax_amount` |
| Header `subtotal`, `discount_amount`, `tax_amount`, `total_amount` | Sums of the lines. `subtotal` is the sum of `gross` |
| Tax components (CGST, SGST) | Server-side, for the journal only. Each component is rounded half-up and the last component takes the remainder, so the line's `tax_amount` never changes |
| Sales return line `net_amount` and `tax_amount` | Pro rata on the sale line's own figures: `round_half_up(sale_line.net_amount × qty / sale_line.quantity, 2)`, and the same for tax. When the return brings the line's returned quantity to the sold quantity, it takes the remainder instead |
| Return header | Sums of the return lines |

### Errors

Body: `{ "code", "message", "details": [], "request_id" }`.

| HTTP | `code` | When |
|---|---|---|
| 400 | `validation_error` | Shape or format is wrong. `details` lists the fields |
| 401 | `unauthenticated` | Missing or expired token |
| 403 | `forbidden` | The permission is missing |
| 404 | `not_found` | Unknown ID |
| 409 | `conflict` | `row_version` mismatch, or `Idempotency-Key` reused |
| 422 | `business_rule` | A rule below is broken. `details` holds one entry per failing rule |

A `business_rule` detail entry is `{ "rule": "<code>", "message": "...", ...context }`. The frontend switches on `rule`.

| `rule` | Context fields | Raised by |
|---|---|---|
| `insufficient_stock` | `item_id`, `requested`, `available` | Sale, debit note, negative adjustment |
| `uom_decimals_exceeded` | `item_id`, `uom_code`, `decimal_places` | Any line with a quantity |
| `item_inactive` | `item_id` | Any new line |
| `tender_total_mismatch` | `expected`, `received` | Sale, sales return |
| `payment_method_unmapped` | `payment_method_id` | Sale, sales return |
| `return_qty_exceeded` | `line_id`, `requested`, `remaining` | Sales return, debit note |
| `tracked_item_rules` | `missing`: list of field names | Item create or patch with `inventory_tracked: true` |
| `field_frozen` | `field` | Item patch of `inventory_tracked` or `uom_id` after stock moved. UOM patch of `decimal_places` while in use |
| `category_depth` | `parent_id` | Category with a parent that has a parent |
| `document_posted` | — | Patch or post of a posted adjustment |
| `period_locked` | `period` | Any post into a locked accounting period (existing rule) |
| `opening_stock_mismatch` | `opening_journal_1400`, `opening_stock_value` | Enabling accounting posting (go-live) |

## Permissions

| Slug | Grants |
|---|---|
| `inventory.read` | Every `GET` under `/inventory` |
| `inventory.masters_write` | UOMs, categories, items |
| `inventory.sales_write` | Counter sale and sales return creates |
| `inventory.adjust` | Stock adjustment create, patch, post |
| `accounting.purchases_write` | Purchase bills and debit notes (unchanged) |

Pickers on inventory screens read existing endpoints, so the user needs those permissions too. `admin` and `super_admin` have them all.

| Picker | Endpoint | Permission |
|---|---|---|
| Payment methods (tenders) | `GET /payment-methods` | `payments.read` |
| Accounts (item income, expense, inventory, COGS) | `GET /accounting/accounts` | `accounting.read` |
| Tax codes | `GET /accounting/tax-codes` | `accounting.read` |
| Member on a sale (optional) | `GET /members` | the existing member read permission |

## Enums

| Name | Values |
|---|---|
| `ItemKind` | `service`, `goods` |
| `AdjustmentReason` | `opening`, `count`, `damage`, `expiry`, `other` |
| `AdjustmentStatus` | `draft`, `posted` |
| `CounterSaleStatus` | `posted` |
| `SalesReturnStatus` | `posted` |
| `StockMovementSource` | `purchase_bill`, `debit_note`, `counter_sale`, `counter_sale_return`, `stock_adjustment` |
| `SalesRegisterGroupBy` | `item`, `category` |

## Schemas

Response shapes. `?` marks a nullable field.

**Uom**
`id`, `code`, `name`, `decimal_places` (0–3), `is_active`, `in_use` (bool), `created_at`, `updated_at?`

**ItemCategory**
`id`, `name`, `parent_id?`, `parent_name?`, `is_active`, `created_at`, `updated_at?`

**Item**
- Identity: `id`, `name`, `sku?`, `hsn_sac?`, `item_kind`
- Classification: `category_id?`, `category_name?`, `uom_id`, `uom_code`, `uom_decimal_places`
- Rates: `sale_rate?`, `purchase_rate?`, `tax_code_id?`
- Accounts: `income_account_id`, `expense_account_id`, `inventory_account_id?`, `cogs_account_id?`
- Stock: `inventory_tracked`, `reorder_level?`, `stock?` (`ItemStock`, present only when tracked), `has_movements` (bool)
- Meta: `is_active`, `row_version`, `created_at`, `updated_at?`

**ItemStock**
`qty_on_hand`, `avg_cost`, `stock_value`

**SaleLine (response)**
- Item: `id`, `item_id`, `item_name`, `uom_code`
- Pricing: `quantity`, `rate`, `discount_amount`, `tax_code_id?`
- Amounts: `net_amount`, `tax_amount`, `line_total`
- Cost: `unit_cost?`, `cost_amount?` (null for service items)
- Returns: `returned_quantity`

**Tender**
`id`, `payment_method_id`, `payment_method_name`, `amount`, `reference?`

**CounterSale**
- Header: `id`, `sale_number`, `sale_date`, `member_id?`, `member_name?`, `customer_name?`, `status`
- Totals: `subtotal`, `discount_amount`, `tax_amount`, `total_amount`, `cogs_amount`
- Children: `lines` (`SaleLine[]`), `tenders` (`Tender[]`), `returns` (`[{ id, return_number, return_date, total_amount }]`)
- Journal: `journal_entry_id`, `journal_number`
- Meta: `row_version`, `created_at`

In list responses `lines`, `tenders` and `returns` are omitted.

**SalesReturnLine**
`id`, `counter_sale_line_id`, `item_id`, `item_name`, `quantity`, `net_amount`, `tax_amount`, `cost_amount?`

**SalesReturn**
- Header: `id`, `return_number`, `counter_sale_id`, `sale_number`, `return_date`, `reason?`, `status`
- Totals: `subtotal`, `tax_amount`, `total_amount`, `cogs_amount`
- Children: `lines`, `tenders`
- Journal: `journal_entry_id`, `journal_number`
- Meta: `row_version`, `created_at`

**StockAdjustmentLine**
`id`, `item_id`, `item_name`, `uom_code`, `qty_delta` (signed string, e.g. `"-2.000"`), `unit_cost?`, `value`

**StockAdjustment**
- Header: `id`, `adjustment_number`, `adjustment_date`, `reason`, `memo?`, `status`
- Children: `lines`
- Totals: `total_value` (signed)
- Journal: `journal_entry_id?`, `journal_number?` (null for `opening` and drafts)
- Meta: `row_version`, `created_at`, `updated_at?`

**StockMovement**
`id`, `movement_date`, `source_type`, `source_id`, `source_number`, `qty_in`, `qty_out`, `unit_cost`, `value`, `balance_qty`, `balance_value`

## Endpoints: inventory (`INVApi`)

| operationId | Method and path | Permission | Request | Response |
|---|---|---|---|---|
| `getInventoryOverview` | `GET /inventory/overview` | `inventory.read` | — | `{ stock_value, tracked_items, low_stock_count, today_sales_total, today_sales_count, as_of }` |
| `listUoms` | `GET /inventory/uoms` | `inventory.read` | `?is_active&search` + list query | `Uom` list |
| `createUom` | `POST /inventory/uoms` | `inventory.masters_write` | `{ code, name, decimal_places, is_active? }` | `201 Uom` |
| `updateUom` | `PATCH /inventory/uoms/:id` | `inventory.masters_write` | `{ name?, decimal_places?, is_active?, row_version }` | `Uom` |
| `listItemCategories` | `GET /inventory/categories` | `inventory.read` | `?is_active&parent_id&search` + list query | `ItemCategory` list |
| `createItemCategory` | `POST /inventory/categories` | `inventory.masters_write` | `{ name, parent_id?, is_active? }` | `201 ItemCategory` |
| `updateItemCategory` | `PATCH /inventory/categories/:id` | `inventory.masters_write` | `{ name?, parent_id?, is_active?, row_version }` | `ItemCategory` |
| `listItems` | `GET /inventory/items` | `inventory.read` | `?search` (name or SKU) `&item_kind&category_id&inventory_tracked&is_active&low_stock` + list query | `Item` list |
| `getItem` | `GET /inventory/items/:id` | `inventory.read` | — | `Item` |
| `createItem` | `POST /inventory/items` | `inventory.masters_write` | `ItemWrite` | `201 Item` |
| `updateItem` | `PATCH /inventory/items/:id` | `inventory.masters_write` | Partial `ItemWrite` + `row_version`. `item_kind` cannot change | `Item` |
| `createCounterSale` | `POST /inventory/sales` | `inventory.sales_write` | `SaleWrite` + `Idempotency-Key` | `201 CounterSale`, posted |
| `listCounterSales` | `GET /inventory/sales` | `inventory.read` | `?from&to&member_id&item_id&search` (number) + list query | `CounterSale` list |
| `getCounterSale` | `GET /inventory/sales/:id` | `inventory.read` | — | `CounterSale` with lines, tenders, returns |
| `createSalesReturn` | `POST /inventory/sales-returns` | `inventory.sales_write` | `ReturnWrite` + `Idempotency-Key` | `201 SalesReturn`, posted |
| `listSalesReturns` | `GET /inventory/sales-returns` | `inventory.read` | `?from&to&counter_sale_id` + list query | `SalesReturn` list |
| `getSalesReturn` | `GET /inventory/sales-returns/:id` | `inventory.read` | — | `SalesReturn` |
| `listStockAdjustments` | `GET /inventory/adjustments` | `inventory.read` | `?status&reason&from&to` + list query | `StockAdjustment` list |
| `createStockAdjustment` | `POST /inventory/adjustments` | `inventory.adjust` | `AdjustmentWrite` + `Idempotency-Key` | `201 StockAdjustment`, draft |
| `getStockAdjustment` | `GET /inventory/adjustments/:id` | `inventory.read` | — | `StockAdjustment` |
| `updateStockAdjustment` | `PATCH /inventory/adjustments/:id` | `inventory.adjust` | Partial `AdjustmentWrite` + `row_version`. Draft only | `StockAdjustment` |
| `postStockAdjustment` | `POST /inventory/adjustments/:id/post` | `inventory.adjust` | `{ row_version }` | `200 StockAdjustment`, posted |
| `getStockSummary` | `GET /inventory/reports/stock-summary` | `inventory.read` | `?as_of&category_id&include_zero` | `{ as_of, rows: [{ item_id, item_name, sku?, category_name?, uom_code, qty_on_hand, avg_cost, stock_value, reorder_level? }], total_value }` |
| `getStockLedger` | `GET /inventory/reports/stock-ledger` | `inventory.read` | `?item_id&from&to` (all required) | `{ item_id, item_name, opening_qty, opening_value, movements: StockMovement[], closing_qty, closing_value }` |
| `getLowStock` | `GET /inventory/reports/low-stock` | `inventory.read` | `?category_id` | `{ rows: [{ item_id, item_name, uom_code, qty_on_hand, reorder_level }] }` |
| `getSalesRegister` | `GET /inventory/reports/sales-register` | `inventory.read` | `?from&to&group_by` | `{ from, to, group_by, rows: [{ key_id, key_name, quantity, net_amount, tax_amount, cogs_amount, margin_amount, margin_percent }], totals: {same fields} }`. Returns are netted |
| `getPurchaseRegister` | `GET /inventory/reports/purchase-register` | `inventory.read` | `?from&to&vendor_id` | `{ from, to, rows: [{ item_id, item_name, uom_code, quantity, net_amount, tax_amount }], totals }`. Debit notes are netted |
| `getValuationCheck` | `GET /inventory/reports/valuation-check` | `inventory.read` | `?as_of` | `{ as_of, stock_value, ledger_balance, difference, account_id, account_code }` |

### Write bodies

**ItemWrite**
- Required: `name`, `item_kind`, `uom_id`, `income_account_id`, `expense_account_id`
- Optional: `sku`, `hsn_sac`, `category_id`, `sale_rate`, `purchase_rate`, `tax_code_id`, `is_active`
- Tracking: `inventory_tracked` (default `false`), `inventory_account_id`, `cogs_account_id`, `reorder_level`

When `inventory_tracked` is `true`:
- `item_kind` must be `goods`.
- `inventory_account_id` must be an active asset account. Default `1400` when omitted.
- `cogs_account_id` must be an active expense account. Default `5050` when omitted.

**SaleWrite**
- Header: `sale_date` (default today), `member_id?`, `customer_name?`
- `lines`: `[{ item_id, quantity, rate?, discount_amount?, tax_code_id? }]`, at least 1
  - `rate` defaults to `item.sale_rate`.
  - `tax_code_id` defaults to the item's tax code.
- `tenders`: `[{ payment_method_id, amount, reference? }]`, at least 1, summing to the server total

**ReturnWrite**
- Header: `counter_sale_id`, `return_date` (default today), `reason?`
- `lines`: `[{ counter_sale_line_id, quantity }]`, at least 1
- `tenders`: same shape as SaleWrite, summing to the return total

**AdjustmentWrite**
- Header: `adjustment_date`, `reason`, `memo?`
- `lines`: `[{ item_id, qty_delta, unit_cost? }]`, at least 1
  - `qty_delta` is signed and not zero.
  - `unit_cost` is required when `qty_delta` is positive.
  - `opening` allows positive lines only.

### Counter sale flow

1. The client computes line and header totals with the [line and total arithmetic](#line-and-total-arithmetic).
   - Rates come from `Item.sale_rate`, and tax rates from the item's tax code in `GET /accounting/tax-codes`.
   - `Item.stock.qty_on_hand` drives a local stock warning.
2. The cashier enters tenders until they equal the computed `total_amount`.
3. The client sends `createCounterSale` with a fresh `Idempotency-Key`, and reuses that key on retry.
4. The server recomputes everything and is the authority.
   - On `422 tender_total_mismatch`, the client shows `expected` from the details and lets the cashier fix the tenders.
   - On `insufficient_stock`, the client shows `available` against the line.

A sales return follows the same steps. It starts from the sale's lines in `getCounterSale` and uses the pro-rata rule.

## Endpoints: accounting, changed by this module (`ACCTApi`)

| operationId | Method and path | Change |
|---|---|---|
| `listItems`, `createItem`, `getItem`, `updateItem` | `/accounting/items…` | **Removed.** Use `INVApi` above |
| `createPurchaseBill`, `updatePurchaseBill` | `POST /accounting/purchase-bills`, `PATCH /accounting/purchase-bills/:id` | Line `quantity` allows 3 decimals, limited by the item's UOM. Line `account_id` becomes optional: it is ignored and set by the server when `item_id` is a tracked item, and still required otherwise |
| `getPurchaseBill`, `listPurchaseBills` | `GET /accounting/purchase-bills…` | Each line adds `item_name?`, `uom_code?`, `inventory_tracked` (bool), `returned_quantity` |
| `createDebitNote` | `POST /accounting/debit-notes` | Body becomes `{ purchase_bill_id, debit_note_date, reason?, lines: [{ purchase_bill_line_id, quantity?, amount? }] }`. Use `quantity` for item lines and `amount` (net) for lines without an item. `subtotal` and `tax_amount` are removed from the body and computed from lines. New rules: `return_qty_exceeded`, `insufficient_stock` |
| `getDebitNote`, `listDebitNotes` | `GET /accounting/debit-notes…` | Adds `lines: [{ id, purchase_bill_line_id, item_id?, item_name?, quantity?, net_amount, tax_amount }]` |
| Go-live enable (existing settings toggle) | — | The failing-checks list may include `opening_stock_mismatch` |
| `getGstSummary` | `GET /accounting/reports/gst-summary` | The response shape is unchanged. Output taxable value now includes counter sales less returns. Input taxable value comes from bills less debit notes |

## Frontend routes

For reference. Owned by the frontend.

| Path | Screen | Permission to show |
|---|---|---|
| `/admin/inventory` | Inventory home | `inventory.read` |
| `/admin/inventory/items`, `/items/new`, `/items/:id` | Item list, form, detail | Write actions need `inventory.masters_write` |
| `/admin/inventory/categories`, `/admin/inventory/uoms` | Masters | as above |
| `/admin/inventory/sales/new` | Counter sale | `inventory.sales_write` |
| `/admin/inventory/sales`, `/sales/:id` | Sale list, detail | The Return action needs `inventory.sales_write` |
| `/admin/inventory/sales/:id/return` | Sales return | `inventory.sales_write` |
| `/admin/inventory/adjustments`, `/new`, `/:id` | Adjustments | Write and post need `inventory.adjust` |
| `/admin/inventory/reports/:report` | The six reports | `inventory.read` |
