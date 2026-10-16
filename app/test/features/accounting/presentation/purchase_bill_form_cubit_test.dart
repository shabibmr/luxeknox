import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/entities/item.dart';
import 'package:luxeknox/features/accounting/domain/entities/purchase_bill.dart';
import 'package:luxeknox/features/accounting/domain/entities/tax_code.dart';
import 'package:luxeknox/features/accounting/domain/entities/vendor.dart';
import 'package:luxeknox/features/accounting/domain/usecases/create_purchase_bill_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_accounts_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_tax_codes_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_vendors_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/post_purchase_bill_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/purchase_bill_form_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockCreatePurchaseBillUseCase extends Mock
    implements CreatePurchaseBillUseCase {}

class MockPostPurchaseBillUseCase extends Mock
    implements PostPurchaseBillUseCase {}

class MockGetVendorsUseCase extends Mock implements GetVendorsUseCase {}

class MockGetAccountsUseCase extends Mock implements GetAccountsUseCase {}

class MockGetTaxCodesUseCase extends Mock implements GetTaxCodesUseCase {}

void main() {
  late MockCreatePurchaseBillUseCase mockCreatePurchaseBill;
  late MockPostPurchaseBillUseCase mockPostPurchaseBill;
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

  final tPostedBill = PurchaseBill(
    id: 'pb-100',
    billNumber: 'BILL-100',
    vendorId: 'v-101',
    vendorName: 'Vendor 1',
    billDate: tDate,
    subtotal: '200.00',
    taxAmount: '36.00',
    totalAmount: '236.00',
    status: 'posted',
    allocatedAmount: '0.00',
    journalEntryId: 'je-1',
  );

  const tKgItem = Item(
    id: 7,
    name: 'Basmati rice',
    kind: 'goods',
    uomId: 2,
    uomCode: 'KG',
    uomDecimalPlaces: 3,
    incomeAccountId: 40,
    expenseAccountId: 50,
    inventoryAccountId: 14,
    inventoryTracked: true,
    purchaseRate: '80.00',
    taxCodeId: 1,
  );

  const tPcsService = Item(
    id: 8,
    name: 'Belt',
    kind: 'goods',
    uomId: 1,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 40,
    expenseAccountId: 1,
    purchaseRate: '25.50',
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
    registerFallbackValue(const PostPurchaseBillParams(id: 'x'));
    registerFallbackValue(const GetVendorsParams());
    registerFallbackValue(const GetAccountsParams());
    registerFallbackValue(const GetTaxCodesParams());
  });

  setUp(() {
    mockCreatePurchaseBill = MockCreatePurchaseBillUseCase();
    mockPostPurchaseBill = MockPostPurchaseBillUseCase();
    mockGetVendors = MockGetVendorsUseCase();
    mockGetAccounts = MockGetAccountsUseCase();
    mockGetTaxCodes = MockGetTaxCodesUseCase();

    cubit = PurchaseBillFormCubit(
      mockCreatePurchaseBill,
      mockPostPurchaseBill,
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

    PurchaseBillFormState seeded({String supplierInvoiceNo = ''}) =>
        PurchaseBillFormState(
          vendorId: 'v-101',
          vendorName: 'Vendor 1',
          billDate: tDate,
          dueDate: tDate.add(const Duration(days: 30)),
          supplierInvoiceNo: supplierInvoiceNo,
          lines: const [
            PurchaseBillLineDraft(
              accountId: 'acc-1',
              quantity: '2',
              rate: '100.00',
              taxCodeId: 'tc-1',
              taxRatePercent: 18.0,
            ),
          ],
        );

    test('saveDraft creates a draft once and never posts', () async {
      when(() => mockCreatePurchaseBill(any()))
          .thenAnswer((_) async => Right(tCreatedBill));
      cubit.emit(seeded(supplierInvoiceNo: '  INV-9 '));

      final ok = await cubit.saveDraft();

      expect(ok, true);
      final params = verify(() => mockCreatePurchaseBill(captureAny()))
          .captured
          .single as CreatePurchaseBillParams;
      expect(params.draft, true);
      expect(params.supplierInvoiceNo, 'INV-9');
      expect(params.idempotencyKey, isNotEmpty);
      verifyNever(() => mockPostPurchaseBill(any()));
      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.createdBill, tCreatedBill);
      expect(cubit.state.isSubmitting, false);
    });

    test('saveAndPost creates then posts once, with separate keys', () async {
      when(() => mockCreatePurchaseBill(any()))
          .thenAnswer((_) async => Right(tCreatedBill));
      when(() => mockPostPurchaseBill(any()))
          .thenAnswer((_) async => Right(tPostedBill));
      cubit.emit(seeded());

      final ok = await cubit.saveAndPost();

      expect(ok, true);
      final create = verify(() => mockCreatePurchaseBill(captureAny()))
          .captured
          .single as CreatePurchaseBillParams;
      final post = verify(() => mockPostPurchaseBill(captureAny()))
          .captured
          .single as PostPurchaseBillParams;
      expect(post.id, 'pb-100');
      expect(post.idempotencyKey, isNotEmpty);
      expect(post.idempotencyKey, isNot(create.idempotencyKey));
      expect(create.supplierInvoiceNo, isNull);
      expect(cubit.state.createdBill, tPostedBill);
      expect(cubit.state.status, LoadStatus.success);
    });

    test('a post error (period locked) shows on the form and keeps the draft',
        () async {
      when(() => mockCreatePurchaseBill(any()))
          .thenAnswer((_) async => Right(tCreatedBill));
      when(() => mockPostPurchaseBill(any())).thenAnswer(
        (_) async => const Left(BusinessRuleFailure('Period is locked')),
      );
      cubit.emit(seeded());

      final ok = await cubit.saveAndPost();

      expect(ok, false);
      expect(cubit.state.status, LoadStatus.failure);
      expect(cubit.state.failure, const BusinessRuleFailure('Period is locked'));
      expect(cubit.state.isSubmitting, false);
      expect(cubit.state.createdBill, tCreatedBill);
    });

    test('retrying after a post error posts the same draft with the same key',
        () async {
      when(() => mockCreatePurchaseBill(any()))
          .thenAnswer((_) async => Right(tCreatedBill));
      var calls = 0;
      when(() => mockPostPurchaseBill(any())).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? const Left(BusinessRuleFailure('Period is locked'))
            : Right(tPostedBill);
      });
      cubit.emit(seeded());

      await cubit.saveAndPost();
      final ok = await cubit.saveAndPost();

      expect(ok, true);
      verify(() => mockCreatePurchaseBill(any())).called(1);
      final keys = verify(() => mockPostPurchaseBill(captureAny()))
          .captured
          .cast<PostPurchaseBillParams>()
          .map((p) => p.idempotencyKey)
          .toList();
      expect(keys, hasLength(2));
      expect(keys[0], keys[1]);
      expect(cubit.state.createdBill, tPostedBill);
    });

    test('a create error emits failure and does not post', () async {
      when(() => mockCreatePurchaseBill(any())).thenAnswer(
        (_) async => const Left(BusinessRuleFailure('Invalid purchase bill')),
      );
      cubit.emit(seeded());

      final ok = await cubit.saveAndPost();

      expect(ok, false);
      expect(
        cubit.state.failure,
        const BusinessRuleFailure('Invalid purchase bill'),
      );
      expect(cubit.state.createdBill, isNull);
      verifyNever(() => mockPostPurchaseBill(any()));
    });
  });

  group('item lines', () {
    setUp(() {
      cubit.emit(
        cubit.state.copyWith(
          availableAccounts: const [
            Account(id: '1', name: 'Repairs', type: 'expense'),
          ],
          availableTaxCodes: const [
            TaxCode(id: '1', code: 'GST5', name: 'GST 5%', ratePercent: '5.0'),
          ],
        ),
      );
    });

    test('picking a tracked item fills rate, tax and UOM and drops the account',
        () {
      cubit.setLineAccount(0, tAccount);
      cubit.setLineItem(0, tKgItem);

      final line = cubit.state.lines[0];
      expect(line.itemId, '7');
      expect(line.itemName, 'Basmati rice');
      expect(line.uomCode, 'KG');
      expect(line.uomDecimalPlaces, 3);
      expect(line.inventoryTracked, true);
      expect(line.rate, '80.00');
      expect(line.taxCodeId, '1');
      expect(line.taxRatePercent, 5.0);
      expect(line.accountId, isNull);
    });

    test('a tracked line needs no account to submit', () {
      cubit.setVendor('v-101');
      cubit.setLineItem(0, tKgItem);
      expect(cubit.state.canSubmit, true);
    });

    test('an untracked item defaults to its expense account', () {
      cubit.setLineItem(0, tPcsService);

      final line = cubit.state.lines[0];
      expect(line.inventoryTracked, false);
      expect(line.accountId, '1');
      expect(line.accountName, 'Repairs');
      expect(line.rate, '25.50');
      expect(line.uomDecimalPlaces, 0);
    });

    test('a fractional quantity is trimmed to the UOM decimals', () {
      cubit.updateLine(0, quantity: '2.375');
      cubit.setLineItem(0, tPcsService);
      expect(cubit.state.lines[0].quantity, '2');
    });

    test('tracked lines are sent without an account id', () async {
      when(() => mockCreatePurchaseBill(any()))
          .thenAnswer((_) async => Right(tCreatedBill));
      cubit.setVendor('v-101');
      cubit.setLineItem(0, tKgItem);
      cubit.updateLine(0, quantity: '10');

      await cubit.saveDraft();

      final params = verify(() => mockCreatePurchaseBill(captureAny()))
          .captured
          .single as CreatePurchaseBillParams;
      expect(params.lines.single.itemId, '7');
      expect(params.lines.single.accountId, isNull);
      expect(params.lines.single.quantity, '10');
    });

    test('clearing the item returns to a plain account line', () {
      cubit.setLineItem(0, tKgItem);
      cubit.setLineItem(0, null);
      final line = cubit.state.lines[0];
      expect(line.itemId, isNull);
      expect(line.inventoryTracked, false);
      expect(line.uomCode, isNull);
    });
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
