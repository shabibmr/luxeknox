import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/accounting_period.dart';
import '../repositories/accounting_repository.dart';

class LockAccountingPeriodParams extends Equatable {
  const LockAccountingPeriodParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

@lazySingleton
class LockAccountingPeriodUseCase
    implements UseCase<AccountingPeriod, LockAccountingPeriodParams> {
  const LockAccountingPeriodUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, AccountingPeriod>> call(
    LockAccountingPeriodParams params,
  ) {
    return _repository.lockAccountingPeriod(params.id);
  }
}
