import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/purchase_bill.dart';
import '../repositories/accounting_repository.dart';

@lazySingleton
class PostPurchaseBillUseCase implements UseCase<PurchaseBill, String> {
  const PostPurchaseBillUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, PurchaseBill>> call(String id) {
    return _repository.postPurchaseBill(id);
  }
}
