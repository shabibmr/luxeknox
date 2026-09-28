import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';

import '../../domain/entities/diet_plan.dart';
import '../../domain/entities/diet_plan_food.dart';
import '../../domain/entities/diet_plan_meal.dart';
import '../../domain/entities/diet_plan_meal_input.dart';
import '../../domain/entities/diet_plan_status.dart';
import '../../domain/entities/diet_plan_version.dart';


DietPlanStatus dietPlanStatusToDomain(api.DietPlanStatusEnum status) {
  return switch (status.name) {
    'active' => DietPlanStatus.active,
    'archived' => DietPlanStatus.archived,
    'draft' => DietPlanStatus.draft,
    _ => DietPlanStatus.draft,
  };
}

extension DietPlanModelMapper on api.DietPlan {
  DietPlan toDomain() {
    final versionMeals = currentVersion?.meals ?? BuiltList();
    return DietPlan(
      id: id.toString(),
      title: title,
      memberId: memberId?.toString(),
      trainerId: trainerId?.toString(),
      dailyCalorieTarget: dailyCalorieTarget,
      proteinTargetG: proteinTargetG,
      carbsTargetG: carbsTargetG,
      fatTargetG: fatTargetG,
      isTemplate: isTemplate,
      status: dietPlanStatusToDomain(status),
      createdAt: createdAt,
      rowVersion: rowVersion,
      meals: versionMeals.map((m) => m.toDomain()).toList(),
    );
  }
}

extension DietPlanMealModelMapper on api.DietPlanMeal {
  DietPlanMeal toDomain() {
    return DietPlanMeal(
      id: id.toString(),
      dietPlanVersionId: dietPlanVersionId.toString(),
      mealName: mealName,
      scheduledTime: scheduledTime,
      targetCalories: targetCalories,
      notes: notes,
      foods: (foods ?? BuiltList()).map((f) => f.toDomain()).toList(),
    );
  }
}

extension DietPlanFoodModelMapper on api.DietPlanFood {
  DietPlanFood toDomain() {
    return DietPlanFood(
      id: id.toString(),
      dietPlanMealId: dietPlanMealId.toString(),
      foodId: foodId.toString(),
      quantity: quantity,
      servingUnit: servingUnit ?? food?.servingUnit,
      foodName: food?.name,
      servingSize: food?.servingSize?.toDouble(),
      calories: food?.calories?.toDouble(),
      proteinGrams: food?.proteinGrams?.toDouble(),
      carbsGrams: food?.carbsGrams?.toDouble(),
      fatGrams: food?.fatGrams?.toDouble(),
    );
  }
}

api.DietPlanWrite toDietPlanWrite({
  String? title,
  String? memberId,
  String? trainerId,
  int? dailyCalorieTarget,
  num? proteinTargetG,
  num? carbsTargetG,
  num? fatTargetG,
  bool? isTemplate,
  int? rowVersion,
}) {
  return api.DietPlanWrite(
    (b) => b
      ..title = title
      ..memberId = memberId == null ? null : int.tryParse(memberId)
      ..trainerId = trainerId == null ? null : int.tryParse(trainerId)
      ..dailyCalorieTarget = dailyCalorieTarget
      ..proteinTargetG = proteinTargetG
      ..carbsTargetG = carbsTargetG
      ..fatTargetG = fatTargetG
      ..isTemplate = isTemplate
      ..rowVersion = rowVersion,
  );
}

api.DietPlanMealsWrite toDietPlanMealsWrite({
  required int rowVersion,
  String? changelog,
  required List<DietPlanMealInput> meals,
}) {
  return api.DietPlanMealsWrite(
    (b) => b
      ..changelog = changelog
      ..rowVersion = rowVersion
      ..meals.replace(
        meals.map(
          (m) => api.DietPlanMealsWriteMealsInner(
            (ib) => ib
              ..mealName = m.mealName
              ..scheduledTime = m.scheduledTime
              ..targetCalories = m.targetCalories
              ..notes = m.notes
              ..foods = ListBuilder(
                m.foods.map(
                  (f) => api.DietPlanMealsWriteMealsInnerFoodsInner(
                    (fb) => fb
                      ..foodId = int.parse(f.foodId)
                      ..quantity = f.quantity
                      ..servingUnit = f.servingUnit,
                  ),
                ),
              ),
          ),
        ),
      ),
  );
}

extension DietPlanVersionModelMapper on api.DietPlanVersion {
  DietPlanVersion toDomain() {
    return DietPlanVersion(
      id: id.toString(),
      dietPlanId: dietPlanId.toString(),
      versionNumber: versionNumber,
      changelog: changelog,
      createdAt: createdAt,
      meals: (meals ?? BuiltList()).map((m) => m.toDomain()).toList(),
    );
  }
}

api.AssignPlanRequest toAssignPlanRequest(String memberId) {
  return api.AssignPlanRequest(
    (b) => b..memberId = int.parse(memberId),
  );
}
