import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment_voucher.dart';
import '../repositories/accounting_repository.dart';

class GetPaymentVouchersParams extends Equatable {
  const GetPaymentVouchersParams({
    this.limit,
    this.offset,
    this.status,
    this.bankAccountId,
    this.from,
    this.to,
    this.search,
  });

  final int? limit;
  final int? offset;
  final String? status;
  final String? bankAccountId;
  final DateTime? from;
  final DateTime? to;
  final String? search;

  @override
  List<Object?> get props => [
    limit,
    offset,
    status,
    bankAccountId,
    from,
    to,
    search,
  ];
}

@lazySingleton
class GetPaymentVouchersUseCase
    implements UseCase<CursorPage<PaymentVoucher>, GetPaymentVouchersParams> {
  const GetPaymentVouchersUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, CursorPage<PaymentVoucher>>> call(
    GetPaymentVouchersParams params,
  ) {
    return _repository.getPaymentVouchers(
      limit: params.limit,
      offset: params.offset,
      status: params.status,
      bankAccountId: params.bankAccountId,
      from: params.from,
      to: params.to,
      search: params.search,
    );
  }
}
