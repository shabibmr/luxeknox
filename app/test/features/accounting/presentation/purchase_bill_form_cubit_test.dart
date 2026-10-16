import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/entities/purchase_bill.dart';
import 'package:luxeknox/features/accounting/domain/entities/tax_code.dart';
import 'package:luxeknox/features/accounting/domain/entities/vendor.dart';
import 'package:luxeknox/features/accounting/domain/usecases/create_purchase_bill_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_accounts_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_tax_codes_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_vendors_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/purchase_bill_form_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockCreatePurchaseBillUseCase extends Mock
    implements CreatePurchaseBillUseCase {}

class MockGetVendorsUseCase extends Mock implements GetVendorsUseCase {}

class MockGetAccountsUseCase extends Mock implements GetAccountsUseCase {}

class MockGetTaxCodesUseCase extends Mock implements GetTaxCodesUseCase {}

void main() {
  late MockCreatePurchaseBillUseCase mockCreatePurchaseBill;
  late MockGetVendorsUseCase mockGetVendors;
  late MockGetAccountsUseCase mockGetAccounts;
  late MockGetTaxCodesUseCase mockGetTaxCodes;
  late PurchaseBillFormCubit cubit;

  final tDate = DateTime.utc(2026, 10, 15);

  final tVendor = const Vendor(id: 'v-101', name: 'Vendor 1');
  final tAccount = const Account(
    id: 'acc-1',
    name: 'Office Supplies',
    type: 'expense',
  );
  final tTaxCode = const TaxCode(
    id: 'tc-1',
    code: 'GST18',
    name: 'GST 18%',
    ratePercent: '18.0',
  );

  final tCreatedBill = PurchaseBill(
    id: 'pb-100',
    billNumber: 'BILL-100',
    vendorId: 'v-101',
    vendorName: 'Vendor 1',
    billDate: tDate,
    dueDate: tDate.add(const Duration(days: 30)),
    subtotal: '200.00',
    taxAmount: '36.00',
    totalAmount: '236.00',
    status: 'draft',
    allocatedAmount: '0.00',
    lines: const [
      PurchaseBillLine(
        id: 'pbl-1',
        billId: 'pb-100',
        accountId: 'acc-1',
        quantity: '2',
        unitPrice: '100.00',
        amount: '200.00',
        taxCodeId: 'tc-1',
        taxAmount: '36.00',
      ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(
      CreatePurchaseBillParams(
        vendorId: 'v-1',
        billDate: DateTime.now(),
        lines: const [],
      ),
    );
    registerFallbackValue(const GetVendorsParams());
    registerFallbackValue(const GetAccountsParams());
    registerFallbackValue(const GetTaxCodesParams());
  });

  setUp(() {
    mockCreatePurchaseBill = MockCreatePurchaseBillUseCase();
    mockGetVendors = MockGetVendorsUseCase();
    mockGetAccounts = MockGetAccountsUseCase();
    mockGetTaxCodes = MockGetTaxCodesUseCase();

    cubit = PurchaseBillFormCubit(
      mockCreatePurchaseBill,
      mockGetVendors,
      mockGetAccounts,
      mockGetTaxCodes,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has 1 line item and initial totals 0.0', () {
    expect(cubit.state.lines.length, 1);
    expect(cubit.state.subtotal, 0.0);
    expect(cubit.state.taxAmount, 0.0);
    expect(cubit.state.totalAmount, 0.0);
    expect(cubit.state.vendorId, isNull);
    expect(cubit.state.canSubmit, false);
  });

  group('dynamic lines and total calculation', () {
    test('addLine adds a line item', () {
      cubit.addLine();
      expect(cubit.state.lines.length, 2);
    });

    test('removeLine removes a line item when > 1 line', () {
      cubit.addLine();
      expect(cubit.state.lines.length, 2);

      cubit.removeLine(0);
      expect(cubit.state.lines.length, 1);
    });

    test('removeLine does not remove if only 1 line remains', () {
      expect(cubit.state.lines.length, 1);
      cubit.removeLine(0);
      expect(cubit.state.lines.length, 1);
    });

    test('updates line values and computes subtotal, tax, and total live', () {
      // Set line 0: qty 2, rate 100, tax 18%
      cubit.updateLine(
        0,
        accountId: 'acc-1',
        quantity: '2',
        rate: '100.00',
        taxCodeId: 'tc-1',
        taxRatePercent: 18.0,
      );

      final line0 = cubit.state.lines[0];
      expect(line0.netAmount, 200.00);
      expect(line0.taxAmount, 36.00);
      expect(line0.totalAmount, 236.00);

      expect(cubit.state.subtotal, 200.00);
      expect(cubit.state.taxAmount, 36.00);
      expect(cubit.state.totalAmount, 236.00);

      // Add second line: qty 1, rate 50, no tax (0%)
      cubit.addLine();
      cubit.updateLine(
        1,
        accountId: 'acc-2',
        quantity: '1',
        rate: '50.00',
        taxRatePercent: 0.0,
      );

      expect(cubit.state.lines.length, 2);
      expect(cubit.state.subtotal, 250.00);
      expect(cubit.state.taxAmount, 36.00);
      expect(cubit.state.totalAmount, 286.00);

      // Removing line 1 recalculates totals back
      cubit.removeLine(1);
      expect(cubit.state.lines.length, 1);
      expect(cubit.state.subtotal, 200.00);
      expect(cubit.state.taxAmount, 36.00);
      expect(cubit.state.totalAmount, 236.00);
    });

    test('helper setters setLineAccount and setLineTaxCode work correctly', () {
      cubit.setLineAccount(0, tAccount);
      expect(cubit.state.lines[0].accountId, 'acc-1');
      expect(cubit.state.lines[0].accountName, 'Office Supplies');

      cubit.setLineTaxCode(0, tTaxCode);
      expect(cubit.state.lines[0].taxCodeId, 'tc-1');
      expect(cubit.state.lines[0].taxRatePercent, 18.0);
    });
  });

  group('validation and submission', () {
    test('canSubmit is true only when vendorId is set and lines are valid', () {
      expect(cubit.state.canSubmit, false);

      cubit.setVendor('v-101', 'Vendor 1');
      expect(cubit.state.canSubmit, false); // line has no account

      cubit.updateLine(
        0,
        accountId: 'acc-1',
        quantity: '2',
        rate: '100.00',
      );
      expect(cubit.state.canSubmit, true);
    });

    blocTest<PurchaseBillFormCubit, PurchaseBillFormState>(
      'submit succeeds and emits success with createdBill',
      build: () {
        when(() => mockCreatePurchaseBill(any())).thenAnswer(
          (_) async => Right(tCreatedBill),
        );
        return cubit;
      },
      seed: () => PurchaseBillFormState(
        vendorId: 'v-101',
        vendorName: 'Vendor 1',
        billDate: tDate,
        dueDate: tDate.add(const Duration(days: 30)),
        lines: const [
          PurchaseBillLineDraft(
            accountId: 'acc-1',
            quantity: '2',
            rate: '100.00',
            taxCodeId: 'tc-1',
            taxRatePercent: 18.0,
          ),
        ],
      ),
      act: (cubit) => cubit.submit(),
      expect: () => [
        isA<PurchaseBillFormState>()
            .having((s) => s.isSubmitting, 'isSubmitting', true)
            .having((s) => s.failure, 'failure', isNull),
        isA<PurchaseBillFormState>()
            .having((s) => s.status, 'status', LoadStatus.success)
            .having((s) => s.createdBill, 'createdBill', tCreatedBill)
            .having((s) => s.isSubmitting, 'isSubmitting', false),
      ],
      verify: (_) {
        verify(
          () => mockCreatePurchaseBill(
            CreatePurchaseBillParams(
              vendorId: 'v-101',
              billDate: tDate,
              dueDate: tDate.add(const Duration(days: 30)),
              lines: const [
                PurchaseBillLine(
                  id: '',
                  billId: '',
                  accountId: 'acc-1',
                  quantity: '2',
                  unitPrice: '100.00',
                  amount: '200.00',
                  taxCodeId: 'tc-1',
                  taxAmount: '36.00',
                ),
              ],
            ),
          ),
        ).called(1);
      },
    );

    blocTest<PurchaseBillFormCubit, PurchaseBillFormState>(
      'submit fails and emits failure',
      build: () {
        when(() => mockCreatePurchaseBill(any())).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Invalid purchase bill')),
        );
        return cubit;
      },
      seed: () => PurchaseBillFormState(
        vendorId: 'v-101',
        billDate: tDate,
        lines: const [
          PurchaseBillLineDraft(
            accountId: 'acc-1',
            quantity: '1',
            rate: '50.00',
          ),
        ],
      ),
      act: (cubit) => cubit.submit(),
      expect: () => [
        isA<PurchaseBillFormState>()
            .having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<PurchaseBillFormState>()
            .having((s) => s.status, 'status', LoadStatus.failure)
            .having(
              (s) => s.failure,
              'failure',
              const BusinessRuleFailure('Invalid purchase bill'),
            )
            .having((s) => s.isSubmitting, 'isSubmitting', false),
      ],
    );
  });

  group('loadDependencies', () {
    blocTest<PurchaseBillFormCubit, PurchaseBillFormState>(
      'loads vendors, accounts, and tax codes into state',
      build: () {
        when(() => mockGetVendors(any())).thenAnswer(
          (_) async => Right(
            CursorPage<Vendor>(items: [tVendor], nextCursor: null, hasMore: false),
          ),
        );
        when(() => mockGetAccounts(any())).thenAnswer(
          (_) async => Right(
            CursorPage<Account>(items: [tAccount], nextCursor: null, hasMore: false),
          ),
        );
        when(() => mockGetTaxCodes(any())).thenAnswer(
          (_) async => Right(
            CursorPage<TaxCode>(items: [tTaxCode], nextCursor: null, hasMore: false),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadDependencies(),
      expect: () => [
        isA<PurchaseBillFormState>()
            .having((s) => s.isLoadingDependencies, 'isLoadingDependencies', true),
        isA<PurchaseBillFormState>()
            .having((s) => s.availableVendors, 'availableVendors', [tVendor])
            .having((s) => s.availableAccounts, 'availableAccounts', [tAccount])
            .having((s) => s.availableTaxCodes, 'availableTaxCodes', [tTaxCode])
            .having((s) => s.isLoadingDependencies, 'isLoadingDependencies', false),
      ],
    );
  });
}
