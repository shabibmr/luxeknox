import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/accounting_reports.dart';
import '../repositories/accounting_repository.dart';

class GetUnearnedPreviewParams extends Equatable {
  const GetUnearnedPreviewParams({
    this.goLiveDate,
  });

  final DateTime? goLiveDate;

  @override
  List<Object?> get props => [goLiveDate];
}

@lazySingleton
class GetUnearnedPreviewUseCase
    implements UseCase<UnearnedPreviewReport, GetUnearnedPreviewParams> {
  const GetUnearnedPreviewUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, UnearnedPreviewReport>> call(
    GetUnearnedPreviewParams params,
  ) {
    return _repository.getUnearnedPreview(
      goLiveDate: params.goLiveDate,
    );
  }
}
