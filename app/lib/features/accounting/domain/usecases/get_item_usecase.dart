import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/item.dart';
import '../repositories/accounting_repository.dart';

@lazySingleton
class GetItemUseCase implements UseCase<Item, int> {
  const GetItemUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, Item>> call(int id) => _repository.getItem(id);
}
