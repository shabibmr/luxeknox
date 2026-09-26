import 'package:api_client/api_client.dart' as api;
import 'package:luxeknox/features/foods/data/models/food_model.dart';
import 'package:luxeknox/features/foods/domain/entities/food.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FoodModelMapper', () {
    test('round trip preserves every field (all fields populated)', () {
      final original = api.Food((b) {
        b
          ..id = 42
          ..name = 'Chicken Breast'
          ..servingUnit = 'g'
          ..servingSize = 100
          ..calories = 165
          ..proteinGrams = 31
          ..carbsGrams = 0
          ..fatGrams = 3.6
          ..fiberGrams = 0
          ..isVerified = true
          ..isActive = true;
      });

      final domain = original.toDomain();
      final roundTripped = domain.toModel();

      expect(roundTripped.id, original.id);
      expect(roundTripped.name, original.name);
      expect(roundTripped.servingUnit, original.servingUnit);
      expect(roundTripped.servingSize, original.servingSize);
      expect(roundTripped.calories, original.calories);
      expect(roundTripped.proteinGrams, original.proteinGrams);
      expect(roundTripped.carbsGrams, original.carbsGrams);
      expect(roundTripped.fatGrams, original.fatGrams);
      expect(roundTripped.fiberGrams, original.fiberGrams);
      expect(roundTripped.isVerified, original.isVerified);
      expect(roundTripped.isActive, original.isActive);
    });

    test('toDomain maps every field correctly', () {
      final model = api.Food((b) {
        b
          ..id = 7
          ..name = 'Brown Rice'
          ..servingUnit = 'cup'
          ..servingSize = 1
          ..calories = 216
          ..proteinGrams = 5
          ..carbsGrams = 45
          ..fatGrams = 1.8
          ..fiberGrams = 3.5
          ..isVerified = false
          ..isActive = true;
      });

      final entity = model.toDomain();

      expect(entity.id, '7');
      expect(entity.name, 'Brown Rice');
      expect(entity.servingUnit, 'cup');
      expect(entity.servingSize, 1.0);
      expect(entity.calories, 216.0);
      expect(entity.proteinGrams, 5.0);
      expect(entity.carbsGrams, 45.0);
      expect(entity.fatGrams, 1.8);
      expect(entity.fiberGrams, 3.5);
      expect(entity.isVerified, false);
      expect(entity.isActive, true);
    });

    test('toDomain maps null nutrition fields and null isVerified', () {
      final model = api.Food((b) {
        b
          ..id = 3
          ..name = 'Water'
          ..servingUnit = 'ml'
          ..isActive = true;
      });

      final entity = model.toDomain();

      expect(entity.servingSize, isNull);
      expect(entity.calories, isNull);
      expect(entity.proteinGrams, isNull);
      expect(entity.carbsGrams, isNull);
      expect(entity.fatGrams, isNull);
      expect(entity.fiberGrams, isNull);
      expect(entity.isVerified, false);
      expect(entity.isActive, true);
    });

    test('toModel maps every field correctly', () {
      const entity = Food(
        id: '9',
        name: 'Salmon',
        servingUnit: 'g',
        servingSize: 100,
        calories: 208,
        proteinGrams: 20,
        carbsGrams: 0,
        fatGrams: 13,
        fiberGrams: 0,
        isVerified: true,
        isActive: true,
      );

      final model = entity.toModel();

      expect(model.id, 9);
      expect(model.name, 'Salmon');
      expect(model.servingUnit, 'g');
      expect(model.servingSize, 100);
      expect(model.calories, 208);
      expect(model.proteinGrams, 20);
      expect(model.carbsGrams, 0);
      expect(model.fatGrams, 13);
      expect(model.fiberGrams, 0);
      expect(model.isVerified, true);
      expect(model.isActive, true);
    });

    test('toWriteModel maps every field correctly', () {
      const entity = Food(
        id: '9',
        name: 'Salmon',
        servingUnit: 'g',
        servingSize: 100,
        calories: 208,
        proteinGrams: 20,
        carbsGrams: 0,
        fatGrams: 13,
        fiberGrams: 0,
        isVerified: true,
        isActive: false,
      );

      final write = entity.toWriteModel();

      expect(write.name, 'Salmon');
      expect(write.servingUnit, 'g');
      expect(write.servingSize, 100);
      expect(write.calories, 208);
      expect(write.proteinGrams, 20);
      expect(write.carbsGrams, 0);
      expect(write.fatGrams, 13);
      expect(write.fiberGrams, 0);
      expect(write.isVerified, true);
      expect(write.isActive, false);
    });
  });
}
