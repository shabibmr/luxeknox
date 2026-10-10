import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/measurement.dart';
import '../entities/measurement_list_page.dart';

abstract class MeasurementsRepository {
  Future<Either<Failure, CursorPage<MeasurementSession>>> listAllMeasurements({
    int? limit,
    String? cursor,
    DateTime? from,
    DateTime? to,
  });

  Future<Either<Failure, MeasurementListPage>> listMeasurements({
    required String memberId,
    int? limit,
    String? cursor,
  });

  Future<Either<Failure, MeasurementSession>> getMeasurement(String id);

  Future<Either<Failure, List<ChartDataPoint>>> getMeasurementChart({
    required String memberId,
    required String metricId,
    DateTime? from,
    DateTime? to,
  });

  Future<Either<Failure, MeasurementSession>> createMeasurement({
    required String memberId,
    DateTime? recordedAt,
    String? notes,
    required List<MeasurementValueEntry> values,
    List<String> mandatoryMetricIds = const [],
  });
}
