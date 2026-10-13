import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/accounting_reports.dart';
import '../repositories/accounting_repository.dart';

class GetGstSummaryParams extends Equatable {
  const GetGstSummaryParams({
    required this.from,
    required this.to,
  });

  final DateTime from;
  final DateTime to;

  @override
  List<Object?> get props => [from, to];
}

@lazySingleton
class GetGstSummaryUseCase
    implements UseCase<GstSummaryReport, GetGstSummaryParams> {
  const GetGstSummaryUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, GstSummaryReport>> call(GetGstSummaryParams params) {
    return _repository.getGstSummary(
      from: params.from,
      to: params.to,
    );
  }
}
