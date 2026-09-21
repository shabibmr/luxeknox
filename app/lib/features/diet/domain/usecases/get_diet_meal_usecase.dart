import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diet_plan_meal.dart';
import '../repositories/diet_plan_repository.dart';

class GetDietMealParams extends Equatable {
  const GetDietMealParams({required this.mealId, this.planId});

  final String mealId;
  final String? planId;

  @override
  List<Object?> get props => [mealId, planId];
}

@lazySingleton
class GetDietMealUseCase implements UseCase<DietPlanMeal, GetDietMealParams> {
  const GetDietMealUseCase(this._repository);

  final DietPlanRepository _repository;

  @override
  Future<Either<Failure, DietPlanMeal>> call(GetDietMealParams params) async {
    if (params.planId != null) {
      final planResult = await _repository.getPlan(params.planId!);
      return planResult.flatMap((plan) {
        final meal =
            plan.meals.where((m) => m.id == params.mealId).firstOrNull;
        if (meal != null) return Right(meal);
        return const Left(NotFoundFailure());
      });
    }

    final plansResult = await _repository.listPlans();
    return plansResult.flatMap((page) {
      for (final plan in page.items) {
        final meal =
            plan.meals.where((m) => m.id == params.mealId).firstOrNull;
        if (meal != null) return Right(meal);
      }
      return const Left(NotFoundFailure());
    });
  }
}
