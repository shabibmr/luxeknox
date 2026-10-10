import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/measurement.dart';
import '../../domain/usecases/goal_metrics_usecases.dart';
import '../../domain/usecases/measurements_usecases.dart';

part 'measurements_cubit.freezed.dart';

@freezed
abstract class MeasurementsState with _$MeasurementsState {
  const factory MeasurementsState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<MeasurementSession>[]) List<MeasurementSession> sessions,
    @Default(<GoalMetric>[]) List<GoalMetric> metrics,
    @Default(<String>[]) List<String> mandatoryMetricIds,
    @Default(false) bool submitting,
    @Default(false) bool hasMore,
    @Default(false) bool loadingMore,
    String? nextCursor,
    Failure? failure,
  }) = _MeasurementsState;
}

@injectable
class MeasurementsCubit extends Cubit<MeasurementsState> {
  MeasurementsCubit(
    this._listMeasurements,
    this._createMeasurement,
    this._listMetrics,
  ) : super(const MeasurementsState());

  final ListMeasurementsUseCase _listMeasurements;
  final CreateMeasurementUseCase _createMeasurement;
  final ListGoalMetricsUseCase _listMetrics;

  String? _memberId;
  bool _loaded = false;

  Future<void> load(String memberId) async {
    _memberId = memberId;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        submitting: false,
      ),
    );

    final metricsResult = await _listMetrics(const ListGoalMetricsParams());
    final sessionsResult = await _listMeasurements(
      ListMeasurementsParams(memberId: memberId, limit: 50),
    );

    final loadedMetrics = metricsResult.fold<List<GoalMetric>?>(
      (_) => null,
      (page) => page.items.where((m) => m.isActive).toList(),
    );

    sessionsResult.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          submitting: false,
          metrics: loadedMetrics ?? state.metrics,
        ),
      ),
      (page) {
        _loaded = true;
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            submitting: false,
            sessions: page.items,
            metrics: loadedMetrics ?? state.metrics,
            mandatoryMetricIds: page.mandatoryMetricIds,
            hasMore: page.hasMore,
            nextCursor: page.nextCursor,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    final memberId = _memberId;
    if (memberId == null ||
        !_loaded ||
        !state.hasMore ||
        state.nextCursor == null ||
        state.loadingMore) {
      return;
    }
    emit(state.copyWith(loadingMore: true));
    final sessionsResult = await _listMeasurements(
      ListMeasurementsParams(
        memberId: memberId,
        cursor: state.nextCursor,
        limit: 50,
      ),
    );
    sessionsResult.fold(
      (failure) => emit(state.copyWith(loadingMore: false, failure: failure)),
      (page) {
        emit(
          state.copyWith(
            loadingMore: false,
            sessions: [...state.sessions, ...page.items],
            hasMore: page.hasMore,
            nextCursor: page.nextCursor,
          ),
        );
      },
    );
  }

  Future<bool> create({
    DateTime? recordedAt,
    String? notes,
    required List<MeasurementValueEntry> values,
  }) async {
    final memberId = _memberId;
    final current = state;
    if (memberId == null ||
        !_loaded ||
        current.status == LoadStatus.loading ||
        current.submitting) {
      return false;
    }
    emit(
      current.copyWith(
        submitting: true,
        failure: null,
        status: LoadStatus.success,
      ),
    );
    final result = await _createMeasurement(
      CreateMeasurementParams(
        memberId: memberId,
        recordedAt: recordedAt,
        notes: notes,
        values: values,
        mandatoryMetricIds: current.mandatoryMetricIds,
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
        await load(memberId);
        return true;
      },
    );
  }
}
