import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../foods/domain/entities/food.dart';
import '../../domain/entities/diet_macros.dart';
import '../../domain/entities/diet_plan.dart';
import '../../domain/entities/diet_plan_meal_input.dart';
import '../../domain/usecases/create_diet_plan_usecase.dart';
import '../../domain/usecases/get_diet_plan_usecase.dart';
import '../../domain/usecases/replace_diet_plan_meals_usecase.dart';
import '../../domain/usecases/update_diet_plan_usecase.dart';

sealed class DietPlanBuilderState extends Equatable {
  const DietPlanBuilderState();

  @override
  List<Object?> get props => [];
}

final class DietPlanBuilderLoading extends DietPlanBuilderState {
  const DietPlanBuilderLoading();
}

final class DietPlanBuilderReady extends DietPlanBuilderState {
  const DietPlanBuilderReady({
    this.planId,
    this.rowVersion,
    required this.title,
    this.dailyCalorieTarget,
    this.proteinTargetG,
    this.carbsTargetG,
    this.fatTargetG,
    this.isTemplate = false,
    this.memberId = '',
    this.meals = const [],
    this.dirty = false,
    this.saving = false,
    this.errorMessage,
    this.savedPlan,
  });

  final String? planId;
  final int? rowVersion;
  final String title;
  final int? dailyCalorieTarget;
  final num? proteinTargetG;
  final num? carbsTargetG;
  final num? fatTargetG;
  final bool isTemplate;
  final String memberId;
  final List<DietPlanMealInput> meals;
  final bool dirty;
  final bool saving;
  final String? errorMessage;
  final DietPlan? savedPlan;

  bool get isEditMode => planId != null;

  DietMacros get computedMacros => computeMacrosFromMealInputs(meals);

  DietPlanBuilderReady copyWith({
    String? planId,
    int? rowVersion,
    String? title,
    int? dailyCalorieTarget,
    num? proteinTargetG,
    num? carbsTargetG,
    num? fatTargetG,
    bool? isTemplate,
    String? memberId,
    List<DietPlanMealInput>? meals,
    bool? dirty,
    bool? saving,
    String? errorMessage,
    DietPlan? savedPlan,
    bool clearError = false,
    bool clearSaved = false,
    bool clearDailyCalorieTarget = false,
    bool clearProteinTarget = false,
    bool clearCarbsTarget = false,
    bool clearFatTarget = false,
  }) {
    return DietPlanBuilderReady(
      planId: planId ?? this.planId,
      rowVersion: rowVersion ?? this.rowVersion,
      title: title ?? this.title,
      dailyCalorieTarget: clearDailyCalorieTarget
          ? null
          : (dailyCalorieTarget ?? this.dailyCalorieTarget),
      proteinTargetG:
          clearProteinTarget ? null : (proteinTargetG ?? this.proteinTargetG),
      carbsTargetG:
          clearCarbsTarget ? null : (carbsTargetG ?? this.carbsTargetG),
      fatTargetG: clearFatTarget ? null : (fatTargetG ?? this.fatTargetG),
      isTemplate: isTemplate ?? this.isTemplate,
      memberId: memberId ?? this.memberId,
      meals: meals ?? this.meals,
      dirty: dirty ?? this.dirty,
      saving: saving ?? this.saving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      savedPlan: clearSaved ? null : (savedPlan ?? this.savedPlan),
    );
  }

  @override
  List<Object?> get props => [
    planId,
    rowVersion,
    title,
    dailyCalorieTarget,
    proteinTargetG,
    carbsTargetG,
    fatTargetG,
    isTemplate,
    memberId,
    meals,
    dirty,
    saving,
    errorMessage,
    savedPlan,
  ];
}

