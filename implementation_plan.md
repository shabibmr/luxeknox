# Implementation plan: #21 + #22 Counter Sale catalog & sale lines

## Seams (confirmed)
1. Widget tests of Counter Sale screen — real cubit, faked `GetItemsUseCase`
2. Unit tests for line-charge arithmetic helper (half-up, tax)

## Scope
- **#21** Catalog grid + item read (`tax_rate_percent`, `qty_on_hand`)
- **#22** Sale lines tray, qty edit/remove, amount due, Continue gated

## Files

### Backend
- [MODIFY] `apps/api/src/inv/items.dto.ts` — add `tax_rate_percent`, `qty_on_hand`
- [MODIFY] `apps/api/src/inv/items.repository.ts` — join tax_codes + item_stock
- [MODIFY] `apps/api/src/inv/items.service.ts` — map fields (tracked→qty or 0; untracked→omit/null)
- [MODIFY] `apps/api/src/inv/items.service.spec.ts` / controller specs as needed
- [MODIFY] `docs/openapi/v1.yaml` — InventoryItem properties
- [MODIFY] `packages/api_client` — regen via `tool/gen_api.sh` (or patch)

### Flutter
- [MODIFY] `app/lib/features/accounting/domain/entities/item.dart` — taxRatePercent, qtyOnHand
- [MODIFY] mapper + any item fixtures/tests
- [NEW] `app/lib/features/inventory/` — counter sale cubit, screen, strings, charge math
- [MODIFY] `admin_routes.dart` — wire CounterSaleScreen + DI
- [NEW] widget + charge unit tests

## Charge arithmetic
- gross = round_half_up(qty × sale_rate, 2)
- tax = 0 if no tax; else round_half_up(gross × rate / 100, 2)
- line charge = gross + tax
- amount due = sum of line charges
- no tax row in tray

## Out of this PR
Buyer (#24), payment (#23), Split (#25)
