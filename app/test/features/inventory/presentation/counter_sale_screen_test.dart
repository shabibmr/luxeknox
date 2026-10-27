import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/widgets/app_currency_text.dart';
import 'package:luxeknox/features/accounting/domain/entities/item.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_items_usecase.dart';
import 'package:luxeknox/features/inventory/presentation/cubit/counter_sale_cubit.dart';
import 'package:luxeknox/features/inventory/presentation/inventory_strings.dart';
import 'package:luxeknox/features/inventory/presentation/screens/counter_sale_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class FakeGetItemsUseCase extends Fake implements GetItemsUseCase {
  FakeGetItemsUseCase(this._items);

  List<Item> _items;
  GetItemsParams? lastParams;

  void setItems(List<Item> items) => _items = items;

  @override
  Future<Either<Failure, CursorPage<Item>>> call(GetItemsParams params) async {
    lastParams = params;
    final search = params.search?.toLowerCase();
    var filtered = _items;
    if (search != null && search.isNotEmpty) {
      filtered = _items
          .where(
            (i) =>
                i.name.toLowerCase().contains(search) ||
                (i.sku?.toLowerCase().contains(search) ?? false),
          )
          .toList();
    }
    if (params.isActive == true) {
      filtered = filtered.where((i) => i.isActive).toList();
    }
    return Right(
      CursorPage(items: filtered, nextCursor: null, hasMore: false),
    );
  }
}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late FakeGetItemsUseCase fakeGetItems;
  late CounterSaleCubit cubit;
  late MockSessionCubit mockSessionCubit;

  const trackedBar = Item(
    id: 1,
    name: 'Protein Bar',
    kind: 'goods',
    sku: 'PB-001',
    uomId: 10,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 100,
    expenseAccountId: 200,
    saleRate: '100.00',
    taxRatePercent: '18.00',
    inventoryTracked: true,
    qtyOnHand: '5.000',
    isActive: true,
  );

  const soldOut = Item(
    id: 6,
    name: 'Sold Out Towel',
    kind: 'goods',
    sku: 'TWL-0',
    uomId: 10,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 100,
    expenseAccountId: 200,
    saleRate: '20.00',
    inventoryTracked: true,
    qtyOnHand: '0.000',
    isActive: true,
  );

  const weighedGoods = Item(
    id: 2,
    name: 'Bulk Whey',
    kind: 'goods',
    sku: 'WHEY-KG',
    uomId: 11,
    uomCode: 'KG',
    uomDecimalPlaces: 3,
    incomeAccountId: 100,
    expenseAccountId: 200,
    saleRate: '10.00',
    inventoryTracked: true,
    qtyOnHand: '2.500',
    isActive: true,
  );

  const untrackedService = Item(
    id: 3,
    name: 'PT Session',
    kind: 'service',
    sku: 'PT-001',
    uomId: 10,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 100,
    expenseAccountId: 200,
    saleRate: '1500.00',
    inventoryTracked: false,
    isActive: true,
  );

  const noRate = Item(
    id: 4,
    name: 'No Rate Item',
    kind: 'goods',
    uomId: 10,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 100,
    expenseAccountId: 200,
    saleRate: null,
    inventoryTracked: true,
    qtyOnHand: '1.000',
    isActive: true,
  );

  const inactive = Item(
    id: 5,
    name: 'Inactive Bar',
    kind: 'goods',
    sku: 'INACT',
    uomId: 10,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 100,
    expenseAccountId: 200,
    saleRate: '9.00',
    inventoryTracked: true,
    qtyOnHand: '1.000',
    isActive: false,
  );

  const writeCapabilities = Capabilities(slugs: ['inventory.sales_write']);
  const noCapabilities = Capabilities(slugs: []);

  const tPrincipal = Principal(
    userId: 'u1',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'p1',
  );

  setUpAll(() {
    registerFallbackValue(const GetItemsParams());
  });

  setUp(() {
    fakeGetItems = FakeGetItemsUseCase([
      trackedBar,
      soldOut,
      weighedGoods,
      untrackedService,
      noRate,
      inactive,
    ]);
    cubit = CounterSaleCubit(fakeGetItems, debounceDuration: Duration.zero);
    mockSessionCubit = MockSessionCubit();
  });

  tearDown(() async {
    await cubit.close();
  });

  Widget buildSubject({Capabilities capabilities = writeCapabilities}) {
    whenListen(
      mockSessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: tPrincipal,
        capabilities: capabilities,
      ),
    );

    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: mockSessionCubit,
        child: CounterSaleScreen(cubit: cubit),
      ),
    );
  }

  String? amountDueValue(WidgetTester tester) {
    final finder = find.byKey(const Key('counter_sale_amount_due'));
    final elements = finder.evaluate();
    if (elements.isEmpty) return null;
    return (elements.first.widget as AppCurrencyText).amount;
  }

  testWidgets('refuses open without inventory.sales_write', (tester) async {
    await tester.pumpWidget(buildSubject(capabilities: noCapabilities));
    await tester.pumpAndSettle();
    expect(find.text(InventoryStrings.noPermission), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_grid')), findsNothing);
  });

  testWidgets('grid lists active items with sale rate; drops others', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Protein Bar'), findsOneWidget);
    expect(find.text('Bulk Whey'), findsOneWidget);
    expect(find.text('PT Session'), findsOneWidget);
    expect(find.text('No Rate Item'), findsNothing);
    expect(find.text('Inactive Bar'), findsNothing);

    // Unit charge includes tax: 100 + 18% = 118.00
    expect(
      find.byWidgetPredicate(
        (w) => w is AppCurrencyText && w.amount == '118.00',
      ),
      findsWidgets,
    );
    expect(find.byKey(const Key('counter_sale_tile_on_hand_1')), findsOneWidget);
    expect(find.textContaining('5.000'), findsWidgets);
    // Tracked with zero on hand stays visible
    expect(find.text('Sold Out Towel'), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_tile_on_hand_6')), findsOneWidget);
    expect(find.textContaining('0.000'), findsWidgets);
    // Untracked service has no on-hand
    expect(find.byKey(const Key('counter_sale_tile_on_hand_3')), findsNothing);
  });

  testWidgets('search matches name or SKU; empty says nothing matched', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('counter_sale_search')),
      'WHEY',
    );
    await tester.pumpAndSettle();
    expect(find.text('Bulk Whey'), findsOneWidget);
    expect(find.text('Protein Bar'), findsNothing);

    await tester.enterText(
      find.byKey(const Key('counter_sale_search')),
      'zzz-none',
    );
    await tester.pumpAndSettle();
    expect(find.text(InventoryStrings.nothingMatched), findsOneWidget);
  });

  testWidgets('tap adds line; second tap increments same line', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('counter_sale_tile_1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('counter_sale_line_qty_1')), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byKey(const Key('counter_sale_line_qty_1'))).controller?.text,
      '1',
    );
    expect(amountDueValue(tester), '118.00');

    await tester.tap(find.byKey(const Key('counter_sale_tile_1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('counter_sale_line_qty_1')), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byKey(const Key('counter_sale_line_qty_1'))).controller?.text,
      '2',
    );
    expect(amountDueValue(tester), '236.00');
    expect(find.byKey(const Key('counter_sale_tray_lines')), findsOneWidget);
  });

  testWidgets('quantity edit, remove, and Continue gate', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final continueBtn = find.byKey(const Key('counter_sale_continue'));
    expect(tester.widget<FilledButton>(continueBtn).onPressed, isNull);

    await tester.tap(find.byKey(const Key('counter_sale_tile_1')));
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(continueBtn).onPressed, isNotNull);
    expect(find.text(InventoryStrings.amountDueLabel), findsOneWidget);
    expect(find.textContaining('Tax'), findsNothing);

    await tester.enterText(
      find.byKey(const Key('counter_sale_line_qty_1')),
      '3',
    );
    await tester.pumpAndSettle();
    expect(amountDueValue(tester), '354.00');

    await tester.tap(find.byKey(const Key('counter_sale_line_remove_1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('counter_sale_line_qty_1')), findsNothing);
    expect(amountDueValue(tester), '0.00');
    expect(tester.widget<FilledButton>(continueBtn).onPressed, isNull);
  });

  testWidgets('weighed qty accepts decimals; over-on-hand stays with on-hand visible', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('counter_sale_tile_2')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('counter_sale_line_qty_2')),
      '3.250',
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('counter_sale_line_on_hand_2')), findsOneWidget);
    expect(find.textContaining('2.500'), findsWidgets);
    // 3.250 * 10.00 = 32.50
    expect(amountDueValue(tester), '32.50');
  });

  testWidgets('tracked goods and untracked service on same sale', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('counter_sale_tile_3')));
    await tester.tap(find.byKey(const Key('counter_sale_tile_1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('counter_sale_line_qty_1')), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_line_qty_3')), findsOneWidget);
    // 118 + 1500 = 1618
    expect(amountDueValue(tester), '1618.00');
  });
}
