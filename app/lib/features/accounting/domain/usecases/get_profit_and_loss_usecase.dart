import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/accounting_reports.dart';
import '../repositories/accounting_repository.dart';

class GetProfitAndLossParams extends Equatable {
  const GetProfitAndLossParams({
    required this.from,
    required this.to,
  });

  final DateTime from;
  final DateTime to;

  @override
  List<Object?> get props => [from, to];
}

@lazySingleton
class GetProfitAndLossUseCase
    implements UseCase<ProfitAndLossReport, GetProfitAndLossParams> {
  const GetProfitAndLossUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, ProfitAndLossReport>> call(
    GetProfitAndLossParams params,
  ) {
    return _repository.getProfitAndLoss(
      from: params.from,
      to: params.to,
    );
  }
}
