import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/item.dart';
import '../repositories/accounting_repository.dart';

@lazySingleton
class GetUomsUseCase implements UseCase<List<Uom>, NoParams> {
  const GetUomsUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, List<Uom>>> call(NoParams params) =>
      _repository.getUoms();
}
