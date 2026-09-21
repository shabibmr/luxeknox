import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/entities/workout_plan_exercise.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/entities/workout_session_set.dart';
import '../../domain/usecases/complete_workout_session_usecase.dart';
import '../../domain/usecases/get_workout_plan_usecase.dart';
import '../../domain/usecases/log_workout_set_usecase.dart';
import '../../domain/usecases/start_workout_session_usecase.dart';
import 'rest_timer_cubit.dart';

sealed class ActiveWorkoutState extends Equatable {
  const ActiveWorkoutState();

  @override
  List<Object?> get props => [];
}

final class ActiveWorkoutIdle extends ActiveWorkoutState {
  const ActiveWorkoutIdle({this.initialPlanId, this.message});

  final String? initialPlanId;
  final String? message;

  @override
  List<Object?> get props => [initialPlanId, message];
}

final class ActiveWorkoutStarting extends ActiveWorkoutState {
  const ActiveWorkoutStarting();
}

final class ActiveWorkoutInProgress extends ActiveWorkoutState {
  const ActiveWorkoutInProgress({
    required this.session,
    required this.loggedSets,
    this.plan,
    this.selectedExerciseId,
    this.actionError,
    this.logging = false,
  });

  final WorkoutSession session;
  final List<WorkoutSessionSet> loggedSets;
  final WorkoutPlan? plan;
  final String? selectedExerciseId;
  final String? actionError;
  final bool logging;

  List<WorkoutPlanExercise> get planExercises => plan?.exercises ?? const [];

  int nextSetNumberFor(String exerciseId) {
    final count =
        loggedSets.where((s) => s.exerciseId == exerciseId).length;
    return count + 1;
  }

  int restSecondsFor(String exerciseId) {
    for (final e in planExercises) {
      if (e.exerciseId == exerciseId) {
        return e.restSeconds ?? 60;
      }
    }
    return 60;
  }

  @override
  List<Object?> get props => [
    session,
    loggedSets,
    plan,
    selectedExerciseId,
    actionError,
    logging,
  ];

  ActiveWorkoutInProgress copyWith({
    WorkoutSession? session,
    List<WorkoutSessionSet>? loggedSets,
    WorkoutPlan? plan,
    String? selectedExerciseId,
    String? actionError,
    bool clearActionError = false,
    bool? logging,
  }) {
    return ActiveWorkoutInProgress(
      session: session ?? this.session,
      loggedSets: loggedSets ?? this.loggedSets,
      plan: plan ?? this.plan,
      selectedExerciseId: selectedExerciseId ?? this.selectedExerciseId,
      actionError: clearActionError ? null : (actionError ?? this.actionError),
      logging: logging ?? this.logging,
    );
  }
}

final class ActiveWorkoutCompleting extends ActiveWorkoutState {
  const ActiveWorkoutCompleting(this.session);

  final WorkoutSession session;

  @override
  List<Object?> get props => [session];
}

final class ActiveWorkoutCompleted extends ActiveWorkoutState {
  const ActiveWorkoutCompleted(
    this.session, {
    required this.loggedSetCount,
  });

  final WorkoutSession session;
  final int loggedSetCount;

  @override
  List<Object?> get props => [session, loggedSetCount];
}

final class ActiveWorkoutFailure extends ActiveWorkoutState {
  const ActiveWorkoutFailure(this.message, {this.initialPlanId});

  final String message;
  final String? initialPlanId;

  @override
  List<Object?> get props => [message, initialPlanId];
}

class ActiveWorkoutCubit extends Cubit<ActiveWorkoutState> {
  ActiveWorkoutCubit(
    this._startSession,
    this._logSet,
    this._completeSession,
    this._getPlan,
    this.restTimer,
  ) : super(const ActiveWorkoutIdle());

  final StartWorkoutSessionUseCase _startSession;
  final LogWorkoutSetUseCase _logSet;
  final CompleteWorkoutSessionUseCase _completeSession;
  final GetWorkoutPlanUseCase _getPlan;
  final RestTimerCubit restTimer;

