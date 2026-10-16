import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/item.dart';
import '../repositories/accounting_repository.dart';

@lazySingleton
class GetItemCategoriesUseCase
    implements UseCase<List<ItemCategory>, NoParams> {
  const GetItemCategoriesUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, List<ItemCategory>>> call(NoParams params) =>
      _repository.getItemCategories();
}
