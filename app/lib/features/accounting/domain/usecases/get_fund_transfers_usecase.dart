import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/fund_transfer.dart';
import '../repositories/accounting_repository.dart';

class GetFundTransfersParams extends Equatable {
  const GetFundTransfersParams({
    this.limit,
    this.offset,
    this.status,
    this.accountId,
    this.from,
    this.to,
    this.search,
  });

  final int? limit;
  final int? offset;
  final String? status;
  final String? accountId;
  final DateTime? from;
  final DateTime? to;
  final String? search;

  @override
  List<Object?> get props =>
      [limit, offset, status, accountId, from, to, search];
}

@lazySingleton
class GetFundTransfersUseCase
    implements UseCase<CursorPage<FundTransfer>, GetFundTransfersParams> {
  const GetFundTransfersUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, CursorPage<FundTransfer>>> call(
      GetFundTransfersParams params) {
    return _repository.getFundTransfers(
      limit: params.limit,
      offset: params.offset,
      status: params.status,
      accountId: params.accountId,
      from: params.from,
      to: params.to,
      search: params.search,
    );
  }
}
