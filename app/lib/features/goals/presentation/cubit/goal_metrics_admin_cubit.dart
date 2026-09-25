import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/goal_metric_category.dart';
import '../../domain/usecases/goal_metrics_usecases.dart';

part 'goal_metrics_admin_cubit.freezed.dart';

@freezed
abstract class GoalMetricsAdminState with _$GoalMetricsAdminState {
  const factory GoalMetricsAdminState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<GoalMetric>[]) List<GoalMetric> items,
    @Default(false) bool submitting,
    Failure? failure,
  }) = _GoalMetricsAdminState;
}

@injectable
class GoalMetricsAdminCubit extends Cubit<GoalMetricsAdminState> {
  GoalMetricsAdminCubit(
    this._listMetrics,
    this._createMetric,
    this._updateMetric,
  ) : super(const GoalMetricsAdminState());

  final ListGoalMetricsUseCase _listMetrics;
  final CreateGoalMetricUseCase _createMetric;
  final UpdateGoalMetricUseCase _updateMetric;

  bool _loaded = false;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        submitting: false,
      ),
    );
    final result = await _listMetrics(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          submitting: false,
        ),
      ),
      (page) {
        _loaded = true;
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            submitting: false,
            items: page.items,
          ),
        );
      },
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
    if (!_loaded || current.status == LoadStatus.loading || current.submitting) {
      return false;
    }
    emit(
      current.copyWith(
        submitting: true,
        failure: null,
        status: LoadStatus.success,
      ),
    );

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
            status: LoadStatus.failure,
            failure: failure,
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
