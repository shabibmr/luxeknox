import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/currency/gym_currency_provider.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/accounting/domain/entities/item.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_items_usecase.dart';
import 'package:luxeknox/features/inventory/presentation/counter_sale_strings.dart';
import 'package:luxeknox/features/inventory/presentation/cubit/counter_sale_cubit.dart';
import 'package:luxeknox/features/inventory/presentation/screens/counter_sale_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockGetItemsUseCase extends Mock implements GetItemsUseCase {}

void main() {
  late MockGetItemsUseCase getItems;

  const whey = Item(
    id: 10,
    name: 'Whey Protein',
    kind: 'goods',
    sku: 'WHEY-1',
    uomId: 1,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 4250,
    expenseAccountId: 5000,
    saleRate: '100.00',
    taxCodeId: 1,
    taxRatePercent: '18.00',
    inventoryTracked: true,
    qtyOnHand: '12.000',
    isActive: true,
  );

  const towel = Item(
    id: 11,
    name: 'Gym Towel',
    kind: 'goods',
    sku: 'TWL-1',
    uomId: 1,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 4250,
    expenseAccountId: 5000,
    saleRate: '1499.00',
    inventoryTracked: true,
    qtyOnHand: '0.000',
    isActive: true,
  );

  const ptSession = Item(
    id: 12,
    name: 'PT Session',
    kind: 'service',
    sku: 'SVC-1',
    uomId: 1,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 4250,
    expenseAccountId: 5000,
    saleRate: '2000.00',
    inventoryTracked: false,
    isActive: true,
  );

  const noRate = Item(
    id: 13,
    name: 'Draft Item',
    kind: 'goods',
    sku: 'DFT-1',
    uomId: 1,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 4250,
    expenseAccountId: 5000,
    inventoryTracked: true,
    qtyOnHand: '1.000',
    isActive: true,
  );

  const inactive = Item(
    id: 14,
    name: 'Retired Bar',
    kind: 'goods',
    sku: 'RET-1',
    uomId: 1,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 4250,
    expenseAccountId: 5000,
    saleRate: '10.00',
    inventoryTracked: true,
    qtyOnHand: '5.000',
    isActive: false,
  );

  setUpAll(() {
    registerFallbackValue(const GetItemsParams());
  });

  setUp(() {
    getItems = MockGetItemsUseCase();
    if (getIt.isRegistered<CounterSaleCubit>()) {
      getIt.unregister<CounterSaleCubit>();
    }
    getIt.registerFactory<CounterSaleCubit>(
      () => CounterSaleCubit(
        getItems,
        debounceDuration: Duration.zero,
      ),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<CounterSaleCubit>()) {
      getIt.unregister<CounterSaleCubit>();
    }
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CounterSaleScreen()));
    await tester.pumpAndSettle();
  }

  String money(String amount) => formatCurrencyAmount(amount, currencyCode: 'INR');

  testWidgets(
    'shows active items with a sale rate, tax-inclusive unit charge, and on-hand',
    (tester) async {
      when(() => getItems(any())).thenAnswer(
        (_) async => const Right(
          CursorPage(items: [whey, towel, ptSession, noRate, inactive], nextCursor: null, hasMore: false),
        ),
      );

      await pumpScreen(tester);

      verify(
        () => getItems(
          any(that: predicate<GetItemsParams>((p) => p.isActive == true)),
        ),
      ).called(1);

      expect(find.text(CounterSaleStrings.title), findsOneWidget);
      expect(find.byKey(const Key('counter_sale_search')), findsOneWidget);

      expect(find.byKey(const Key('counter_sale_tile_10')), findsOneWidget);
      expect(find.byKey(const Key('counter_sale_tile_11')), findsOneWidget);
      expect(find.byKey(const Key('counter_sale_tile_12')), findsOneWidget);
      expect(find.byKey(const Key('counter_sale_tile_13')), findsNothing);
      expect(find.byKey(const Key('counter_sale_tile_14')), findsNothing);

      expect(find.text('Whey Protein'), findsOneWidget);
      expect(find.text(money('118.00')), findsOneWidget);
      expect(find.byKey(const Key('counter_sale_on_hand_10')), findsOneWidget);
      expect(find.text('${CounterSaleStrings.onHandLabel}: 12.000'), findsOneWidget);

      expect(find.text('Gym Towel'), findsOneWidget);
      expect(find.text(money('1499.00')), findsOneWidget);
      expect(find.text('${CounterSaleStrings.onHandLabel}: 0.000'), findsOneWidget);

      expect(find.text('PT Session'), findsOneWidget);
      expect(find.text(money('2000.00')), findsOneWidget);
      expect(find.byKey(const Key('counter_sale_on_hand_12')), findsNothing);
    },
  );

  testWidgets('search matches name or SKU and empty result says nothing matched', (
    tester,
  ) async {
    when(() => getItems(any())).thenAnswer((invocation) async {
      final params = invocation.positionalArguments.first as GetItemsParams;
      if (params.search == 'WHEY') {
        return const Right(
          CursorPage(items: [whey], nextCursor: null, hasMore: false),
        );
      }
      if (params.search == 'ZZZ') {
        return const Right(
          CursorPage(items: <Item>[], nextCursor: null, hasMore: false),
        );
      }
      return const Right(
        CursorPage(items: [whey, towel], nextCursor: null, hasMore: false),
      );
    });

    await pumpScreen(tester);
    expect(find.byKey(const Key('counter_sale_tile_10')), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_tile_11')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('counter_sale_search')), 'WHEY');
    await tester.pumpAndSettle();

    verify(
      () => getItems(
        any(
          that: predicate<GetItemsParams>(
            (p) => p.search == 'WHEY' && p.isActive == true,
          ),
        ),
      ),
    ).called(1);
    expect(find.byKey(const Key('counter_sale_tile_10')), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_tile_11')), findsNothing);

    await tester.enterText(find.byKey(const Key('counter_sale_search')), 'ZZZ');
    await tester.pumpAndSettle();

    expect(find.text(CounterSaleStrings.noItemsMatch), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_grid')), findsNothing);
  });
}
