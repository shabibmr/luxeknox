import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/usecases/archive_workout_plan_usecase.dart';
import '../../domain/usecases/get_workout_plan_usecase.dart';
import '../../domain/usecases/publish_workout_plan_usecase.dart';

sealed class WorkoutPlanDetailState extends Equatable {
  const WorkoutPlanDetailState();

  @override
  List<Object?> get props => [];
}

final class WorkoutPlanDetailLoading extends WorkoutPlanDetailState {
  const WorkoutPlanDetailLoading();
}

final class WorkoutPlanDetailLoaded extends WorkoutPlanDetailState {
  const WorkoutPlanDetailLoaded(this.plan);

  final WorkoutPlan plan;

  @override
  List<Object?> get props => [plan];
}

final class WorkoutPlanDetailFailure extends WorkoutPlanDetailState {
  const WorkoutPlanDetailFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class WorkoutPlanDetailActionInFlight extends WorkoutPlanDetailState {
  const WorkoutPlanDetailActionInFlight(this.plan);

  final WorkoutPlan plan;

  @override
  List<Object?> get props => [plan];
}

@injectable
class WorkoutPlanDetailCubit extends Cubit<WorkoutPlanDetailState> {
  WorkoutPlanDetailCubit(
    this._getPlan,
    this._publishPlan,
    this._archivePlan,
  ) : super(const WorkoutPlanDetailLoading());

  final GetWorkoutPlanUseCase _getPlan;
  final PublishWorkoutPlanUseCase _publishPlan;
  final ArchiveWorkoutPlanUseCase _archivePlan;

  String? _planId;

  Future<void> load(String planId) async {
    _planId = planId;
    emit(const WorkoutPlanDetailLoading());
    final result = await _getPlan(planId);
    result.fold(
      (failure) => emit(WorkoutPlanDetailFailure(failureMessage(failure))),
      (plan) => emit(WorkoutPlanDetailLoaded(plan)),
    );
  }

  Future<void> publish() async {
    final planId = _planId;
    final current = state;
    if (planId == null) return;
    final plan = switch (current) {
      WorkoutPlanDetailLoaded(:final plan) => plan,
      WorkoutPlanDetailActionInFlight(:final plan) => plan,
      _ => null,
    };
    if (plan == null) return;

    emit(WorkoutPlanDetailActionInFlight(plan));
    final result = await _publishPlan(planId);
    result.fold(
      (failure) => emit(WorkoutPlanDetailFailure(failureMessage(failure))),
      (updated) => emit(WorkoutPlanDetailLoaded(updated)),
    );
  }

  Future<void> archive() async {
    final planId = _planId;
    final current = state;
    if (planId == null) return;
    final plan = switch (current) {
      WorkoutPlanDetailLoaded(:final plan) => plan,
      WorkoutPlanDetailActionInFlight(:final plan) => plan,
      _ => null,
    };
    if (plan == null) return;

    emit(WorkoutPlanDetailActionInFlight(plan));
    final result = await _archivePlan(planId);
    result.fold(
      (failure) => emit(WorkoutPlanDetailFailure(failureMessage(failure))),
      (updated) => emit(WorkoutPlanDetailLoaded(updated)),
    );
  }
}
