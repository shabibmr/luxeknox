import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
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
    registerFallbackValue(
      const ActiveWorkoutSetEdited(setId: 'fallback'),
    );
    registerFallbackValue(const ActiveWorkoutSetDeleted('fallback'));
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
  }) async {
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

        await tester.tap(find.widgetWithText(FilledButton, WorkoutStrings.deleteSet));
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
          ActiveWorkoutState(session: session, loggedSets: const [], resumed: true),
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
}
