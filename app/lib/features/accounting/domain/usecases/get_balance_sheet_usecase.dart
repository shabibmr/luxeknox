import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/accounting_reports.dart';
import '../repositories/accounting_repository.dart';

class GetBalanceSheetParams extends Equatable {
  const GetBalanceSheetParams({
    required this.asOf,
  });

  final DateTime asOf;

  @override
  List<Object?> get props => [asOf];
}

@lazySingleton
class GetBalanceSheetUseCase
    implements UseCase<BalanceSheetReport, GetBalanceSheetParams> {
  const GetBalanceSheetUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, BalanceSheetReport>> call(
    GetBalanceSheetParams params,
  ) {
    return _repository.getBalanceSheet(
      asOf: params.asOf,
    );
  }
}
