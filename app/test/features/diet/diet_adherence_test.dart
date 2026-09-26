import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/diet/domain/entities/diet_adherence.dart';

void main() {
  group('computeDietAdherence', () {
    test('returns 100 when target is 0 or negative', () {
      expect(computeDietAdherence(caloriesConsumed: 2000, targetCalories: 0), 100.0);
      expect(computeDietAdherence(caloriesConsumed: 2000, targetCalories: -100), 100.0);
    });

    test('returns 100 when consumed equals target', () {
      expect(
        computeDietAdherence(caloriesConsumed: 2000, targetCalories: 2000),
        100.0,
      );
    });

    test('returns 90 when off by 10%', () {
      expect(
        computeDietAdherence(caloriesConsumed: 1800, targetCalories: 2000),
        90.0,
      );
      expect(
        computeDietAdherence(caloriesConsumed: 2200, targetCalories: 2000),
        90.0,
      );
    });

    test('clamps score between 0 and 100', () {
      expect(
        computeDietAdherence(caloriesConsumed: 5000, targetCalories: 2000),
        0.0,
      );
    });
  });

  group('DietAdherenceRating', () {
    test('maps score >= 85 to onTarget', () {
      expect(DietAdherenceRating.fromScore(85), DietAdherenceRating.onTarget);
      expect(DietAdherenceRating.fromScore(100), DietAdherenceRating.onTarget);
    });

    test('maps score between 70 and 84 to moderate', () {
      expect(DietAdherenceRating.fromScore(70), DietAdherenceRating.moderate);
      expect(DietAdherenceRating.fromScore(84.9), DietAdherenceRating.moderate);
    });

    test('maps score < 70 to offTarget', () {
      expect(DietAdherenceRating.fromScore(69.9), DietAdherenceRating.offTarget);
      expect(DietAdherenceRating.fromScore(0), DietAdherenceRating.offTarget);
    });
  });
}
