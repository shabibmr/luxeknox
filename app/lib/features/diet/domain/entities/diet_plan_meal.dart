import 'package:equatable/equatable.dart';

import 'diet_plan_food.dart';

class DietPlanMeal extends Equatable {
  const DietPlanMeal({
    required this.id,
    required this.dietPlanVersionId,
    required this.mealName,
    this.scheduledTime,
    this.targetCalories,
    this.notes,
    this.foods = const [],
  });

  final String id;
  final String dietPlanVersionId;
  final String mealName;
  final String? scheduledTime;
  final int? targetCalories;
  final String? notes;
  final List<DietPlanFood> foods;

  @override
  List<Object?> get props => [
    id,
    dietPlanVersionId,
    mealName,
    scheduledTime,
    targetCalories,
    notes,
    foods,
  ];
}
