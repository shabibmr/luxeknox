import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/diet_plan.dart';
import '../../domain/usecases/archive_diet_plan_usecase.dart';
import '../../domain/usecases/assign_diet_plan_usecase.dart';
import '../../domain/usecases/get_diet_plan_usecase.dart';
import '../../domain/usecases/publish_diet_plan_usecase.dart';

part 'diet_plan_detail_cubit.freezed.dart';

@freezed
abstract class DietPlanDetailState with _$DietPlanDetailState {
  const factory DietPlanDetailState({
    @Default(LoadStatus.initial) LoadStatus status,
    DietPlan? plan,
    DietPlan? assignedPlan,
    @Default(false) bool actionInFlight,
    Failure? failure,
  }) = _DietPlanDetailState;
}

@injectable
class DietPlanDetailCubit extends Cubit<DietPlanDetailState> {
  DietPlanDetailCubit(
    this._getPlan,
    this._publishPlan,
    this._archivePlan,
    this._assignPlan,
  ) : super(const DietPlanDetailState());

  final GetDietPlanUseCase _getPlan;
  final PublishDietPlanUseCase _publishPlan;
  final ArchiveDietPlanUseCase _archivePlan;
  final AssignDietPlanUseCase _assignPlan;

  String? _planId;

  Future<void> load(String planId) async {
    _planId = planId;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        actionInFlight: false,
        assignedPlan: null,
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
          actionInFlight: false,
          plan: plan,
          assignedPlan: null,
        ),
      ),
    );
  }

  Future<void> reload() async {
    final id = _planId;
    if (id == null) return;
    await load(id);
  }

  Future<void> publish() async {
    final planId = _planId;
    if (planId == null || state.plan == null) return;

    emit(
      state.copyWith(
        actionInFlight: true,
        failure: null,
        assignedPlan: null,
      ),
    );
    final result = await _publishPlan(planId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          actionInFlight: false,
          assignedPlan: null,
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
    if (planId == null || state.plan == null) return;

    emit(
      state.copyWith(
        actionInFlight: true,
        failure: null,
        assignedPlan: null,
      ),
    );
    final result = await _archivePlan(planId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          actionInFlight: false,
          assignedPlan: null,
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
    if (planId == null || plan == null) return;

    emit(
      state.copyWith(
        actionInFlight: true,
        failure: null,
        assignedPlan: null,
      ),
    );
    final result = await _assignPlan(
      AssignDietPlanParams(planId: planId, memberId: memberId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          actionInFlight: false,
          assignedPlan: null,
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
