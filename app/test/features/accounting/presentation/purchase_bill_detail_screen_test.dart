import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/widgets/app_error_view.dart';
import 'package:luxeknox/core/widgets/app_loading.dart';
import 'package:luxeknox/core/widgets/app_status_chip.dart';
import 'package:luxeknox/features/accounting/domain/entities/purchase_bill.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/purchase_bill_detail_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/purchase_bill_detail_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockPurchaseBillDetailCubit extends MockCubit<PurchaseBillDetailState>
    implements PurchaseBillDetailCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockPurchaseBillDetailCubit mockPurchaseBillDetailCubit;
  late MockSessionCubit mockSessionCubit;

  final tDate = DateTime.utc(2026, 10, 15);

  final tDraftBill = PurchaseBill(
    id: 'pb-10',
    billNumber: 'BILL-2026-0010',
    vendorId: 'v-101',
    vendorName: 'Apex Equipment Co',
    billDate: tDate,
    dueDate: tDate.add(const Duration(days: 30)),
    subtotal: '1000.00',
    taxAmount: '180.00',
    totalAmount: '1180.00',
    status: 'draft',
    allocatedAmount: '0.00',
    lines: const [
      PurchaseBillLine(
        id: 'pbl-1',
        billId: 'pb-10',
        accountId: 'acc-500',
        description: 'Commercial Treadmill',
        quantity: '1',
        unitPrice: '1000.00',
        amount: '1000.00',
        taxCodeId: 'tc-1',
        taxAmount: '180.00',
      ),
    ],
  );

  final tPostedBill = PurchaseBill(
    id: 'pb-10',
    billNumber: 'BILL-2026-0010',
    vendorId: 'v-101',
    vendorName: 'Apex Equipment Co',
    billDate: tDate,
    dueDate: tDate.add(const Duration(days: 30)),
    subtotal: '1000.00',
    taxAmount: '180.00',
    totalAmount: '1180.00',
    status: 'posted',
    allocatedAmount: '0.00',
    journalEntryId: 'JRN-2026-0088',
    lines: const [
      PurchaseBillLine(
        id: 'pbl-1',
        billId: 'pb-10',
        accountId: 'acc-500',
        description: 'Commercial Treadmill',
        quantity: '1',
        unitPrice: '1000.00',
        amount: '1000.00',
        taxCodeId: 'tc-1',
        taxAmount: '180.00',
      ),
    ],
  );

  const writeCapabilities = Capabilities(
    slugs: ['accounting.read', 'accounting.purchases_write'],
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
    registerFallbackValue(tDraftBill);
  });

  setUp(() {
    mockPurchaseBillDetailCubit = MockPurchaseBillDetailCubit();
    mockSessionCubit = MockSessionCubit();

    when(() => mockPurchaseBillDetailCubit.load(any()))
        .thenAnswer((_) async {});
    when(() => mockPurchaseBillDetailCubit.setBill(any()))
        .thenReturn(null);

    if (getIt.isRegistered<PurchaseBillDetailCubit>()) {
      getIt.unregister<PurchaseBillDetailCubit>();
    }
    getIt.registerFactory<PurchaseBillDetailCubit>(
      () => mockPurchaseBillDetailCubit,
    );
  });

  tearDown(() {
    if (getIt.isRegistered<PurchaseBillDetailCubit>()) {
      getIt.unregister<PurchaseBillDetailCubit>();
    }
  });

  Widget buildTestableWidget({
    Capabilities capabilities = writeCapabilities,
    PurchaseBillDetailState state = const PurchaseBillDetailState(
      status: LoadStatus.success,
    ),
    PurchaseBillDetailCubit? cubit,
    String billId = 'pb-10',
    PurchaseBill? initialBill,
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
      mockPurchaseBillDetailCubit,
      const Stream<PurchaseBillDetailState>.empty(),
      initialState: state,
    );

    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: mockSessionCubit,
        child: PurchaseBillDetailScreen(
          billId: billId,
          cubit: cubit ?? mockPurchaseBillDetailCubit,
          initialBill: initialBill,
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
          state: PurchaseBillDetailState(
            status: LoadStatus.success,
            bill: tDraftBill,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AccountingStrings.noPermission), findsOneWidget);
      expect(find.text('BILL-2026-0010'), findsNothing);
      expect(find.byKey(const Key('post_bill_button')), findsNothing);
    });
  });

  group('Bill Details rendering', () {
    testWidgets(
        'renders bill header, vendor, dates, status chip, line items table, and totals',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: PurchaseBillDetailState(
            status: LoadStatus.success,
            bill: tDraftBill,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Title
      expect(find.text(AccountingStrings.billDetailTitle), findsOneWidget);

      // Bill Number & Status chip
      expect(find.text('BILL-2026-0010'), findsOneWidget);
      expect(
        find.widgetWithText(AppStatusChip, AccountingStrings.statusDraft),
        findsOneWidget,
      );

      // Vendor & Dates
      expect(find.text('Apex Equipment Co'), findsOneWidget);
      expect(find.text('2026-10-15'), findsOneWidget); // Bill Date
      expect(find.text('2026-11-14'), findsOneWidget); // Due Date

      // Line items table
      expect(find.text('Commercial Treadmill'), findsOneWidget);
      expect(find.text('acc-500'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text(AccountingStrings.formatAmount(1000.0)), findsAtLeastNWidgets(2));
      expect(find.text(AccountingStrings.formatAmount(180.0)), findsAtLeastNWidgets(2));

      // Totals
      expect(find.text(AccountingStrings.subtotalLabel), findsOneWidget);
      expect(find.text(AccountingStrings.taxAmountLabel), findsAtLeastNWidgets(1));
      expect(find.text(AccountingStrings.totalAmountLabel), findsOneWidget);
      expect(find.text(AccountingStrings.formatAmount(1180.0)), findsOneWidget);
    });
  });

  group('Posted bill', () {
    testWidgets('shows the journal entry id and no Post button', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          capabilities: writeCapabilities,
          state: PurchaseBillDetailState(
            status: LoadStatus.success,
            bill: tPostedBill,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('post_bill_button')), findsNothing);
      expect(
        find.widgetWithText(AppStatusChip, AccountingStrings.statusPosted),
        findsOneWidget,
      );
      expect(find.byKey(const Key('journal_entry_id_text')), findsOneWidget);
      expect(find.text('JRN-2026-0088'), findsOneWidget);
      expect(find.text(AccountingStrings.journalNumberLabel), findsOneWidget);
    });
  });

  group('Loading and Error states', () {
    testWidgets('shows loading indicator on loading state', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const PurchaseBillDetailState(
            status: LoadStatus.loading,
            bill: null,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(AppLoading), findsOneWidget);
    });

    testWidgets('shows error view and retry invokes cubit.load',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          state: const PurchaseBillDetailState(
            status: LoadStatus.failure,
            failure: NetworkFailure(),
            bill: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorView), findsOneWidget);

      await tester.tap(find.text(AccountingStrings.retry));
      await tester.pump();

      verify(() => mockPurchaseBillDetailCubit.load('pb-10')).called(1);
    });
  });
}
