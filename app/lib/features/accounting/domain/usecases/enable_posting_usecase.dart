import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/accounting_repository.dart';

class EnablePostingParams extends Equatable {
  const EnablePostingParams({
    this.goLiveDate,
  });

  final DateTime? goLiveDate;

  @override
  List<Object?> get props => [goLiveDate];
}

@lazySingleton
class EnablePostingUseCase
    implements UseCase<bool, EnablePostingParams> {
  const EnablePostingUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, bool>> call(
    EnablePostingParams params,
  ) {
    return _repository.enablePosting(
      goLiveDate: params.goLiveDate,
    );
  }
}
