import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/bloc/event_transformers.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/entities/workout_plan_exercise.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/entities/workout_session_set.dart';
import '../../domain/usecases/complete_workout_session_usecase.dart';
import '../../domain/usecases/get_workout_plan_usecase.dart';
import '../../domain/usecases/log_workout_set_usecase.dart';
import '../../domain/usecases/start_workout_session_usecase.dart';
import '../cubit/rest_timer_cubit.dart';

part 'active_workout_bloc.freezed.dart';

sealed class ActiveWorkoutEvent extends Equatable {
  const ActiveWorkoutEvent();

  @override
  List<Object?> get props => [];
}

final class ActiveWorkoutConfigured extends ActiveWorkoutEvent {
  const ActiveWorkoutConfigured({required this.memberId, this.workoutPlanId});

  final String memberId;
  final String? workoutPlanId;

  @override
  List<Object?> get props => [memberId, workoutPlanId];
}

final class ActiveWorkoutStarted extends ActiveWorkoutEvent {
  const ActiveWorkoutStarted({this.workoutPlanId});

  final String? workoutPlanId;

  @override
  List<Object?> get props => [workoutPlanId];
}

final class ActiveWorkoutExerciseSelected extends ActiveWorkoutEvent {
  const ActiveWorkoutExerciseSelected(this.exerciseId);

  final String exerciseId;

  @override
  List<Object?> get props => [exerciseId];
}

final class ActiveWorkoutSetLogged extends ActiveWorkoutEvent {
  const ActiveWorkoutSetLogged({
    required this.exerciseId,
    this.repsCompleted,
    this.weightLiftedKg,
    this.rpeScore,
  });

  final String exerciseId;
  final int? repsCompleted;
  final num? weightLiftedKg;
  final num? rpeScore;

  @override
  List<Object?> get props => [
    exerciseId,
    repsCompleted,
    weightLiftedKg,
    rpeScore,
  ];
}

final class ActiveWorkoutCompletionRequested extends ActiveWorkoutEvent {
  const ActiveWorkoutCompletionRequested({
    this.notes,
    this.clientFeedbackRating,
  });

  final String? notes;
  final int? clientFeedbackRating;

  @override
  List<Object?> get props => [notes, clientFeedbackRating];
}

final class ActiveWorkoutReset extends ActiveWorkoutEvent {
  const ActiveWorkoutReset();
}

@freezed
abstract class ActiveWorkoutState with _$ActiveWorkoutState {
  const ActiveWorkoutState._();

  const factory ActiveWorkoutState({
    @Default(LoadStatus.initial) LoadStatus status,
    WorkoutSession? session,
    @Default(<WorkoutSessionSet>[]) List<WorkoutSessionSet> loggedSets,
    WorkoutPlan? plan,
    String? selectedExerciseId,
    String? initialPlanId,
    /// Non-failure text such as a missing member id. API errors use [failure].
    String? message,
    Failure? failure,
    @Default(false) bool logging,
    @Default(false) bool completed,
    int? loggedSetCount,
  }) = _ActiveWorkoutState;

  List<WorkoutPlanExercise> get planExercises => plan?.exercises ?? const [];

  int nextSetNumberFor(String exerciseId) {
    final count = loggedSets.where((s) => s.exerciseId == exerciseId).length;
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
}

@injectable
class ActiveWorkoutBloc extends Bloc<ActiveWorkoutEvent, ActiveWorkoutState> {
  ActiveWorkoutBloc(
    this._startSession,
    this._logSet,
    this._completeSession,
    this._getPlan,
    this.restTimer,
  ) : super(const ActiveWorkoutState()) {
    on<ActiveWorkoutConfigured>(_onConfigured);
    on<ActiveWorkoutStarted>(_onStarted);
    on<ActiveWorkoutExerciseSelected>(_onExerciseSelected);
    on<ActiveWorkoutSetLogged>(_onSetLogged, transformer: sequential());
    on<ActiveWorkoutCompletionRequested>(_onComplete);
    on<ActiveWorkoutReset>(_onReset);
  }

  final StartWorkoutSessionUseCase _startSession;
  final LogWorkoutSetUseCase _logSet;
  final CompleteWorkoutSessionUseCase _completeSession;
  final GetWorkoutPlanUseCase _getPlan;
  final RestTimerCubit restTimer;

  String? _memberId;
  String? _initialPlanId;

