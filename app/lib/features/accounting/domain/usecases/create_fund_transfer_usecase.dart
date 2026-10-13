import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/fund_transfer.dart';
import '../repositories/accounting_repository.dart';

class CreateFundTransferParams extends Equatable {
  const CreateFundTransferParams({
    required this.transferDate,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    this.feeAmount,
    this.feeAccountId,
    this.memo,
    this.idempotencyKey,
  });

  final DateTime transferDate;
  final String fromAccountId;
  final String toAccountId;
  final String amount;
  final String? feeAmount;
  final String? feeAccountId;
  final String? memo;
  final String? idempotencyKey;

  @override
  List<Object?> get props => [
        transferDate,
        fromAccountId,
        toAccountId,
        amount,
        feeAmount,
        feeAccountId,
        memo,
        idempotencyKey,
      ];
}

@lazySingleton
class CreateFundTransferUseCase
    implements UseCase<FundTransfer, CreateFundTransferParams> {
  const CreateFundTransferUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, FundTransfer>> call(CreateFundTransferParams params) {
    return _repository.createFundTransfer(
      transferDate: params.transferDate,
      fromAccountId: params.fromAccountId,
      toAccountId: params.toAccountId,
      amount: params.amount,
      feeAmount: params.feeAmount,
      feeAccountId: params.feeAccountId,
      memo: params.memo,
      idempotencyKey: params.idempotencyKey,
    );
  }
}
