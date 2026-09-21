import 'dart:async';

import 'package:app/core/error/failures.dart';
import 'package:app/features/workout/domain/entities/workout_plan.dart';
import 'package:app/features/workout/domain/entities/workout_plan_exercise.dart';
import 'package:app/features/workout/domain/entities/workout_plan_status.dart';
import 'package:app/features/workout/domain/entities/workout_session.dart';
import 'package:app/features/workout/domain/entities/workout_session_set.dart';
import 'package:app/features/workout/domain/usecases/complete_workout_session_usecase.dart';
import 'package:app/features/workout/domain/usecases/get_workout_plan_usecase.dart';
import 'package:app/features/workout/domain/usecases/log_workout_set_usecase.dart';
import 'package:app/features/workout/domain/usecases/start_workout_session_usecase.dart';
import 'package:app/features/workout/presentation/cubit/active_workout_cubit.dart';
import 'package:app/features/workout/presentation/cubit/rest_timer_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockStart extends Mock implements StartWorkoutSessionUseCase {}

class _MockLog extends Mock implements LogWorkoutSetUseCase {}

class _MockComplete extends Mock implements CompleteWorkoutSessionUseCase {}

class _MockGetPlan extends Mock implements GetWorkoutPlanUseCase {}

void main() {
  late _MockStart startSession;
  late _MockLog logSet;
  late _MockComplete completeSession;
  late _MockGetPlan getPlan;
  late StreamController<void> tickController;
  late RestTimerCubit restTimer;

  WorkoutSession session({
    String id = 's1',
    DateTime? completedAt,
    int? durationMinutes,
    num? totalVolumeKg,
    int? clientFeedbackRating,
    String? notes,
  }) {
    return WorkoutSession(
      id: id,
      memberId: '7',
      workoutPlanId: '3',
      startedAt: DateTime.utc(2026, 1, 1),
      completedAt: completedAt,
      durationMinutes: durationMinutes,
      totalVolumeKg: totalVolumeKg,
      clientFeedbackRating: clientFeedbackRating,
      notes: notes,
    );
  }

  WorkoutSessionSet loggedSet({
    String id = 'set1',
    String exerciseId = '100',
    int setNumber = 1,
  }) {
    return WorkoutSessionSet(
      id: id,
      workoutSessionId: 's1',
      exerciseId: exerciseId,
      setNumber: setNumber,
      repsCompleted: 10,
      weightLiftedKg: 50,
      isCompleted: true,
    );
  }

  WorkoutPlan plan() {
    return WorkoutPlan(
      id: '3',
      title: 'Push',
      isTemplate: false,
      status: WorkoutPlanStatus.active,
      rowVersion: 1,
      exercises: const [
        WorkoutPlanExercise(
          exerciseId: '100',
          dayNumber: 1,
          orderIndex: 0,
          targetSets: 3,
          restSeconds: 45,
        ),
      ],
    );
  }

  setUpAll(() {
    registerFallbackValue(
      const StartWorkoutSessionParams(memberId: '1'),
    );
    registerFallbackValue(
      const LogWorkoutSetParams(
        sessionId: '1',
        exerciseId: '1',
        setNumber: 1,
      ),
    );
    registerFallbackValue(
      const CompleteWorkoutSessionParams(sessionId: '1'),
    );
  });

  setUp(() {
    startSession = _MockStart();
    logSet = _MockLog();
    completeSession = _MockComplete();
    getPlan = _MockGetPlan();
    tickController = StreamController<void>.broadcast();
    restTimer = RestTimerCubit(ticker: () => tickController.stream);
  });

  tearDown(() async {
    await restTimer.close();
    await tickController.close();
  });

  ActiveWorkoutCubit buildCubit() {
    final cubit = ActiveWorkoutCubit(
      startSession,
      logSet,
      completeSession,
      getPlan,
      restTimer,
    );
    cubit.configure(memberId: '7', workoutPlanId: '3');
    return cubit;
  }

  blocTest<ActiveWorkoutCubit, ActiveWorkoutState>(
    'starts session, logs set (starts rest), completes',
    build: () {
      when(() => startSession(any())).thenAnswer(
        (_) async => Right(session()),
      );
      when(() => getPlan('3')).thenAnswer((_) async => Right(plan()));
      when(() => logSet(any())).thenAnswer(
        (_) async => Right(loggedSet()),
      );
      when(() => completeSession(any())).thenAnswer(
        (_) async => Right(
          session(
            completedAt: DateTime.utc(2026, 1, 1, 1),
            durationMinutes: 40,
            totalVolumeKg: 500,
          ),
        ),
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.start(workoutPlanId: '3');
      await cubit.logSet(
        exerciseId: '100',
        repsCompleted: 10,
        weightLiftedKg: 50,
      );
      expect(restTimer.state.isRunning, isTrue);
      expect(restTimer.state.remainingSeconds, 45);
      await cubit.complete();
    },
    expect: () => [
      isA<ActiveWorkoutStarting>(),
      isA<ActiveWorkoutInProgress>()
          .having((s) => s.session.id, 'session', 's1')
          .having((s) => s.plan?.id, 'plan', '3'),
      isA<ActiveWorkoutInProgress>().having((s) => s.logging, 'logging', true),
      isA<ActiveWorkoutInProgress>()
          .having((s) => s.loggedSets.length, 'sets', 1)
          .having((s) => s.logging, 'logging', false),
      isA<ActiveWorkoutCompleting>(),
      isA<ActiveWorkoutCompleted>()
          .having((s) => s.session.durationMinutes, 'duration', 40)
          .having((s) => s.session.totalVolumeKg, 'volume', 500)
          .having((s) => s.loggedSetCount, 'loggedSetCount', 1),
    ],
    verify: (_) {
      final captured = verify(
        () => completeSession(captureAny()),
      ).captured.single as CompleteWorkoutSessionParams;
      expect(captured.sessionId, 's1');
      expect(captured.notes, isNull);
      expect(captured.clientFeedbackRating, isNull);
    },
  );

  blocTest<ActiveWorkoutCubit, ActiveWorkoutState>(
    'complete forwards notes and rating',
    build: () {
      when(() => startSession(any())).thenAnswer(
        (_) async => Right(session()),
      );
      when(() => getPlan('3')).thenAnswer((_) async => Right(plan()));
      when(() => completeSession(any())).thenAnswer(
        (invocation) async {
          final params =
              invocation.positionalArguments.first
                  as CompleteWorkoutSessionParams;
          return Right(
            session(
              completedAt: DateTime.utc(2026, 1, 1, 1),
              durationMinutes: 30,
              totalVolumeKg: 200,
              notes: params.notes,
              clientFeedbackRating: params.clientFeedbackRating,
            ),
          );
        },
      );
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.start(workoutPlanId: '3');
      await cubit.complete(notes: 'Felt strong', clientFeedbackRating: 5);
    },
    expect: () => [
      isA<ActiveWorkoutStarting>(),
      isA<ActiveWorkoutInProgress>(),
      isA<ActiveWorkoutCompleting>(),
      isA<ActiveWorkoutCompleted>()
          .having((s) => s.session.notes, 'notes', 'Felt strong')
          .having((s) => s.session.clientFeedbackRating, 'rating', 5)
          .having((s) => s.loggedSetCount, 'loggedSetCount', 0),
    ],
    verify: (_) {
      final captured = verify(
        () => completeSession(captureAny()),
      ).captured.single as CompleteWorkoutSessionParams;
      expect(captured.sessionId, 's1');
      expect(captured.notes, 'Felt strong');
      expect(captured.clientFeedbackRating, 5);
    },
  );

  blocTest<ActiveWorkoutCubit, ActiveWorkoutState>(
    'start failure',
    build: () {
      when(() => startSession(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return buildCubit();
    },
    act: (cubit) => cubit.start(),
    expect: () => [
      isA<ActiveWorkoutStarting>(),
      isA<ActiveWorkoutFailure>(),
    ],
  );
}
