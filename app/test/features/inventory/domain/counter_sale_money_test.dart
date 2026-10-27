import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/inventory/domain/counter_sale_money.dart';

void main() {
  group('unitCharge', () {
    test('sale rate alone when there is no tax rate', () {
      expect(unitCharge(saleRate: '1499.00'), '1499.00');
    });

    test('includes tax with half-up rounding', () {
      expect(
        unitCharge(saleRate: '100.00', taxRatePercent: '18.00'),
        '118.00',
      );
    });

    test('half-up on tax fraction', () {
      // 10.00 × 2.5% = 0.25 exactly → 10.25
      expect(
        unitCharge(saleRate: '10.00', taxRatePercent: '2.50'),
        '10.25',
      );
      // 33.33 × 18% = 5.9994 → 6.00 tax → 39.33
      expect(
        unitCharge(saleRate: '33.33', taxRatePercent: '18.00'),
        '39.33',
      );
    });
  });
}
