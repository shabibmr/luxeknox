import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../foods/domain/entities/food.dart';
import '../../domain/entities/diet_macros.dart';
import '../../domain/entities/diet_plan.dart';
import '../../domain/entities/diet_plan_meal_input.dart';
import '../../domain/usecases/create_diet_plan_usecase.dart';
import '../../domain/usecases/get_diet_plan_usecase.dart';
import '../../domain/usecases/replace_diet_plan_meals_usecase.dart';
import '../../domain/usecases/update_diet_plan_usecase.dart';

part 'diet_plan_builder_cubit.freezed.dart';

@freezed
abstract class DietPlanBuilderState with _$DietPlanBuilderState {
  const DietPlanBuilderState._();

  const factory DietPlanBuilderState({
    @Default(LoadStatus.initial) LoadStatus status,
    String? planId,
    int? rowVersion,
    @Default('') String title,
    int? dailyCalorieTarget,
    num? proteinTargetG,
    num? carbsTargetG,
    num? fatTargetG,
    @Default(false) bool isTemplate,
    @Default('') String memberId,
    @Default(<DietPlanMealInput>[]) List<DietPlanMealInput> meals,
    @Default(false) bool dirty,
    @Default(false) bool saving,
    // Client-only checks ("Title is required"). Server errors use [failure].
    String? validationMessage,
    Failure? failure,
    DietPlan? savedPlan,
  }) = _DietPlanBuilderState;

  bool get isEditMode => planId != null;

  DietMacros get computedMacros => computeMacrosFromMealInputs(meals);
}

@injectable
class DietPlanBuilderCubit extends Cubit<DietPlanBuilderState> {
  DietPlanBuilderCubit(
    this._getPlan,
    this._createPlan,
    this._updatePlan,
    this._replaceMeals,
  ) : super(const DietPlanBuilderState());

  final GetDietPlanUseCase _getPlan;
  final CreateDietPlanUseCase _createPlan;
  final UpdateDietPlanUseCase _updatePlan;
  final ReplaceDietPlanMealsUseCase _replaceMeals;

  int _mealKeySeq = 0;
  bool _formReady = false;

  String _nextMealKey() {
    _mealKeySeq += 1;
    return 'meal-$_mealKeySeq';
  }

  Future<void> init({String? planId}) async {
    if (planId == null) {
      _formReady = true;
      emit(const DietPlanBuilderState(status: LoadStatus.success));
      return;
    }
    _formReady = false;
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _getPlan(planId);
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
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
        _formReady = true;
        emit(
          DietPlanBuilderState(
            status: LoadStatus.success,
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

  DietPlanBuilderState? get _editor => _formReady ? state : null;

  DietPlanBuilderState _cleared(DietPlanBuilderState ready) {
    return ready.copyWith(
      status: LoadStatus.success,
      failure: null,
      validationMessage: null,
    );
  }

  void setTitle(String value) {
    final ready = _editor;
    if (ready == null) return;
    emit(_cleared(ready).copyWith(title: value, dirty: true));
  }

  void setIsTemplate(bool value) {
    final ready = _editor;
    if (ready == null) return;
    emit(_cleared(ready).copyWith(isTemplate: value, dirty: true));
  }

  void setMemberId(String value) {
    final ready = _editor;
    if (ready == null) return;
    emit(_cleared(ready).copyWith(memberId: value, dirty: true));
  }

  void setDailyCalorieTarget(int? value) {
    final ready = _editor;
    if (ready == null) return;
    emit(
      _cleared(ready).copyWith(dailyCalorieTarget: value, dirty: true),
    );
  }

  void setProteinTargetG(num? value) {
    final ready = _editor;
    if (ready == null) return;
    emit(_cleared(ready).copyWith(proteinTargetG: value, dirty: true));
  }

  void setCarbsTargetG(num? value) {
    final ready = _editor;
    if (ready == null) return;
    emit(_cleared(ready).copyWith(carbsTargetG: value, dirty: true));
  }

  void setFatTargetG(num? value) {
    final ready = _editor;
    if (ready == null) return;
    emit(_cleared(ready).copyWith(fatTargetG: value, dirty: true));
  }

  void addMeal({String mealName = 'Meal'}) {
    final ready = _editor;
    if (ready == null) return;
    final next = [
      ...ready.meals,
      DietPlanMealInput(key: _nextMealKey(), mealName: mealName),
    ];
    emit(_cleared(ready).copyWith(meals: next, dirty: true));
  }

  void removeMeal(String mealKey) {
    final ready = _editor;
    if (ready == null) return;
    emit(
      _cleared(ready).copyWith(
        meals: ready.meals.where((m) => m.key != mealKey).toList(),
        dirty: true,
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
    final ready = _editor;
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
    emit(_cleared(ready).copyWith(meals: next, dirty: true));
  }

  void addFood(String mealKey, Food food, {num quantity = 1}) {
    final ready = _editor;
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
    emit(_cleared(ready).copyWith(meals: next, dirty: true));
  }

  void removeFood(String mealKey, int foodIndex) {
    final ready = _editor;
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
    emit(_cleared(ready).copyWith(meals: next, dirty: true));
  }

  void setFoodQuantity(String mealKey, int foodIndex, num quantity) {
    final ready = _editor;
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
    emit(_cleared(ready).copyWith(meals: next, dirty: true));
  }

  Future<bool> save() async {
    final ready = _editor;
    if (ready == null) return false;
    final title = ready.title.trim();
    if (title.isEmpty) {
      emit(
        ready.copyWith(
          validationMessage: 'Title is required',
          failure: null,
        ),
      );
      return false;
    }
    for (final meal in ready.meals) {
      if (meal.mealName.trim().isEmpty) {
        emit(
          ready.copyWith(
            validationMessage: 'Meal name is required',
            failure: null,
          ),
        );
        return false;
      }
    }

    emit(
      ready.copyWith(
        saving: true,
        failure: null,
        validationMessage: null,
        savedPlan: null,
      ),
    );

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
              status: LoadStatus.failure,
              failure: failure,
              validationMessage: null,
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
              status: LoadStatus.failure,
              failure: failure,
              validationMessage: null,
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
            status: LoadStatus.failure,
            failure: failure,
            validationMessage: null,
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
        _formReady = true;
        emit(
          DietPlanBuilderState(
            status: LoadStatus.success,
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
            savedPlan: full,
          ),
        );
        return true;
      },
    );
  }
}
