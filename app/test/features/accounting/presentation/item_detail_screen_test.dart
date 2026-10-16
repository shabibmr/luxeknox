import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/router/routes.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/entities/item.dart';
import 'package:luxeknox/features/accounting/domain/entities/tax_code.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_accounts_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_tax_codes_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/item_detail_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/item_detail_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockItemDetailCubit extends MockCubit<ItemDetailState>
    implements ItemDetailCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

class MockGetAccountsUseCase extends Mock implements GetAccountsUseCase {}

class MockGetTaxCodesUseCase extends Mock implements GetTaxCodesUseCase {}

void main() {
  late MockItemDetailCubit cubit;
  late MockGetAccountsUseCase getAccounts;
  late MockGetTaxCodesUseCase getTaxCodes;

  const tTracked = Item(
    id: 1,
    name: 'Protein Bar',
    kind: 'goods',
    sku: 'PB-001',
    categoryName: 'Snacks',
    uomId: 10,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    saleRate: '50.00',
    purchaseRate: '30.00',
    taxCodeId: 7,
    incomeAccountId: 100,
    expenseAccountId: 200,
    inventoryAccountId: 300,
    cogsAccountId: 400,
    inventoryTracked: true,
    reorderLevel: '5.000',
    hasMovements: true,
  );

  const tService = Item(
    id: 2,
    name: 'PT Session',
    kind: 'service',
    uomId: 10,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 100,
    expenseAccountId: 200,
  );

  Widget wrap(Item item, {List<String> slugs = const ['inventory.read']}) {
    when(() => cubit.state).thenReturn(
      ItemDetailState(status: LoadStatus.success, item: item),
    );
    final session = MockSessionCubit();
    whenListen(
      session,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: const Principal(
          userId: '1',
          userType: UserType.admin,
          displayName: 'Admin',
          profileId: 'p1',
        ),
        capabilities: Capabilities(slugs: slugs),
      ),
    );
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => ItemDetailScreen(
            itemId: item.id,
            cubit: cubit,
            getAccounts: getAccounts,
            getTaxCodes: getTaxCodes,
          ),
        ),
        GoRoute(
          path: Routes.adminAccountingItemEditById('${item.id}'),
          builder: (_, _) => const Text('edit-screen'),
        ),
      ],
    );
    return BlocProvider<SessionCubit>.value(
      value: session,
      child: MaterialApp.router(routerConfig: router),
    );
  }

  setUp(() {
    cubit = MockItemDetailCubit();
    getAccounts = MockGetAccountsUseCase();
    getTaxCodes = MockGetTaxCodesUseCase();
    registerFallbackValue(const GetAccountsParams());
    registerFallbackValue(const GetTaxCodesParams());
    when(() => getAccounts(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<Account>(
          items: [
            Account(id: '100', name: 'Sales Income', type: 'income'),
            Account(id: '200', name: 'Cost of Sales', type: 'expense'),
            Account(id: '300', name: 'Inventory Asset', type: 'asset'),
            Account(id: '400', name: 'COGS', type: 'expense'),
          ],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
    when(() => getTaxCodes(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<TaxCode>(
          items: [
            TaxCode(id: '7', code: 'GST18', name: 'GST 18%', ratePercent: '18'),
          ],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
  });

  testWidgets('tracked item shows all sections with resolved names', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(wrap(tTracked));
    await tester.pumpAndSettle();

    expect(find.text('Protein Bar'), findsOneWidget);
    expect(find.text('PB-001'), findsOneWidget);
    expect(find.text('Sales Income'), findsOneWidget);
    expect(find.text('Inventory Asset'), findsOneWidget);
    expect(find.text('COGS'), findsOneWidget);
    expect(find.text('GST 18%'), findsOneWidget);
    expect(find.text('5.000'), findsOneWidget);
    expect(find.text(AccountingStrings.itemInventoryAccountLabel),
        findsOneWidget);
  });

  testWidgets('untracked item shows em dashes and no inventory accounts', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(wrap(tService));
    await tester.pumpAndSettle();

    expect(find.text(AccountingStrings.itemEmDash), findsWidgets);
    expect(find.text(AccountingStrings.itemInventoryAccountLabel),
        findsNothing);
    expect(find.text(AccountingStrings.itemCogsAccountLabel), findsNothing);
  });

  testWidgets('Edit is hidden without accounting.accounts_write', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(tTracked));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.edit_outlined), findsNothing);
  });

  testWidgets('Edit is shown with write access and navigates', (tester) async {
    await tester.pumpWidget(
      wrap(tTracked, slugs: const ['inventory.read', 'accounting.accounts_write']),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    expect(find.text('edit-screen'), findsOneWidget);
  });
}
