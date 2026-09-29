import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_status.dart';
import 'package:luxeknox/features/workout/domain/usecases/list_workout_plans_usecase.dart';
import 'package:luxeknox/features/workout/presentation/widgets/workout_plan_picker_sheet.dart';
import 'package:mocktail/mocktail.dart';

class MockListWorkoutPlansUseCase extends Mock
    implements ListWorkoutPlansUseCase {}

void main() {
  late MockListWorkoutPlansUseCase listPlans;

  const testPlans = <WorkoutPlan>[
    WorkoutPlan(
      id: 'p1',
      title: 'Upper Body Strength',
      status: WorkoutPlanStatus.active,
      targetGoal: 'Strength',
      difficulty: 'Intermediate',
      isTemplate: false,
      rowVersion: 1,
    ),
    WorkoutPlan(
      id: 'p2',
      title: 'Cardio Blast',
      status: WorkoutPlanStatus.active,
      targetGoal: 'Endurance',
      difficulty: 'Beginner',
      isTemplate: false,
      rowVersion: 1,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(const ListWorkoutPlansParams());
  });

  setUp(() {
    listPlans = MockListWorkoutPlansUseCase();
    when(() => listPlans(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(items: testPlans, nextCursor: null, hasMore: false),
      ),
    );
  });

  testWidgets('WorkoutPlanPickerSheet renders plans and selects on tap', (
    tester,
  ) async {
    WorkoutPlan? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                selected = await showWorkoutPlanPickerSheet(
                  context,
                  memberId: '7',
                  listPlans: listPlans,
                );
              },
              child: const Text('Pick Plan'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Pick Plan'));
    await tester.pumpAndSettle();

    expect(find.text('Upper Body Strength'), findsOneWidget);
    expect(find.text('Cardio Blast'), findsOneWidget);

    await tester.tap(find.text('Upper Body Strength'));
    await tester.pumpAndSettle();

    expect(selected, isNotNull);
    expect(selected!.id, 'p1');
    expect(selected!.title, 'Upper Body Strength');
  });
}