  String? _memberId;
  String? _initialPlanId;

  void configure({required String memberId, String? workoutPlanId}) {
    _memberId = memberId;
    _initialPlanId = workoutPlanId;
    emit(ActiveWorkoutIdle(initialPlanId: workoutPlanId));
  }

  Future<void> start({String? workoutPlanId}) async {
    final memberId = _memberId;
    if (memberId == null) {
      emit(const ActiveWorkoutFailure('Missing member id'));
      return;
    }
    final planId = (workoutPlanId ?? _initialPlanId)?.trim();
    final resolvedPlanId =
        (planId == null || planId.isEmpty) ? null : planId;

    emit(const ActiveWorkoutStarting());
    final result = await _startSession(
      StartWorkoutSessionParams(
        memberId: memberId,
        workoutPlanId: resolvedPlanId,
      ),
    );

    await result.fold(
      (failure) async {
        emit(
          ActiveWorkoutFailure(
            failureMessage(failure),
            initialPlanId: resolvedPlanId,
          ),
        );
      },
      (session) async {
        WorkoutPlan? plan;
        if (resolvedPlanId != null) {
          final planResult = await _getPlan(resolvedPlanId);
          plan = planResult.fold((_) => null, (p) => p);
        }
        final firstExerciseId = plan?.exercises.isNotEmpty == true
            ? plan!.exercises.first.exerciseId
            : null;
        emit(
          ActiveWorkoutInProgress(
            session: session,
            loggedSets: List.of(session.sets),
            plan: plan,
            selectedExerciseId: firstExerciseId,
          ),
        );
      },
    );
  }

  void selectExercise(String exerciseId) {
    final current = state;
    if (current is! ActiveWorkoutInProgress) return;
    emit(current.copyWith(selectedExerciseId: exerciseId, clearActionError: true));
  }

  Future<void> logSet({
    required String exerciseId,
    int? repsCompleted,
    num? weightLiftedKg,
    num? rpeScore,
  }) async {
    final current = state;
    if (current is! ActiveWorkoutInProgress || current.logging) return;

    final setNumber = current.nextSetNumberFor(exerciseId);
    emit(current.copyWith(logging: true, clearActionError: true));

    final result = await _logSet(
      LogWorkoutSetParams(
        sessionId: current.session.id,
        exerciseId: exerciseId,
        setNumber: setNumber,
        repsCompleted: repsCompleted,
        weightLiftedKg: weightLiftedKg,
        rpeScore: rpeScore,
      ),
    );

    result.fold(
      (failure) {
        emit(
          current.copyWith(
            logging: false,
            actionError: failureMessage(failure),
          ),
        );
      },
      (logged) {
        final updated = List<WorkoutSessionSet>.of(current.loggedSets)
          ..add(logged);
        emit(
          current.copyWith(
            loggedSets: updated,
            logging: false,
            clearActionError: true,
          ),
        );
        restTimer.start(current.restSecondsFor(exerciseId));
      },
    );
  }

  Future<void> complete({
    String? notes,
    int? clientFeedbackRating,
  }) async {
    final current = state;
    if (current is! ActiveWorkoutInProgress) return;

    emit(ActiveWorkoutCompleting(current.session));
    final result = await _completeSession(
      CompleteWorkoutSessionParams(
        sessionId: current.session.id,
        notes: notes,
        clientFeedbackRating: clientFeedbackRating,
      ),
    );
    result.fold(
      (failure) {
        emit(
          current.copyWith(
            actionError: failureMessage(failure),
            logging: false,
          ),
        );
      },
      (session) {
        restTimer.cancel();
        emit(
          ActiveWorkoutCompleted(
            session,
            loggedSetCount: current.loggedSets.length,
          ),
        );
      },
    );
  }

  void resetToIdle() {
    restTimer.cancel();
    emit(ActiveWorkoutIdle(initialPlanId: _initialPlanId));
  }
}
