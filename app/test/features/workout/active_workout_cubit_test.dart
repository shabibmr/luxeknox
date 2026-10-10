import 'dart:async';

import 'package:luxeknox/core/error/failure_messages.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_exercise.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_plan_status.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_session.dart';
import 'package:luxeknox/features/workout/domain/entities/workout_session_set.dart';
import 'package:luxeknox/features/workout/domain/usecases/complete_workout_session_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/delete_workout_set_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/get_active_workout_session_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/get_workout_plan_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/log_workout_set_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/start_workout_session_usecase.dart';
import 'package:luxeknox/features/workout/domain/usecases/update_workout_set_usecase.dart';
import 'package:luxeknox/features/workout/presentation/bloc/active_workout_bloc.dart';
import 'package:luxeknox/features/workout/presentation/cubit/rest_timer_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockStart extends Mock implements StartWorkoutSessionUseCase {}

class _MockLog extends Mock implements LogWorkoutSetUseCase {}

class _MockComplete extends Mock implements CompleteWorkoutSessionUseCase {}

class _MockGetPlan extends Mock implements GetWorkoutPlanUseCase {}

class _MockGetActive extends Mock implements GetActiveWorkoutSessionUseCase {}

class _MockUpdateSet extends Mock implements UpdateWorkoutSetUseCase {}

class _MockDeleteSet extends Mock implements DeleteWorkoutSetUseCase {}