  void _onConfigured(
    ActiveWorkoutConfigured event,
    Emitter<ActiveWorkoutState> emit,
  ) {
    _memberId = event.memberId;
    _initialPlanId = event.workoutPlanId;
    emit(
      state.copyWith(
        status: LoadStatus.initial,
        initialPlanId: event.workoutPlanId,
        session: null,
        loggedSets: const [],
        plan: null,
        selectedExerciseId: null,
        message: null,
        failure: null,
        logging: false,
        completed: false,
        loggedSetCount: null,
      ),
    );
  }

  Future<void> _onStarted(
    ActiveWorkoutStarted event,
    Emitter<ActiveWorkoutState> emit,
  ) async {
    final memberId = _memberId;
    if (memberId == null) {
      emit(
        state.copyWith(
          status: LoadStatus.failure,
          message: 'Missing member id',
          failure: null,
          session: null,
        ),
      );
      return;
    }
    final planId = (event.workoutPlanId ?? _initialPlanId)?.trim();
    final resolvedPlanId = (planId == null || planId.isEmpty) ? null : planId;

    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        message: null,
        session: null,
        loggedSets: const [],
        plan: null,
        selectedExerciseId: null,
        logging: false,
        completed: false,
        loggedSetCount: null,
        initialPlanId: resolvedPlanId,
      ),
    );
    final result = await _startSession(
      StartWorkoutSessionParams(
        memberId: memberId,
        workoutPlanId: resolvedPlanId,
      ),
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: LoadStatus.failure,
            failure: failure,
            message: null,
            session: null,
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
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            message: null,
            session: session,
            loggedSets: List.of(session.sets),
            plan: plan,
            selectedExerciseId: firstExerciseId,
            logging: false,
            completed: false,
            loggedSetCount: null,
            initialPlanId: resolvedPlanId,
          ),
        );
      },
    );
  }

  void _onExerciseSelected(
    ActiveWorkoutExerciseSelected event,
    Emitter<ActiveWorkoutState> emit,
  ) {
    if (state.session == null || state.completed) return;
    if (state.status == LoadStatus.loading) return;
    emit(
      state.copyWith(
        selectedExerciseId: event.exerciseId,
        failure: null,
        message: null,
        status: LoadStatus.success,
      ),
    );
  }

  Future<void> _onSetLogged(
    ActiveWorkoutSetLogged event,
    Emitter<ActiveWorkoutState> emit,
  ) async {
    final current = state;
    if (current.session == null || current.completed) return;
    if (current.status == LoadStatus.loading) return;

    final setNumber = current.nextSetNumberFor(event.exerciseId);
    final sessionId = current.session!.id;
    final restSeconds = current.restSecondsFor(event.exerciseId);
    emit(state.copyWith(logging: true, failure: null, message: null));

    final result = await _logSet(
      LogWorkoutSetParams(
        sessionId: sessionId,
        exerciseId: event.exerciseId,
        setNumber: setNumber,
        repsCompleted: event.repsCompleted,
        weightLiftedKg: event.weightLiftedKg,
        rpeScore: event.rpeScore,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            logging: false,
            status: LoadStatus.failure,
            failure: failure,
            message: null,
          ),
        );
      },
      (logged) {
        emit(
          state.copyWith(
            status: LoadStatus.success,
            logging: false,
            failure: null,
            message: null,
            loggedSets: [...state.loggedSets, logged],
          ),
        );
        restTimer.start(restSeconds);
      },
    );
  }

  Future<void> _onComplete(
    ActiveWorkoutCompletionRequested event,
    Emitter<ActiveWorkoutState> emit,
  ) async {
    final current = state;
    if (current.session == null || current.completed) return;
    if (current.status == LoadStatus.loading) return;

    final loggedSetCount = current.loggedSets.length;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        message: null,
        logging: false,
      ),
    );
    final result = await _completeSession(
      CompleteWorkoutSessionParams(
        sessionId: current.session!.id,
        notes: event.notes,
        clientFeedbackRating: event.clientFeedbackRating,
      ),
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: LoadStatus.failure,
            failure: failure,
            message: null,
            logging: false,
          ),
        );
      },
      (session) {
        restTimer.cancel();
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            message: null,
            session: session,
            completed: true,
            loggedSetCount: loggedSetCount,
            logging: false,
          ),
        );
      },
    );
  }

  void _onReset(ActiveWorkoutReset event, Emitter<ActiveWorkoutState> emit) {
    restTimer.cancel();
    emit(ActiveWorkoutState(initialPlanId: _initialPlanId));
  }

  @override
  Future<void> close() async {
    if (!restTimer.isClosed) {
      await restTimer.close();
    }
    return super.close();
  }
}
