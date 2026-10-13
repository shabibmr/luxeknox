import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/accounting_period.dart';
import '../repositories/accounting_repository.dart';

class UnlockAccountingPeriodParams extends Equatable {
  const UnlockAccountingPeriodParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

@lazySingleton
class UnlockAccountingPeriodUseCase
    implements UseCase<AccountingPeriod, UnlockAccountingPeriodParams> {
  const UnlockAccountingPeriodUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, AccountingPeriod>> call(
    UnlockAccountingPeriodParams params,
  ) {
    return _repository.unlockAccountingPeriod(params.id);
  }
}
