import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/accounts_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/widgets/account_picker_sheet.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountsCubit extends MockCubit<AccountsState>
    implements AccountsCubit {}

void main() {
  late MockAccountsCubit mockAccountsCubit;

  const tActiveAccount = Account(
    id: '1',
    code: '1010',
    name: 'Operating Bank Account',
    type: 'asset',
    isBank: true,
    isControl: false,
    isActive: true,
  );

  const tInactiveAccount = Account(
    id: '2',
    code: '2020',
    name: 'Deactivated Term Loan',
    type: 'liability',
    isBank: false,
    isControl: false,
    isActive: false,
  );

  setUp(() {
    mockAccountsCubit = MockAccountsCubit();

    when(() => mockAccountsCubit.load(
          accountType: any(named: 'accountType'),
          isActive: any(named: 'isActive'),
          search: any(named: 'search'),
          clearType: any(named: 'clearType'),
          clearActive: any(named: 'clearActive'),
        )).thenAnswer((_) async {});
    when(() => mockAccountsCubit.filterByType(any()))
        .thenAnswer((_) async {});
    when(() => mockAccountsCubit.filterByActive(any()))
        .thenAnswer((_) async {});
    when(() => mockAccountsCubit.setSearch(any())).thenAnswer((_) async {});

    if (getIt.isRegistered<AccountsCubit>()) {
      getIt.unregister<AccountsCubit>();
    }
    getIt.registerFactory<AccountsCubit>(() => mockAccountsCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<AccountsCubit>()) {
      getIt.unregister<AccountsCubit>();
    }
  });

  Widget buildPickerLauncher({
    bool activeOnly = true,
    String? accountType,
    AccountsState state = const AccountsState(
      status: LoadStatus.success,
      accounts: [tActiveAccount, tInactiveAccount],
    ),
    void Function(Account? picked)? onPicked,
  }) {
    whenListen(
      mockAccountsCubit,
      const Stream<AccountsState>.empty(),
      initialState: state,
    );

    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              final picked = await showAccountPickerSheet(
                context,
                activeOnly: activeOnly,
                accountType: accountType,
                cubit: mockAccountsCubit,
              );
              onPicked?.call(picked);
            },
            child: const Text('Open Picker'),
          ),
        ),
      ),
    );
  }

  testWidgets('picking an active account returns the account', (tester) async {
    Account? selectedAccount;

    await tester.pumpWidget(
      buildPickerLauncher(
        activeOnly: true,
        onPicked: (acc) => selectedAccount = acc,
      ),
    );

    // Open sheet
    await tester.tap(find.text('Open Picker'));
    await tester.pumpAndSettle();

    // Active account is visible by name only
    expect(find.text('Operating Bank Account'), findsOneWidget);
    expect(find.text('1010'), findsNothing);

    // Tap active account
    await tester.tap(find.text('Operating Bank Account'));
    await tester.pumpAndSettle();

    // Sheet dismissed and selected account is returned
    expect(selectedAccount, equals(tActiveAccount));
  });

  testWidgets(
      'ACC-093: deactivated account cannot be picked on a new document when activeOnly == true',
      (tester) async {
    Account? selectedAccount;

    await tester.pumpWidget(
      buildPickerLauncher(
        activeOnly: true,
        onPicked: (acc) => selectedAccount = acc,
      ),
    );

    // Open sheet
    await tester.tap(find.text('Open Picker'));
    await tester.pumpAndSettle();

    // Active account is present
    expect(find.text('Operating Bank Account'), findsOneWidget);

    // Deactivated account is excluded from the picker for new documents
    expect(find.text('Deactivated Term Loan'), findsNothing);
    expect(find.text('2020'), findsNothing);
    expect(selectedAccount, isNull);
  });

  testWidgets(
      'ACC-093: when activeOnly == false, deactivated account is visible but cannot be picked',
      (tester) async {
    Account? selectedAccount;

    await tester.pumpWidget(
      buildPickerLauncher(
        activeOnly: false,
        onPicked: (acc) => selectedAccount = acc,
      ),
    );

    // Open sheet
    await tester.tap(find.text('Open Picker'));
    await tester.pumpAndSettle();

    // Both active and inactive accounts are visible
    expect(find.text('Operating Bank Account'), findsOneWidget);
    expect(find.text('Deactivated Term Loan'), findsOneWidget);

    // Inactive account displays inactive badge
    expect(find.text(AccountingStrings.inactiveBadge), findsOneWidget);

    // Tap deactivated account
    await tester.tap(find.text('Deactivated Term Loan'));
    await tester.pumpAndSettle();

    // Warning is displayed and sheet remains open (cannot be picked)
    expect(
      find.text(AccountingStrings.cannotPickDeactivated),
      findsOneWidget,
    );
    expect(selectedAccount, isNull);
    expect(find.byType(AccountPickerSheet), findsOneWidget);
  });

  testWidgets('AccountPickerField renders formatted label and allows selection',
      (tester) async {
    Account? currentAccount = tActiveAccount;

    whenListen(
      mockAccountsCubit,
      const Stream<AccountsState>.empty(),
      initialState: const AccountsState(
        status: LoadStatus.success,
        accounts: [tActiveAccount],
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => AccountPickerField(
              value: currentAccount,
              cubit: mockAccountsCubit,
              onChanged: (account) {
                setState(() {
                  currentAccount = account;
                });
              },
            ),
          ),
        ),
      ),
    );

    // Displays account name only (no code in references)
    expect(find.text('Operating Bank Account'), findsOneWidget);
    expect(find.text('1010 - Operating Bank Account'), findsNothing);

    // Clear selection
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();

    expect(currentAccount, isNull);
    expect(find.text(AccountingStrings.selectAccount), findsAtLeastNWidgets(1));
  });

  testWidgets('search text in AccountPickerSheet triggers cubit.setSearch',
      (tester) async {
    await tester.pumpWidget(
      buildPickerLauncher(activeOnly: true),
    );

    await tester.tap(find.text('Open Picker'));
    await tester.pumpAndSettle();

    final searchField =
        find.byKey(const Key('account_picker_search_field'));
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'Operating');
    await tester.pump();

    verify(() => mockAccountsCubit.setSearch('Operating')).called(1);
  });
}
