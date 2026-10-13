import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/accounting_reports.dart';
import '../repositories/accounting_repository.dart';

class GetTrialBalanceParams extends Equatable {
  const GetTrialBalanceParams({
    this.from,
    required this.to,
  });

  final DateTime? from;
  final DateTime to;

  @override
  List<Object?> get props => [from, to];
}

@lazySingleton
class GetTrialBalanceUseCase
    implements UseCase<TrialBalanceReport, GetTrialBalanceParams> {
  const GetTrialBalanceUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, TrialBalanceReport>> call(
    GetTrialBalanceParams params,
  ) {
    return _repository.getTrialBalance(
      from: params.from,
      to: params.to,
    );
  }
}
