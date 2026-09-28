import 'package:luxeknox/features/diet/domain/entities/diet_macros.dart';
import 'package:luxeknox/features/diet/domain/entities/diet_plan_food.dart';
import 'package:luxeknox/features/diet/domain/entities/diet_plan_meal.dart';
import 'package:luxeknox/features/diet/domain/entities/diet_plan_meal_input.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('macrosForFoodLine', () {
    test('scales by quantity / servingSize', () {
      final macros = macrosForFoodLine(
        quantity: 2,
        servingSize: 1,
        calories: 100,
        proteinGrams: 10,
        carbsGrams: 5,
        fatGrams: 2,
      );
      expect(macros.calories, 200);
      expect(macros.proteinGrams, 20);
      expect(macros.carbsGrams, 10);
      expect(macros.fatGrams, 4);
    });

    test('defaults servingSize to 1 when null', () {
      final macros = macrosForFoodLine(
        quantity: 1.5,
        calories: 100,
        proteinGrams: 8,
      );
      expect(macros.calories, 150);
      expect(macros.proteinGrams, 12);
    });
  });

  group('computeMacrosFromMeals', () {
    test('sums foods across meals', () {
      final macros = computeMacrosFromMeals([
        const DietPlanMeal(
          id: '1',
          dietPlanVersionId: 'v1',
          mealName: 'Breakfast',
          foods: [
            DietPlanFood(
              id: 'f1',
              dietPlanMealId: '1',
              foodId: '10',
              quantity: 1,
              calories: 200,
              proteinGrams: 20,
              carbsGrams: 10,
              fatGrams: 5,
            ),
          ],
        ),
        const DietPlanMeal(
          id: '2',
          dietPlanVersionId: 'v1',
          mealName: 'Lunch',
          foods: [
            DietPlanFood(
              id: 'f2',
              dietPlanMealId: '2',
              foodId: '11',
              quantity: 2,
              servingSize: 1,
              calories: 100,
              proteinGrams: 5,
              carbsGrams: 20,
              fatGrams: 1,
            ),
          ],
        ),
      ]);
      expect(macros.calories, 400);
      expect(macros.proteinGrams, 30);
      expect(macros.carbsGrams, 50);
      expect(macros.fatGrams, 7);
    });
  });

  group('computeMacrosFromMealInputs', () {
    test('sums builder inputs', () {
      final macros = computeMacrosFromMealInputs([
        const DietPlanMealInput(
          key: 'm1',
          mealName: 'Snack',
          foods: [
            DietPlanFoodInput(
              foodId: '1',
              quantity: 1,
              calories: 50,
              proteinGrams: 2,
              carbsGrams: 8,
              fatGrams: 1,
            ),
          ],
        ),
      ]);
      expect(macros.calories, 50);
      expect(macros.proteinGrams, 2);
    });
  });
}
