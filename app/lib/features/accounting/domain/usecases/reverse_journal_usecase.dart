import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/journal.dart';
import '../repositories/accounting_repository.dart';

class ReverseJournalParams extends Equatable {
  const ReverseJournalParams({
    required this.id,
    this.entryDate,
    this.memo,
    this.idempotencyKey,
  });

  final String id;
  final DateTime? entryDate;
  final String? memo;
  final String? idempotencyKey;

  @override
  List<Object?> get props => [id, entryDate, memo, idempotencyKey];
}

@lazySingleton
class ReverseJournalUseCase implements UseCase<Journal, ReverseJournalParams> {
  const ReverseJournalUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, Journal>> call(ReverseJournalParams params) {
    return _repository.reverseJournal(
      id: params.id,
      entryDate: params.entryDate,
      memo: params.memo,
      idempotencyKey: params.idempotencyKey,
    );
  }
}
