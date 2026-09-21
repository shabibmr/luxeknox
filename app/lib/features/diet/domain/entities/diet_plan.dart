import 'package:equatable/equatable.dart';

import 'diet_plan_meal.dart';
import 'diet_plan_status.dart';

class DietPlan extends Equatable {
  const DietPlan({
    required this.id,
    required this.title,
    this.memberId,
    this.trainerId,
    this.dailyCalorieTarget,
    this.proteinTargetG,
    this.carbsTargetG,
    this.fatTargetG,
    required this.isTemplate,
    required this.status,
    this.createdAt,
    required this.rowVersion,
    this.meals = const [],
  });

  final String id;
  final String title;
  final String? memberId;
  final String? trainerId;
  final int? dailyCalorieTarget;
  final num? proteinTargetG;
  final num? carbsTargetG;
  final num? fatTargetG;
  final bool isTemplate;
  final DietPlanStatus status;
  final DateTime? createdAt;
  final int rowVersion;
  final List<DietPlanMeal> meals;

  @override
  List<Object?> get props => [
    id,
    title,
    memberId,
    trainerId,
    dailyCalorieTarget,
    proteinTargetG,
    carbsTargetG,
    fatTargetG,
    isTemplate,
    status,
    createdAt,
    rowVersion,
    meals,
  ];
}
