import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/accounting_period.dart';
import '../repositories/accounting_repository.dart';

class GetAccountingPeriodsParams extends Equatable {
  const GetAccountingPeriodsParams({
    this.fiscalYearId,
    this.status,
  });

  final String? fiscalYearId;
  final String? status;

  @override
  List<Object?> get props => [fiscalYearId, status];
}

@lazySingleton
class GetAccountingPeriodsUseCase
    implements UseCase<List<AccountingPeriod>, GetAccountingPeriodsParams> {
  const GetAccountingPeriodsUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, List<AccountingPeriod>>> call(
    GetAccountingPeriodsParams params,
  ) {
    return _repository.getAccountingPeriods(
      fiscalYearId: params.fiscalYearId,
      status: params.status,
    );
  }
}
