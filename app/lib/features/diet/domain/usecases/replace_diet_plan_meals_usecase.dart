import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diet_plan.dart';
import '../entities/diet_plan_meal_input.dart';
import '../repositories/diet_plan_repository.dart';

class ReplaceDietPlanMealsParams extends Equatable {
  const ReplaceDietPlanMealsParams({
    required this.id,
    required this.rowVersion,
    this.changelog,
    required this.meals,
  });

  final String id;
  final int rowVersion;
  final String? changelog;
  final List<DietPlanMealInput> meals;

  @override
  List<Object?> get props => [id, rowVersion, changelog, meals];
}

@lazySingleton
class ReplaceDietPlanMealsUseCase
    implements UseCase<DietPlan, ReplaceDietPlanMealsParams> {
  const ReplaceDietPlanMealsUseCase(this._repository);

  final DietPlanRepository _repository;

  @override
  Future<Either<Failure, DietPlan>> call(ReplaceDietPlanMealsParams params) {
    return _repository.replaceMeals(
      params.id,
      rowVersion: params.rowVersion,
      changelog: params.changelog,
      meals: params.meals,
    );
  }
}
