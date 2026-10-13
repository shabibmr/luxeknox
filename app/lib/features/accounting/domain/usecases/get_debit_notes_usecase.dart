import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/debit_note.dart';
import '../repositories/accounting_repository.dart';

class GetDebitNotesParams extends Equatable {
  const GetDebitNotesParams({
    this.limit,
    this.offset,
    this.status,
    this.purchaseBillId,
    this.from,
    this.to,
    this.search,
  });

  final int? limit;
  final int? offset;
  final String? status;
  final String? purchaseBillId;
  final DateTime? from;
  final DateTime? to;
  final String? search;

  @override
  List<Object?> get props => [
    limit,
    offset,
    status,
    purchaseBillId,
    from,
    to,
    search,
  ];
}

@lazySingleton
class GetDebitNotesUseCase
    implements UseCase<CursorPage<DebitNote>, GetDebitNotesParams> {
  const GetDebitNotesUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, CursorPage<DebitNote>>> call(
    GetDebitNotesParams params,
  ) {
    return _repository.getDebitNotes(
      limit: params.limit,
      offset: params.offset,
      status: params.status,
      purchaseBillId: params.purchaseBillId,
      from: params.from,
      to: params.to,
      search: params.search,
    );
  }
}
