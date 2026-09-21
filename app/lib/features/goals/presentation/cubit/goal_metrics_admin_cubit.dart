import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/goal_metric_category.dart';
import '../../domain/usecases/goal_metrics_usecases.dart';

sealed class GoalMetricsAdminState extends Equatable {
  const GoalMetricsAdminState();

  @override
  List<Object?> get props => [];
}

final class GoalMetricsAdminLoading extends GoalMetricsAdminState {
  const GoalMetricsAdminLoading();
}

final class GoalMetricsAdminLoaded extends GoalMetricsAdminState {
  const GoalMetricsAdminLoaded({
    required this.items,
    this.submitting = false,
    this.error,
  });

  final List<GoalMetric> items;
  final bool submitting;
  final String? error;

  GoalMetricsAdminLoaded copyWith({
    List<GoalMetric>? items,
    bool? submitting,
    String? error,
  }) {
    return GoalMetricsAdminLoaded(
      items: items ?? this.items,
      submitting: submitting ?? this.submitting,
      error: error,
    );
  }

  @override
  List<Object?> get props => [items, submitting, error];
}

final class GoalMetricsAdminFailure extends GoalMetricsAdminState {
  const GoalMetricsAdminFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class GoalMetricsAdminCubit extends Cubit<GoalMetricsAdminState> {
  GoalMetricsAdminCubit(
    this._listMetrics,
    this._createMetric,
    this._updateMetric,
  ) : super(const GoalMetricsAdminLoading());

  final ListGoalMetricsUseCase _listMetrics;
  final CreateGoalMetricUseCase _createMetric;
  final UpdateGoalMetricUseCase _updateMetric;

  Future<void> load() async {
    emit(const GoalMetricsAdminLoading());
    final result = await _listMetrics(const NoParams());
    result.fold(
      (failure) => emit(GoalMetricsAdminFailure(failureMessage(failure))),
      (page) => emit(GoalMetricsAdminLoaded(items: page.items)),
    );
  }

  Future<bool> save({
    String? id,
    required String name,
    required String unitOfMeasure,
    required GoalMetricCategory category,
    bool isActive = true,
  }) async {
    final current = state;
    if (current is! GoalMetricsAdminLoaded) return false;
    emit(current.copyWith(submitting: true, error: null));

    final result = id == null
        ? await _createMetric(
            CreateGoalMetricParams(
              name: name,
              unitOfMeasure: unitOfMeasure,
              category: category,
              isActive: isActive,
            ),
          )
        : await _updateMetric(
            UpdateGoalMetricParams(
              id: id,
              name: name,
              unitOfMeasure: unitOfMeasure,
              category: category,
              isActive: isActive,
            ),
          );

    return result.fold(
      (failure) {
        emit(
          current.copyWith(
            submitting: false,
            error: failureMessage(failure),
          ),
        );
        return false;
      },
      (_) async {
        await load();
        return true;
      },
    );
  }
}
