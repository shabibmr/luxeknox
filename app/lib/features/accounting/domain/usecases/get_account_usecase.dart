import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/account.dart';
import '../repositories/accounting_repository.dart';

class GetAccountParams extends Equatable {
  const GetAccountParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

@lazySingleton
class GetAccountUseCase implements UseCase<Account, GetAccountParams> {
  const GetAccountUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, Account>> call(GetAccountParams params) {
    return _repository.getAccount(params.id);
  }
}
