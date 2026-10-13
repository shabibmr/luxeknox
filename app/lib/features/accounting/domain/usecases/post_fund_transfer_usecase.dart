import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/fund_transfer.dart';
import '../repositories/accounting_repository.dart';

@lazySingleton
class PostFundTransferUseCase implements UseCase<FundTransfer, String> {
  const PostFundTransferUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, FundTransfer>> call(String id) {
    return _repository.postFundTransfer(id);
  }
}
