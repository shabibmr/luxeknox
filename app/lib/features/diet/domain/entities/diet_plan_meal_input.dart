import 'package:equatable/equatable.dart';

/// Builder / replace-write food line. Macro fields are UI-only for display.
class DietPlanFoodInput extends Equatable {
  const DietPlanFoodInput({
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

  final String foodId;
  final num quantity;
  final String? servingUnit;
  final String? foodName;
  final double? servingSize;
  final double? calories;
  final double? proteinGrams;
  final double? carbsGrams;
  final double? fatGrams;

  DietPlanFoodInput copyWith({
    String? foodId,
    num? quantity,
    String? servingUnit,
    String? foodName,
    double? servingSize,
    double? calories,
    double? proteinGrams,
    double? carbsGrams,
    double? fatGrams,
  }) {
    return DietPlanFoodInput(
      foodId: foodId ?? this.foodId,
      quantity: quantity ?? this.quantity,
      servingUnit: servingUnit ?? this.servingUnit,
      foodName: foodName ?? this.foodName,
      servingSize: servingSize ?? this.servingSize,
      calories: calories ?? this.calories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
    );
  }

  @override
  List<Object?> get props => [
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

/// Builder / replace-write meal. Local [key] identifies rows before save.
class DietPlanMealInput extends Equatable {
  const DietPlanMealInput({
    required this.key,
    required this.mealName,
    this.scheduledTime,
    this.targetCalories,
    this.notes,
    this.foods = const [],
  });

  final String key;
  final String mealName;
  final String? scheduledTime;
  final int? targetCalories;
  final String? notes;
  final List<DietPlanFoodInput> foods;

  DietPlanMealInput copyWith({
    String? key,
    String? mealName,
    String? scheduledTime,
    int? targetCalories,
    String? notes,
    List<DietPlanFoodInput>? foods,
    bool clearScheduledTime = false,
    bool clearTargetCalories = false,
    bool clearNotes = false,
  }) {
    return DietPlanMealInput(
      key: key ?? this.key,
      mealName: mealName ?? this.mealName,
      scheduledTime:
          clearScheduledTime ? null : (scheduledTime ?? this.scheduledTime),
      targetCalories:
          clearTargetCalories ? null : (targetCalories ?? this.targetCalories),
      notes: clearNotes ? null : (notes ?? this.notes),
      foods: foods ?? this.foods,
    );
  }

  @override
  List<Object?> get props => [
    key,
    mealName,
    scheduledTime,
    targetCalories,
    notes,
    foods,
  ];
}
