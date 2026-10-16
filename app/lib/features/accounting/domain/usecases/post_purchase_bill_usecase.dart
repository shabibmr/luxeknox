import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/purchase_bill.dart';
import '../repositories/accounting_repository.dart';

class PostPurchaseBillParams extends Equatable {
  const PostPurchaseBillParams({required this.id, this.idempotencyKey});

  final String id;
  final String? idempotencyKey;

  @override
  List<Object?> get props => [id, idempotencyKey];
}

@lazySingleton
class PostPurchaseBillUseCase
    implements UseCase<PurchaseBill, PostPurchaseBillParams> {
  const PostPurchaseBillUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, PurchaseBill>> call(PostPurchaseBillParams params) {
    return _repository.postPurchaseBill(
      params.id,
      idempotencyKey: params.idempotencyKey,
    );
  }
}
