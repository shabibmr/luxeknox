import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/journal.dart';
import '../repositories/accounting_repository.dart';

class GetJournalParams extends Equatable {
  const GetJournalParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

@lazySingleton
class GetJournalUseCase implements UseCase<Journal, GetJournalParams> {
  const GetJournalUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, Journal>> call(GetJournalParams params) {
    return _repository.getJournal(params.id);
  }
}
