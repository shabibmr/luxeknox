import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/inventory/domain/sale_line_charge.dart';

void main() {
  group('saleLineCharge', () {
    test('quantity times sale rate, half-up to 2 decimals, no tax', () {
      expect(
        saleLineCharge(quantity: '1', saleRate: '10.00'),
        '10.00',
      );
      expect(
        saleLineCharge(quantity: '2', saleRate: '10.00'),
        '20.00',
      );
      // 1.005 * 1 → half-up path via qty*rate
      expect(
        saleLineCharge(quantity: '1.005', saleRate: '1.00'),
        '1.01',
      );
    });

    test('adds tax when tax rate percent is set', () {
      // gross 100.00, 18% → tax 18.00 → charge 118.00
      expect(
        saleLineCharge(
          quantity: '1',
          saleRate: '100.00',
          taxRatePercent: '18.00',
        ),
        '118.00',
      );
      // gross 10.00 * 2 = 20.00, 5% → tax 1.00 → 21.00
      expect(
        saleLineCharge(
          quantity: '2',
          saleRate: '10.00',
          taxRatePercent: '5.00',
        ),
        '21.00',
      );
    });

    test('tax half-up to 2 decimals', () {
      // gross 10.00, 7.5% → 0.75 exactly
      expect(
        saleLineCharge(
          quantity: '1',
          saleRate: '10.00',
          taxRatePercent: '7.50',
        ),
        '10.75',
      );
      // gross 1.00, 12.5% → 0.125 → half-up 0.13 → charge 1.13
      expect(
        saleLineCharge(
          quantity: '1',
          saleRate: '1.00',
          taxRatePercent: '12.50',
        ),
        '1.13',
      );
    });

    test('null or empty tax rate means no tax', () {
      expect(
        saleLineCharge(
          quantity: '1',
          saleRate: '50.00',
          taxRatePercent: null,
        ),
        '50.00',
      );
      expect(
        saleLineCharge(
          quantity: '1',
          saleRate: '50.00',
          taxRatePercent: '',
        ),
        '50.00',
      );
    });
  });

  group('sumCharges', () {
    test('sums line charges half-up safe as money strings', () {
      expect(sumCharges(['10.00', '5.50', '1.25']), '16.75');
      expect(sumCharges([]), '0.00');
    });
  });
}