final class DietPlanBuilderFailure extends DietPlanBuilderState {
  const DietPlanBuilderFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class DietPlanBuilderCubit extends Cubit<DietPlanBuilderState> {
  DietPlanBuilderCubit(
    this._getPlan,
    this._createPlan,
    this._updatePlan,
    this._replaceMeals,
  ) : super(const DietPlanBuilderLoading());

  final GetDietPlanUseCase _getPlan;
  final CreateDietPlanUseCase _createPlan;
  final UpdateDietPlanUseCase _updatePlan;
  final ReplaceDietPlanMealsUseCase _replaceMeals;

  int _mealKeySeq = 0;

  String _nextMealKey() {
    _mealKeySeq += 1;
    return 'meal-$_mealKeySeq';
  }

  Future<void> init({String? planId}) async {
    if (planId == null) {
      emit(const DietPlanBuilderReady(title: ''));
      return;
    }
    emit(const DietPlanBuilderLoading());
    final result = await _getPlan(planId);
    result.fold(
      (failure) => emit(DietPlanBuilderFailure(failureMessage(failure))),
      (plan) {
        final meals = [
          for (final m in plan.meals)
            DietPlanMealInput(
              key: _nextMealKey(),
              mealName: m.mealName,
              scheduledTime: m.scheduledTime,
              targetCalories: m.targetCalories,
              notes: m.notes,
              foods: [
                for (final f in m.foods)
                  DietPlanFoodInput(
                    foodId: f.foodId,
                    quantity: f.quantity,
                    servingUnit: f.servingUnit,
                    foodName: f.foodName,
                    servingSize: f.servingSize,
                    calories: f.calories,
                    proteinGrams: f.proteinGrams,
                    carbsGrams: f.carbsGrams,
                    fatGrams: f.fatGrams,
                  ),
              ],
            ),
        ];
        emit(
          DietPlanBuilderReady(
            planId: plan.id,
            rowVersion: plan.rowVersion,
            title: plan.title,
            dailyCalorieTarget: plan.dailyCalorieTarget,
            proteinTargetG: plan.proteinTargetG,
            carbsTargetG: plan.carbsTargetG,
            fatTargetG: plan.fatTargetG,
            isTemplate: plan.isTemplate,
            memberId: plan.memberId ?? '',
            meals: meals,
          ),
        );
      },
    );
  }

  DietPlanBuilderReady? get _ready {
    final s = state;
    return s is DietPlanBuilderReady ? s : null;
  }

  void setTitle(String value) {
    final ready = _ready;
    if (ready == null) return;
    emit(ready.copyWith(title: value, dirty: true, clearError: true));
  }

  void setIsTemplate(bool value) {
    final ready = _ready;
    if (ready == null) return;
    emit(ready.copyWith(isTemplate: value, dirty: true, clearError: true));
  }

  void setMemberId(String value) {
    final ready = _ready;
    if (ready == null) return;
    emit(ready.copyWith(memberId: value, dirty: true, clearError: true));
  }

  void setDailyCalorieTarget(int? value) {
    final ready = _ready;
    if (ready == null) return;
    emit(
      ready.copyWith(
        dailyCalorieTarget: value,
        clearDailyCalorieTarget: value == null,
        dirty: true,
        clearError: true,
      ),
    );
  }

  void setProteinTargetG(num? value) {
    final ready = _ready;
    if (ready == null) return;
    emit(
      ready.copyWith(
        proteinTargetG: value,
        clearProteinTarget: value == null,
        dirty: true,
        clearError: true,
      ),
    );
  }

  void setCarbsTargetG(num? value) {
    final ready = _ready;
    if (ready == null) return;
    emit(
      ready.copyWith(
        carbsTargetG: value,
        clearCarbsTarget: value == null,
        dirty: true,
        clearError: true,
      ),
    );
  }

  void setFatTargetG(num? value) {
    final ready = _ready;
    if (ready == null) return;
    emit(
      ready.copyWith(
        fatTargetG: value,
        clearFatTarget: value == null,
        dirty: true,
        clearError: true,
      ),
    );
  }

  void addMeal({String mealName = 'Meal'}) {
    final ready = _ready;
    if (ready == null) return;
    final next = [
      ...ready.meals,
      DietPlanMealInput(key: _nextMealKey(), mealName: mealName),
    ];
    emit(ready.copyWith(meals: next, dirty: true, clearError: true));
  }

  void removeMeal(String mealKey) {
    final ready = _ready;
    if (ready == null) return;
    emit(
      ready.copyWith(
        meals: ready.meals.where((m) => m.key != mealKey).toList(),
        dirty: true,
        clearError: true,
      ),
    );
  }

  void updateMeal(
    String mealKey, {
    String? mealName,
    String? scheduledTime,
    int? targetCalories,
    String? notes,
    bool clearScheduledTime = false,
    bool clearTargetCalories = false,
    bool clearNotes = false,
  }) {
    final ready = _ready;
    if (ready == null) return;
    final next = [
      for (final m in ready.meals)
        if (m.key == mealKey)
          m.copyWith(
            mealName: mealName,
            scheduledTime: scheduledTime,
            targetCalories: targetCalories,
            notes: notes,
            clearScheduledTime: clearScheduledTime,
            clearTargetCalories: clearTargetCalories,
            clearNotes: clearNotes,
          )
        else
          m,
    ];
    emit(ready.copyWith(meals: next, dirty: true, clearError: true));
  }

  void addFood(String mealKey, Food food, {num quantity = 1}) {
    final ready = _ready;
    if (ready == null) return;
    final next = [
      for (final m in ready.meals)
        if (m.key == mealKey)
          m.copyWith(
            foods: [
              ...m.foods,
              DietPlanFoodInput(
                foodId: food.id,
                quantity: quantity,
                servingUnit: food.servingUnit,
                foodName: food.name,
                servingSize: food.servingSize,
                calories: food.calories,
                proteinGrams: food.proteinGrams,
                carbsGrams: food.carbsGrams,
                fatGrams: food.fatGrams,
              ),
            ],
          )
        else
          m,
    ];
    emit(ready.copyWith(meals: next, dirty: true, clearError: true));
  }

  void removeFood(String mealKey, int foodIndex) {
    final ready = _ready;
    if (ready == null) return;
    final next = <DietPlanMealInput>[];
    for (final m in ready.meals) {
      if (m.key != mealKey) {
        next.add(m);
        continue;
      }
      if (foodIndex < 0 || foodIndex >= m.foods.length) {
        next.add(m);
        continue;
      }
      final foods = List<DietPlanFoodInput>.from(m.foods)..removeAt(foodIndex);
      next.add(m.copyWith(foods: foods));
    }
    emit(ready.copyWith(meals: next, dirty: true, clearError: true));
  }

  void setFoodQuantity(String mealKey, int foodIndex, num quantity) {
    final ready = _ready;
    if (ready == null) return;
    final next = <DietPlanMealInput>[];
    for (final m in ready.meals) {
      if (m.key != mealKey) {
        next.add(m);
        continue;
      }
      if (foodIndex < 0 || foodIndex >= m.foods.length) {
        next.add(m);
        continue;
      }
      final foods = List<DietPlanFoodInput>.from(m.foods);
      foods[foodIndex] = foods[foodIndex].copyWith(quantity: quantity);
      next.add(m.copyWith(foods: foods));
    }
    emit(ready.copyWith(meals: next, dirty: true, clearError: true));
  }

  Future<bool> save() async {
    final ready = _ready;
    if (ready == null) return false;
    final title = ready.title.trim();
    if (title.isEmpty) {
      emit(ready.copyWith(errorMessage: 'Title is required'));
      return false;
    }
    for (final meal in ready.meals) {
      if (meal.mealName.trim().isEmpty) {
        emit(ready.copyWith(errorMessage: 'Meal name is required'));
        return false;
      }
    }

    emit(ready.copyWith(saving: true, clearError: true, clearSaved: true));

    DietPlan? plan;
    if (ready.planId == null) {
      final created = await _createPlan(
        CreateDietPlanParams(
          title: title,
          memberId:
              ready.memberId.trim().isEmpty ? null : ready.memberId.trim(),
          dailyCalorieTarget: ready.dailyCalorieTarget,
          proteinTargetG: ready.proteinTargetG,
          carbsTargetG: ready.carbsTargetG,
          fatTargetG: ready.fatTargetG,
          isTemplate: ready.isTemplate,
        ),
      );
      var failed = false;
      created.fold(
        (failure) {
          failed = true;
          emit(
            ready.copyWith(
              saving: false,
              errorMessage: failureMessage(failure),
            ),
          );
        },
        (p) => plan = p,
      );
      if (failed) return false;
    } else {
      final updated = await _updatePlan(
        UpdateDietPlanParams(
          id: ready.planId!,
          rowVersion: ready.rowVersion ?? 0,
          title: title,
          memberId:
              ready.memberId.trim().isEmpty ? null : ready.memberId.trim(),
          dailyCalorieTarget: ready.dailyCalorieTarget,
          proteinTargetG: ready.proteinTargetG,
          carbsTargetG: ready.carbsTargetG,
          fatTargetG: ready.fatTargetG,
          isTemplate: ready.isTemplate,
        ),
      );
      var failed = false;
      updated.fold(
        (failure) {
          failed = true;
          emit(
            ready.copyWith(
              saving: false,
              errorMessage: failureMessage(failure),
            ),
          );
        },
        (p) => plan = p,
      );
      if (failed) return false;
    }

    final savedMeta = plan!;
    final replaced = await _replaceMeals(
      ReplaceDietPlanMealsParams(
        id: savedMeta.id,
        rowVersion: savedMeta.rowVersion,
        meals: ready.meals,
      ),
    );

    return replaced.fold(
      (failure) {
        emit(
          ready.copyWith(
            planId: savedMeta.id,
            rowVersion: savedMeta.rowVersion,
            saving: false,
            errorMessage: failureMessage(failure),
          ),
        );
        return false;
      },
      (full) {
        final meals = [
          for (final m in full.meals)
            DietPlanMealInput(
              key: _nextMealKey(),
              mealName: m.mealName,
              scheduledTime: m.scheduledTime,
              targetCalories: m.targetCalories,
              notes: m.notes,
              foods: [
                for (final f in m.foods)
                  DietPlanFoodInput(
                    foodId: f.foodId,
                    quantity: f.quantity,
                    servingUnit: f.servingUnit,
                    foodName: f.foodName,
                    servingSize: f.servingSize,
                    calories: f.calories,
                    proteinGrams: f.proteinGrams,
                    carbsGrams: f.carbsGrams,
                    fatGrams: f.fatGrams,
                  ),
              ],
            ),
        ];
        emit(
          DietPlanBuilderReady(
            planId: full.id,
            rowVersion: full.rowVersion,
            title: full.title,
            dailyCalorieTarget: full.dailyCalorieTarget,
            proteinTargetG: full.proteinTargetG,
            carbsTargetG: full.carbsTargetG,
            fatTargetG: full.fatTargetG,
            isTemplate: full.isTemplate,
            memberId: full.memberId ?? '',
            meals: meals,
            dirty: false,
            saving: false,
            savedPlan: full,
          ),
        );
        return true;
      },
    );
  }
}
