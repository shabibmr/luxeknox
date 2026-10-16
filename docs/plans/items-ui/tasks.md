# Items UI — tasks

**Plan:** [plan.md](./plan.md). **Legend:** `[ ]` open, `[~]` code done and tests pending, `[x]` done. IDs `IU-nn`. Test with fake repositories; `dart analyze app/lib/features/accounting` must stay clean after each task.

## A. Backend and client

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IU-01 | `[x]` | Add `GET /inventory/uoms` and `GET /inventory/item-categories` in `apps/api/src/inv/` (`inventory.read`, `is_active` filter, no pagination). Specs for controller and service | — | Specs pass; UOM rows return `id`, `code`, `decimal_places` |
| IU-02 | `[ ]` | Regenerate the OpenAPI doc and `packages/api_client` (`Uom`, `ItemCategory`, new `INVApi` methods) | IU-01 | `dart analyze packages/api_client` clean; generated diff limited to new models and API methods |

## B. Data layer

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IU-10 | `[x]` | Replace `domain/entities/item.dart` with a freezed `Item` matching `InventoryItem` (int ids, `sku`, `hsnSac`, `categoryName`, `uomCode`, `uomDecimalPlaces`, string rates, tracking fields, `hasMovements`, `isActive`, `rowVersion`). Add `Uom` and `ItemCategory`. Also covers IL-20 | — | Field names match the contract; `build_runner` output committed separately |
| IU-11 | `[x]` | Datasource: `listItems`/`getItem` on the inventory API, `createItem`/`updateItem` on the accounting API, `listUoms`, `listItemCategories`. Register `INVApi` in `register_module.dart`; regenerate the injector | IU-02, IU-10 | Compiles; injector resolves |
| IU-12 | `[x]` | Mappers: `InventoryItem` → `Item`; form values → `ItemCreate`/`ItemUpdate` (money as two-decimal strings, quantity as three-decimal, blank → null). Remove the stale `toItemCreate` | IU-10 | Mapper tests: blank SKU becomes null, `12.5` becomes `"12.50"`, tracked item keeps account ids |
| IU-13 | `[x]` | Repository interface and impl: change `getItems/getItem/createItem/updateItem` to the new shape (int ids) and add `getUoms`, `getItemCategories`; map errors to `Failure` like vendors. One use case per method | IU-11, IU-12 | Repository tests with a mocked client cover success, empty page, and a 422 `business_rule` error |

## C. Navigation

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IU-20 | `[x]` | `routes.dart`: `adminAccountingItems`, `…ItemsCreate`, `…ItemsDetail`, `…ItemsEdit` plus `adminAccountingItemById` / `…ItemEditById` helpers | — | Constants follow the vendor naming |
| IU-21 | `[x]` | `route_capabilities.dart`: `items/create` and `items/:id/edit` → `accounting.accounts_write` (before the `/admin/accounting` catch-all); `items` and `items/:id` → `inventory.read` | IU-20 | Router test: a user with only `accounting.read` is refused on create; `inventory.read` opens the list |
| IU-22 | `[x]` | `admin_routes.dart`: `items` route with children `create`, `:id`, `:id/edit` (`create` before `:id`; detail accepts an `Item` in `extra`), in the accounting branch | IU-20 | Deep link to `/admin/accounting/items/5` opens detail |
| IU-23 | `[x]` | Accounting home: **Items** button beside Vendors, shown only with `inventory.read`. Add all item strings to `accounting_strings.dart` | IU-22 | Widget test: button visible with the capability, hidden without it, tap navigates |

## D. List

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IU-30 | `[x]` | `ItemsCubit`: load, refresh, load-more (limit/offset), debounced search (name or SKU), filters for kind / active / tracked | IU-13 | Cubit tests: search re-queries from offset 0; filter change resets the page; load-more appends; an error keeps the old list |
| IU-31 | `[x]` | `ItemsListScreen`: search field, filter chips, row = name, SKU, kind, UOM, sale rate, tracked and inactive badges; shared `App*` loading / empty / error widgets; pull to refresh; create FAB (needs `accounting.accounts_write`) | IU-30, IU-22 | Widget test: rows render, inactive badge shows, empty and error states, FAB hidden without write access, row tap opens detail |

## E. Detail

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IU-40 | `[x]` | `ItemDetailCubit`: emit `initialItem` at once, then refresh from the API; a load failure keeps the cached item with an error banner | IU-13 | Cubit test: initial item emitted before the fetch resolves |
| IU-41 | `[x]` | `ItemDetailScreen`: sections *Basics* (name, SKU, HSN/SAC, kind, category, UOM, status), *Pricing & tax* (rates, tax code name), *Accounting* (income, expense, inventory, COGS account names), *Inventory* (tracked, reorder level, has movements). Edit action gated on write access. Resolve account and tax-code names with the existing account and tax-code use cases | IU-40, IU-22 | Widget test: tracked and untracked items; missing optional fields show an em dash; Edit hidden without access |

## F. Create / edit form

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IU-50 | `[x]` | `UomPickerSheet` and a category dropdown using `getUoms` / `getItemCategories`; inactive rows visible but not selectable | IU-13 | Widget test: select returns the UOM; inactive row disabled |
| IU-51 | `[ ]` | `ItemFormCubit`: create and edit modes; fields from `ItemCreate`; client checks per plan decision 7; the tracking toggle defaults inventory (`1400`) and COGS (`5050`) accounts; `hasMovements` locks tracking and UOM; `itemKind` locked in edit; API errors map to a form-level message | IU-13, IU-50 | Cubit tests: name required; negative rate rejected; tracking on without accounts refused; locked fields cannot change; create and edit payloads are right |
| IU-52 | `[ ]` | `ItemFormScreen`: kind segmented control, name, SKU, HSN/SAC, category, UOM, rates, tax code picker, income / expense `AccountPickerSheet`, active switch, tracking section with inventory and COGS pickers and reorder level; submit disabled while saving; on success go to item detail and show a saved snackbar | IU-51, IU-22 | Widget test: tracking section appears and disappears; submit disabled when invalid; server error text shown |

## G. Verify

| ID | Status | Task | Needs | Done when |
|---|---|---|---|---|
| IU-60 | `[ ]` | Route and permission tests across the four routes; `dart analyze` and `flutter test test/features/accounting` clean | IU-23, IU-31, IU-41, IU-52 | All green |
| IU-61 | `[ ]` | Real-data pass against **localhost** (confirm the Firestore-provided API URL first): create a service item and a tracked goods item, search by SKU, open detail, edit a rate, confirm an item with movements locks UOM and tracking | IU-60 | Every screen works; business-rule errors read clearly |

## Deferred

- Item delete (the API has none) and a dedicated deactivate action (use the active switch for now).
- UOM and category management screens (INV-081).
- Barcode scan on the item screen (INV-204).
- Moving item writes to `/inventory/items` (IL-91).
- Stock quantity on the list and detail (needs the stock summary endpoint from the full inventory plan).
