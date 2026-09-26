import 'package:luxeknox/features/foods/domain/entities/food.dart';
import 'package:luxeknox/features/foods/presentation/widgets/food_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tFood = Food(
    id: '1',
    name: 'Chicken Breast',
    servingUnit: 'g',
    calories: 165,
    proteinGrams: 31,
    carbsGrams: 0,
    fatGrams: 4,
    isVerified: true,
  );

  group('FoodListItem (Q2)', () {
    testWidgets('renders name, calories, macro summary, and serving unit', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FoodListItem(food: tFood)),
        ),
      );

      expect(find.text('Chicken Breast'), findsOneWidget);
      expect(find.textContaining('165 kcal'), findsOneWidget);
      expect(find.textContaining('P31'), findsOneWidget);
      expect(find.text('g'), findsOneWidget);
    });

    testWidgets('shows macro summary without calories when calories is null', (
      tester,
    ) async {
      const noCalories = Food(
        id: '2',
        name: 'Water',
        servingUnit: 'ml',
        isVerified: false,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FoodListItem(food: noCalories)),
        ),
      );

      expect(find.textContaining('kcal'), findsNothing);
      expect(find.textContaining('P-'), findsOneWidget);
    });

    testWidgets('invokes onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FoodListItem(food: tFood, onTap: () => tapped = true),
          ),
        ),
      );

      await tester.tap(find.byType(FoodListItem));
      expect(tapped, isTrue);
    });
  });
}
