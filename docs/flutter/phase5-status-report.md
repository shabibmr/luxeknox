# Phase 5 Payments — status (2026-09-21)

## Implemented (first 5)
- Clean Architecture feature `features/payments` (domain / data / presentation)
- `PAYApi` registered in DI (`register_module` + injectable codegen)
- **Member ledger** — `/profile/payments` filtered by session profile id; detail `/profile/payments/:id`
- **Admin ledger** — `/admin/payments` with status filters (all/pending/partial/paid/refunded)
- **Outstanding dues** — `/admin/payments/outstanding` via `listOutstandingPayments`
- **Payment detail** — invoice, amounts (decimal strings), status chip, history list
- **Payment methods** — `/admin/payments/methods` catalog + create dialog (`payments.create`); More hub tile
- Trainer read-only member payments: `/trainer/members/:id/payments`
- Route capability gates: record → `payments.create`; methods/outstanding → `payments.read`

## Checklist
- [x] member ledger
- [x] admin ledger
- [x] outstanding dues
- [x] payment detail
- [x] payment methods
- [ ] POS
- [ ] discounts
- [ ] split tender
- [ ] refund/adjustment
- [ ] receipt
- [ ] financial integration tests

## Tests
- `test/features/payments/payments_ledger_cubit_test.dart`
- `test/features/payments/payment_methods_cubit_test.dart`
- Router/capability coverage updated for new payment paths

## OPEN / blockers
- Nest `PAY` module not implemented yet — live API calls will 404 until backend PAY-001+ lands
- Money amounts kept as decimal strings end-to-end (never JSON numbers)

## Recommended next
POS capture (`createPayment` + tenders + `Idempotency-Key`), then refund/adjust + receipt
