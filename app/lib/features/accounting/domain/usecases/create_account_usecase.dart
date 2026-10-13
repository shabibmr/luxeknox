import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/account.dart';
import '../repositories/accounting_repository.dart';

class CreateAccountParams extends Equatable {
  const CreateAccountParams({
    required this.code,
    required this.name,
    required this.accountType,
    this.parentId,
    this.isActive,
    this.isBank,
    this.isControl,
    this.controlRole,
  });

  final String code;
  final String name;
  final String accountType;
  final String? parentId;
  final bool? isActive;
  final bool? isBank;
  final bool? isControl;
  final String? controlRole;

  @override
  List<Object?> get props => [
    code,
    name,
    accountType,
    parentId,
    isActive,
    isBank,
    isControl,
    controlRole,
  ];
}

@lazySingleton
class CreateAccountUseCase implements UseCase<Account, CreateAccountParams> {
  const CreateAccountUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, Account>> call(CreateAccountParams params) {
    return _repository.createAccount(
      code: params.code,
      name: params.name,
      accountType: params.accountType,
      parentId: params.parentId,
      isActive: params.isActive,
      isBank: params.isBank,
      isControl: params.isControl,
      controlRole: params.controlRole,
    );
  }
}
