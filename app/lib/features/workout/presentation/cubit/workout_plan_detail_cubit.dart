import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/usecases/archive_workout_plan_usecase.dart';
import '../../domain/usecases/assign_workout_plan_usecase.dart';
import '../../domain/usecases/get_workout_plan_usecase.dart';
import '../../domain/usecases/publish_workout_plan_usecase.dart';

part 'workout_plan_detail_cubit.freezed.dart';

@freezed
abstract class WorkoutPlanDetailState with _$WorkoutPlanDetailState {
  const factory WorkoutPlanDetailState({
    @Default(LoadStatus.initial) LoadStatus status,
    WorkoutPlan? plan,
    /// Set after a successful template assign; UI navigates then clears.
    WorkoutPlan? assignedPlan,
    @Default(false) bool actionInFlight,
    Failure? failure,
  }) = _WorkoutPlanDetailState;
}

@injectable
class WorkoutPlanDetailCubit extends Cubit<WorkoutPlanDetailState> {
  WorkoutPlanDetailCubit(
    this._getPlan,
    this._publishPlan,
    this._archivePlan,
    this._assignPlan,
  ) : super(const WorkoutPlanDetailState());

  final GetWorkoutPlanUseCase _getPlan;
  final PublishWorkoutPlanUseCase _publishPlan;
  final ArchiveWorkoutPlanUseCase _archivePlan;
  final AssignWorkoutPlanUseCase _assignPlan;

  String? _planId;

  Future<void> load(String planId) async {
    _planId = planId;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        assignedPlan: null,
        actionInFlight: false,
      ),
    );
    final result = await _getPlan(planId);
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (plan) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          plan: plan,
          actionInFlight: false,
        ),
      ),
    );
  }

  Future<void> publish() async {
    final planId = _planId;
    final plan = state.plan;
    if (planId == null || plan == null || state.actionInFlight) return;
    if (state.status == LoadStatus.loading) return;

    emit(state.copyWith(actionInFlight: true, failure: null));
    final result = await _publishPlan(planId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          actionInFlight: false,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          actionInFlight: false,
          plan: updated,
          assignedPlan: null,
        ),
      ),
    );
  }

  Future<void> archive() async {
    final planId = _planId;
    final plan = state.plan;
    if (planId == null || plan == null || state.actionInFlight) return;
    if (state.status == LoadStatus.loading) return;

    emit(state.copyWith(actionInFlight: true, failure: null));
    final result = await _archivePlan(planId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          actionInFlight: false,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          actionInFlight: false,
          plan: updated,
          assignedPlan: null,
        ),
      ),
    );
  }

  Future<void> assignToMember(String memberId) async {
    final planId = _planId;
    final plan = state.plan;
    if (planId == null || plan == null || state.actionInFlight) return;
    if (state.status == LoadStatus.loading) return;

    emit(state.copyWith(actionInFlight: true, failure: null));
    final result = await _assignPlan(
      AssignWorkoutPlanParams(planId: planId, memberId: memberId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          actionInFlight: false,
        ),
      ),
      (assigned) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          actionInFlight: false,
          plan: plan,
          assignedPlan: assigned,
        ),
      ),
    );
  }

  void clearAssignedPlan() {
    if (state.assignedPlan != null) {
      emit(state.copyWith(assignedPlan: null));
    }
  }
}