void main() {
  late _MockStart startSession;
  late _MockLog logSet;
  late _MockComplete completeSession;
  late _MockGetPlan getPlan;
  late _MockGetActive getActive;
  late _MockUpdateSet updateSet;
  late _MockDeleteSet deleteSet;
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
    return const WorkoutPlan(
      id: '3',
      title: 'Push',
      isTemplate: false,
      status: WorkoutPlanStatus.active,
      rowVersion: 1,
      exercises: [
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
    registerFallbackValue(const StartWorkoutSessionParams(memberId: '1'));
    registerFallbackValue(
      const LogWorkoutSetParams(sessionId: '1', exerciseId: '1', setNumber: 1),
    );
    registerFallbackValue(const CompleteWorkoutSessionParams(sessionId: '1'));
    registerFallbackValue(const GetActiveWorkoutSessionParams(memberId: '1'));
    registerFallbackValue(
      const UpdateWorkoutSetParams(sessionId: '1', setId: '1'),
    );
    registerFallbackValue(
      const DeleteWorkoutSetParams(sessionId: '1', setId: '1'),
    );
  });

  setUp(() {
    startSession = _MockStart();
    logSet = _MockLog();
    completeSession = _MockComplete();
    getPlan = _MockGetPlan();
    getActive = _MockGetActive();
    updateSet = _MockUpdateSet();
    deleteSet = _MockDeleteSet();
    when(
      () => getActive(any()),
    ).thenAnswer((_) async => const Right(null));
    tickController = StreamController<void>.broadcast();
    restTimer = RestTimerCubit(ticker: () => tickController.stream);
  });

  tearDown(() async {
    if (!restTimer.isClosed) {
      await restTimer.close();
    }
    await tickController.close();
  });

  ActiveWorkoutBloc buildBloc() {
    final bloc = ActiveWorkoutBloc(
      startSession,
      logSet,
      completeSession,
      getPlan,
      getActive,
      updateSet,
      deleteSet,
      restTimer,
    );
    bloc.add(const ActiveWorkoutConfigured(memberId: '7', workoutPlanId: '3'));
    return bloc;
  }

  test('last prescribed set uses rest between exercises', () {
    const state = ActiveWorkoutState(
      plan: WorkoutPlan(
        id: '3',
        title: 'Push',
        isTemplate: false,
        status: WorkoutPlanStatus.active,
        rowVersion: 1,
        exercises: [
          WorkoutPlanExercise(
            exerciseId: '100',
            dayNumber: 1,
            orderIndex: 0,
            targetSets: 3,
            restSeconds: 45,
            restBetweenExercisesSeconds: 120,
          ),
        ],
      ),
    );

    expect(state.restSecondsFor('100', completedSetNumber: 1), 45);
    expect(state.restSecondsFor('100', completedSetNumber: 2), 45);
    expect(state.restSecondsFor('100', completedSetNumber: 3), 120);
    expect(state.restSecondsFor('missing', completedSetNumber: 1), 60);
  });

  blocTest<ActiveWorkoutBloc, ActiveWorkoutState>(
    'starts session, logs set (starts rest), completes',
    build: () {
      when(() => startSession(any())).thenAnswer((_) async => Right(session()));
      when(() => getPlan('3')).thenAnswer((_) async => Right(plan()));
      when(() => logSet(any())).thenAnswer((_) async => Right(loggedSet()));
      when(() => completeSession(any())).thenAnswer(
        (_) async => Right(
          session(
            completedAt: DateTime.utc(2026, 1, 1, 1),
            durationMinutes: 40,
            totalVolumeKg: 500,
          ),
        ),
      );
      return buildBloc();
    },
    act: (bloc) async {
      bloc.add(const ActiveWorkoutStarted(workoutPlanId: '3'));
      await bloc.stream.firstWhere(
        (s) => s.status == LoadStatus.success && s.session != null,
      );
      bloc.add(
        const ActiveWorkoutSetLogged(
          exerciseId: '100',
          repsCompleted: 10,
          weightLiftedKg: 50,
        ),
      );
      await bloc.stream.firstWhere((s) => s.loggedSets.length == 1);
      expect(restTimer.state.isRunning, isTrue);
      expect(restTimer.state.remainingSeconds, 45);
      bloc.add(const ActiveWorkoutCompletionRequested());
      await bloc.stream.firstWhere((s) => s.completed);
    },
    expect: () => [
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.initial)
          .having((s) => s.initialPlanId, 'initialPlanId', '3'),
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.loading)
          .having((s) => s.session, 'session', isNull),
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.session?.id, 'session', 's1')
          .having((s) => s.plan?.id, 'plan', '3')
          .having((s) => s.completed, 'completed', false),
      isA<ActiveWorkoutState>().having((s) => s.logging, 'logging', true),
      isA<ActiveWorkoutState>()
          .having((s) => s.loggedSets.length, 'sets', 1)
          .having((s) => s.logging, 'logging', false)
          .having((s) => s.status, 'status', LoadStatus.success),
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.loading)
          .having((s) => s.session?.id, 'session', 's1')
          .having((s) => s.loggedSets.length, 'sets', 1),
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.completed, 'completed', true)
          .having((s) => s.session?.durationMinutes, 'duration', 40)
          .having((s) => s.session?.totalVolumeKg, 'volume', 500)
          .having((s) => s.loggedSetCount, 'loggedSetCount', 1),
    ],
    verify: (_) {
      final captured =
          verify(() => completeSession(captureAny())).captured.single
              as CompleteWorkoutSessionParams;
      expect(captured.sessionId, 's1');
      expect(captured.notes, isNull);
      expect(captured.clientFeedbackRating, isNull);
    },
  );

  blocTest<ActiveWorkoutBloc, ActiveWorkoutState>(
    'complete forwards notes and rating',
    build: () {
      when(() => startSession(any())).thenAnswer((_) async => Right(session()));
      when(() => getPlan('3')).thenAnswer((_) async => Right(plan()));
      when(() => completeSession(any())).thenAnswer((invocation) async {
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
      });
      return buildBloc();
    },
    act: (bloc) async {
      bloc.add(const ActiveWorkoutStarted(workoutPlanId: '3'));
      await bloc.stream.firstWhere(
        (s) => s.status == LoadStatus.success && s.session != null,
      );
      bloc.add(
        const ActiveWorkoutCompletionRequested(
          notes: 'Felt strong',
          clientFeedbackRating: 5,
        ),
      );
      await bloc.stream.firstWhere((s) => s.completed);
    },
    expect: () => [
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.initial)
          .having((s) => s.initialPlanId, 'initialPlanId', '3'),
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.loading)
          .having((s) => s.session, 'session', isNull),
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.completed, 'completed', false),
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.loading)
          .having((s) => s.session?.id, 'session', 's1'),
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.completed, 'completed', true)
          .having((s) => s.session?.notes, 'notes', 'Felt strong')
          .having((s) => s.session?.clientFeedbackRating, 'rating', 5)
          .having((s) => s.loggedSetCount, 'loggedSetCount', 0),
    ],
    verify: (_) {
      final captured =
          verify(() => completeSession(captureAny())).captured.single
              as CompleteWorkoutSessionParams;
      expect(captured.sessionId, 's1');
      expect(captured.notes, 'Felt strong');
      expect(captured.clientFeedbackRating, 5);
    },
  );

  blocTest<ActiveWorkoutBloc, ActiveWorkoutState>(
    'resumes active session instead of starting',
    build: () {
      final activeSession = WorkoutSession(
        id: 's1',
        memberId: '7',
        workoutPlanId: '3',
        startedAt: DateTime.utc(2026, 1, 1),
        sets: [
          loggedSet(id: 'set1', exerciseId: '100', setNumber: 1),
          loggedSet(id: 'set2', exerciseId: '100', setNumber: 2),
        ],
      );
      when(
        () => getActive(any()),
      ).thenAnswer((_) async => Right(activeSession));
      when(() => getPlan('3')).thenAnswer((_) async => Right(plan()));
      when(() => logSet(any())).thenAnswer(
        (_) async => Right(loggedSet(id: 'set3', exerciseId: '100', setNumber: 3)),
      );
      return buildBloc();
    },
    act: (bloc) async {
      bloc.add(const ActiveWorkoutStarted(workoutPlanId: 'ignored-route-id'));
      await bloc.stream.firstWhere(
        (s) => s.status == LoadStatus.success && s.session != null,
      );
      bloc.add(
        const ActiveWorkoutSetLogged(exerciseId: '100', repsCompleted: 8),
      );
      await bloc.stream.firstWhere((s) => s.loggedSets.length == 3);
    },
    verify: (_) {
      verifyNever(() => startSession(any()));
      final captured =
          verify(() => logSet(captureAny())).captured.single
              as LogWorkoutSetParams;
      expect(captured.setNumber, 3);
    },
    expect: () => [
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.initial),
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.loading)
          .having((s) => s.session, 'session', isNull),
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.resumed, 'resumed', true)
          .having((s) => s.session?.id, 'session', 's1')
          .having((s) => s.plan?.id, 'plan', '3')
          .having((s) => s.loggedSets.length, 'sets', 2),
      isA<ActiveWorkoutState>().having((s) => s.logging, 'logging', true),
      isA<ActiveWorkoutState>()
          .having((s) => s.loggedSets.length, 'sets', 3)
          .having((s) => s.logging, 'logging', false)
          .having((s) => s.status, 'status', LoadStatus.success),
    ],
  );

  blocTest<ActiveWorkoutBloc, ActiveWorkoutState>(
    'starts new session when none active',
    build: () {
      when(() => getActive(any())).thenAnswer((_) async => const Right(null));
      when(() => startSession(any())).thenAnswer((_) async => Right(session()));
      when(() => getPlan('3')).thenAnswer((_) async => Right(plan()));
      return buildBloc();
    },
    act: (bloc) async {
      bloc.add(const ActiveWorkoutStarted(workoutPlanId: '3'));
      await bloc.stream.firstWhere(
        (s) => s.status == LoadStatus.success && s.session != null,
      );
    },
    verify: (_) {
      verify(() => startSession(any())).called(1);
    },
    expect: () => [
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.initial),
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.loading)
          .having((s) => s.session, 'session', isNull),
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.resumed, 'resumed', false)
          .having((s) => s.session?.id, 'session', 's1'),
    ],
  );

  blocTest<ActiveWorkoutBloc, ActiveWorkoutState>(
    'edit replaces the set in loggedSets',
    build: () {
      when(() => startSession(any())).thenAnswer((_) async => Right(session()));
      when(() => getPlan('3')).thenAnswer((_) async => Right(plan()));
      when(() => logSet(any())).thenAnswer((_) async => Right(loggedSet()));
      when(() => updateSet(any())).thenAnswer(
        (_) async => const Right(
          WorkoutSessionSet(
            id: 'set1',
            workoutSessionId: 's1',
            exerciseId: '100',
            setNumber: 1,
            repsCompleted: 12,
            weightLiftedKg: 60,
            isCompleted: true,
          ),
        ),
      );
      return buildBloc();
    },
    act: (bloc) async {
      bloc.add(const ActiveWorkoutStarted(workoutPlanId: '3'));
      await bloc.stream.firstWhere(
        (s) => s.status == LoadStatus.success && s.session != null,
      );
      bloc.add(
        const ActiveWorkoutSetLogged(exerciseId: '100', repsCompleted: 10),
      );
      await bloc.stream.firstWhere((s) => s.loggedSets.length == 1);
      bloc.add(
        const ActiveWorkoutSetEdited(setId: 'set1', reps: 12, weightKg: 60),
      );
      await bloc.stream.firstWhere(
        (s) => s.loggedSets.any((set) => set.repsCompleted == 12),
      );
    },
    verify: (bloc) {
      expect(bloc.state.loggedSets.single.weightLiftedKg, 60);
    },
  );

  blocTest<ActiveWorkoutBloc, ActiveWorkoutState>(
    'delete removes the set from loggedSets',
    build: () {
      when(() => startSession(any())).thenAnswer((_) async => Right(session()));
      when(() => getPlan('3')).thenAnswer((_) async => Right(plan()));
      when(() => logSet(any())).thenAnswer((_) async => Right(loggedSet()));
      when(() => deleteSet(any())).thenAnswer((_) async => const Right(unit));
      return buildBloc();
    },
    act: (bloc) async {
      bloc.add(const ActiveWorkoutStarted(workoutPlanId: '3'));
      await bloc.stream.firstWhere(
        (s) => s.status == LoadStatus.success && s.session != null,
      );
      bloc.add(
        const ActiveWorkoutSetLogged(exerciseId: '100', repsCompleted: 10),
      );
      await bloc.stream.firstWhere((s) => s.loggedSets.length == 1);
      bloc.add(const ActiveWorkoutSetDeleted('set1'));
      await bloc.stream.firstWhere((s) => s.loggedSets.isEmpty);
    },
    verify: (bloc) {
      expect(bloc.state.loggedSets, isEmpty);
    },
  );

  blocTest<ActiveWorkoutBloc, ActiveWorkoutState>(
    'edit failure surfaces server message',
    build: () {
      when(() => startSession(any())).thenAnswer((_) async => Right(session()));
      when(() => getPlan('3')).thenAnswer((_) async => Right(plan()));
      when(() => logSet(any())).thenAnswer((_) async => Right(loggedSet()));
      when(() => updateSet(any())).thenAnswer(
        (_) async => const Left(
          BusinessRuleFailure(
            'Read-only: an active Personal Training subscription is required to modify this member',
          ),
        ),
      );
      return buildBloc();
    },
    act: (bloc) async {
      bloc.add(const ActiveWorkoutStarted(workoutPlanId: '3'));
      await bloc.stream.firstWhere(
        (s) => s.status == LoadStatus.success && s.session != null,
      );
      bloc.add(
        const ActiveWorkoutSetLogged(exerciseId: '100', repsCompleted: 10),
      );
      await bloc.stream.firstWhere((s) => s.loggedSets.length == 1);
      bloc.add(const ActiveWorkoutSetEdited(setId: 'set1', reps: 12));
      await bloc.stream.firstWhere((s) => s.status == LoadStatus.failure);
    },
    verify: (bloc) {
      expect(
        failureMessage(bloc.state.failure!),
        'Read-only: an active Personal Training subscription is required to modify this member',
      );
      expect(bloc.state.loggedSets.single.repsCompleted, 10);
    },
  );

  blocTest<ActiveWorkoutBloc, ActiveWorkoutState>(
    'edit/delete ignored once completed',
    build: () {
      when(() => startSession(any())).thenAnswer((_) async => Right(session()));
      when(() => getPlan('3')).thenAnswer((_) async => Right(plan()));
      when(() => completeSession(any())).thenAnswer(
        (_) async => Right(
          session(completedAt: DateTime.utc(2026, 1, 1, 1)),
        ),
      );
      return buildBloc();
    },
    act: (bloc) async {
      bloc.add(const ActiveWorkoutStarted(workoutPlanId: '3'));
      await bloc.stream.firstWhere(
        (s) => s.status == LoadStatus.success && s.session != null,
      );
      bloc.add(const ActiveWorkoutCompletionRequested());
      await bloc.stream.firstWhere((s) => s.completed);
      bloc.add(const ActiveWorkoutSetEdited(setId: 'set1', reps: 12));
      bloc.add(const ActiveWorkoutSetDeleted('set1'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    },
    verify: (_) {
      verifyNever(() => updateSet(any()));
      verifyNever(() => deleteSet(any()));
    },
  );

  blocTest<ActiveWorkoutBloc, ActiveWorkoutState>(
    'start failure',
    build: () {
      when(
        () => startSession(any()),
      ).thenAnswer((_) async => const Left(NetworkFailure()));
      return buildBloc();
    },
    act: (bloc) async {
      bloc.add(const ActiveWorkoutStarted());
      await bloc.stream.firstWhere((s) => s.status == LoadStatus.failure);
    },
    expect: () => [
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.initial)
          .having((s) => s.initialPlanId, 'initialPlanId', '3'),
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.loading)
          .having((s) => s.session, 'session', isNull),
      isA<ActiveWorkoutState>()
          .having((s) => s.status, 'status', LoadStatus.failure)
          .having((s) => s.failure, 'failure', isA<NetworkFailure>())
          .having((s) => s.session, 'session', isNull),
    ],
  );
}
