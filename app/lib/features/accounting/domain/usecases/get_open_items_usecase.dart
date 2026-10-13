import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/accounting_reports.dart';
import '../repositories/accounting_repository.dart';

class GetOpenItemsParams extends Equatable {
  const GetOpenItemsParams({
    required this.kind,
  });

  final String kind;

  @override
  List<Object?> get props => [kind];
}

@lazySingleton
class GetOpenItemsUseCase
    implements UseCase<OpenItemsReport, GetOpenItemsParams> {
  const GetOpenItemsUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, OpenItemsReport>> call(GetOpenItemsParams params) {
    return _repository.getOpenItems(
      kind: params.kind,
    );
  }
}
