import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/food_repository.dart';

@lazySingleton
class DeactivateFoodUseCase implements UseCase<void, String> {
  const DeactivateFoodUseCase(this._repository);

  final FoodRepository _repository;

  @override
  Future<Either<Failure, void>> call(String id) {
    return _repository.deactivate(id);
  }
}
