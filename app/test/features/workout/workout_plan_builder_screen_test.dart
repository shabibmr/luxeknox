import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:luxeknox/features/workout/domain/usecases/create_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/get_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/publish_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/replace_workout_plan_exercises_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/update_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/presentation/cubit/workout_plan_builder_cubit.dart';
import 'package:luxeknox/features/workout/presentation/screens/workout_plan_builder_screen.dart';
import 'package:mocktail/mocktail.dart';

class _MockGet extends Mock implements GetWorkoutPlanUseCase {}

class _MockCreate extends Mock implements CreateWorkoutPlanUseCase {}

class _MockUpdate extends Mock implements UpdateWorkoutPlanUseCase {}

class _MockReplace extends Mock implements ReplaceWorkoutPlanExercisesUseCase {}

class _MockPublish extends Mock implements PublishWorkoutPlanUseCase {}

void main() {
  setUp(() {
    GetIt.I.registerFactory(
      () => WorkoutPlanBuilderCubit(
        _MockGet(),
        _MockCreate(),
        _MockUpdate(),
        _MockReplace(),
        _MockPublish(),
      ),
    );
  });
  tearDown(GetIt.I.reset);

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(home: WorkoutPlanBuilderScreen(isTemplate: true)),
    );
    await tester.pump();
  }

  testWidgets('Next is blocked until the blueprint is valid', (tester) async {
    await pump(tester);
    await tester.enterText(find.byType(TextFormField).first, 'Plan');
    await tester.tap(find.byKey(const Key('blueprint_next')));
    await tester.pump();
    expect(find.text('12-week objective is required'), findsOneWidget);
    expect(find.text('Add exercise (Day +)'), findsNothing);
  });

  testWidgets('valid blueprint advances to exercises', (tester) async {
    await pump(tester);
    await tester.enterText(find.byType(TextFormField).first, 'Plan');
    await tester.enterText(
      find.byKey(const Key('blueprint_objective')),
      'Lose 6 kg',
    );
    await tester.enterText(
      find.byKey(const Key('blueprint_milestone')),
      'Squat BW',
    );
    await tester.tap(find.byKey(const Key('blueprint_freq_inc')));
    await tester.tap(find.byKey(const Key('blueprint_dur_inc')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('blueprint_split')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Full body').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('blueprint_next')));
    await tester.tap(find.byKey(const Key('blueprint_next')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('blueprint_back')), findsOneWidget);
    expect(find.text('Exercises'), findsWidgets);
  });
}
