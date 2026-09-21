import 'package:equatable/equatable.dart';

import 'diet_plan_meal.dart';

class DietPlanVersion extends Equatable {
  final String id;
  final String dietPlanId;
  final int versionNumber;
  final String? changelog;
  final DateTime? createdAt;
  final List<DietPlanMeal> meals;

  const DietPlanVersion({
    required this.id,
    required this.dietPlanId,
    required this.versionNumber,
    this.changelog,
    this.createdAt,
    this.meals = const [],
  });

  @override
  List<Object?> get props => [
    id,
    dietPlanId,
    versionNumber,
    changelog,
    createdAt,
    meals,
  ];
}
