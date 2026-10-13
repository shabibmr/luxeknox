import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/account.dart';
import '../repositories/accounting_repository.dart';

class GetAccountsParams extends Equatable {
  const GetAccountsParams({
    this.limit,
    this.offset,
    this.accountType,
    this.isActive,
    this.search,
  });

  final int? limit;
  final int? offset;
  final String? accountType;
  final bool? isActive;
  final String? search;

  @override
  List<Object?> get props => [limit, offset, accountType, isActive, search];
}

@lazySingleton
class GetAccountsUseCase
    implements UseCase<CursorPage<Account>, GetAccountsParams> {
  const GetAccountsUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, CursorPage<Account>>> call(GetAccountsParams params) {
    return _repository.getAccounts(
      limit: params.limit,
      offset: params.offset,
      accountType: params.accountType,
      isActive: params.isActive,
      search: params.search,
    );
  }
}
