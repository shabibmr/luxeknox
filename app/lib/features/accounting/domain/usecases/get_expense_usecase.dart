import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/expense_voucher.dart';
import '../repositories/accounting_repository.dart';

@lazySingleton
class GetExpenseUseCase implements UseCase<ExpenseVoucher, String> {
  const GetExpenseUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, ExpenseVoucher>> call(String id) {
    return _repository.getExpense(id);
  }
}
