# IU-31 — ItemsListScreen

**Status:** Done  
**Plan:** `docs/plans/items-ui/plan.md` §D / `tasks.md` IU-31 `[x]`

## Delivered

- `items_list_screen.dart` — full list (search, kind/active/tracked chips, rows, App*, refresh, FAB, detail navigation)
- `accounting_strings.dart` — item list labels; `searchItems` → name or SKU
- `items_list_screen_test.dart` — 8 widget tests green
- Verified: `flutter test …/items_list_screen_test.dart` pass; `dart analyze` clean on screen + strings

## Next open (unblocked)

- IU-41 ItemDetailScreen
- IU-50 UomPickerSheet
- IU-02 OpenAPI regen (still `[ ]`)
