import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/goals/domain/helpers/bmi.dart';

void main() {
  group('weightToKg', () {
    test('passes kg through', () {
      expect(weightToKg(80, 'kg'), 80);
    });

    test('converts lbs', () {
      expect(weightToKg(220, 'lbs'), closeTo(99.790, 0.01));
    });

    test('rejects unknown unit', () {
      expect(weightToKg(80, 'stone'), isNull);
    });
  });

  group('computeBmi', () {
    test('computes from kg and cm', () {
      expect(
        computeBmi(weightKg: 81, heightCm: 180),
        closeTo(25.0, 0.01),
      );
    });

    test('null when height missing', () {
      expect(computeBmi(weightKg: 81, heightCm: null), isNull);
    });

    test('null when weight missing', () {
      expect(computeBmi(weightKg: null, heightCm: 180), isNull);
    });
  });
}
