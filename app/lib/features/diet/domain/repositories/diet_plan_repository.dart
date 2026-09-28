import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/diet_plan.dart';
import '../entities/diet_plan_meal_input.dart';
import '../entities/diet_plan_version.dart';

abstract class DietPlanRepository {
  Future<Either<Failure, CursorPage<DietPlan>>> listPlans({
    String? memberId,
    bool? isTemplate,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, DietPlan>> getPlan(String id);

  Future<Either<Failure, DietPlan>> createPlan({
    required String title,
    String? memberId,
    String? trainerId,
    int? dailyCalorieTarget,
    num? proteinTargetG,
    num? carbsTargetG,
    num? fatTargetG,
    bool? isTemplate,
  });

  Future<Either<Failure, DietPlan>> updatePlan(
    String id, {
    String? title,
    String? memberId,
    String? trainerId,
    int? dailyCalorieTarget,
    num? proteinTargetG,
    num? carbsTargetG,
    num? fatTargetG,
    bool? isTemplate,
    required int rowVersion,
  });

  Future<Either<Failure, DietPlan>> replaceMeals(
    String id, {
    required int rowVersion,
    String? changelog,
    required List<DietPlanMealInput> meals,
  });

  Future<Either<Failure, DietPlan>> publish(String id);

  Future<Either<Failure, DietPlan>> archive(String id);

  Future<Either<Failure, DietPlan>> assign(String planId, String memberId);

  Future<Either<Failure, List<DietPlanVersion>>> listVersions(String planId);
}

