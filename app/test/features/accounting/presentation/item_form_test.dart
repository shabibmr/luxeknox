import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/entities/item.dart';
import 'package:luxeknox/features/accounting/domain/usecases/create_item_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_account_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_item_categories_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_item_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_tax_codes_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/update_item_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/item_form_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/item_form_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _Session extends MockCubit<SessionState> implements SessionCubit {}

class _GetCategories extends Mock implements GetItemCategoriesUseCase {}

class _GetItem extends Mock implements GetItemUseCase {}

class _Create extends Mock implements CreateItemUseCase {}

class _Update extends Mock implements UpdateItemUseCase {}

class _GetAccount extends Mock implements GetAccountUseCase {}

class _GetTax extends Mock implements GetTaxCodesUseCase {}

const _uom = Uom(id: 1, code: 'NOS', name: 'Numbers', decimalPlaces: 0);

const _blankDraft = ItemDraft(
  name: 'x',
  kind: 'goods',
  uomId: 1,
  incomeAccountId: 1,
  expenseAccountId: 1,
);

Account _acct(String id) => Account(id: id, name: 'Acct $id', type: 'asset');

Item _item({bool hasMovements = false, bool tracked = false}) => Item(
  id: 9,
  name: 'Protein',
  kind: 'goods',
  uomId: 1,
  uomCode: 'NOS',
  uomDecimalPlaces: 0,
  incomeAccountId: 4000,
  expenseAccountId: 5000,
  inventoryTracked: tracked,
  inventoryAccountId: tracked ? 1400 : null,
  cogsAccountId: tracked ? 5050 : null,
  hasMovements: hasMovements,
);

