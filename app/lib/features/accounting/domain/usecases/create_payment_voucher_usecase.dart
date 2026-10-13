import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment_voucher.dart';
import '../repositories/accounting_repository.dart';

class CreatePaymentVoucherParams extends Equatable {
  const CreatePaymentVoucherParams({
    required this.paymentDate,
    required this.bankAccountId,
    required this.totalAmount,
    this.memo,
    required this.allocations,
    this.idempotencyKey,
  });

  final DateTime paymentDate;
  final String bankAccountId;
  final String totalAmount;
  final String? memo;
  final List<Map<String, dynamic>> allocations;
  final String? idempotencyKey;

  @override
  List<Object?> get props => [
        paymentDate,
        bankAccountId,
        totalAmount,
        memo,
        allocations,
        idempotencyKey,
      ];
}

@lazySingleton
class CreatePaymentVoucherUseCase
    implements UseCase<PaymentVoucher, CreatePaymentVoucherParams> {
  const CreatePaymentVoucherUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, PaymentVoucher>> call(
      CreatePaymentVoucherParams params) {
    return _repository.createPaymentVoucher(
      paymentDate: params.paymentDate,
      bankAccountId: params.bankAccountId,
      totalAmount: params.totalAmount,
      memo: params.memo,
      allocations: params.allocations,
      idempotencyKey: params.idempotencyKey,
    );
  }
}
