import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/food.dart';
import '../repositories/food_repository.dart';

@lazySingleton
class GetFoodUseCase implements UseCase<Food, String> {
  const GetFoodUseCase(this._repository);

  final FoodRepository _repository;

  @override
  Future<Either<Failure, Food>> call(String id) {
    return _repository.getFood(id);
  }
}
