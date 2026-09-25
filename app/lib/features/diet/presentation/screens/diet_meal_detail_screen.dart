import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/diet_macros.dart';
import '../../domain/entities/diet_plan_meal.dart';
import '../../domain/usecases/get_diet_meal_usecase.dart';
import '../cubit/diet_meal_detail_cubit.dart';
import '../diet_strings.dart';
import '../widgets/diet_macro_summary.dart';

class DietMealDetailScreen extends StatelessWidget {
  const DietMealDetailScreen({
    super.key,
    required this.mealId,
    this.planId,
  });

  final String mealId;
  final String? planId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DietMealDetailCubit(
        getIt<GetDietMealUseCase>(),
      )..load(mealId: mealId, planId: planId),
      child: _DietMealDetailBody(mealId: mealId, planId: planId),
    );
  }
}

class _DietMealDetailBody extends StatelessWidget {
  const _DietMealDetailBody({required this.mealId, this.planId});

  final String mealId;
  final String? planId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DietMealDetailCubit, DietMealDetailState>(
      builder: (context, state) {
        if (state.status == LoadStatus.loading && state.meal == null) {
          return Scaffold(
            appBar: AppBar(title: const Text(DietStrings.mealDetailTitle)),
            body: const AppLoading(),
          );
        }
        if (state.status == LoadStatus.failure && state.meal == null) {
          return Scaffold(
            appBar: AppBar(title: const Text(DietStrings.mealDetailTitle)),
            body: AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () => context.read<DietMealDetailCubit>().load(
                mealId: mealId,
                planId: planId,
              ),
            ),
          );
        }
        final meal = state.meal;
        if (meal == null) {
          return Scaffold(
            appBar: AppBar(title: const Text(DietStrings.mealDetailTitle)),
          );
        }
        return _MealDetailContent(meal: meal);
      },
    );
  }
}

class _MealDetailContent extends StatelessWidget {
  const _MealDetailContent({required this.meal});

  final DietPlanMeal meal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final macros = computeMacrosFromMeals([meal]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          meal.mealName.isNotEmpty ? meal.mealName : DietStrings.mealDetailTitle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.mealName,
                      style: theme.textTheme.headlineSmall,
                    ),
                    if (meal.scheduledTime != null &&
                        meal.scheduledTime!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            meal.scheduledTime!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (meal.targetCalories != null)
                Chip(
                  avatar: const Icon(Icons.local_fire_department, size: 18),
                  label: Text('${meal.targetCalories} kcal'),
                ),
            ],
          ),
          if (meal.notes != null && meal.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                meal.notes!,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
          const SizedBox(height: 16),
          DietMacroSummary(
            macros: macros,
            calorieTarget: meal.targetCalories,
          ),
          const Divider(height: 32),
          Text(DietStrings.foodsSection, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          if (meal.foods.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(DietStrings.emptyFoods),
            )
          else
            ...meal.foods.map((food) {
              final foodMacros = macrosForFoodLine(
                quantity: food.quantity,
                servingSize: food.servingSize,
                calories: food.calories,
                proteinGrams: food.proteinGrams,
                carbsGrams: food.carbsGrams,
                fatGrams: food.fatGrams,
              );
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(food.foodName ?? 'Food #${food.foodId}'),
                  subtitle: Text(
                    '${DietStrings.foodLineSubtitle(quantity: food.quantity, servingUnit: food.servingUnit)}'
                    '${foodMacros.calories > 0 ? ' · ${DietStrings.macroValue(foodMacros.calories, suffix: ' kcal')}' : ''}',
                  ),
                  trailing: (foodMacros.proteinGrams > 0 ||
                          foodMacros.carbsGrams > 0 ||
                          foodMacros.fatGrams > 0)
                      ? Text(
                          'P: ${DietStrings.macroValue(foodMacros.proteinGrams)}g  '
                          'C: ${DietStrings.macroValue(foodMacros.carbsGrams)}g  '
                          'F: ${DietStrings.macroValue(foodMacros.fatGrams)}g',
                          style: theme.textTheme.bodySmall,
                        )
                      : null,
                ),
              );
            }),
        ],
      ),
    );
  }
}
