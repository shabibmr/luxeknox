import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/measurement.dart';
import '../entities/measurement_list_page.dart';
import '../repositories/measurements_repository.dart';

class ListAllMeasurementsParams extends Equatable {
  const ListAllMeasurementsParams({
    this.limit,
    this.cursor,
    this.from,
    this.to,
  });

  final int? limit;
  final String? cursor;
  final DateTime? from;
  final DateTime? to;

  @override
  List<Object?> get props => [limit, cursor, from, to];
}

@lazySingleton
class ListAllMeasurementsUseCase
    implements
        UseCase<CursorPage<MeasurementSession>, ListAllMeasurementsParams> {
  const ListAllMeasurementsUseCase(this._repository);

  final MeasurementsRepository _repository;

  @override
  Future<Either<Failure, CursorPage<MeasurementSession>>> call(
    ListAllMeasurementsParams params,
  ) {
    return _repository.listAllMeasurements(
      limit: params.limit,
      cursor: params.cursor,
      from: params.from,
      to: params.to,
    );
  }
}

class ListMeasurementsParams extends Equatable {
  const ListMeasurementsParams({
    required this.memberId,
    this.limit,
    this.cursor,
  });

  final String memberId;
  final int? limit;
  final String? cursor;

  @override
  List<Object?> get props => [memberId, limit, cursor];
}

@lazySingleton
class ListMeasurementsUseCase
    implements UseCase<MeasurementListPage, ListMeasurementsParams> {
  const ListMeasurementsUseCase(this._repository);

  final MeasurementsRepository _repository;

  @override
  Future<Either<Failure, MeasurementListPage>> call(
    ListMeasurementsParams params,
  ) {
    return _repository.listMeasurements(
      memberId: params.memberId,
      limit: params.limit,
      cursor: params.cursor,
    );
  }
}

@lazySingleton
class GetMeasurementUseCase implements UseCase<MeasurementSession, String> {
  const GetMeasurementUseCase(this._repository);

  final MeasurementsRepository _repository;

  @override
  Future<Either<Failure, MeasurementSession>> call(String id) {
    return _repository.getMeasurement(id);
  }
}

class CreateMeasurementParams extends Equatable {
  const CreateMeasurementParams({
    required this.memberId,
    this.recordedAt,
    this.notes,
    required this.values,
    this.mandatoryMetricIds = const [],
  });

  final String memberId;
  final DateTime? recordedAt;
  final String? notes;
  final List<MeasurementValueEntry> values;
  final List<String> mandatoryMetricIds;

  @override
  List<Object?> get props => [
    memberId,
    recordedAt,
    notes,
    values,
    mandatoryMetricIds,
  ];
}

@lazySingleton
class CreateMeasurementUseCase
    implements UseCase<MeasurementSession, CreateMeasurementParams> {
  const CreateMeasurementUseCase(this._repository);

  final MeasurementsRepository _repository;

  @override
  Future<Either<Failure, MeasurementSession>> call(
    CreateMeasurementParams params,
  ) {
    return _repository.createMeasurement(
      memberId: params.memberId,
      recordedAt: params.recordedAt,
      notes: params.notes,
      values: params.values,
      mandatoryMetricIds: params.mandatoryMetricIds,
    );
  }
}

class GetMeasurementChartParams extends Equatable {
  const GetMeasurementChartParams({
    required this.memberId,
    required this.metricId,
    this.from,
    this.to,
  });

  final String memberId;
  final String metricId;
  final DateTime? from;
  final DateTime? to;

  @override
  List<Object?> get props => [memberId, metricId, from, to];
}

@lazySingleton
class GetMeasurementChartUseCase
    implements UseCase<List<ChartDataPoint>, GetMeasurementChartParams> {
  const GetMeasurementChartUseCase(this._repository);

  final MeasurementsRepository _repository;

  @override
  Future<Either<Failure, List<ChartDataPoint>>> call(
    GetMeasurementChartParams params,
  ) {
    return _repository.getMeasurementChart(
      memberId: params.memberId,
      metricId: params.metricId,
      from: params.from,
      to: params.to,
    );
  }
}
