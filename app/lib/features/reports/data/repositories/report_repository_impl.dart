import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../domain/entities/app_report_type.dart';
import '../../domain/entities/report_query.dart';
import '../../domain/entities/report_result.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_datasource.dart';
import '../models/report_mappers.dart';

@LazySingleton(as: ReportRepository)
class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl(this._remote);

  final ReportRemoteDataSource _remote;

  @override
  Future<Either<Failure, ReportResult>> getReport(ReportQuery query) async {
    try {
      final model = await _remote.getReport(
        type: toApiReportType(query.type),
        from: toApiDate(query.from),
        to: toApiDate(query.to),
        productId: query.productId == null ? null : int.tryParse(query.productId!),
        trainerId: query.trainerId == null ? null : int.tryParse(query.trainerId!),
      );
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> exportCsv(ReportQuery query) async {
    try {
      final csv = await _remote.exportCsv(
        typeWire: query.type.wireName,
        from: toApiDate(query.from),
        to: toApiDate(query.to),
        productId: query.productId == null ? null : int.tryParse(query.productId!),
        trainerId: query.trainerId == null ? null : int.tryParse(query.trainerId!),
      );
      return Right(csv);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
