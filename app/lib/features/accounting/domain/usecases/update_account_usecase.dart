import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/account.dart';
import '../repositories/accounting_repository.dart';

class UpdateAccountParams extends Equatable {
  const UpdateAccountParams({
    required this.id,
    this.name,
    this.parentId,
    this.isActive,
    this.isBank,
    this.clearParentId = false,
  });

  final String id;
  final String? name;
  final String? parentId;
  final bool? isActive;
  final bool? isBank;
  final bool clearParentId;

  @override
  List<Object?> get props => [id, name, parentId, isActive, isBank, clearParentId];
}

@lazySingleton
class UpdateAccountUseCase implements UseCase<Account, UpdateAccountParams> {
  const UpdateAccountUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, Account>> call(UpdateAccountParams params) {
    return _repository.updateAccount(
      id: params.id,
      name: params.name,
      parentId: params.parentId,
      isActive: params.isActive,
      isBank: params.isBank,
      clearParentId: params.clearParentId,
    );
  }
}
