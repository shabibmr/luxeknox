import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/measurement.dart';
import '../../domain/usecases/goal_metrics_usecases.dart';
import '../../domain/usecases/measurements_usecases.dart';

sealed class MeasurementsState extends Equatable {
  const MeasurementsState();

  @override
  List<Object?> get props => [];
}

final class MeasurementsLoading extends MeasurementsState {
  const MeasurementsLoading();
}

final class MeasurementsLoaded extends MeasurementsState {
  const MeasurementsLoaded({
    required this.sessions,
    required this.metrics,
    this.submitting = false,
    this.error,
    this.hasMore = false,
    this.nextCursor,
  });

  final List<MeasurementSession> sessions;
  final List<GoalMetric> metrics;
  final bool submitting;
  final String? error;
  final bool hasMore;
  final String? nextCursor;

  MeasurementsLoaded copyWith({
    List<MeasurementSession>? sessions,
    List<GoalMetric>? metrics,
    bool? submitting,
    String? error,
    bool? hasMore,
    String? nextCursor,
  }) {
    return MeasurementsLoaded(
      sessions: sessions ?? this.sessions,
      metrics: metrics ?? this.metrics,
      submitting: submitting ?? this.submitting,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }

  @override
  List<Object?> get props => [
    sessions,
    metrics,
    submitting,
    error,
    hasMore,
    nextCursor,
  ];
}

final class MeasurementsFailure extends MeasurementsState {
  const MeasurementsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class MeasurementsCubit extends Cubit<MeasurementsState> {
  MeasurementsCubit(this._listMeasurements, this._createMeasurement, this._listMetrics)
    : super(const MeasurementsLoading());

  final ListMeasurementsUseCase _listMeasurements;
  final CreateMeasurementUseCase _createMeasurement;
  final ListGoalMetricsUseCase _listMetrics;

  String? _memberId;
  List<String> _mandatoryMetricIds = const [];

  Future<void> load(
    String memberId, {
    List<String> mandatoryMetricIds = const [],
  }) async {
    _memberId = memberId;
    _mandatoryMetricIds = mandatoryMetricIds;
    emit(const MeasurementsLoading());

    final metricsResult = await _listMetrics(const NoParams());
    final sessionsResult = await _listMeasurements(
      ListMeasurementsParams(memberId: memberId, limit: 50),
    );

    final metrics = metricsResult.fold(
      (_) => <GoalMetric>[],
      (page) => page.items.where((m) => m.isActive).toList(),
    );

    sessionsResult.fold(
      (failure) => emit(MeasurementsFailure(failureMessage(failure))),
      (page) => emit(
        MeasurementsLoaded(
          sessions: page.items,
          metrics: metrics,
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  Future<bool> create({
    DateTime? recordedAt,
    String? notes,
    required List<MeasurementValueEntry> values,
  }) async {
    final memberId = _memberId;
    final current = state;
    if (memberId == null || current is! MeasurementsLoaded) return false;
    emit(current.copyWith(submitting: true, error: null));
    final result = await _createMeasurement(
      CreateMeasurementParams(
        memberId: memberId,
        recordedAt: recordedAt,
        notes: notes,
        values: values,
        mandatoryMetricIds: _mandatoryMetricIds,
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
        await load(memberId, mandatoryMetricIds: _mandatoryMetricIds);
        return true;
      },
    );
  }
}
