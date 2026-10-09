import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_exercise_input.dart';
import 'package:luxeknox/features/workout/presentation/widgets/plan_exercise_reorder_list.dart';
import 'package:luxeknox/features/workout/presentation/workout_strings.dart';

void main() {
  const squat = WorkoutPlanExerciseInput(
    exerciseId: '10',
    dayNumber: 1,
    orderIndex: 0,
    exerciseName: 'Squat',
    targetSets: 3,
    targetReps: '8',
  );

  Future<void> pump(
    WidgetTester tester, {
    int? restSeconds,
    required void Function(int index, int? restSeconds) onRestChanged,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlanExerciseReorderList(
            exercises: [squat.copyWith(restSeconds: restSeconds)],
            onReorder: (_, _) {},
            onRestChanged: onRestChanged,
          ),
        ),
      ),
    );
  }

  testWidgets('rest preset writes seconds for that exercise', (tester) async {
    int? saved;
    await pump(tester, onRestChanged: (_, value) => saved = value);

    expect(find.text(WorkoutStrings.restBetweenSetsLabel), findsOneWidget);
    await tester.tap(find.text('90s'));
    await tester.pump();

    expect(saved, 90);
  });

  testWidgets('typing a rest value writes seconds', (tester) async {
    int? saved = 0;
    await pump(tester, onRestChanged: (_, value) => saved = value);

    await tester.enterText(find.byType(TextField), '75');
    await tester.pump();

    expect(saved, 75);
  });

  testWidgets('clearing the field clears rest', (tester) async {
    int? saved = 60;
    await pump(
      tester,
      restSeconds: 60,
      onRestChanged: (_, value) => saved = value,
    );

    await tester.enterText(find.byType(TextField), '');
    await tester.pump();

    expect(saved, isNull);
  });

  testWidgets('exercise rest preset is separate from set rest', (tester) async {
    int? setRest;
    int? exerciseRest;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlanExerciseReorderList(
            exercises: const [squat],
            onReorder: (_, _) {},
            onRestChanged: (_, value) => setRest = value,
            onExerciseRestChanged: (_, value) => exerciseRest = value,
          ),
        ),
      ),
    );

    expect(find.text(WorkoutStrings.restBetweenExercisesLabel), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('rest-between-exercises')),
        matching: find.text('120s'),
      ),
    );
    await tester.pump();

    expect(exerciseRest, 120);
    expect(setRest, isNull);
  });
}
