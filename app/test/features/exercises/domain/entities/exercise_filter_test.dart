import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/exercises/domain/entities/exercise_filter.dart';

void main() {
  group('ExerciseFilter', () {
    test('should have value equality', () {
      const filter1 = ExerciseFilter(
        searchText: 'Chest',
        muscleGroup: 'Chest',
        equipment: 'Barbell',
        difficulty: 'Intermediate',
      );

      const filter2 = ExerciseFilter(
        searchText: 'Chest',
        muscleGroup: 'Chest',
        equipment: 'Barbell',
        difficulty: 'Intermediate',
      );

      expect(filter1, filter2);
    });

    test('should not be equal when fields differ', () {
      const filter1 = ExerciseFilter(
        searchText: 'Chest',
        muscleGroup: 'Chest',
        equipment: 'Barbell',
        difficulty: 'Intermediate',
      );

      const filter2 = ExerciseFilter(
        searchText: 'Back',
        muscleGroup: 'Chest',
        equipment: 'Barbell',
        difficulty: 'Intermediate',
      );

      expect(filter1, isNot(filter2));
    });

    group('isEmpty', () {
      test('should return true when all fields are null', () {
        const filter = ExerciseFilter();

        expect(filter.isEmpty, isTrue);
      });

      test('should return false when searchText is not null', () {
        const filter = ExerciseFilter(searchText: 'Chest');

        expect(filter.isEmpty, isFalse);
      });

      test('should return false when muscleGroup is not null', () {
        const filter = ExerciseFilter(muscleGroup: 'Chest');

        expect(filter.isEmpty, isFalse);
      });

      test('should return false when equipment is not null', () {
        const filter = ExerciseFilter(equipment: 'Barbell');

        expect(filter.isEmpty, isFalse);
      });

      test('should return false when difficulty is not null', () {
        const filter = ExerciseFilter(difficulty: 'Intermediate');

        expect(filter.isEmpty, isFalse);
      });

      test('should return false when any field is not null', () {
        const filter = ExerciseFilter(
          searchText: 'Chest',
          muscleGroup: 'Chest',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        );

        expect(filter.isEmpty, isFalse);
      });
    });

    group('copyWith', () {
      test('should create a copy with changed searchText', () {
        const original = ExerciseFilter(
          searchText: 'Chest',
          muscleGroup: 'Chest',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        );

        final updated = original.copyWith(searchText: 'Back');

        expect(updated.searchText, 'Back');
        expect(updated.muscleGroup, 'Chest');
        expect(updated.equipment, 'Barbell');
        expect(updated.difficulty, 'Intermediate');
      });

      test('should create a copy with changed muscleGroup', () {
        const original = ExerciseFilter(
          searchText: 'Chest',
          muscleGroup: 'Chest',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        );

        final updated = original.copyWith(muscleGroup: 'Back');

        expect(updated.searchText, 'Chest');
        expect(updated.muscleGroup, 'Back');
        expect(updated.equipment, 'Barbell');
        expect(updated.difficulty, 'Intermediate');
      });

      test('should create a copy with changed equipment', () {
        const original = ExerciseFilter(
          searchText: 'Chest',
          muscleGroup: 'Chest',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        );

        final updated = original.copyWith(equipment: 'Dumbbell');

        expect(updated.searchText, 'Chest');
        expect(updated.muscleGroup, 'Chest');
        expect(updated.equipment, 'Dumbbell');
        expect(updated.difficulty, 'Intermediate');
      });

      test('should create a copy with changed difficulty', () {
        const original = ExerciseFilter(
          searchText: 'Chest',
          muscleGroup: 'Chest',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        );

        final updated = original.copyWith(difficulty: 'Beginner');

        expect(updated.searchText, 'Chest');
        expect(updated.muscleGroup, 'Chest');
        expect(updated.equipment, 'Barbell');
        expect(updated.difficulty, 'Beginner');
      });

      test('should leave unchanged fields as is', () {
        const original = ExerciseFilter(
          searchText: 'Chest',
          muscleGroup: 'Chest',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        );

        final updated = original.copyWith(searchText: 'Back');

        expect(updated.muscleGroup, original.muscleGroup);
        expect(updated.equipment, original.equipment);
        expect(updated.difficulty, original.difficulty);
      });

      test('should allow setting a field to null explicitly', () {
        const original = ExerciseFilter(
          searchText: 'Chest',
          muscleGroup: 'Chest',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        );

        final updated = original.copyWith(searchText: null);

        expect(updated.searchText, isNull);
        expect(updated.muscleGroup, 'Chest');
        expect(updated.equipment, 'Barbell');
        expect(updated.difficulty, 'Intermediate');
      });

      test('should create a copy with multiple fields changed', () {
        const original = ExerciseFilter(
          searchText: 'Chest',
          muscleGroup: 'Chest',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        );

        final updated = original.copyWith(
          searchText: 'Back',
          difficulty: 'Advanced',
        );

        expect(updated.searchText, 'Back');
        expect(updated.muscleGroup, 'Chest');
        expect(updated.equipment, 'Barbell');
        expect(updated.difficulty, 'Advanced');
      });

      test('should clear all filters when all nulls are passed', () {
        const original = ExerciseFilter(
          searchText: 'Chest',
          muscleGroup: 'Chest',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        );

        final updated = original.copyWith(
          searchText: null,
          muscleGroup: null,
          equipment: null,
          difficulty: null,
        );

        expect(updated.isEmpty, isTrue);
      });
    });
  });
}
