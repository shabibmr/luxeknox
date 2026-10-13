import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/expense_voucher.dart';
import '../repositories/accounting_repository.dart';

class GetExpensesParams extends Equatable {
  const GetExpensesParams({
    this.limit,
    this.offset,
    this.status,
    this.vendorId,
    this.from,
    this.to,
    this.search,
  });

  final int? limit;
  final int? offset;
  final String? status;
  final String? vendorId;
  final DateTime? from;
  final DateTime? to;
  final String? search;

  @override
  List<Object?> get props => [
    limit,
    offset,
    status,
    vendorId,
    from,
    to,
    search,
  ];
}

@lazySingleton
class GetExpensesUseCase
    implements UseCase<CursorPage<ExpenseVoucher>, GetExpensesParams> {
  const GetExpensesUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, CursorPage<ExpenseVoucher>>> call(
    GetExpensesParams params,
  ) {
    return _repository.getExpenses(
      limit: params.limit,
      offset: params.offset,
      status: params.status,
      vendorId: params.vendorId,
      from: params.from,
      to: params.to,
      search: params.search,
    );
  }
}
