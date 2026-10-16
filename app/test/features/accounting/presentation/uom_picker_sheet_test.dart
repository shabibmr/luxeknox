import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' show Either;
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/accounting/domain/entities/item.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/widgets/item_category_dropdown.dart';
import 'package:luxeknox/features/accounting/presentation/widgets/uom_picker_sheet.dart';

void main() {
  const kg = Uom(id: 1, code: 'KG', name: 'Kilogram', decimalPlaces: 3);
  const old = Uom(
    id: 2,
    code: 'OLD',
    name: 'Retired unit',
    decimalPlaces: 0,
    isActive: false,
  );

  Future<Either<Failure, List<Uom>>> loader() async =>
      Either.right(const [kg, old]);

  testWidgets('selecting an active UOM returns it; inactive row is disabled', (
    tester,
  ) async {
    Uom? picked;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async =>
                picked = await showUomPickerSheet(context, loader: loader),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text(AccountingStrings.inactiveBadge), findsOneWidget);

    await tester.tap(find.byKey(const Key('uom_row_2')));
    await tester.pumpAndSettle();
    expect(picked, isNull);
    expect(find.byKey(const Key('uom_row_2')), findsOneWidget);

    await tester.tap(find.byKey(const Key('uom_row_1')));
    await tester.pumpAndSettle();
    expect(picked, kg);
  });

  testWidgets('category dropdown offers a none option and categories', (
    tester,
  ) async {
    ItemCategory? changed;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ItemCategoryDropdown(
            value: null,
            onChanged: (c) => changed = c,
            loader: () async => Either.right(const [
              ItemCategory(id: 7, name: 'Drinks'),
            ]),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('item_category_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Drinks').last);
    await tester.pumpAndSettle();
    expect(changed?.id, 7);
  });
}
