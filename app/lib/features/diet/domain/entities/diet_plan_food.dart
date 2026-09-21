import 'package:equatable/equatable.dart';

class DietPlanFood extends Equatable {
  const DietPlanFood({
    required this.id,
    required this.dietPlanMealId,
    required this.foodId,
    required this.quantity,
    this.servingUnit,
    this.foodName,
    this.servingSize,
    this.calories,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
  });

  final String id;
  final String dietPlanMealId;
  final String foodId;
  final num quantity;
  final String? servingUnit;
  final String? foodName;
  final double? servingSize;
  final double? calories;
  final double? proteinGrams;
  final double? carbsGrams;
  final double? fatGrams;

  @override
  List<Object?> get props => [
    id,
    dietPlanMealId,
    foodId,
    quantity,
    servingUnit,
    foodName,
    servingSize,
    calories,
    proteinGrams,
    carbsGrams,
    fatGrams,
  ];
}
