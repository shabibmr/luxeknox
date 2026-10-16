import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/features/accounting/domain/entities/vendor.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/purchase_bill_form_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/purchase_bill_form_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockPurchaseBillFormCubit extends MockCubit<PurchaseBillFormState>
    implements PurchaseBillFormCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockPurchaseBillFormCubit mockPurchaseBillFormCubit;
  late MockSessionCubit mockSessionCubit;

  final tDate = DateTime.utc(2026, 10, 15);

  final tVendor = const Vendor(id: 'v-101', name: 'Acme Fitness Equipments');

  const writeCapabilities = Capabilities(
    slugs: ['accounting.read', 'accounting.purchases_write'],
  );
  const readOnlyCapabilities = Capabilities(
    slugs: ['accounting.read'],
  );

  const tPrincipal = Principal(
    userId: 'u1',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'p1',
  );

  setUp(() {
    mockPurchaseBillFormCubit = MockPurchaseBillFormCubit();
    mockSessionCubit = MockSessionCubit();

    when(() => mockPurchaseBillFormCubit.loadDependencies())
        .thenAnswer((_) async {});
    when(() => mockPurchaseBillFormCubit.saveAndPost())
        .thenAnswer((_) async => true);
    when(() => mockPurchaseBillFormCubit.saveDraft())
        .thenAnswer((_) async => true);
    when(() => mockPurchaseBillFormCubit.addLine()).thenReturn(null);
    when(() => mockPurchaseBillFormCubit.removeLine(any())).thenReturn(null);

    if (getIt.isRegistered<PurchaseBillFormCubit>()) {
      getIt.unregister<PurchaseBillFormCubit>();
    }
    getIt.registerFactory<PurchaseBillFormCubit>(
      () => mockPurchaseBillFormCubit,
    );
  });

  tearDown(() {
    if (getIt.isRegistered<PurchaseBillFormCubit>()) {
      getIt.unregister<PurchaseBillFormCubit>();
    }
  });

  Widget buildTestableWidget({
    Capabilities capabilities = writeCapabilities,
    PurchaseBillFormState? state,
    PurchaseBillFormCubit? cubit,
  }) {
    final formState = state ??
        PurchaseBillFormState(
          billDate: tDate,
          dueDate: tDate.add(const Duration(days: 30)),
          availableVendors: [tVendor],
        );

    whenListen(
      mockSessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: tPrincipal,
        capabilities: capabilities,
      ),
    );

    whenListen(
      mockPurchaseBillFormCubit,
      const Stream<PurchaseBillFormState>.empty(),
      initialState: formState,
    );

    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: mockSessionCubit,
        child: PurchaseBillFormScreen(
          cubit: cubit ?? mockPurchaseBillFormCubit,
        ),
      ),
    );
  }

  testWidgets(
      'displays no permission message when user lacks purchases_write capability',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(capabilities: readOnlyCapabilities),
    );
    await tester.pumpAndSettle();

    expect(find.text(AccountingStrings.noPermission), findsOneWidget);
    expect(find.byKey(const Key('submit_bill_button')), findsNothing);
  });

  testWidgets(
      'renders vendor picker, date pickers, line items, and summary preview',
      (tester) async {
    final formState = PurchaseBillFormState(
      vendorId: 'v-101',
      vendorName: 'Acme Fitness Equipments',
      billDate: tDate,
      dueDate: tDate.add(const Duration(days: 30)),
      availableVendors: [tVendor],
      lines: const [
        PurchaseBillLineDraft(
          accountId: 'acc-1',
          accountName: 'Equipment',
          description: 'Power Rack',
          quantity: '2',
          rate: '500.00',
          taxRatePercent: 10.0,
        ),
      ],
    );

    await tester.pumpWidget(buildTestableWidget(state: formState));
    await tester.pumpAndSettle();

    // Screen title
    expect(find.text(AccountingStrings.createBillTitle), findsOneWidget);

    // Vendor picker
    expect(find.byKey(const Key('vendor_picker_field')), findsOneWidget);

    // Date pickers
    expect(find.byKey(const Key('bill_date_picker')), findsOneWidget);
    expect(find.byKey(const Key('due_date_picker')), findsOneWidget);

    // Line items section
    expect(find.text('Line Items (1)'), findsOneWidget);
    expect(find.byKey(const Key('add_line_button')), findsOneWidget);
    expect(find.byKey(const Key('account_picker_0')), findsOneWidget);
    expect(find.byKey(const Key('description_field_0')), findsOneWidget);
    expect(find.byKey(const Key('quantity_field_0')), findsOneWidget);
    expect(find.byKey(const Key('rate_field_0')), findsOneWidget);
    expect(find.byKey(const Key('tax_code_field_0')), findsOneWidget);

    // Live Subtotal / Tax / Total amounts:
    // Subtotal: 2 * 500 = $1,000.00
    // Tax: 1000 * 10% = $100.00
    // Total: $1,100.00
    expect(find.byKey(const Key('subtotal_amount')), findsOneWidget);
    expect(find.text(AccountingStrings.formatAmount(1000.0)), findsAtLeastNWidgets(1));
    expect(find.byKey(const Key('tax_amount')), findsOneWidget);
    expect(find.text(AccountingStrings.formatAmount(100.0)), findsAtLeastNWidgets(1));
    expect(find.byKey(const Key('total_amount')), findsOneWidget);
    expect(find.text(AccountingStrings.formatAmount(1100.0)), findsAtLeastNWidgets(1));

    // Submit button
    expect(find.byKey(const Key('submit_bill_button')), findsOneWidget);
  });

  testWidgets('tapping add_line_button calls cubit.addLine', (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add_line_button')));
    await tester.pump();

    verify(() => mockPurchaseBillFormCubit.addLine()).called(1);
  });

  testWidgets('tapping submit button invokes cubit.saveAndPost when canSubmit is true',
      (tester) async {
    final validState = PurchaseBillFormState(
      vendorId: 'v-101',
      billDate: tDate,
      availableVendors: [tVendor],
      lines: const [
        PurchaseBillLineDraft(
          accountId: 'acc-1',
          quantity: '1',
          rate: '100.00',
        ),
      ],
    );

    await tester.pumpWidget(buildTestableWidget(state: validState));
    await tester.pumpAndSettle();

    final submitButton = find.byKey(const Key('submit_bill_button'));
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();

    verify(() => mockPurchaseBillFormCubit.saveAndPost()).called(1);
  });

  testWidgets('tapping Save draft invokes cubit.saveDraft', (tester) async {
    final validState = PurchaseBillFormState(
      vendorId: 'v-101',
      billDate: tDate,
      availableVendors: [tVendor],
      lines: const [
        PurchaseBillLineDraft(accountId: 'acc-1', quantity: '1', rate: '100.00'),
      ],
    );

    await tester.pumpWidget(buildTestableWidget(state: validState));
    await tester.pumpAndSettle();

    final draftButton = find.byKey(const Key('save_draft_button'));
    await tester.ensureVisible(draftButton);
    await tester.tap(draftButton);
    await tester.pump();

    verify(() => mockPurchaseBillFormCubit.saveDraft()).called(1);
    verifyNever(() => mockPurchaseBillFormCubit.saveAndPost());
  });

  testWidgets(
      'a tracked item line hides the account picker and shows UOM and the tax hint',
      (tester) async {
    final trackedState = PurchaseBillFormState(
      vendorId: 'v-101',
      billDate: tDate,
      availableVendors: [tVendor],
      lines: const [
        PurchaseBillLineDraft(
          itemId: '7',
          itemName: 'Basmati rice',
          uomCode: 'KG',
          inventoryTracked: true,
          quantity: '10',
          rate: '80.00',
        ),
        PurchaseBillLineDraft(accountId: 'acc-1', quantity: '1', rate: '5.00'),
      ],
    );

    await tester.pumpWidget(buildTestableWidget(state: trackedState));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('account_picker_0')), findsNothing);
    expect(find.byKey(const Key('account_picker_1')), findsOneWidget);
    expect(find.text('KG'), findsOneWidget);
    expect(find.text('Basmati rice'), findsOneWidget);
    expect(find.text(AccountingStrings.rateExcludesTaxHint), findsNWidgets(2));
    expect(find.byKey(const Key('supplier_invoice_no_field')), findsOneWidget);
  });
}
