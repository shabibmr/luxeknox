import 'package:equatable/equatable.dart';

import 'diet_plan_meal.dart';
import 'diet_plan_meal_input.dart';

/// Aggregated macros for a plan or meal, derived from food line items.
class DietMacros extends Equatable {
  const DietMacros({
    this.calories = 0,
    this.proteinGrams = 0,
    this.carbsGrams = 0,
    this.fatGrams = 0,
  });

  final double calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;

  bool get isEmpty =>
      calories == 0 && proteinGrams == 0 && carbsGrams == 0 && fatGrams == 0;

  DietMacros operator +(DietMacros other) {
    return DietMacros(
      calories: calories + other.calories,
      proteinGrams: proteinGrams + other.proteinGrams,
      carbsGrams: carbsGrams + other.carbsGrams,
      fatGrams: fatGrams + other.fatGrams,
    );
  }

  @override
  List<Object?> get props => [calories, proteinGrams, carbsGrams, fatGrams];
}

/// Scales per-serving food macros by quantity / servingSize (default 1).
DietMacros macrosForFoodLine({
  required num quantity,
  double? servingSize,
  double? calories,
  double? proteinGrams,
  double? carbsGrams,
  double? fatGrams,
}) {
  final size = (servingSize == null || servingSize == 0) ? 1.0 : servingSize;
  final factor = quantity.toDouble() / size;
  return DietMacros(
    calories: (calories ?? 0) * factor,
    proteinGrams: (proteinGrams ?? 0) * factor,
    carbsGrams: (carbsGrams ?? 0) * factor,
    fatGrams: (fatGrams ?? 0) * factor,
  );
}

DietMacros computeMacrosFromMeals(List<DietPlanMeal> meals) {
  var total = const DietMacros();
  for (final meal in meals) {
    for (final food in meal.foods) {
      total += macrosForFoodLine(
        quantity: food.quantity,
        servingSize: food.servingSize,
        calories: food.calories,
        proteinGrams: food.proteinGrams,
        carbsGrams: food.carbsGrams,
        fatGrams: food.fatGrams,
      );
    }
  }
  return total;
}

DietMacros computeMacrosFromMealInputs(List<DietPlanMealInput> meals) {
  var total = const DietMacros();
  for (final meal in meals) {
    for (final food in meal.foods) {
      total += macrosForFoodLine(
        quantity: food.quantity,
        servingSize: food.servingSize,
        calories: food.calories,
        proteinGrams: food.proteinGrams,
        carbsGrams: food.carbsGrams,
        fatGrams: food.fatGrams,
      );
    }
  }
  return total;
}
