import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/goal_status.dart';
import '../../domain/entities/member_goal.dart';
import '../../domain/usecases/goal_metrics_usecases.dart';
import '../../domain/usecases/goals_usecases.dart';

part 'goal_form_cubit.freezed.dart';

@freezed
abstract class GoalFormState with _$GoalFormState {
  const factory GoalFormState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<GoalMetric>[]) List<GoalMetric> metrics,
    MemberGoal? existing,
    @Default(false) bool submitting,
    Failure? failure,
    MemberGoal? savedGoal,
  }) = _GoalFormState;
}

@injectable
class GoalFormCubit extends Cubit<GoalFormState> {
  GoalFormCubit(
    this._listMetrics,
    this._createGoal,
    this._updateGoal,
    this._getGoal,
  ) : super(const GoalFormState());

  final ListGoalMetricsUseCase _listMetrics;
  final CreateMemberGoalUseCase _createGoal;
  final UpdateGoalUseCase _updateGoal;
  final GetGoalUseCase _getGoal;

  String? _memberId;
  String? _goalId;
  bool _formReady = false;

  Future<void> init({required String memberId, String? goalId}) async {
    _memberId = memberId;
    _goalId = goalId;
    _formReady = false;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        submitting: false,
        savedGoal: null,
      ),
    );
    final metricsResult = await _listMetrics(const NoParams());
    MemberGoal? existing;
    if (goalId != null) {
      final goalResult = await _getGoal(goalId);
      existing = goalResult.fold((_) => null, (g) => g);
    }
    metricsResult.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) {
        _formReady = true;
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            submitting: false,
            metrics: page.items.where((m) => m.isActive).toList(),
            existing: existing,
            savedGoal: null,
          ),
        );
      },
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
    if (!_formReady || current.submitting) return;
    final memberId = _memberId;
    if (memberId == null) return;
    emit(
      current.copyWith(
        submitting: true,
        failure: null,
        savedGoal: null,
        status: LoadStatus.success,
      ),
    );

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
            status: LoadStatus.failure,
            failure: failure,
            savedGoal: null,
          ),
        ),
        (goal) => emit(
          current.copyWith(
            submitting: false,
            status: LoadStatus.success,
            failure: null,
            savedGoal: goal,
          ),
        ),
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
          status: LoadStatus.failure,
          failure: failure,
          savedGoal: null,
        ),
      ),
      (goal) => emit(
        current.copyWith(
          submitting: false,
          status: LoadStatus.success,
          failure: null,
          savedGoal: goal,
        ),
      ),
    );
  }
}
