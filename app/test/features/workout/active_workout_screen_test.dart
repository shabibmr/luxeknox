import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_exercise.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_status.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_session.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_session_set.dart';
import 'package:luxeknox/features/workout/presentation/bloc/active_workout_bloc.dart';
import 'package:luxeknox/features/workout/presentation/cubit/rest_timer_cubit.dart';
import 'package:luxeknox/features/workout/presentation/screens/active_workout_screen.dart';
import 'package:luxeknox/features/workout/presentation/workout_strings.dart';
import 'package:mocktail/mocktail.dart';

class MockActiveWorkoutBloc
    extends MockBloc<ActiveWorkoutEvent, ActiveWorkoutState>
    implements ActiveWorkoutBloc {}

/// Covers the review finding on Task 6: the set edit/delete UI and the
/// resumed/failure snackbar listener in active_workout_screen.dart had no
/// test. Uses a mocked [ActiveWorkoutBloc] (bloc_test's MockBloc, the
/// pattern already used in test/core/router/trainer_routes_test.dart)
/// instead of real use cases.
void main() {
  late MockActiveWorkoutBloc bloc;

  final loggedSet = const WorkoutSessionSet(
    id: 's1',
    workoutSessionId: 'sess1',
    exerciseId: 'ex1',
    setNumber: 1,
    repsCompleted: 10,
    weightLiftedKg: 50,
    rpeScore: 7,
  );

  final session = WorkoutSession(
    id: 'sess1',
    memberId: '42',
    startedAt: DateTime(2026, 1, 1),
    sets: [loggedSet],
  );

  setUpAll(() {
    registerFallbackValue(const ActiveWorkoutSetEdited(setId: 'fallback'));
    registerFallbackValue(const ActiveWorkoutSetDeleted('fallback'));
    registerFallbackValue(const ActiveWorkoutSetLogged(exerciseId: 'fallback'));
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
    Stream<ActiveWorkoutState>? stream,
    Size size = const Size(800, 1200),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.view.resetViewInsets();
    });
    whenListen(
      bloc,
      stream ?? const Stream<ActiveWorkoutState>.empty(),
      initialState: initialState,
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: ActiveWorkoutScreen(memberId: '42', historyPath: '/history'),
      ),
    );
    await tester.pump();
  }

  Future<void> scrollColumnTo(WidgetTester tester, Finder target) async {
    final column = find.byKey(const ValueKey('active-workout-column'));
    for (var i = 0; i < 8 && target.hitTestable().evaluate().isEmpty; i++) {
      await tester.drag(column, const Offset(0, -300));
      await tester.pump();
    }
    await tester.ensureVisible(target);
    expect(target.hitTestable(), findsOneWidget);
  }

  final inProgressState = ActiveWorkoutState(
    session: session,
    loggedSets: [loggedSet],
  );

  group('set edit/delete menu', () {
    testWidgets(
      'Edit opens a sheet prefilled with the set, and saving dispatches '
      'ActiveWorkoutSetEdited with the new reps',
      (tester) async {
        await pumpScreen(tester, initialState: inProgressState);

        await tester.tap(find.byType(PopupMenuButton<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text(WorkoutStrings.editSet));
        await tester.pumpAndSettle();

        // Prefilled from the tapped set.
        expect(find.text('10'), findsOneWidget);
        expect(find.text('50'), findsOneWidget);
        expect(find.text('7'), findsOneWidget);

        // The main logging form behind the sheet also has reps/weight/rpe
        // TextFields, so scope to the sheet to avoid editing the wrong one.
        final sheetFields = find.descendant(
          of: find.byType(BottomSheet),
          matching: find.byType(TextField),
        );
        await tester.enterText(sheetFields.at(0), '12');
        await tester.tap(
          find.descendant(
            of: find.byType(BottomSheet),
            matching: find.widgetWithText(FilledButton, WorkoutStrings.save),
          ),
        );
        await tester.pumpAndSettle();

        verify(
          () => bloc.add(
            const ActiveWorkoutSetEdited(
              setId: 's1',
              reps: 12,
              weightKg: 50,
              rpe: 7,
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'Delete then confirm dispatches ActiveWorkoutSetDeleted(setId)',
      (tester) async {
        await pumpScreen(tester, initialState: inProgressState);

        await tester.tap(find.byType(PopupMenuButton<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text(WorkoutStrings.deleteSet));
        await tester.pumpAndSettle();

        await tester.tap(
          find.widgetWithText(FilledButton, WorkoutStrings.deleteSet),
        );
        await tester.pumpAndSettle();

        verify(() => bloc.add(const ActiveWorkoutSetDeleted('s1'))).called(1);
      },
    );

    testWidgets('Delete then cancel dispatches nothing', (tester) async {
      await pumpScreen(tester, initialState: inProgressState);

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(WorkoutStrings.deleteSet));
      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(TextButton, WorkoutStrings.completeConfirmCancel),
      );
      await tester.pumpAndSettle();

      verifyNever(() => bloc.add(any(that: isA<ActiveWorkoutSetDeleted>())));
      verifyNever(() => bloc.add(any(that: isA<ActiveWorkoutSetEdited>())));
    });

    testWidgets('menu is not available once the session is completed', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        initialState: ActiveWorkoutState(
          session: session,
          loggedSets: [loggedSet],
          completed: true,
          loggedSetCount: 1,
        ),
      );

      expect(find.byType(PopupMenuButton<String>), findsNothing);
      expect(find.text(WorkoutStrings.editSet), findsNothing);
      expect(find.text(WorkoutStrings.deleteSet), findsNothing);
    });
  });

  group('resumed / failure snackbar listener', () {
    testWidgets(
      'resumed flipping false -> true shows the resumedSession snackbar '
      'exactly once, not again on an unrelated rebuild',
      (tester) async {
        final controller = StreamController<ActiveWorkoutState>();
        addTearDown(controller.close);

        await pumpScreen(
          tester,
          initialState: const ActiveWorkoutState(),
          stream: controller.stream,
        );

        expect(find.text(WorkoutStrings.resumedSession), findsNothing);

        controller.add(
          ActiveWorkoutState(
            session: session,
            loggedSets: const [],
            resumed: true,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text(WorkoutStrings.resumedSession), findsOneWidget);

        // Unrelated rebuild: resumed stays true, something else changes.
        // listenWhen must not re-fire, so no second snackbar is queued.
        controller.add(
          ActiveWorkoutState(
            session: session,
            loggedSets: const [],
            resumed: true,
            logging: true,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text(WorkoutStrings.resumedSession), findsOneWidget);
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets(
      'a failure carrying the read-only PT message shows it verbatim',
      (tester) async {
        const readOnlyMessage =
            'Read-only: an active Personal Training subscription is '
            'required to modify this member';
        final controller = StreamController<ActiveWorkoutState>();
        addTearDown(controller.close);

        await pumpScreen(
          tester,
          initialState: inProgressState,
          stream: controller.stream,
        );

        controller.add(
          inProgressState.copyWith(
            failure: const BusinessRuleFailure(readOnlyMessage),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // The failure is also shown inline above the form (pre-existing
        // behavior); assert it verbatim specifically inside the SnackBar.
        expect(
          find.descendant(
            of: find.byType(SnackBar),
            matching: find.text(readOnlyMessage),
          ),
          findsOneWidget,
        );
      },
    );
  });

  group('phone logging surface', () {
    const exerciseName =
        'Back Squat with a very long prescribed name for a narrow phone';

    final squat = WorkoutPlanExercise(
      exerciseId: 'ex1',
      exerciseName: exerciseName,
      dayNumber: 1,
      orderIndex: 0,
      targetSets: 3,
      targetReps: '8-12',
      targetWeightKg: 50,
    );

    final row = const WorkoutPlanExercise(
      exerciseId: 'ex2',
      exerciseName: 'Barbell Row',
      dayNumber: 1,
      orderIndex: 1,
      targetSets: 3,
      targetReps: '10',
      targetWeightKg: 40,
    );

    final plan = WorkoutPlan(
      id: 'p1',
      title: 'Strength',
      isTemplate: false,
      status: WorkoutPlanStatus.active,
      rowVersion: 1,
      exercises: [squat, row],
    );

    final phoneState = ActiveWorkoutState(
      session: session,
      loggedSets: [loggedSet],
      plan: plan,
      selectedExerciseId: 'ex1',
    );

    const disabledComplete =
        'Complete Workout (Complete all planned exercises first)';

    for (final width in [360.0, 599.0]) {
      testWidgets(
        'at ${width.toInt()}dp shows the current set and hides dense controls',
        (tester) async {
          await pumpScreen(
            tester,
            initialState: phoneState,
            size: Size(width, 900),
          );

          expect(find.text(exerciseName), findsOneWidget);
          expect(
            find.text(
              WorkoutStrings.exerciseTargetLine(
                sets: 3,
                reps: '8-12',
                weightKg: 50,
              ),
            ),
            findsOneWidget,
          );
          expect(find.text(WorkoutStrings.weightLabel), findsOneWidget);
          expect(find.text(WorkoutStrings.repsLabel), findsOneWidget);
          expect(find.textContaining(WorkoutStrings.done), findsOneWidget);
          expect(find.byTooltip('-2.5 kg'), findsOneWidget);
          expect(find.byTooltip('+2.5 kg'), findsOneWidget);
          expect(find.byTooltip('-1 rep'), findsOneWidget);
          expect(find.byTooltip('+1 rep'), findsOneWidget);

          expect(find.text(WorkoutStrings.rpeLabel), findsNothing);
          expect(find.text(WorkoutStrings.setNotesLabel), findsNothing);
          expect(find.text(WorkoutStrings.exerciseHistoryTitle), findsNothing);
          expect(find.text(WorkoutStrings.skipSet), findsNothing);
          expect(find.byTooltip('Set Comments'), findsNothing);

          await tester.tap(find.byTooltip(WorkoutStrings.moreExerciseActions));
          await tester.pumpAndSettle();
          expect(
            find.text(WorkoutStrings.exerciseHistoryTitle),
            findsOneWidget,
          );
          expect(find.text(WorkoutStrings.exerciseComments), findsOneWidget);
          expect(find.text(WorkoutStrings.skipSet), findsOneWidget);

          await tester.binding.handlePopRoute();
          await tester.pumpAndSettle();

          await tester.ensureVisible(find.text(WorkoutStrings.setDetails));
          await tester.tap(find.text(WorkoutStrings.setDetails));
          await tester.pumpAndSettle();
          expect(find.text(WorkoutStrings.rpeLabel), findsOneWidget);
          expect(find.text(WorkoutStrings.setNotesLabel), findsOneWidget);

          await scrollColumnTo(tester, find.text(disabledComplete));
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets(
      'from 600dp up to 840dp keeps the dense column without overflow',
      (tester) async {
        final denseExercise = WorkoutPlanExercise(
          exerciseId: 'ex1',
          exerciseName: exerciseName,
          dayNumber: 1,
          orderIndex: 0,
          targetSets: 4,
          targetReps:
              '8-12 explosive reps with a pause held at the bottom '
              'of every repetition before standing',
          targetWeightKg: 102.5,
        );
        await pumpScreen(
          tester,
          initialState: ActiveWorkoutState(
            session: session,
            loggedSets: [loggedSet],
            plan: WorkoutPlan(
              id: 'p1',
              title: 'Strength',
              isTemplate: false,
              status: WorkoutPlanStatus.active,
              rowVersion: 1,
              exercises: [denseExercise],
            ),
            selectedExerciseId: 'ex1',
          ),
          size: const Size(640, 1800),
        );

        expect(find.text(WorkoutStrings.rpeLabel), findsOneWidget);
        expect(find.text(WorkoutStrings.setNotesLabel), findsOneWidget);
        expect(find.text(WorkoutStrings.skipSet), findsOneWidget);
        expect(find.textContaining(WorkoutStrings.done), findsOneWidget);
        expect(
          find.byTooltip(WorkoutStrings.exerciseHistoryTitle),
          findsOneWidget,
        );
        expect(find.byTooltip('Set Comments'), findsOneWidget);
        expect(
          find.byTooltip(WorkoutStrings.moreExerciseActions),
          findsNothing,
        );
        expect(find.text(WorkoutStrings.setDetails), findsNothing);
        await scrollColumnTo(tester, find.text(disabledComplete));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('a future exercise is one short locked line', (tester) async {
      await pumpScreen(
        tester,
        initialState: phoneState.copyWith(selectedExerciseId: 'ex2'),
        size: const Size(360, 900),
      );

      expect(find.text(WorkoutStrings.futureExerciseLocked), findsOneWidget);
      expect(find.text(WorkoutStrings.weightLabel), findsNothing);
      expect(
        find.textContaining('cannot log sets until preceding'),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'finished prescribed sets are one short line and complete stays available',
      (tester) async {
        final donePlan = WorkoutPlan(
          id: 'p1',
          title: 'Strength',
          isTemplate: false,
          status: WorkoutPlanStatus.active,
          rowVersion: 1,
          exercises: [
            const WorkoutPlanExercise(
              exerciseId: 'ex1',
              exerciseName: 'Back Squat',
              dayNumber: 1,
              orderIndex: 0,
              targetSets: 1,
              targetReps: '8',
              targetWeightKg: 50,
            ),
          ],
        );
        await pumpScreen(
          tester,
          initialState: ActiveWorkoutState(
            session: session,
            loggedSets: [loggedSet],
            plan: donePlan,
            selectedExerciseId: 'ex1',
          ),
          size: const Size(360, 900),
        );

        expect(find.text(WorkoutStrings.allPrescribedSetsDone), findsOneWidget);
        expect(find.text(WorkoutStrings.weightLabel), findsNothing);
        expect(find.text(WorkoutStrings.completeSession), findsOneWidget);
        expect(find.text(disabledComplete), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('logging stays disabled while rest is running', (tester) async {
      final timer = RestTimerCubit(ticker: () => const Stream.empty());
      addTearDown(timer.close);
      when(() => bloc.restTimer).thenReturn(timer);
      timer.start(30);

      await pumpScreen(
        tester,
        initialState: phoneState,
        size: const Size(360, 900),
      );

      expect(find.text(WorkoutStrings.restTimer), findsOneWidget);
      expect(find.textContaining('before logging'), findsNothing);
      await tester.tap(find.textContaining('${WorkoutStrings.done} ·'));
      await tester.pump();
      verifyNever(() => bloc.add(any(that: isA<ActiveWorkoutSetLogged>())));
      expect(tester.takeException(), isNull);
    });

    testWidgets('set editor keeps Save reachable when the keyboard is open', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        initialState: phoneState,
        size: const Size(360, 640),
      );

      await scrollColumnTo(tester, find.byTooltip(WorkoutStrings.setActions));
      await tester.tap(find.byTooltip(WorkoutStrings.setActions));
      await tester.pumpAndSettle();
      await tester.tap(find.text(WorkoutStrings.editSet));
      await tester.pumpAndSettle();

      tester.view.viewInsets = const FakeViewPadding(bottom: 400);
      await tester.pumpAndSettle();

      final save = find.widgetWithText(FilledButton, WorkoutStrings.save);
      final sheet = find.byKey(const ValueKey('set-editor-scroll'));
      for (var i = 0; i < 8 && save.evaluate().isEmpty; i++) {
        await tester.drag(sheet, const Offset(0, -220));
        await tester.pump();
      }
      await tester.ensureVisible(save);
      final visibleBottom =
          tester.view.physicalSize.height / tester.view.devicePixelRatio -
          tester.view.viewInsets.bottom;
      expect(tester.getRect(save).bottom, lessThanOrEqualTo(visibleBottom + 1));
      expect(save, findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'comments sheet keeps Post reachable when the keyboard is open',
      (tester) async {
        await pumpScreen(
          tester,
          initialState: phoneState,
          size: const Size(360, 640),
        );

        await scrollColumnTo(tester, find.byTooltip(WorkoutStrings.setActions));
        await tester.tap(find.byTooltip(WorkoutStrings.setActions));
        await tester.pumpAndSettle();
        await tester.tap(find.text(WorkoutStrings.setComments));
        await tester.pumpAndSettle();

        tester.view.viewInsets = const FakeViewPadding(bottom: 400);
        await tester.pumpAndSettle();

        final post = find.widgetWithText(FilledButton, 'Post');
        final sheet = find.byKey(const ValueKey('comments-sheet-scroll'));
        for (var i = 0; i < 8 && post.evaluate().isEmpty; i++) {
          await tester.drag(sheet, const Offset(0, -220));
          await tester.pump();
        }
        await tester.ensureVisible(post);
        final visibleBottom =
            tester.view.physicalSize.height / tester.view.devicePixelRatio -
            tester.view.viewInsets.bottom;
        expect(
          tester.getRect(post).bottom,
          lessThanOrEqualTo(visibleBottom + 1),
        );
        expect(post, findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });
}
