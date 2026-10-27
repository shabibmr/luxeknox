# Spec: Accounting Masters Quality, Correctness & UI Hardening

**Module:** `accounting-masters`  
**Status:** Approved  
**Date:** 2026-10-27  
**Origin:** Code review of accounting masters (Accounts, Vendors, Items)

---

## Assumptions

1. **Flutter Frontend Scope:** The issues identified are primarily in `app/lib/features/accounting/presentation/` (screens, widgets, cubits) and minimal domain entity adjustments (`Account.parentId`).
2. **Backend Contract:** The API already supports `parent_id` on accounts, pagination & search on vendors (`GET /accounting/vendors`), and items search (`GET /inventory/items`). No breaking backend changes are required.
3. **Routing Standards:** GoRouter is the project standard (`Routes.adminAccounting*`); imperative `Navigator.push(MaterialPageRoute)` is legacy debt to be eliminated.
4. **Picker Standard:** `AppPagedPickerSheet<T>` is the established standard for master entity selectors with server-side pagination and search.

---

## 1. Objective

Harden and correct the Accounting Masters presentation layer (Chart of Accounts, Vendors, Items & Catalog) across three focus areas:
1. **Correctness:** Fix search-clearing in `AccountsCubit`, prevent parent-account wipeouts in `AccountFormScreen`, eliminate race conditions in `VendorsCubit`, and ensure type-safe parsing in `ItemFormCubit`.
2. **Architecture & Standards:** Migrate `VendorsListScreen` to declarative GoRouter navigation, eliminate redundant gesture event wrappers in `AccountPickerSheet`, and introduce a canonical `VendorPickerSheet` / `VendorPickerField` matching the pattern used by Items and Accounts.
3. **Performance:** Add debouncing and epoch tracking across all master search fields, eliminate unneeded whole-screen `setState` rebuilds, and avoid 500-item bulk queries on `ItemDetailScreen`.

---

## 2. Tech Stack & Commands

- **Framework:** Flutter 3.x / Dart 3.x with `flutter_bloc`, `freezed`, `injectable`, `go_router`.
- **Target OS:** Cross-platform (Web, Android, iOS, Windows/macOS desktop).

### Commands
```bash
# Analyze code
cd app; dart analyze lib/features/accounting

# Run relevant test suites
cd app; flutter test test/features/accounting/presentation/chart_of_accounts_screen_test.dart test/features/accounting/presentation/account_form_screen_test.dart test/features/accounting/presentation/account_picker_sheet_test.dart test/features/accounting/presentation/vendors_list_screen_test.dart test/features/accounting/presentation/vendor_form_cubit_test.dart test/features/accounting/presentation/items_list_screen_test.dart test/features/accounting/presentation/item_detail_screen_test.dart test/features/accounting/presentation/item_form_test.dart test/features/accounting/presentation/item_search_field_test.dart test/features/accounting/presentation/uom_picker_sheet_test.dart

# Regenerate DI if usecases or cubit constructors change
cd app; dart run build_runner build --delete-conflicting-outputs
```

---

## 3. Project Structure

```
app/lib/features/accounting/
├── domain/entities/
│   └── account.dart                       # Add parentId: String?
├── data/models/mappers/
│   └── account_mapper.dart                # Map parent_id <-> parentId
├── presentation/
│   ├── cubit/
│   │   ├── accounts_cubit.dart            # Add clearSearch, debouncing & _loadEpoch
│   │   ├── account_form_cubit.dart        # Hydrate parentId & provide picker support
│   │   ├── vendors_cubit.dart             # Add debouncing & _loadEpoch
│   │   └── item_form_cubit.dart           # Safe int.tryParse for account IDs
│   ├── screens/
│   │   ├── chart_of_accounts_screen.dart  # Debounced search & clean reset
│   │   ├── account_form_screen.dart       # AccountPickerField for parentId
│   │   ├── vendors_list_screen.dart       # GoRouter context.push navigation
│   │   ├── items_list_screen.dart         # ValueListenableBuilder clear icon
│   │   └── item_detail_screen.dart        # Targeted name resolution
│   └── widgets/
│       ├── account_picker_sheet.dart      # Clean single ListTile tap event
│       └── vendor_picker_sheet.dart       # NEW: Canonical vendor picker & form field
```

---

## 4. Code Style & Conventions

