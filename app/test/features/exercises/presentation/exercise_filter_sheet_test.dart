import 'package:app/features/exercises/domain/entities/exercise_filter.dart';
import 'package:app/features/exercises/presentation/widgets/exercise_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExerciseFilterSheet (K6)', () {
    testWidgets('applying fields returns the updated filter', (tester) async {
      ExerciseFilter? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await ExerciseFilterSheet.show(
                    context,
                    const ExerciseFilter(searchText: 'press'),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Muscle group'),
        'Chest',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Equipment'),
        'Barbell',
      );
      await tester.tap(find.text('Apply filters'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.searchText, 'press');
      expect(result!.muscleGroup, 'Chest');
      expect(result!.equipment, 'Barbell');
      expect(result!.difficulty, isNull);
    });

    testWidgets('clear all empties every field before applying', (
      tester,
    ) async {
      ExerciseFilter? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await ExerciseFilterSheet.show(
                    context,
                    const ExerciseFilter(
                      muscleGroup: 'Chest',
                      equipment: 'Barbell',
                      difficulty: 'Advanced',
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Clear all'));
      await tester.pump();
      await tester.tap(find.text('Apply filters'));
      await tester.pumpAndSettle();

      expect(result!.isEmpty, isTrue);
    });
  });
}
