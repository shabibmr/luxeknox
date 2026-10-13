import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/widgets/app_error_view.dart';
import 'package:luxeknox/core/widgets/app_loading.dart';
import 'package:luxeknox/features/accounting/domain/entities/expense_voucher.dart';
import 'package:luxeknox/features/accounting/domain/entities/purchase_bill.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/expense_detail_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/expense_detail_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockExpenseDetailCubit extends MockCubit<ExpenseDetailState>
    implements ExpenseDetailCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockExpenseDetailCubit mockExpenseDetailCubit;
  late MockSessionCubit mockSessionCubit;

  final tDate = DateTime.utc(2026, 10, 15);

  final tDraftExpense = ExpenseVoucher(
    id: 'exp-100',
    voucherNumber: 'EXP-2026-0100',
    expenseDate: tDate,
    bankAccountId: '1020',
    totalAmount: '250.00',
    taxAmount: '0.00',
    status: 'draft',
    memo: 'Office Supplies Inc',
    lines: const [
      PurchaseBillLine(
        id: 'l-1',
        billId: 'exp-100',
        accountId: '6010',
        description: 'Copy paper and toner',
        quantity: '1',
        unitPrice: '250.00',
        amount: '250.00',
      ),
    ],
  );

  final tPostedExpense = ExpenseVoucher(
    id: 'exp-100',
    voucherNumber: 'EXP-2026-0100',
    expenseDate: tDate,
    bankAccountId: '1020',
    totalAmount: '250.00',
    taxAmount: '0.00',
    status: 'posted',
    journalEntryId: 'JRN-2026-0789',
    memo: 'Office Supplies Inc',
    lines: const [
      PurchaseBillLine(
        id: 'l-1',
        billId: 'exp-100',
        accountId: '6010',
        description: 'Copy paper and toner',
        quantity: '1',
        unitPrice: '250.00',
        amount: '250.00',
      ),
    ],
  );

  const writeCapabilities = Capabilities(
    slugs: ['accounting.read', 'accounting.expenses_write'],
  );
  const readOnlyCapabilities = Capabilities(
    slugs: ['accounting.read'],
  );
  const noCapabilities = Capabilities(
    slugs: [],
  );

  const tPrincipal = Principal(
    userId: 'u1',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'p1',
  );

  setUpAll(() {
    registerFallbackValue(tDraftExpense);
  });

  setUp(() {
    mockExpenseDetailCubit = MockExpenseDetailCubit();
    mockSessionCubit = MockSessionCubit();

    when(() => mockExpenseDetailCubit.load(any()))
        .thenAnswer((_) async {});
    when(() => mockExpenseDetailCubit.post())
        .thenAnswer((_) async => true);
    when(() => mockExpenseDetailCubit.setExpense(any()))
        .thenReturn(null);

    if (getIt.isRegistered<ExpenseDetailCubit>()) {
      getIt.unregister<ExpenseDetailCubit>();
    }
    getIt.registerFactory<ExpenseDetailCubit>(() => mockExpenseDetailCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<ExpenseDetailCubit>()) {
      getIt.unregister<ExpenseDetailCubit>();
    }
  });

  Widget buildTestableWidget({
    Capabilities capabilities = writeCapabilities,
    ExpenseDetailState state = const ExpenseDetailState(
      status: LoadStatus.success,
    ),
    ExpenseDetailCubit? cubit,
    String expenseId = 'exp-100',
    ExpenseVoucher? initialExpense,
  }) {
    whenListen(
      mockSessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: tPrincipal,
        capabilities: capabilities,
      ),
    );

    whenListen(
      mockExpenseDetailCubit,
      const Stream<ExpenseDetailState>.empty(),
      initialState: state,
    );

    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: mockSessionCubit,
        child: ExpenseDetailScreen(
          expenseId: expenseId,
          cubit: cubit ?? mockExpenseDetailCubit,
          initialExpense: initialExpense,
        ),
      ),
    );
  }

  group('Permission check', () {
    testWidgets('displays no permission when user lacks accounting.read',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: noCapabilities,
          state: ExpenseDetailState(
            status: LoadStatus.success,
            expense: tDraftExpense,
          ),
        ),
      );

      expect(find.text(AccountingStrings.noPermission), findsOneWidget);
    });
  });

  group('Expense details rendering', () {
    testWidgets('renders expense header, lines table, and totals',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: ExpenseDetailState(
            status: LoadStatus.success,
            expense: tDraftExpense,
          ),
        ),
      );

      expect(find.byKey(const Key('expense_number_text')), findsOneWidget);
      expect(find.text('EXP-2026-0100'), findsOneWidget);
      expect(find.byKey(const Key('expense_status_chip')), findsOneWidget);
      expect(find.text('Draft'), findsOneWidget);
      expect(find.text('Office Supplies Inc'), findsOneWidget);
      expect(find.text('Copy paper and toner'), findsOneWidget);
      expect(find.byKey(const Key('expense_total_amount')), findsOneWidget);
      expect(find.text('\$250.00'), findsWidgets);
    });

    testWidgets('renders journal entry number when expense is posted',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: ExpenseDetailState(
            status: LoadStatus.success,
            expense: tPostedExpense,
          ),
        ),
      );

      expect(find.byKey(const Key('journal_entry_badge')), findsOneWidget);
      expect(find.text('${AccountingStrings.journalNumberLabel}: JRN-2026-0789'),
          findsOneWidget);
      expect(find.text('Posted'), findsOneWidget);
    });
  });

  group('CRITICAL ACC-095: Post button and posting workflow', () {
    testWidgets(
        'shows Post button when draft and user has expenses_write capability',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: ExpenseDetailState(
            status: LoadStatus.success,
            expense: tDraftExpense,
          ),
        ),
      );

      expect(find.byKey(const Key('post_expense_button')), findsOneWidget);
    });

    testWidgets('hides Post button when expense is already posted',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: ExpenseDetailState(
            status: LoadStatus.success,
            expense: tPostedExpense,
          ),
        ),
      );

      expect(find.byKey(const Key('post_expense_button')), findsNothing);
    });

    testWidgets('hides Post button when user lacks expenses_write capability',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: readOnlyCapabilities,
          state: ExpenseDetailState(
            status: LoadStatus.success,
            expense: tDraftExpense,
          ),
        ),
      );

      expect(find.byKey(const Key('post_expense_button')), findsNothing);
    });

    testWidgets(
        'clicking Post button shows confirmation dialog and confirming calls cubit.post()',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: ExpenseDetailState(
            status: LoadStatus.success,
            expense: tDraftExpense,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('post_expense_button')));
      await tester.pumpAndSettle();

      expect(find.text(AccountingStrings.postExpenseConfirm), findsOneWidget);

      await tester.tap(find.byKey(const Key('post_confirm_button')));
      await tester.pumpAndSettle();

      verify(() => mockExpenseDetailCubit.post()).called(1);
    });

    testWidgets(
        'cancelling Post confirmation dialog does not call cubit.post()',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: ExpenseDetailState(
            status: LoadStatus.success,
            expense: tDraftExpense,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('post_expense_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('post_cancel_button')));
      await tester.pumpAndSettle();

      verifyNever(() => mockExpenseDetailCubit.post());
    });
  });

  group('Loading and Error states', () {
    testWidgets('renders loading widget when loading', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const ExpenseDetailState(
            status: LoadStatus.loading,
            expense: null,
          ),
        ),
      );

      expect(find.byType(AppLoading), findsOneWidget);
    });

    testWidgets('renders error view and retrying calls load', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const ExpenseDetailState(
            status: LoadStatus.failure,
            failure: BusinessRuleFailure('Error loading expense'),
            expense: null,
          ),
        ),
      );

      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.text('Error loading expense'), findsOneWidget);

      await tester.tap(find.text(AccountingStrings.retry));
      await tester.pump();

      verify(() => mockExpenseDetailCubit.load('exp-100')).called(1);
    });
  });
}
