import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/expense_voucher.dart';
import '../entities/purchase_bill.dart';
import '../repositories/accounting_repository.dart';

class CreateExpenseParams extends Equatable {
  const CreateExpenseParams({
    required this.expenseDate,
    this.paidFromAccountId,
    this.vendorId,
    this.payeeName,
    required this.lines,
    this.idempotencyKey,
  });

  final DateTime expenseDate;
  final String? paidFromAccountId;
  final String? vendorId;
  final String? payeeName;
  final List<PurchaseBillLine> lines;
  final String? idempotencyKey;

  @override
  List<Object?> get props => [
        expenseDate,
        paidFromAccountId,
        vendorId,
        payeeName,
        lines,
        idempotencyKey,
      ];
}

@lazySingleton
class CreateExpenseUseCase
    implements UseCase<ExpenseVoucher, CreateExpenseParams> {
  const CreateExpenseUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, ExpenseVoucher>> call(CreateExpenseParams params) {
    return _repository.createExpense(
      expenseDate: params.expenseDate,
      paidFromAccountId: params.paidFromAccountId,
      vendorId: params.vendorId,
      payeeName: params.payeeName,
      lines: params.lines,
      idempotencyKey: params.idempotencyKey,
    );
  }
}
