import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/widgets/app_error_view.dart';
import 'package:luxeknox/core/widgets/app_loading.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/account_form_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/account_form_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountFormCubit extends MockCubit<AccountFormState>
    implements AccountFormCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockAccountFormCubit mockAccountFormCubit;

  const tAdminPrincipal = Principal(
    userId: '1',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'p1',
  );

  const tWriteCapabilities = Capabilities(
    slugs: ['accounting.accounts_write'],
  );

  const tNoCapabilities = Capabilities(
    slugs: [],
  );

  const tAccount = Account(
    id: 'acc-1',
    name: 'Cash on Hand',
    type: 'asset',
    isActive: true,
    isBank: false,
    isControl: false,
  );

  const tControlAccount = Account(
    id: 'acc-control',
    name: 'Accounts Receivable',
    type: 'asset',
    isActive: true,
    isBank: false,
    isControl: true,
    description: 'receivable',
  );

  setUp(() {
    mockAccountFormCubit = MockAccountFormCubit();
    when(() => mockAccountFormCubit.state)
        .thenReturn(const AccountFormState());
    when(() => mockAccountFormCubit.load(any()))
        .thenAnswer((_) async {});
    when(
      () => mockAccountFormCubit.create(
        name: any(named: 'name'),
        accountType: any(named: 'accountType'),
        parentId: any(named: 'parentId'),
        isActive: any(named: 'isActive'),
        isBank: any(named: 'isBank'),
        isControl: any(named: 'isControl'),
        controlRole: any(named: 'controlRole'),
      ),
    ).thenAnswer((_) async => true);
    when(
      () => mockAccountFormCubit.update(
        id: any(named: 'id'),
        name: any(named: 'name'),
        parentId: any(named: 'parentId'),
        isActive: any(named: 'isActive'),
        isBank: any(named: 'isBank'),
      ),
    ).thenAnswer((_) async => true);

    if (getIt.isRegistered<AccountFormCubit>()) {
      getIt.unregister<AccountFormCubit>();
    }
    getIt.registerFactory<AccountFormCubit>(() => mockAccountFormCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<AccountFormCubit>()) {
      getIt.unregister<AccountFormCubit>();
    }
  });

  Widget wrap(
    Widget child, {
    Capabilities capabilities = tWriteCapabilities,
  }) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: tAdminPrincipal,
        capabilities: capabilities,
      ),
    );

    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: child,
      ),
    );
  }

  Widget wrapPushed(
    Widget child, {
    Capabilities capabilities = tWriteCapabilities,
    void Function(dynamic result)? onResult,
  }) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: tAdminPrincipal,
        capabilities: capabilities,
      ),
    );

    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                final result = await Navigator.of(context).push<dynamic>(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider<SessionCubit>.value(
                      value: sessionCubit,
                      child: child,
                    ),
                  ),
                );
                onResult?.call(result);
              },
              child: const Text('Open Screen'),
            ),
          ),
        ),
      ),
    );
  }

  group('AccountFormScreen - Permission Guard', () {
    testWidgets('shows noPermission message when capability is missing',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          AccountFormScreen(cubit: mockAccountFormCubit),
          capabilities: tNoCapabilities,
        ),
      );

      expect(find.text(AccountingStrings.noPermission), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);
    });
  });

  group('AccountFormScreen - Create Mode', () {
    testWidgets('renders all fields and creates account on submit',
        (tester) async {
      dynamic popResult;
      await tester.pumpWidget(
        wrapPushed(
          AccountFormScreen(cubit: mockAccountFormCubit),
          onResult: (res) => popResult = res,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Screen'));
      await tester.pumpAndSettle();

      expect(find.text(AccountingStrings.createAccountTitle), findsOneWidget);
      expect(find.widgetWithText(TextFormField, AccountingStrings.nameLabel),
          findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(
        find.widgetWithText(
          TextFormField,
          AccountingStrings.parentAccountLabel,
        ),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(SwitchListTile, AccountingStrings.isBankLabel),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(SwitchListTile, AccountingStrings.isControlLabel),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(SwitchListTile, AccountingStrings.isActiveLabel),
        findsOneWidget,
      );

      // Enter name and pick type
      await tester.enterText(
        find.widgetWithText(TextFormField, AccountingStrings.nameLabel),
        'Main Operating Account',
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AccountingStrings.accountTypeAsset).last);
      await tester.pumpAndSettle();

      // Tap Bank toggle
      await tester.tap(
        find.widgetWithText(SwitchListTile, AccountingStrings.isBankLabel),
      );
      await tester.pumpAndSettle();

      // Submit via bottom button
      await tester.tap(find.widgetWithText(ElevatedButton, AccountingStrings.create));
      await tester.pumpAndSettle();

      verify(
        () => mockAccountFormCubit.create(
          name: 'Main Operating Account',
          accountType: 'asset',
          parentId: null,
          isActive: true,
          isBank: true,
          isControl: false,
          controlRole: null,
        ),
      ).called(1);

      expect(popResult, isTrue);
      expect(
        find.text(AccountingStrings.accountSavedSuccess),
        findsOneWidget,
      );
    });

    testWidgets('shows validation errors when required fields are empty',
        (tester) async {
      await tester.pumpWidget(
        wrap(AccountFormScreen(cubit: mockAccountFormCubit)),
      );
      await tester.pumpAndSettle();

      // Submit without entering data
      await tester.tap(find.widgetWithText(ElevatedButton, AccountingStrings.create));
      await tester.pumpAndSettle();

      expect(find.text(AccountingStrings.nameRequired), findsOneWidget);
      expect(find.text(AccountingStrings.typeRequired), findsOneWidget);

      verifyNever(
        () => mockAccountFormCubit.create(
          name: any(named: 'name'),
          accountType: any(named: 'accountType'),
          parentId: any(named: 'parentId'),
          isActive: any(named: 'isActive'),
          isBank: any(named: 'isBank'),
          isControl: any(named: 'isControl'),
          controlRole: any(named: 'controlRole'),
        ),
      );
    });

    testWidgets('displays error snackbar when cubit create fails',
        (tester) async {
      when(
        () => mockAccountFormCubit.create(
          name: any(named: 'name'),
          accountType: any(named: 'accountType'),
          parentId: any(named: 'parentId'),
          isActive: any(named: 'isActive'),
          isBank: any(named: 'isBank'),
          isControl: any(named: 'isControl'),
          controlRole: any(named: 'controlRole'),
        ),
      ).thenAnswer((_) async => false);

      when(() => mockAccountFormCubit.state).thenReturn(
        const AccountFormState(
          failure: BusinessRuleFailure('Unable to create account'),
        ),
      );

      await tester.pumpWidget(
        wrap(AccountFormScreen(cubit: mockAccountFormCubit)),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, AccountingStrings.nameLabel),
        'Cash',
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AccountingStrings.accountTypeAsset).last);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, AccountingStrings.create));
      await tester.pumpAndSettle();

      expect(find.text('Unable to create account'), findsOneWidget);
    });

    testWidgets('enabling isControl shows control role field', (tester) async {
      await tester.pumpWidget(
        wrap(AccountFormScreen(cubit: mockAccountFormCubit)),
      );
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(TextFormField, AccountingStrings.controlRoleLabel),
        findsNothing,
      );

      // Toggle control account on
      await tester.tap(
        find.widgetWithText(SwitchListTile, AccountingStrings.isControlLabel),
      );
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(TextFormField, AccountingStrings.controlRoleLabel),
        findsOneWidget,
      );
    });
  });

  group('AccountFormScreen - Edit Mode', () {
    testWidgets('renders existing account with disabled type',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          AccountFormScreen(
            account: tAccount,
            cubit: mockAccountFormCubit,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AccountingStrings.editAccountTitle), findsOneWidget);
      expect(find.text('Cash on Hand'), findsOneWidget);

      // Type dropdown is disabled (onChanged is null)
      final typeDropdown = tester.widget<DropdownButtonFormField<String>>(
        find.byType(DropdownButtonFormField<String>),
      );
      expect(typeDropdown.onChanged, isNull);

      // Control switch is disabled (onChanged is null)
      final controlSwitch = tester.widget<SwitchListTile>(
        find.widgetWithText(SwitchListTile, AccountingStrings.isControlLabel),
      );
      expect(controlSwitch.onChanged, isNull);
    });

    testWidgets('updates account successfully on submit', (tester) async {
      dynamic popResult;
      await tester.pumpWidget(
        wrapPushed(
          AccountFormScreen(
            account: tAccount,
            cubit: mockAccountFormCubit,
          ),
          onResult: (res) => popResult = res,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Screen'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, AccountingStrings.nameLabel),
        'Cash on Hand - Main Vault',
      );

      // Submit via AppBar save button
      await tester.tap(find.widgetWithText(TextButton, AccountingStrings.save));
      await tester.pumpAndSettle();

      verify(
        () => mockAccountFormCubit.update(
          id: tAccount.id,
          name: 'Cash on Hand - Main Vault',
          parentId: null,
          isActive: true,
          isBank: false,
        ),
      ).called(1);

      expect(popResult, isTrue);
      expect(
        find.text(AccountingStrings.accountSavedSuccess),
        findsOneWidget,
      );
    });

    testWidgets('toggling isActive to false prompts confirmation dialog',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          AccountFormScreen(
            account: tAccount,
            cubit: mockAccountFormCubit,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Active switch
      await tester.tap(
        find.widgetWithText(SwitchListTile, AccountingStrings.isActiveLabel),
      );
      await tester.pumpAndSettle();

      // Confirmation dialog should be displayed
      expect(
        find.text(AccountingStrings.deactivateAccountConfirm),
        findsOneWidget,
      );

      // Dismiss via Cancel
      await tester.tap(find.text(AccountingStrings.cancel));
      await tester.pumpAndSettle();

      expect(
        find.text(AccountingStrings.deactivateAccountConfirm),
        findsNothing,
      );

      // Active switch is still true
      var activeSwitch = tester.widget<SwitchListTile>(
        find.widgetWithText(SwitchListTile, AccountingStrings.isActiveLabel),
      );
      expect(activeSwitch.value, isTrue);

      // Tap Active switch again and confirm
      await tester.tap(
        find.widgetWithText(SwitchListTile, AccountingStrings.isActiveLabel),
      );
      await tester.pumpAndSettle();

      // Tap confirm action (button text: deactivateAccount)
      await tester.tap(
        find.widgetWithText(TextButton, AccountingStrings.deactivateAccount),
      );
      await tester.pumpAndSettle();

      activeSwitch = tester.widget<SwitchListTile>(
        find.widgetWithText(SwitchListTile, AccountingStrings.isActiveLabel),
      );
      expect(activeSwitch.value, isFalse);
    });

    testWidgets(
        'forbids deactivating control account and shows warning snackbar',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          AccountFormScreen(
            account: tControlAccount,
            cubit: mockAccountFormCubit,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Active switch on control account
      await tester.tap(
        find.widgetWithText(SwitchListTile, AccountingStrings.isActiveLabel),
      );
      await tester.pumpAndSettle();

      // Confirmation dialog should NOT appear
      expect(
        find.text(AccountingStrings.deactivateAccountConfirm),
        findsNothing,
      );

      // Warning snackbar should appear
      expect(
        find.text(AccountingStrings.cannotDeactivateControl),
        findsOneWidget,
      );

      // Switch stays true
      final activeSwitch = tester.widget<SwitchListTile>(
        find.widgetWithText(SwitchListTile, AccountingStrings.isActiveLabel),
      );
      expect(activeSwitch.value, isTrue);
    });

    testWidgets('loads account via accountId and shows loading state',
        (tester) async {
      when(() => mockAccountFormCubit.state).thenReturn(
        const AccountFormState(status: LoadStatus.loading),
      );

      await tester.pumpWidget(
        wrap(
          AccountFormScreen(
            accountId: 'acc-1',
            cubit: mockAccountFormCubit,
          ),
        ),
      );

      verify(() => mockAccountFormCubit.load('acc-1')).called(1);
      expect(find.byType(AppLoading), findsOneWidget);
    });

    testWidgets('shows AppErrorView when initial load by accountId fails',
        (tester) async {
      when(() => mockAccountFormCubit.state).thenReturn(
        const AccountFormState(
          status: LoadStatus.failure,
          failure: BusinessRuleFailure('Account not found'),
        ),
      );

      await tester.pumpWidget(
        wrap(
          AccountFormScreen(
            accountId: 'acc-999',
            cubit: mockAccountFormCubit,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.text('Account not found'), findsOneWidget);
    });
  });
}
