import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/journal.dart';
import '../repositories/accounting_repository.dart';

class GetJournalsParams extends Equatable {
  const GetJournalsParams({
    this.limit,
    this.offset,
    this.from,
    this.to,
    this.sourceType,
    this.paymentId,
  });

  final int? limit;
  final int? offset;
  final DateTime? from;
  final DateTime? to;
  final String? sourceType;
  final String? paymentId;

  @override
  List<Object?> get props => [limit, offset, from, to, sourceType, paymentId];
}

@lazySingleton
class GetJournalsUseCase
    implements UseCase<CursorPage<Journal>, GetJournalsParams> {
  const GetJournalsUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, CursorPage<Journal>>> call(GetJournalsParams params) {
    return _repository.getJournals(
      limit: params.limit,
      offset: params.offset,
      from: params.from,
      to: params.to,
      sourceType: params.sourceType,
      paymentId: params.paymentId,
    );
  }
}
