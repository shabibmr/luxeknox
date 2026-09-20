import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/foods/domain/entities/food_filter.dart';

void main() {
  group('FoodFilter', () {
    test('should have value equality', () {
      const filter1 = FoodFilter(query: 'chicken', isVerified: true);
      const filter2 = FoodFilter(query: 'chicken', isVerified: true);

      expect(filter1, filter2);
    });

    test('should not be equal when fields differ', () {
      const filter1 = FoodFilter(query: 'chicken', isVerified: true);
      const filter2 = FoodFilter(query: 'beef', isVerified: true);

      expect(filter1, isNot(filter2));
    });

    group('isEmpty', () {
      test('should return true when all fields are null', () {
        const filter = FoodFilter();

        expect(filter.isEmpty, isTrue);
      });

      test('should return false when query is not null', () {
        const filter = FoodFilter(query: 'chicken');

        expect(filter.isEmpty, isFalse);
      });

      test('should return false when isVerified is not null', () {
        const filter = FoodFilter(isVerified: false);

        expect(filter.isEmpty, isFalse);
      });
    });

    group('copyWith', () {
      test('should create a copy with changed query', () {
        const original = FoodFilter(query: 'chicken', isVerified: true);

        final updated = original.copyWith(query: 'beef');

        expect(updated.query, 'beef');
        expect(updated.isVerified, true);
      });

      test('should leave unchanged fields as is', () {
        const original = FoodFilter(query: 'chicken', isVerified: true);

        final updated = original.copyWith(query: 'beef');

        expect(updated.isVerified, original.isVerified);
      });

      test('should allow setting a field to null explicitly', () {
        const original = FoodFilter(query: 'chicken', isVerified: true);

        final updated = original.copyWith(query: null);

        expect(updated.query, isNull);
        expect(updated.isVerified, true);
      });

      test('should clear all filters when all nulls are passed', () {
        const original = FoodFilter(query: 'chicken', isVerified: true);

        final updated = original.copyWith(query: null, isVerified: null);

        expect(updated.isEmpty, isTrue);
      });
    });
  });
}
