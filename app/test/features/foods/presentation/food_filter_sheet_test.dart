import 'package:app/features/foods/domain/entities/food_filter.dart';
import 'package:app/features/foods/presentation/widgets/food_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FoodFilterSheet (Q4)', () {
    testWidgets('applying the verified switch returns the updated filter', (
      tester,
    ) async {
      FoodFilter? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await FoodFilterSheet.show(
                    context,
                    const FoodFilter(query: 'chicken'),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.tap(find.text('Apply filters'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.query, 'chicken');
      expect(result!.isVerified, isTrue);
    });

    testWidgets('clear all resets isVerified before applying', (tester) async {
      FoodFilter? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await FoodFilterSheet.show(
                    context,
                    const FoodFilter(isVerified: true),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Clear all'));
      await tester.pump();
      await tester.tap(find.text('Apply filters'));
      await tester.pumpAndSettle();

      expect(result!.isEmpty, isTrue);
    });
  });
}
