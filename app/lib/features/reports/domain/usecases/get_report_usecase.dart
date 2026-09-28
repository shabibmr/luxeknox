import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/report_query.dart';
import '../entities/report_result.dart';
import '../repositories/report_repository.dart';

@lazySingleton
class GetReportUseCase implements UseCase<ReportResult, ReportQuery> {
  const GetReportUseCase(this._repository);

  final ReportRepository _repository;

  @override
  Future<Either<Failure, ReportResult>> call(ReportQuery params) {
    return _repository.getReport(
      params.copyWith(format: ReportExportFormat.json),
    );
  }
}
