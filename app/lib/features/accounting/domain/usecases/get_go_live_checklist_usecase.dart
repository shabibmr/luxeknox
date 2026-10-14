import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/go_live.dart';
import '../repositories/accounting_repository.dart';

class GetGoLiveChecklistParams extends Equatable {
  const GetGoLiveChecklistParams({
    this.goLiveDate,
  });

  final DateTime? goLiveDate;

  @override
  List<Object?> get props => [goLiveDate];
}

@lazySingleton
class GetGoLiveChecklistUseCase
    implements UseCase<GoLiveChecklist, GetGoLiveChecklistParams> {
  const GetGoLiveChecklistUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, GoLiveChecklist>> call(
    GetGoLiveChecklistParams params,
  ) {
    return _repository.getGoLiveChecklist(
      goLiveDate: params.goLiveDate,
    );
  }
}
