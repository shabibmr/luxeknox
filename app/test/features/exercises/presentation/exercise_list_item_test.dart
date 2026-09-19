import 'package:app/features/exercises/domain/entities/exercise.dart';
import 'package:app/features/exercises/presentation/widgets/exercise_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tExercise = Exercise(
    id: '1',
    name: 'Bench Press',
    primaryMuscleGroup: 'Chest',
    secondaryMuscles: ['Triceps'],
    equipmentNeeded: ['Barbell', 'Bench'],
    instructions: 'Push the bar up.',
    difficultyLevel: 'Intermediate',
    isActive: true,
  );

  group('ExerciseListItem (K4)', () {
    testWidgets('renders name, muscle group, equipment, and difficulty', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ExerciseListItem(exercise: tExercise)),
        ),
      );

      expect(find.text('Bench Press'), findsOneWidget);
      expect(find.textContaining('Chest'), findsOneWidget);
      expect(find.textContaining('Barbell, Bench'), findsOneWidget);
      expect(find.text('Intermediate'), findsOneWidget);
    });

    testWidgets('shows "No equipment" when the list is empty', (tester) async {
      const noEquipment = Exercise(
        id: '2',
        name: 'Plank',
        primaryMuscleGroup: 'Core',
        secondaryMuscles: [],
        equipmentNeeded: [],
        instructions: 'Hold.',
        difficultyLevel: 'Beginner',
        isActive: true,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ExerciseListItem(exercise: noEquipment)),
        ),
      );

      expect(find.textContaining('No equipment'), findsOneWidget);
    });

    testWidgets('invokes onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseListItem(
              exercise: tExercise,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ExerciseListItem));
      expect(tapped, isTrue);
    });
  });
}