void main() {
  late _GetItem getItem;
  late _Create create;
  late _Update update;
  late _GetAccount getAccount;
  late _GetTax getTax;
  late ItemFormCubit cubit;

  setUpAll(() {
    registerFallbackValue(_blankDraft);
    registerFallbackValue(const GetAccountParams(id: '1'));
    registerFallbackValue(const GetTaxCodesParams());
    registerFallbackValue(const NoParams());
    registerFallbackValue(const UpdateItemParams(id: 1, draft: _blankDraft));
  });

  setUp(() {
    getItem = _GetItem();
    create = _Create();
    update = _Update();
    getAccount = _GetAccount();
    getTax = _GetTax();
    when(() => getAccount(any())).thenAnswer(
      (i) async =>
          Right(_acct((i.positionalArguments.first as GetAccountParams).id)),
    );
    cubit = ItemFormCubit(getItem, create, update, getAccount, getTax);
    final categories = _GetCategories();
    when(() => categories(any())).thenAnswer((_) async => const Right([]));
    if (getIt.isRegistered<GetItemCategoriesUseCase>()) {
      getIt.unregister<GetItemCategoriesUseCase>();
    }
    getIt.registerFactory<GetItemCategoriesUseCase>(() => categories);
  });

  tearDown(() {
    cubit.close();
    if (getIt.isRegistered<GetItemCategoriesUseCase>()) {
      getIt.unregister<GetItemCategoriesUseCase>();
    }
  });

  void fillValid() {
    cubit
      ..nameChanged('Tea')
      ..uomChanged(_uom)
      ..incomeAccountChanged(_acct('4000'))
      ..expenseAccountChanged(_acct('5000'));
  }

  group('ItemFormCubit', () {
    test('name is required', () async {
      cubit
        ..uomChanged(_uom)
        ..incomeAccountChanged(_acct('4000'))
        ..expenseAccountChanged(_acct('5000'));
      expect(await cubit.submit(), isFalse);
      expect(cubit.state.errors['name'], AccountingStrings.itemNameRequired);
      verifyNever(() => create(any()));
    });

    test('negative rate is rejected', () async {
      fillValid();
      cubit.saleRateChanged('-1');
      expect(await cubit.submit(), isFalse);
      expect(
        cubit.state.errors['saleRate'],
        AccountingStrings.itemRateInvalid,
      );
    });

    test('tracking on without accounts is refused', () async {
      when(
        () => getAccount(any()),
      ).thenAnswer((_) async => const Left(NotFoundFailure()));
      fillValid();
      await cubit.trackingChanged(true);
      expect(await cubit.submit(), isFalse);
      expect(
        cubit.state.errors.keys,
        containsAll(['inventoryAccount', 'cogsAccount']),
      );
    });

    test('tracking defaults to the 1400 and 5050 accounts', () async {
      await cubit.trackingChanged(true);
      expect(cubit.state.inventoryAccount?.id, '1400');
      expect(cubit.state.cogsAccount?.id, '5050');
    });

    test('create payload is right', () async {
      when(() => create(any())).thenAnswer((_) async => Right(_item()));
      fillValid();
      cubit.saleRateChanged('12.5');
      expect(await cubit.submit(), isTrue);
      final d = verify(() => create(captureAny())).captured.single as ItemDraft;
      expect(d.name, 'Tea');
      expect(d.uomId, 1);
      expect(d.incomeAccountId, 4000);
      expect(d.saleRate, '12.5');
      expect(d.inventoryTracked, isFalse);
      expect(d.inventoryAccountId, isNull);
    });

    test('edit locks fields and sends an update', () async {
      when(() => update(any())).thenAnswer((_) async => Right(_item()));
      await cubit.loadForEdit(
        9,
        initial: _item(hasMovements: true, tracked: true),
      );
      expect(cubit.state.isEdit, isTrue);
      cubit.kindChanged('service');
      cubit.uomChanged(
        const Uom(id: 2, code: 'KG', name: 'Kg', decimalPlaces: 3),
      );
      await cubit.trackingChanged(false);
      expect(cubit.state.kind, 'goods');
      expect(cubit.state.uom?.id, 1);
      expect(cubit.state.inventoryTracked, isTrue);
      cubit.nameChanged('Protein X');
      expect(await cubit.submit(), isTrue);
      final p =
          verify(() => update(captureAny())).captured.single
              as UpdateItemParams;
      expect(p.id, 9);
      expect(p.draft.name, 'Protein X');
      expect(p.draft.inventoryAccountId, 1400);
    });

    test('API error becomes a form-level failure', () async {
      when(() => create(any())).thenAnswer(
        (_) async => const Left(BusinessRuleFailure('SKU already exists')),
      );
      fillValid();
      expect(await cubit.submit(), isFalse);
      expect(
        cubit.state.failure,
        const BusinessRuleFailure('SKU already exists'),
      );
      expect(cubit.state.isSubmitting, isFalse);
    });
  });

  group('ItemFormScreen', () {
    Widget host() {
      final session = _Session();
      whenListen(
        session,
        const Stream<SessionState>.empty(),
        initialState: const SessionAuthenticated(
          principal: Principal(
            userId: '1',
            userType: UserType.admin,
            displayName: 'Admin',
            profileId: 'p1',
          ),
          capabilities: Capabilities(slugs: ['accounting.accounts_write']),
        ),
      );
      return BlocProvider<SessionCubit>.value(
        value: session,
        child: MaterialApp(home: ItemFormScreen(cubit: cubit)),
      );
    }

    testWidgets('tracking section toggles; submit disabled when invalid', (
      tester,
    ) async {
      await tester.pumpWidget(host());
      final save = find.byKey(const Key('item_save_button'));
      expect(tester.widget<ElevatedButton>(save).onPressed, isNull);

      expect(
        find.byKey(const Key('item_inventory_account_field')),
        findsNothing,
      );
      await tester.ensureVisible(find.byKey(const Key('item_tracked_switch')));
      await tester.tap(find.byKey(const Key('item_tracked_switch')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('item_inventory_account_field')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('item_cogs_account_field')), findsOneWidget);

      await tester.tap(find.byKey(const Key('item_tracked_switch')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('item_inventory_account_field')),
        findsNothing,
      );

      cubit.nameChanged('Tea');
      await tester.pumpAndSettle();
      expect(tester.widget<ElevatedButton>(save).onPressed, isNotNull);
    });

    testWidgets('server error text is shown', (tester) async {
      when(() => create(any())).thenAnswer(
        (_) async => const Left(BusinessRuleFailure('SKU already exists')),
      );
      fillValid();
      await tester.pumpWidget(host());
      await cubit.submit();
      await tester.pump();
      expect(find.text('SKU already exists'), findsOneWidget);
    });
  });
}
