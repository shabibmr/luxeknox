import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment_voucher.dart';
import '../repositories/accounting_repository.dart';

@lazySingleton
class GetPaymentVoucherUseCase implements UseCase<PaymentVoucher, String> {
  const GetPaymentVoucherUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, PaymentVoucher>> call(String id) {
    return _repository.getPaymentVoucher(id);
  }
}
