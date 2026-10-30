import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_exercise.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_status.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_session.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_session_set.dart';
import 'package:luxeknox/features/workout/presentation/bloc/active_workout_bloc.dart';
import 'package:luxeknox/features/workout/presentation/cubit/rest_timer_cubit.dart';
import 'package:luxeknox/features/workout/presentation/screens/live_workout_session_screen.dart';
import 'package:luxeknox/features/workout/presentation/workout_strings.dart';
import 'package:mocktail/mocktail.dart';

class MockActiveWorkoutBloc
    extends MockBloc<ActiveWorkoutEvent, ActiveWorkoutState>
    implements ActiveWorkoutBloc {}

void main() {
  late MockActiveWorkoutBloc bloc;

  final plan = const WorkoutPlan(
    id: 'plan1',
    title: 'Hypertrophy Day',
    isTemplate: false,
    status: WorkoutPlanStatus.active,
    rowVersion: 1,
    exercises: [
      WorkoutPlanExercise(
        exerciseId: 'ex1',
        exerciseName: 'Barbell Squat',
        dayNumber: 1,
        orderIndex: 0,
        targetSets: 3,
        targetReps: '8-10',
        targetWeightKg: 100,
      ),
    ],
  );

  final testSet = const WorkoutSessionSet(
    id: 's1',
    workoutSessionId: 'sess1',
    exerciseId: 'ex1',
    setNumber: 1,
    repsCompleted: 8,
    weightLiftedKg: 100,
    actualRir: '2',
    actualDurationSeconds: 45,
  );

  final testSession = WorkoutSession(
    id: 'sess1',
    memberId: 'member10',
    startedAt: DateTime(2026, 1, 1),
    sets: [testSet],
  );

  setUpAll(() {
    registerFallbackValue(const ActiveWorkoutSetEdited(setId: 'fallback'));
    registerFallbackValue(const ActiveWorkoutSetLogged(exerciseId: 'fallback'));
    registerFallbackValue(const ActiveWorkoutCompletionRequested());
  });

  setUp(() {
    bloc = MockActiveWorkoutBloc();
    when(() => bloc.restTimer).thenReturn(RestTimerCubit());
    getIt.registerFactory<ActiveWorkoutBloc>(() => bloc);
  });

  tearDown(() => getIt.reset());

  Future<void> pumpScreen(
    WidgetTester tester, {
    required ActiveWorkoutState initialState,
    Size size = const Size(1000, 1200),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    whenListen(
      bloc,
      const Stream<ActiveWorkoutState>.empty(),
      initialState: initialState,
    );
    await tester.pumpWidget(
      const MaterialApp(home: LiveWorkoutSessionScreen(memberId: 'member10')),
    );
    await tester.pump();
  }

  testWidgets(
    'RIR stepper and mode toggle: switching to Timed mode reveals stopwatch and duration controls',
    (tester) async {
      final state = ActiveWorkoutState(
        status: LoadStatus.success,
        session: testSession,
        plan: plan,
        selectedExerciseId: 'ex1',
        loggedSets: const [],
      );

      await pumpScreen(tester, initialState: state);

      // Reps mode initially visible
      expect(find.byKey(const ValueKey('timed-mode-toggle')), findsOneWidget);
      expect(find.byKey(const ValueKey('set-reps-field')), findsOneWidget);
      expect(find.byKey(const ValueKey('set-rir-field')), findsOneWidget);
      expect(find.byKey(const ValueKey('set-duration-field')), findsNothing);

      // Test RIR stepper buttons
      final addRirBtn = find.byTooltip('+1 RIR');
      expect(addRirBtn, findsOneWidget);
      await tester.tap(addRirBtn);
      await tester.pump();
      expect(find.widgetWithText(TextField, '1'), findsOneWidget);

      await tester.tap(addRirBtn);
      await tester.pump();
      expect(find.widgetWithText(TextField, '2'), findsOneWidget);

      final minusRirBtn = find.byTooltip('-1 RIR');
      await tester.tap(minusRirBtn);
      await tester.pump();
      expect(find.widgetWithText(TextField, '1'), findsOneWidget);

      // Switch to Timed Duration / Stopwatch mode
      await tester.tap(find.text(WorkoutStrings.timedModeToggleDuration));
      await tester.pumpAndSettle();

      // Duration field & stopwatch button now visible, reps field hidden
      expect(find.byKey(const ValueKey('set-duration-field')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('stopwatch-toggle-btn')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('set-reps-field')), findsNothing);

      // Adjust duration
      final add5sBtn = find.byTooltip('+5s');
      expect(add5sBtn, findsOneWidget);
      await tester.tap(add5sBtn);
      await tester.pump();
      expect(find.widgetWithText(TextField, '5'), findsOneWidget);

      // Submit set in duration mode dispatches ActiveWorkoutSetLogged with duration and RIR
      final doneBtn = find.widgetWithText(
        FilledButton,
        '${WorkoutStrings.done} · Set #1',
      );
      await tester.tap(doneBtn);
      await tester.pump();

      final captured =
          verify(
                () => bloc.add(captureAny(that: isA<ActiveWorkoutSetLogged>())),
              ).captured.first
              as ActiveWorkoutSetLogged;

      expect(captured.exerciseId, 'ex1');
      expect(captured.repsCompleted, isNull);
      expect(captured.actualDurationSeconds, 5);
      expect(captured.actualRir, 1);
    },
  );

  testWidgets(
    'clicking complete opens feedback modal and dispatches multi-rating payload',
    (tester) async {
      // 3 of 3 sets completed
      final state = ActiveWorkoutState(
        status: LoadStatus.success,
        session: testSession,
        plan: plan,
        selectedExerciseId: 'ex1',
        loggedSets: [testSet, testSet, testSet],
      );

      await pumpScreen(tester, initialState: state);

      // Complete button is enabled
      final completeBtn = find.widgetWithText(
        FilledButton,
        WorkoutStrings.completeSession,
      );
      expect(completeBtn, findsOneWidget);
      await tester.tap(completeBtn);
      await tester.pumpAndSettle();

      // Feedback modal is open with sliders
      expect(find.text(WorkoutStrings.completeConfirmTitle), findsOneWidget);
      expect(find.text(WorkoutStrings.effortRatingLabel), findsOneWidget);
      expect(find.text(WorkoutStrings.satisfactionRatingLabel), findsOneWidget);
      expect(find.text(WorkoutStrings.painDiscomfortLabel), findsOneWidget);

      // Submit modal
      await tester.tap(find.byKey(const ValueKey('feedback-modal-submit-btn')));
      await tester.pumpAndSettle();

      final captured =
          verify(
                () => bloc.add(
                  captureAny(that: isA<ActiveWorkoutCompletionRequested>()),
                ),
              ).captured.first
              as ActiveWorkoutCompletionRequested;

      expect(captured.effortRating, 7);
      expect(captured.satisfactionRating, 8);
      expect(captured.painDiscomfortScore, 0);
      expect(captured.painNotes, isNull);
    },
  );

  testWidgets(
    'completed panel renders effort, satisfaction, pain, notes, and high discomfort alert when pain >= 4',
    (tester) async {
      final highPainSession = WorkoutSession(
        id: 'sess1',
        memberId: 'member10',
        startedAt: DateTime(2026, 1, 1, 10, 0),
        completedAt: DateTime(2026, 1, 1, 10, 45),
        durationMinutes: 45,
        totalVolumeKg: 1200,
        effortRating: 9,
        satisfactionRating: 8,
        painDiscomfortScore: 5,
        painNotes: 'Sharp pinch in anterior right shoulder',
      );

      final state = ActiveWorkoutState(
        status: LoadStatus.success,
        session: highPainSession,
        completed: true,
        loggedSetCount: 6,
      );

      await pumpScreen(tester, initialState: state);

      expect(find.text(WorkoutStrings.sessionCompleted), findsOneWidget);
      expect(find.text(WorkoutStrings.effortRatingLabel), findsOneWidget);
      expect(find.text('9 / 10'), findsOneWidget);
      expect(find.text(WorkoutStrings.satisfactionRatingLabel), findsOneWidget);
      expect(find.text('8 / 10'), findsOneWidget);
      expect(find.text(WorkoutStrings.painDiscomfortLabel), findsOneWidget);
      expect(find.text('5 / 10'), findsOneWidget);
      expect(
        find.text('Sharp pinch in anterior right shoulder'),
        findsOneWidget,
      );
      expect(find.text(WorkoutStrings.highDiscomfortAlert), findsOneWidget);
    },
  );
}
