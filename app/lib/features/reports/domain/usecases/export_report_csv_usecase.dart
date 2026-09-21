import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/report_query.dart';
import '../repositories/report_repository.dart';

@lazySingleton
class ExportReportCsvUseCase implements UseCase<String, ReportQuery> {
  const ExportReportCsvUseCase(this._repository);

  final ReportRepository _repository;

  @override
  Future<Either<Failure, String>> call(ReportQuery params) {
    return _repository.exportCsv(
      params.copyWith(format: ReportExportFormat.csv),
    );
  }
}