- **Debounced Cubit Pattern with Epoch Tracking:**
```dart
int _loadEpoch = 0;
Timer? _debounceTimer;

void search(String? query) {
  _debounceTimer?.cancel();
  final next = (query == null || query.trim().isEmpty) ? null : query.trim();
  emit(state.copyWith(search: next));

  _debounceTimer = Timer(const Duration(milliseconds: 300), () {
    load(search: next, clearSearch: next == null);
  });
}

Future<void> load({String? search, bool clearSearch = false, ...}) async {
  final epoch = ++_loadEpoch;
  final nextSearch = clearSearch ? null : (search ?? state.search);
  // ...
  final result = await _getAccounts(...);
  if (isClosed || epoch != _loadEpoch) return; // Discard out-of-order response
  // emit state
}
```

- **Picker Field Pattern:**
Use `AppPickerFormField<T>` and `AppPagedPickerSheet<T>` for all master entity selectors. Avoid raw string text fields for IDs.

---

## 5. Testing Strategy

1. **Unit & Cubit Tests:**
   - `AccountsCubit`: Verify `load(clearSearch: true)` and `setSearch(null)` resets `state.search` to `null`.
   - `VendorsCubit`: Verify that out-of-order network responses do not overwrite newer search state.
   - `ItemFormCubit`: Verify that non-numeric account ID strings produce a form validation error rather than throwing an unhandled `FormatException`.
2. **Widget Tests:**
   - `ChartOfAccountsScreen`: Clear button `(x)` resets search field and loads all accounts.
   - `AccountFormScreen`: When editing an existing account with `parentId`, the parent picker pre-selects the parent and does not wipe it on save.
   - `VendorsListScreen`: Tapping create FAB or vendor tile pushes GoRouter route.
   - `VendorPickerSheet`: Searching, selecting an active vendor returns the vendor; inactive vendor handled per policy.
   - `ItemDetailScreen`: Verifies names render correctly without unconstrained 500-item queries.

---

## 6. Boundaries

- **Always:**
  - Keep `dart analyze lib/features/accounting` completely clean (0 errors, 0 warnings).
  - Use `AppStatusChip`, `AppLoading`, `AppEmptyView`, `AppErrorView` from `core/widgets`.
  - Check capability permissions before exposing create/edit actions.
- **Ask First:**
  - Modifying backend OpenAPI contracts or database schemas.
  - Introducing any new external package dependencies.
- **Never:**
  - Use raw `Navigator.push(MaterialPageRoute(...))` inside views where a named GoRouter route exists.
  - Fire un-debounced network requests on raw `TextField.onChanged`.
  - Use `int.parse` directly on untrusted or loosely-typed strings without `tryParse` or regex validation.

---

## 7. Success Criteria

1. **Search Reset:** Tapping the clear icon or backspacing to empty in `ChartOfAccountsScreen` and `AccountPickerSheet` immediately resets the filter to show all accounts.
2. **Parent Account Preservation:** Editing and saving an account with a parent preserves the `parent_id` in the API payload. The form provides an `AccountPickerField` that excludes self-selection.
3. **Race Condition Prevention:** Rapidly typing queries in Accounts and Vendors search fields issues debounced requests (~300ms) and out-of-order responses are dropped via epoch guards.
4. **Declarative Navigation:** `VendorsListScreen` navigates via `Routes.adminAccountingVendorsCreate` and `Routes.adminAccountingVendorEditById`.
5. **Reusable Vendor Picker:** `VendorPickerSheet` and `VendorPickerField` are available and tested.
6. **Robust Parsing:** `ItemFormCubit.buildDraft` uses `int.tryParse` safely and handles any format mismatches cleanly.
7. **Test Green:** All tests pass cleanly (`flutter test test/features/accounting/...`).

---

## 8. Decisions Locked

1. **Vendor Inactivity Policy in `VendorPickerSheet`:**
   Inactive vendors remain visible in the picker list so historical records display their names, but they are disabled with an "Inactive" badge and cannot be selected on new documents (showing an explanatory snackbar if tapped).
2. **ItemDetailScreen Name Resolution:**
   Replace the 500-item bulk catalog dump with targeted single-item lookups (`Future.wait`) for only the 4 account IDs (`incomeAccountId`, `expenseAccountId`, `inventoryAccountId`, `cogsAccountId`) and 1 `taxCodeId` referenced by the item.
