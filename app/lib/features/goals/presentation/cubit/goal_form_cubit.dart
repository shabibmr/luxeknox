import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/goal_status.dart';
import '../../domain/entities/member_goal.dart';
import '../../domain/usecases/goal_metrics_usecases.dart';
import '../../domain/usecases/goals_usecases.dart';
import '../../../../core/usecase/usecase.dart';

sealed class GoalFormState extends Equatable {
  const GoalFormState();

  @override
  List<Object?> get props => [];
}

final class GoalFormLoading extends GoalFormState {
  const GoalFormLoading();
}

final class GoalFormReady extends GoalFormState {
  const GoalFormReady({
    required this.metrics,
    this.existing,
    this.submitting = false,
    this.error,
  });

  final List<GoalMetric> metrics;
  final MemberGoal? existing;
  final bool submitting;
  final String? error;

  GoalFormReady copyWith({
    List<GoalMetric>? metrics,
    MemberGoal? existing,
    bool? submitting,
    String? error,
  }) {
    return GoalFormReady(
      metrics: metrics ?? this.metrics,
      existing: existing ?? this.existing,
      submitting: submitting ?? this.submitting,
      error: error,
    );
  }

  @override
  List<Object?> get props => [metrics, existing, submitting, error];
}

final class GoalFormFailure extends GoalFormState {
  const GoalFormFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class GoalFormSaved extends GoalFormState {
  const GoalFormSaved(this.goal);

  final MemberGoal goal;

  @override
  List<Object?> get props => [goal];
}

@injectable
class GoalFormCubit extends Cubit<GoalFormState> {
  GoalFormCubit(
    this._listMetrics,
    this._createGoal,
    this._updateGoal,
    this._getGoal,
  ) : super(const GoalFormLoading());

  final ListGoalMetricsUseCase _listMetrics;
  final CreateMemberGoalUseCase _createGoal;
  final UpdateGoalUseCase _updateGoal;
  final GetGoalUseCase _getGoal;

  String? _memberId;
  String? _goalId;

  Future<void> init({required String memberId, String? goalId}) async {
    _memberId = memberId;
    _goalId = goalId;
    emit(const GoalFormLoading());
    final metricsResult = await _listMetrics(const NoParams());
    MemberGoal? existing;
    if (goalId != null) {
      final goalResult = await _getGoal(goalId);
      existing = goalResult.fold((_) => null, (g) => g);
    }
    metricsResult.fold(
      (failure) => emit(GoalFormFailure(failureMessage(failure))),
      (page) => emit(
        GoalFormReady(
          metrics: page.items.where((m) => m.isActive).toList(),
          existing: existing,
        ),
      ),
    );
  }

  Future<void> submit({
    required String metricId,
    num? baselineValue,
    num? targetValue,
    DateTime? startDate,
    DateTime? targetDate,
    GoalStatus? status,
  }) async {
    final current = state;
    if (current is! GoalFormReady) return;
    final memberId = _memberId;
    if (memberId == null) return;
    emit(current.copyWith(submitting: true, error: null));

    if (_goalId != null) {
      final result = await _updateGoal(
        UpdateGoalParams(
          id: _goalId!,
          metricId: metricId,
          baselineValue: baselineValue,
          targetValue: targetValue,
          startDate: startDate,
          targetDate: targetDate,
          status: status,
        ),
      );
      result.fold(
        (failure) => emit(
          current.copyWith(
            submitting: false,
            error: failureMessage(failure),
          ),
        ),
        (goal) => emit(GoalFormSaved(goal)),
      );
      return;
    }

    final result = await _createGoal(
      CreateMemberGoalParams(
        memberId: memberId,
        metricId: metricId,
        baselineValue: baselineValue,
        targetValue: targetValue,
        startDate: startDate,
        targetDate: targetDate,
        status: status ?? GoalStatus.inProgress,
      ),
    );
    result.fold(
      (failure) => emit(
        current.copyWith(
          submitting: false,
          error: failureMessage(failure),
        ),
      ),
      (goal) => emit(GoalFormSaved(goal)),
    );
  }
}
