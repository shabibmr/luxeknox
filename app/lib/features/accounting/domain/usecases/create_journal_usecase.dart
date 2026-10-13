import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/journal.dart';
import '../repositories/accounting_repository.dart';

class CreateJournalParams extends Equatable {
  const CreateJournalParams({
    required this.entryDate,
    required this.sourceType,
    this.memo,
    required this.lines,
    this.idempotencyKey,
  });

  final DateTime entryDate;
  final String sourceType;
  final String? memo;
  final List<JournalLine> lines;
  final String? idempotencyKey;

  @override
  List<Object?> get props => [
    entryDate,
    sourceType,
    memo,
    lines,
    idempotencyKey,
  ];
}

@lazySingleton
class CreateJournalUseCase implements UseCase<Journal, CreateJournalParams> {
  const CreateJournalUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, Journal>> call(CreateJournalParams params) {
    return _repository.createJournal(
      entryDate: params.entryDate,
      sourceType: params.sourceType,
      memo: params.memo,
      lines: params.lines,
      idempotencyKey: params.idempotencyKey,
    );
  }
}
