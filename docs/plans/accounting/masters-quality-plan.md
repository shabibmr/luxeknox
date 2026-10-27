# Technical Implementation Plan: Accounting Masters Quality & Hardening

**Spec:** [`masters-quality-spec.md`](./masters-quality-spec.md)  
**Status:** Approved  
**Date:** 2026-10-27  

---

## 1. Architectural Strategy

We will address the code review findings in thin, independently verifiable vertical slices:
1. **Accounts Slice:** Fix domain model omission (`parentId`), cubit search-reset logic, cubit debouncing/epochs, and UI parent account selector.
2. **Vendors Slice:** Fix imperative navigation by adopting GoRouter, add cubit debouncing/epochs, and implement the canonical `VendorPickerSheet` / `VendorPickerField`.
3. **Items Slice:** Harden `ItemFormCubit` ID parsing, optimize `ItemsListScreen` search controller listeners, and replace 500-item bulk queries in `ItemDetailScreen` with targeted parallel ID lookups (`Future.wait`).

```
Slice A: Accounts Data & Logic (Entity, Mapper, AccountsCubit)
   │
   ▼
Slice B: Accounts Presentation (Chart of Accounts, Account Form, Picker Sheet)
   │
   ▼
Slice C: Vendors Logic & Navigation (VendorsCubit, VendorsListScreen)
   │
   ▼
Slice D: Vendor Picker Component (VendorPickerSheet & Field)
   │
   ▼
Slice E: Items Hardening (ItemFormCubit, ItemsListScreen, ItemDetailScreen)
```

---

## 2. Component Design & Changes

### Slice A: Accounts Domain, Mapper & Cubit
- **`Account` Domain Entity:** Add `final String? parentId;`.
- **`accounting_mappers.dart`:** Map `api.Account.parentId` to `Account.parentId`.
- **`AccountsCubit`:**
  - Add `bool clearSearch = false` to `load(...)`.
  - In `load(...)`: `final nextSearch = clearSearch ? null : (search ?? state.search);`.
  - Add `_loadEpoch` counter to reject responses from stale requests.
  - Implement debounced `setSearch(String? query)` with 300ms timer.

### Slice B: Accounts UI Hardening
- **`chart_of_accounts_screen.dart`:**
  - In `_onSearchChanged`: pass `null` when trimmed string is empty.
  - In `suffixIcon` clear button: call `context.read<AccountsCubit>().setSearch(null)`.
- **`account_form_screen.dart`:**
  - In `_applyAccount`: hydrate parent account ID into state.
  - Replace the raw `_parentIdController` text field with `AccountPickerField` (excluding self to prevent circular graphs).
- **`account_picker_sheet.dart`:**
  - Remove redundant outer `GestureDetector` that wraps `ListTile`.
  - Keep disabled state and feedback exclusively on `ListTile.onTap`.

### Slice C: Vendors Cubit & List Screen
- **`VendorsCubit`:**
  - Add `_loadEpoch` counter to avoid out-of-order race conditions on slow network responses.
  - Add `_debounceTimer` with 300ms delay in `searchVendors(String? query)`.
- **`vendors_list_screen.dart`:**
  - Replace `Navigator.of(context).push(MaterialPageRoute(...))` with GoRouter `context.push(Routes.adminAccountingVendorsCreate)` and `context.push(Routes.adminAccountingVendorEditById(vendor.id))`.

### Slice D: Canonical Vendor Picker Component
- **`vendor_picker_sheet.dart`:**
  - Build `VendorPickerSheet` using `AppPagedPickerSheet<Vendor>` querying `GetVendorsUseCase`.
  - Render inactive vendors with `AppStatusChip(label: 'Inactive', color: Colors.grey)` and disabled interaction with explanatory snackbar.
  - Build `VendorPickerField` using `AppPickerFormField<Vendor>`.

### Slice E: Items Hardening
- **`item_form_cubit.dart`:**
  - In `buildDraft()`: safely parse `incomeAccountId` and `expenseAccountId` using `int.tryParse(...)`. If parsing fails, register a validation failure instead of crashing with `FormatException`.
- **`items_list_screen.dart`:**
  - Replace whole-screen `setState(() {})` inside `TextField.onChanged` with `ValueListenableBuilder<TextEditingValue>` on `_searchController` for the clear icon.
- **`item_detail_screen.dart`:**
  - In `_loadNames()`: replace unconstrained 500-account and 500-tax-code fetches with targeted parallel lookups via `Future.wait` on `getAccount` and `getTaxCode` for only the IDs present on the item.

---

## 3. Risks & Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Circular parent account reference | Low | In `AccountFormScreen`, filter out `accountId` from the parent picker choices. |
| Stale search requests in rapid typing | Medium | Increment `_loadEpoch` on every call; discard responses if epoch changed or cubit closed. |
| Inactive vendor accidentally picked | Low | Disabled tile with hit-test feedback and snackbar; unit tested. |
| Missing account on ItemDetailScreen | Low | Fallback to em dash (`—`) if individual ID lookup returns `NotFoundFailure`. |

---

## 4. Verification Checkpoints

1. **Checkpoint 1 (Accounts):** Run `chart_of_accounts_screen_test.dart`, `account_form_screen_test.dart`, `account_picker_sheet_test.dart`, `accounts_cubit_test.dart`.
2. **Checkpoint 2 (Vendors):** Run `vendors_list_screen_test.dart`, `vendors_cubit_test.dart`, and new `vendor_picker_sheet_test.dart`.
3. **Checkpoint 3 (Items):** Run `items_list_screen_test.dart`, `item_detail_screen_test.dart`, `item_form_test.dart`.
4. **Checkpoint 4 (Integration & Lint):** Run `dart analyze lib/features/accounting` to confirm 0 errors/warnings.
