import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/measurement.dart';
import '../../domain/helpers/mandatory_metrics.dart';
import '../../domain/repositories/measurements_repository.dart';
import '../datasources/goals_remote_datasource.dart';
import '../models/goals_mappers.dart';

@LazySingleton(as: MeasurementsRepository)
class MeasurementsRepositoryImpl implements MeasurementsRepository {
  MeasurementsRepositoryImpl(this._remote);

  final GoalsRemoteDataSource _remote;

  int? _parseId(String id) => int.tryParse(id);

  @override
  Future<Either<Failure, CursorPage<MeasurementSession>>> listMeasurements({
    required String memberId,
    int? limit,
    String? cursor,
  }) async {
    final intId = _parseId(memberId);
    if (intId == null) {
      return const Left(ValidationFailure(['Invalid member id']));
    }
    try {
      final page = await _remote.listMeasurements(
        memberId: intId,
        limit: limit,
        cursor: cursor,
      );
      return Right(
        CursorPage(
          items: page.data.map((m) => m.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MeasurementSession>> getMeasurement(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final session = await _remote.getMeasurement(intId);
      return Right(session.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MeasurementSession>> createMeasurement({
    required String memberId,
    DateTime? recordedAt,
    String? notes,
    required List<MeasurementValueEntry> values,
    List<String> mandatoryMetricIds = const [],
  }) async {
    final intId = _parseId(memberId);
    if (intId == null) {
      return const Left(ValidationFailure(['Invalid member id']));
    }
    final missing = missingMandatoryMetrics(
      mandatoryIds: mandatoryMetricIds,
      submittedMetricIds: values.map((v) => v.metricId),
    );
    if (missing.isNotEmpty) {
      return Left(
        ValidationFailure(
          missing.map((id) => 'Missing mandatory metric: $id').toList(),
        ),
      );
    }
    try {
      final created = await _remote.createMeasurement(
        intId,
        toMeasurementWrite(
          recordedAt: recordedAt,
          notes: notes,
          values: values,
        ),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
