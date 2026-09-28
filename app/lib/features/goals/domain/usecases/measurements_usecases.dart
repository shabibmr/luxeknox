import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/measurement.dart';
import '../repositories/measurements_repository.dart';

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
    implements UseCase<CursorPage<MeasurementSession>, ListMeasurementsParams> {
  const ListMeasurementsUseCase(this._repository);

  final MeasurementsRepository _repository;

  @override
  Future<Either<Failure, CursorPage<MeasurementSession>>> call(
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
