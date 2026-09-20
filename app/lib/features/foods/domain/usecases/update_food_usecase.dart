import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/food.dart';
import '../repositories/food_repository.dart';

@lazySingleton
class UpdateFoodUseCase implements UseCase<Food, Food> {
  const UpdateFoodUseCase(this._repository);

  final FoodRepository _repository;

  @override
  Future<Either<Failure, Food>> call(Food food) {
    return _repository.update(food);
  }
}
