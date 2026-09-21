import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/diet_plan.dart';
import '../../domain/usecases/archive_diet_plan_usecase.dart';
import '../../domain/usecases/assign_diet_plan_usecase.dart';
import '../../domain/usecases/get_diet_plan_usecase.dart';
import '../../domain/usecases/publish_diet_plan_usecase.dart';

sealed class DietPlanDetailState extends Equatable {
  const DietPlanDetailState();

  @override
  List<Object?> get props => [];
}

final class DietPlanDetailLoading extends DietPlanDetailState {
  const DietPlanDetailLoading();
}

final class DietPlanDetailLoaded extends DietPlanDetailState {
  const DietPlanDetailLoaded(this.plan, {this.assignedPlan});

  final DietPlan plan;

  /// Set after a successful template assign; UI navigates then clears.
  final DietPlan? assignedPlan;

  @override
  List<Object?> get props => [plan, assignedPlan];
}

final class DietPlanDetailFailure extends DietPlanDetailState {
  const DietPlanDetailFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class DietPlanDetailActionInFlight extends DietPlanDetailState {
  const DietPlanDetailActionInFlight(this.plan);

  final DietPlan plan;

  @override
  List<Object?> get props => [plan];
}

@injectable
class DietPlanDetailCubit extends Cubit<DietPlanDetailState> {
  DietPlanDetailCubit(
    this._getPlan,
    this._publishPlan,
    this._archivePlan,
    this._assignPlan,
  ) : super(const DietPlanDetailLoading());

  final GetDietPlanUseCase _getPlan;
  final PublishDietPlanUseCase _publishPlan;
  final ArchiveDietPlanUseCase _archivePlan;
  final AssignDietPlanUseCase _assignPlan;

  String? _planId;

  Future<void> load(String planId) async {
    _planId = planId;
    emit(const DietPlanDetailLoading());
    final result = await _getPlan(planId);
    result.fold(
      (failure) => emit(DietPlanDetailFailure(failureMessage(failure))),
      (plan) => emit(DietPlanDetailLoaded(plan)),
    );
  }

  Future<void> reload() async {
    final id = _planId;
    if (id == null) return;
    await load(id);
  }

  Future<void> publish() async {
    final planId = _planId;
    final current = state;
    if (planId == null) return;
    final plan = switch (current) {
      DietPlanDetailLoaded(:final plan) => plan,
      DietPlanDetailActionInFlight(:final plan) => plan,
      _ => null,
    };
    if (plan == null) return;

    emit(DietPlanDetailActionInFlight(plan));
    final result = await _publishPlan(planId);
    result.fold(
      (failure) => emit(DietPlanDetailFailure(failureMessage(failure))),
      (updated) => emit(DietPlanDetailLoaded(updated)),
    );
  }

  Future<void> archive() async {
    final planId = _planId;
    final current = state;
    if (planId == null) return;
    final plan = switch (current) {
      DietPlanDetailLoaded(:final plan) => plan,
      DietPlanDetailActionInFlight(:final plan) => plan,
      _ => null,
    };
    if (plan == null) return;

    emit(DietPlanDetailActionInFlight(plan));
    final result = await _archivePlan(planId);
    result.fold(
      (failure) => emit(DietPlanDetailFailure(failureMessage(failure))),
      (updated) => emit(DietPlanDetailLoaded(updated)),
    );
  }

  Future<void> assignToMember(String memberId) async {
    final planId = _planId;
    final current = state;
    if (planId == null) return;
    final plan = switch (current) {
      DietPlanDetailLoaded(:final plan) => plan,
      DietPlanDetailActionInFlight(:final plan) => plan,
      _ => null,
    };
    if (plan == null) return;

    emit(DietPlanDetailActionInFlight(plan));
    final result = await _assignPlan(
      AssignDietPlanParams(planId: planId, memberId: memberId),
    );
    result.fold(
      (failure) => emit(DietPlanDetailFailure(failureMessage(failure))),
      (assigned) => emit(DietPlanDetailLoaded(plan, assignedPlan: assigned)),
    );
  }

  void clearAssignedPlan() {
    final current = state;
    if (current is DietPlanDetailLoaded && current.assignedPlan != null) {
      emit(DietPlanDetailLoaded(current.plan));
    }
  }
}
