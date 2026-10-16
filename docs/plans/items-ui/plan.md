# Items UI — navigation, list, detail, create/edit form

**Status:** Draft. **Tasks:** [tasks.md](./tasks.md). **Date:** 2026-10-16.
**Builds on:** [inventory-lite plan](../inventory-lite/plan.md) (IL-20 to IL-22 Flutter item datamodel, IL-91 item form) and the [inventory contract](../inventory/contract.md).

## Goal

An admin can reach **Items** from the app navigation, browse and search them, open one to see everything about it, and create (or edit) an item. Today there is no item screen at all.

## What exists (verified in the repo)

| Area | State |
|---|---|
| API reads | `GET /inventory/items` (`inventory.read`; filters `search`, `item_kind`, `category_id`, `is_active`, `inventory_tracked`) and `GET /inventory/items/:id`. Returns `InventoryItem` with `uomCode`, `uomDecimalPlaces`, `categoryName`, `hasMovements`, `rowVersion`. |
| API writes | `POST /accounting/items`, `PATCH /accounting/items/:id` (`accounting.accounts_write`). `ItemCreate` needs `name`, `itemKind`, `uomId`, `incomeAccountId`, `expenseAccountId`; money fields are decimal strings. |
| API gap | **No endpoint lists UOMs or item categories** (inventory-lite decision 2 made them DB-only). The form's UOM picker has nothing to read. |
| Generated client | `InventoryItem`, `InventoryItemPage`, `ItemCreate`, `ItemUpdate`, `ItemKind` exist in `packages/api_client`. |
| Flutter data | `features/accounting/domain/entities/item.dart` is **stale**: string ids, a `code` field, no UOM, SKU, rates or tracking. `accounting_repository` has `getItems/getItem/createItem/updateItem` with the same stale shape, and `toItemCreate` in `accounting_mappers.dart`. Nothing in the app calls the inventory API yet. |
| Flutter UI | No item cubit or screen. Vendors (`vendors_list_screen`, `vendor_form_screen`, `vendors_cubit`, `vendor_form_cubit`) are the closest pattern to copy. `AccountPickerSheet` exists for accounts. |
| Navigation | Accounting routes live under `/admin/accounting/*` in `core/router/admin_routes.dart`, constants in `routes.dart`, capability gates in `route_capabilities.dart`. The accounting home has a button per area (vendors at `accounting_home_screen.dart:456`). |

## Decisions

1. **Feature home: `features/accounting`**, not a new `features/inventory`. Items are the accounting item master and every other screen that needs them (bills, counter sale) already sits next to it. If the inventory UI later grows its own feature folder, moving the item files is mechanical.
2. **Reads from `/inventory/items`, writes to `/accounting/items`.** This matches inventory-lite decision 3 and avoids the richer-fields problem (the accounting `Item` response has no UOM code or `hasMovements`). The IL-91 "move writes to `/inventory/items`" stays deferred; the write call sits behind one repository method, so moving it later changes one datasource.
3. **One new freezed `Item` entity replaces the stale one** (this is IL-20). Ids are `int`. Money and quantity stay `String` decimals in the entity and are parsed only at display and validation. No compatibility shim: the app is in dev, so the old `getItems/getItem/createItem/updateItem` signatures are changed in place.
4. **Add two small read endpoints:** `GET /inventory/uoms` and `GET /inventory/item-categories` (`inventory.read`), then regenerate the client. This reverses inventory-lite decision 2 for reads only. Category and UOM *writes* stay out of scope. **Needs your OK before backend work starts** (see Open questions).
5. **Routes** (all under the admin shell, accounting branch):

   | Path | Screen | Gate |
   |---|---|---|
   | `/admin/accounting/items` | list | `inventory.read` |
   | `/admin/accounting/items/create` | form (create) | `accounting.accounts_write` |
   | `/admin/accounting/items/:id` | detail | `inventory.read` |
   | `/admin/accounting/items/:id/edit` | form (edit) | `accounting.accounts_write` |

   `items/create` is listed before `items/:id` so it is not swallowed by the id route, and the specific gates in `route_capabilities.dart` go before the `/admin/accounting` catch-all.
6. **Navigation entry:** an **Items** button on the accounting home next to Vendors, plus a back-stack that returns to the list after save. The list's FAB (create) and the detail's Edit action are hidden without `accounting.accounts_write`.
7. **Form is server-validated, client-assisted.** Client checks only what saves a round trip (name required and ≤150, SKU ≤64, HSN ≤16, rates non-negative, accounts required). All business rules come back from the API and show on the form.
8. **Inventory-tracking rules in the form:** turning on *Track inventory* reveals inventory and COGS account pickers, defaulting to the accounts with codes `1400` and `5050`. When the loaded item has `hasMovements`, *Track inventory* and *UOM* are read-only (per INV-081). `itemKind` is not editable after create (the update DTO has no `item_kind`).
9. **Concurrency:** the update DTO carries no `row_version`, so v1 has no optimistic-lock check. (Open question 2.)

## Architecture (follows the vendors pattern)

```
domain/entities/item.dart               freezed Item (+ Uom, ItemCategory)
domain/repositories/accounting_repository.dart   getItems/getItem/createItem/updateItem/getUoms/getItemCategories
domain/usecases/                         get_items, get_item, create_item, update_item, get_uoms, get_item_categories
data/datasources/accounting_remote_datasource.dart   InventoryApi reads + AccountingApi writes
data/models/accounting_mappers.dart      InventoryItem -> Item, form values -> ItemCreate/ItemUpdate
presentation/cubit/                      items_cubit, item_detail_cubit, item_form_cubit
presentation/screens/                    items_list_screen, item_detail_screen, item_form_screen
presentation/widgets/                    uom_picker_sheet (reuse AccountPickerSheet)
presentation/accounting_strings.dart     new strings
```

States: list = loading / empty / error / loaded with pagination (limit/offset) and a debounced search box; filter chips for kind, active and tracked. Detail = loading / error / loaded, with sections *Basics*, *Pricing & tax*, *Accounting*, *Inventory*. Form = pristine / submitting / failure / success.

## Phases

1. **Backend + client:** UOM and category read endpoints, regenerate `api_client`.
2. **Data layer:** entity, repository, datasource, mappers, use cases, DI.
3. **Navigation:** route constants, routes, capability gates, home button, strings.
4. **List.**
5. **Detail.**
6. **Form** (create and edit).
7. **Tests and a real-data pass.**

## Risks

- **Stale entity ripple.** Changing `Item` and the repository signatures breaks every file that imports them. `get_open_items_usecase.dart` matched a search for "item" but is unrelated (open AR/AP items). Run `dart analyze` after the data-layer task.
- **Generated code churn.** `build_runner` rewrites many `*.freezed.dart` files, and the working tree already has about 20 modified freezed files unrelated to this work. Commit generated output separately and check the diff only touches files this change owns.
- **Local app can hit production.** The app reads its API URL from Firestore. Confirm the target is `localhost` before any UI run that creates an item.
- **Two permission families.** Reading needs `inventory.read` and writing needs `accounting.accounts_write`. A role with only one sees a half-working screen; the gating in decision 6 prevents dead buttons.

## Open questions

1. OK to add the two read endpoints (decision 4)? The alternative is a hard-coded UOM list in the app, which drifts from the seed.
2. Should the update DTO gain `row_version` for optimistic locking, or is last-write-wins fine for the item master?
3. Should Items live under Accounting, or does it want its own bottom-nav or More-hub entry?
