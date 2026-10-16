import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/accounting/domain/entities/item.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_items_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/widgets/item_search_field.dart';
import 'package:mocktail/mocktail.dart';

class MockGetItemsUseCase extends Mock implements GetItemsUseCase {}

void main() {
  late MockGetItemsUseCase getItems;

  const water = Item(
    id: 1,
    name: 'Water Bottle',
    sku: 'WB-01',
    kind: 'goods',
    uomId: 1,
    uomCode: 'NOS',
    uomDecimalPlaces: 0,
    incomeAccountId: 1,
    expenseAccountId: 2,
  );
  const towel = Item(
    id: 2,
    name: 'Gym Towel',
    sku: 'GT-02',
    kind: 'goods',
    uomId: 1,
    uomCode: 'NOS',
    uomDecimalPlaces: 0,
    incomeAccountId: 1,
    expenseAccountId: 2,
  );

  setUpAll(() => registerFallbackValue(const GetItemsParams()));

  setUp(() {
    getItems = MockGetItemsUseCase();
    when(() => getItems(any())).thenAnswer((inv) async {
      final p = inv.positionalArguments.first as GetItemsParams;
      const all = [water, towel];
      final items = p.search == null
          ? all
          : all
                .where(
                  (i) => i.name.toLowerCase().contains(p.search!.toLowerCase()),
                )
                .toList();
      return Right(CursorPage(items: items, nextCursor: null, hasMore: false));
    });
  });

  testWidgets('typing filters results and selecting returns the item', (
    tester,
  ) async {
    Item? picked;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ItemSearchField(getItems: getItems, onChanged: (i) => picked = i),
        ),
      ),
    );

    await tester.tap(find.byType(ItemSearchField));
    await tester.pumpAndSettle();
    expect(find.text('Water Bottle'), findsOneWidget);
    expect(find.text('Gym Towel'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('item_search_field')), 'towel');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('Water Bottle'), findsNothing);

    await tester.tap(find.text('Gym Towel'));
    await tester.pumpAndSettle();

    expect(picked, towel);
    final last =
        verify(() => getItems(captureAny())).captured.last as GetItemsParams;
    expect(last.search, 'towel');
    expect(last.isActive, true);
  });
}
