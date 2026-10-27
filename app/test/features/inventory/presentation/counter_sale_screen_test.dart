import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/core/widgets/app_currency_text.dart';
import 'package:luxeknox/features/accounting/domain/entities/item.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_items_usecase.dart';
import 'package:luxeknox/features/inventory/domain/entities/counter_sale.dart';
import 'package:luxeknox/features/inventory/domain/entities/create_counter_sale_input.dart';
import 'package:luxeknox/features/inventory/domain/usecases/create_counter_sale_usecase.dart';
import 'package:luxeknox/features/inventory/presentation/cubit/counter_sale_cubit.dart';
import 'package:luxeknox/features/inventory/presentation/inventory_strings.dart';
import 'package:luxeknox/features/inventory/presentation/screens/counter_sale_screen.dart';
import 'package:luxeknox/features/payments/domain/entities/payment_method.dart';
import 'package:luxeknox/features/payments/domain/usecases/get_payment_methods_usecase.dart';
import 'package:luxeknox/features/people/domain/entities/profile_summary.dart';
import 'package:luxeknox/features/people/domain/usecases/list_members_usecase.dart';
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
    return Right(CursorPage(items: filtered, nextCursor: null, hasMore: false));
  }
}

class FakeGetPaymentMethodsUseCase extends Fake
    implements GetPaymentMethodsUseCase {
  FakeGetPaymentMethodsUseCase(this._methods);

  List<PaymentMethod> _methods;
  int callCount = 0;

  void setMethods(List<PaymentMethod> methods) => _methods = methods;

  @override
  Future<Either<Failure, List<PaymentMethod>>> call(NoParams params) async {
    callCount++;
    return Right(_methods);
  }
}

class FakeListMembersUseCase extends Fake implements ListMembersUseCase {
  FakeListMembersUseCase(this.members);

  final List<ProfileSummary> members;

  @override
  Future<Either<Failure, CursorPage<ProfileSummary>>> call(
    ListMembersParams params,
  ) async {
    return Right(CursorPage(items: members, nextCursor: null, hasMore: false));
  }
}

class FakeCreateCounterSaleUseCase extends Fake
    implements CreateCounterSaleUseCase {
  FakeCreateCounterSaleUseCase({this.result});

  Either<Failure, CounterSale>? result;
  final List<CreateCounterSaleInput> calls = [];

  @override
  Future<Either<Failure, CounterSale>> call(
    CreateCounterSaleInput params,
  ) async {
    calls.add(params);
    return result ??
        Right(
          CounterSale(
            id: 99,
            saleNumber: 'CS-0001',
            totalAmount: params.tenders.first.amount,
            tenders: [
              for (final t in params.tenders)
                CounterSaleTender(
                  paymentMethodId: t.paymentMethodId,
                  paymentMethodName: 'Cash',
                  amount: t.amount,
                ),
            ],
          ),
        );
  }
}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

String buyerNameOf(WidgetTester tester) {
  return tester
          .widget<TextField>(find.byKey(const Key('counter_sale_buyer_name')))
          .controller
          ?.text ??
      '';
}

