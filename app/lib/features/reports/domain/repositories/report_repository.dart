import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/report_query.dart';
import '../entities/report_result.dart';

abstract class ReportRepository {
  Future<Either<Failure, ReportResult>> getReport(ReportQuery query);

  /// CSV body for [ReportExportFormat.csv]. Server may return text/csv.
  Future<Either<Failure, String>> exportCsv(ReportQuery query);
}
