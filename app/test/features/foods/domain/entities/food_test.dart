import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/foods/domain/entities/food.dart';

void main() {
  group('Food', () {
    test('should have value equality', () {
      const food1 = Food(
        id: '1',
        name: 'Chicken Breast',
        servingUnit: 'g',
        servingSize: 100,
        calories: 165,
        proteinGrams: 31,
        carbsGrams: 0,
        fatGrams: 3.6,
        fiberGrams: 0,
        isVerified: true,
      );

      const food2 = Food(
        id: '1',
        name: 'Chicken Breast',
        servingUnit: 'g',
        servingSize: 100,
        calories: 165,
        proteinGrams: 31,
        carbsGrams: 0,
        fatGrams: 3.6,
        fiberGrams: 0,
        isVerified: true,
      );

      expect(food1, food2);
    });

    test('should not be equal when fields differ', () {
      const food1 = Food(
        id: '1',
        name: 'Chicken Breast',
        servingUnit: 'g',
        isVerified: true,
      );

      const food2 = Food(
        id: '2',
        name: 'Chicken Breast',
        servingUnit: 'g',
        isVerified: true,
      );

      expect(food1, isNot(food2));
    });

    test('should handle nullable nutrition fields', () {
      const food1 = Food(
        id: '1',
        name: 'Water',
        servingUnit: 'ml',
        isVerified: false,
      );

      const food2 = Food(
        id: '1',
        name: 'Water',
        servingUnit: 'ml',
        servingSize: null,
        calories: null,
        proteinGrams: null,
        carbsGrams: null,
        fatGrams: null,
        fiberGrams: null,
        isVerified: false,
      );

      expect(food1, food2);
    });

    test('copyWith overrides only the given fields', () {
      const original = Food(
        id: '1',
        name: 'Chicken Breast',
        servingUnit: 'g',
        calories: 165,
        isVerified: false,
        isActive: true,
      );

      final updated = original.copyWith(isVerified: true, isActive: false);

      expect(updated.isVerified, isTrue);
      expect(updated.isActive, isFalse);
      expect(updated.id, original.id);
      expect(updated.name, original.name);
      expect(updated.calories, original.calories);
    });
  });
}
