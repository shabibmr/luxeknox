import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/accounting_period.dart';
import '../repositories/accounting_repository.dart';

@lazySingleton
class GetFiscalYearsUseCase implements UseCase<List<FiscalYear>, NoParams> {
  const GetFiscalYearsUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, List<FiscalYear>>> call(NoParams params) {
    return _repository.getFiscalYears();
  }
}