void main() {
  late FakeGetItemsUseCase fakeGetItems;
  late FakeGetPaymentMethodsUseCase fakePaymentMethods;
  late FakeListMembersUseCase fakeListMembers;
  late FakeCreateCounterSaleUseCase fakeCreate;
  late CounterSaleCubit cubit;
  late MockSessionCubit mockSessionCubit;

  const alice = ProfileSummary(
    id: 10,
    fullName: 'Alice Walker',
    membershipNumber: 'M-1001',
    membershipStatus: 'active',
  );

  const cash = PaymentMethod(
    id: '1',
    methodName: 'Cash',
    isDigital: false,
    isActive: true,
  );
  const card = PaymentMethod(
    id: '2',
    methodName: 'Card',
    isDigital: true,
    isActive: true,
  );
  const inactiveUpi = PaymentMethod(
    id: '3',
    methodName: 'UPI',
    isDigital: true,
    isActive: false,
  );

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
    registerFallbackValue(const NoParams());
    registerFallbackValue(const CreateCounterSaleInput(lines: [], tenders: []));
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
    fakePaymentMethods = FakeGetPaymentMethodsUseCase([
      cash,
      card,
      inactiveUpi,
    ]);
    fakeListMembers = FakeListMembersUseCase(const [alice]);
    fakeCreate = FakeCreateCounterSaleUseCase();
    cubit = CounterSaleCubit(
      fakeGetItems,
      fakePaymentMethods,
      fakeListMembers,
      fakeCreate,
      debounceDuration: Duration.zero,
    );
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
        child: CounterSaleScreen(cubit: cubit, listMembers: fakeListMembers),
      ),
    );
  }

  String? amountDueValue(WidgetTester tester) {
    final finder = find.byKey(const Key('counter_sale_amount_due'));
    final elements = finder.evaluate();
    if (elements.isEmpty) return null;
    return (elements.first.widget as AppCurrencyText).amount;
  }

  Future<void> openBuyer(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('counter_sale_tile_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('counter_sale_continue')));
    await tester.pumpAndSettle();
  }

  Future<void> openTender(WidgetTester tester) async {
    await openBuyer(tester);
    await tester.tap(find.byKey(const Key('counter_sale_buyer_continue')));
    await tester.pumpAndSettle();
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

    expect(
      find.byWidgetPredicate(
        (w) => w is AppCurrencyText && w.amount == '118.00',
      ),
      findsWidgets,
    );
    expect(
      find.byKey(const Key('counter_sale_tile_on_hand_1')),
      findsOneWidget,
    );
    expect(find.textContaining('5.000'), findsWidgets);
    expect(find.text('Sold Out Towel'), findsOneWidget);
    expect(
      find.byKey(const Key('counter_sale_tile_on_hand_6')),
      findsOneWidget,
    );
    expect(find.textContaining('0.000'), findsWidgets);
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
      tester
          .widget<TextField>(find.byKey(const Key('counter_sale_line_qty_1')))
          .controller
          ?.text,
      '1',
    );
    expect(amountDueValue(tester), '118.00');

    await tester.tap(find.byKey(const Key('counter_sale_tile_1')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('counter_sale_line_qty_1')))
          .controller
          ?.text,
      '2',
    );
    expect(amountDueValue(tester), '236.00');
  });

  testWidgets('quantity edit, remove, and Continue gate', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    final continueBtn = find.byKey(const Key('counter_sale_continue'));
    expect(tester.widget<FilledButton>(continueBtn).onPressed, isNull);

    await tester.tap(find.byKey(const Key('counter_sale_tile_1')));
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(continueBtn).onPressed, isNotNull);

    await tester.enterText(
      find.byKey(const Key('counter_sale_line_qty_1')),
      '3',
    );
    await tester.pumpAndSettle();
    expect(amountDueValue(tester), '354.00');

    await tester.tap(find.byKey(const Key('counter_sale_line_remove_1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('counter_sale_line_qty_1')), findsNothing);
    expect(tester.widget<FilledButton>(continueBtn).onPressed, isNull);
  });

  testWidgets(
    'weighed qty accepts decimals; over-on-hand stays with on-hand visible',
    (tester) async {
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
      expect(
        find.byKey(const Key('counter_sale_line_on_hand_2')),
        findsOneWidget,
      );
      expect(find.textContaining('2.500'), findsWidgets);
      expect(amountDueValue(tester), '32.50');
    },
  );

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
    expect(amountDueValue(tester), '1618.00');
  });

  testWidgets('a sale line can continue to the buyer step', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('counter_sale_continue')))
          .onPressed,
      isNull,
    );

    await tester.tap(find.byKey(const Key('counter_sale_tile_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('counter_sale_continue')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('counter_sale_buyer')), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_grid')), findsNothing);
    expect(find.text(InventoryStrings.buyerMemberHint), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_buyer_name')), findsOneWidget);
  });

  testWidgets('picking a Member clears a typed buyer name', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await openBuyer(tester);

    await tester.enterText(
      find.byKey(const Key('counter_sale_buyer_name')),
      'Sam Lee',
    );
    await tester.pumpAndSettle();
    expect(buyerNameOf(tester), 'Sam Lee');

    await tester.tap(find.byKey(const Key('counter_sale_buyer_member')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alice Walker'));
    await tester.pumpAndSettle();

    expect(find.text('Alice Walker (M-1001)'), findsOneWidget);
    expect(buyerNameOf(tester), isEmpty);
    expect(find.text('Sam Lee'), findsNothing);
  });

  testWidgets('typing a buyer name clears the selected Member', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await openBuyer(tester);

    await tester.tap(find.byKey(const Key('counter_sale_buyer_member')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alice Walker'));
    await tester.pumpAndSettle();
    expect(find.text('Alice Walker (M-1001)'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('counter_sale_buyer_name')),
      'Sam Lee',
    );
    await tester.pumpAndSettle();

    expect(buyerNameOf(tester), 'Sam Lee');
    expect(find.text('Alice Walker (M-1001)'), findsNothing);
    expect(find.text(InventoryStrings.buyerMemberHint), findsOneWidget);
  });

  testWidgets('a blank buyer can be continued', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await openBuyer(tester);

    expect(buyerNameOf(tester), isEmpty);
    expect(find.text(InventoryStrings.buyerMemberHint), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('counter_sale_buyer_continue')),
          )
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.byKey(const Key('counter_sale_buyer_continue')));
    await tester.pumpAndSettle();
    expect(find.text(InventoryStrings.tenderStepTitle), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_buyer')), findsNothing);
  });

  testWidgets('back to the grid keeps the lines and the buyer', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await openBuyer(tester);

    await tester.enterText(
      find.byKey(const Key('counter_sale_buyer_name')),
      'Sam Lee',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('counter_sale_back')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('counter_sale_grid')), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_line_qty_1')), findsOneWidget);
    expect(amountDueValue(tester), '118.00');

    await tester.tap(find.byKey(const Key('counter_sale_continue')));
    await tester.pumpAndSettle();
    expect(buyerNameOf(tester), 'Sam Lee');

    await tester.tap(find.byKey(const Key('counter_sale_buyer_member')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alice Walker'));
    await tester.pumpAndSettle();
    expect(find.text('Alice Walker (M-1001)'), findsOneWidget);
    expect(buyerNameOf(tester), isEmpty);

    await tester.tap(find.byKey(const Key('counter_sale_back')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('counter_sale_continue')));
    await tester.pumpAndSettle();

    expect(find.text('Alice Walker (M-1001)'), findsOneWidget);
    expect(buyerNameOf(tester), isEmpty);
  });

  // --- #23 Settle with one payment method ---

  testWidgets('tender step lists active payment methods; hides inactive', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await openTender(tester);

    expect(
      find.byKey(const Key('counter_sale_payment_methods')),
      findsOneWidget,
    );
    expect(find.text('Cash'), findsOneWidget);
    expect(find.text('Card'), findsOneWidget);
    expect(find.text('UPI'), findsNothing);
    expect(find.byKey(const Key('counter_sale_method_3')), findsNothing);
    expect(
      find.byKey(const Key('counter_sale_tender_amount_due')),
      findsOneWidget,
    );
  });

  testWidgets('empty payment methods tells cashier to add methods', (
    tester,
  ) async {
    fakePaymentMethods.setMethods(const []);
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await openTender(tester);

    expect(
      find.byKey(const Key('counter_sale_no_payment_methods')),
      findsOneWidget,
    );
    expect(find.text(InventoryStrings.noPaymentMethods), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('counter_sale_confirm')))
          .onPressed,
      isNull,
    );
  });

  testWidgets(
    'choosing one method settles whole amount; confirm creates sale',
    (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      await openTender(tester);

      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('counter_sale_confirm')))
            .onPressed,
        isNull,
      );

      await tester.tap(find.byKey(const Key('counter_sale_method_1')));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('counter_sale_confirm')))
            .onPressed,
        isNotNull,
      );

      await tester.tap(find.byKey(const Key('counter_sale_confirm')));
      await tester.pumpAndSettle();

      expect(fakeCreate.calls, hasLength(1));
      final input = fakeCreate.calls.single;
      expect(input.memberId, isNull);
      expect(input.buyerName, isNull);
      expect(input.lines, [
        const CreateCounterSaleLineInput(itemId: 1, quantity: '1'),
      ]);
      expect(input.tenders, [
        const CreateCounterSaleTenderInput(
          paymentMethodId: 1,
          amount: '118.00',
        ),
      ]);
      expect(input.idempotencyKey, isNotEmpty);

      expect(
        find.byKey(const Key('counter_sale_posted_number')),
        findsOneWidget,
      );
      expect(find.text('CS-0001'), findsOneWidget);
      expect(
        find.byKey(const Key('counter_sale_posted_amount')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('counter_sale_posted_tender_1')),
        findsOneWidget,
      );
      expect(find.text('Cash'), findsOneWidget);
    },
  );

  testWidgets(
    'create omits rate discount tax date and reference; member or name exclusive',
    (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      await openTender(tester);
      cubit.setMember(10, member: alice);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('counter_sale_method_2')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('counter_sale_confirm')));
      await tester.pumpAndSettle();

      final input = fakeCreate.calls.single;
      expect(input.memberId, 10);
      expect(input.buyerName, isNull);
      expect(input.lines.single.itemId, 1);
      expect(input.tenders.single.paymentMethodId, 2);
      expect(input.tenders.single.amount, '118.00');
    },
  );

  testWidgets('retry reuses idempotency key; new sale mints a new key', (
    tester,
  ) async {
    fakeCreate.result = const Left(
      BusinessRuleFailure('Map this payment method in Go-live setup'),
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await openTender(tester);
    await tester.tap(find.byKey(const Key('counter_sale_method_1')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('counter_sale_confirm')));
    await tester.pumpAndSettle();
    final firstKey = fakeCreate.calls.first.idempotencyKey;
    expect(firstKey, isNotEmpty);
    expect(find.byKey(const Key('counter_sale_confirm_error')), findsOneWidget);

    await tester.tap(find.byKey(const Key('counter_sale_confirm')));
    await tester.pumpAndSettle();
    expect(fakeCreate.calls, hasLength(2));
    expect(fakeCreate.calls[1].idempotencyKey, firstKey);

    fakeCreate.result = null;
    await tester.tap(find.byKey(const Key('counter_sale_confirm')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('counter_sale_new_sale')), findsOneWidget);

    await tester.tap(find.byKey(const Key('counter_sale_new_sale')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('counter_sale_grid')), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_tray_empty')), findsOneWidget);

    await openTender(tester);
    await tester.tap(find.byKey(const Key('counter_sale_method_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('counter_sale_confirm')));
    await tester.pumpAndSettle();
    expect(fakeCreate.calls.last.idempotencyKey, isNot(firstKey));
  });

  testWidgets('over on-hand keeps confirm off and on-hand visible', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('counter_sale_tile_1')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('counter_sale_line_qty_1')),
      '9',
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('counter_sale_line_on_hand_1')),
      findsOneWidget,
    );
    expect(find.textContaining('5.000'), findsWidgets);

    await tester.tap(find.byKey(const Key('counter_sale_continue')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('counter_sale_buyer_continue')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('counter_sale_method_1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('counter_sale_over_on_hand')), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_tender_lines')), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_line_on_hand_1')), findsOneWidget);
    expect(find.textContaining('5.000'), findsWidgets);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('counter_sale_confirm')))
          .onPressed,
      isNull,
    );
    expect(fakeCreate.calls, isEmpty);

    await tester.enterText(
      find.byKey(const Key('counter_sale_line_qty_1')),
      '2',
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('counter_sale_over_on_hand')), findsNothing);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('counter_sale_confirm')))
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('server stock refusal shows available and keeps sale', (
    tester,
  ) async {
    fakeCreate.result = Left(
      BusinessRuleFailure(InventoryStrings.onlyAvailable('2.000')),
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await openTender(tester);
    await tester.tap(find.byKey(const Key('counter_sale_method_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('counter_sale_confirm')));
    await tester.pumpAndSettle();

    expect(find.text(InventoryStrings.onlyAvailable('2.000')), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_confirm')), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_posted_number')), findsNothing);
  });

  testWidgets('unmapped payment method keeps sale with Go-live message', (
    tester,
  ) async {
    fakeCreate.result = const Left(
      BusinessRuleFailure(InventoryStrings.mapPaymentMethodHint),
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await openTender(tester);
    await tester.tap(find.byKey(const Key('counter_sale_method_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('counter_sale_confirm')));
    await tester.pumpAndSettle();

    expect(find.text(InventoryStrings.mapPaymentMethodHint), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_confirm')), findsOneWidget);
  });

  testWidgets('tender mismatch shows expected total and keeps sale', (
    tester,
  ) async {
    fakeCreate.result = Left(
      BusinessRuleFailure(InventoryStrings.expectedTotal('120.00')),
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await openTender(tester);
    await tester.tap(find.byKey(const Key('counter_sale_method_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('counter_sale_confirm')));
    await tester.pumpAndSettle();

    expect(find.text(InventoryStrings.expectedTotal('120.00')), findsOneWidget);
    expect(find.byKey(const Key('counter_sale_confirm')), findsOneWidget);
  });

  testWidgets('leaving Counter Sale before confirm drops the open sale', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await openTender(tester);
    await tester.tap(find.byKey(const Key('counter_sale_method_1')));
    await tester.pumpAndSettle();

    expect(cubit.state.lines, isNotEmpty);
    cubit.discardOpenSale();
    await tester.pumpAndSettle();

    expect(cubit.state.lines, isEmpty);
    expect(cubit.state.step, CounterSaleStep.catalog);
    expect(cubit.state.selectedPaymentMethodId, isNull);
    expect(cubit.confirmIdempotencyKeyForTest, isNull);
  });
}
