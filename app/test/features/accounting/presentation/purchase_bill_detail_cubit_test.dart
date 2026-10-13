import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/purchase_bill.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_purchase_bill_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/post_purchase_bill_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/purchase_bill_detail_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPurchaseBillUseCase extends Mock
    implements GetPurchaseBillUseCase {}

class MockPostPurchaseBillUseCase extends Mock
    implements PostPurchaseBillUseCase {}

void main() {
  late MockGetPurchaseBillUseCase mockGetPurchaseBill;
  late MockPostPurchaseBillUseCase mockPostPurchaseBill;
  late PurchaseBillDetailCubit cubit;

  final tDate = DateTime.utc(2026, 10, 15);

  final tDraftBill = PurchaseBill(
    id: 'pb-10',
    billNumber: 'BILL-0010',
    vendorId: 'v-1',
    vendorName: 'Acme Supply',
    billDate: tDate,
    dueDate: tDate.add(const Duration(days: 30)),
    subtotal: '500.00',
    taxAmount: '90.00',
    totalAmount: '590.00',
    status: 'draft',
    allocatedAmount: '0.00',
    lines: const [
      PurchaseBillLine(
        id: 'pbl-10',
        billId: 'pb-10',
        accountId: 'acc-5',
        quantity: '5',
        unitPrice: '100.00',
        amount: '500.00',
        taxCodeId: 'tc-1',
        taxAmount: '90.00',
      ),
    ],
  );

  final tPostedBill = PurchaseBill(
    id: 'pb-10',
    billNumber: 'BILL-0010',
    vendorId: 'v-1',
    vendorName: 'Acme Supply',
    billDate: tDate,
    dueDate: tDate.add(const Duration(days: 30)),
    subtotal: '500.00',
    taxAmount: '90.00',
    totalAmount: '590.00',
    status: 'posted',
    allocatedAmount: '0.00',
    journalEntryId: 'JRN-2026-0042',
    lines: const [
      PurchaseBillLine(
        id: 'pbl-10',
        billId: 'pb-10',
        accountId: 'acc-5',
        quantity: '5',
        unitPrice: '100.00',
        amount: '500.00',
        taxCodeId: 'tc-1',
        taxAmount: '90.00',
      ),
    ],
  );

  setUp(() {
    mockGetPurchaseBill = MockGetPurchaseBillUseCase();
    mockPostPurchaseBill = MockPostPurchaseBillUseCase();

    cubit = PurchaseBillDetailCubit(
      mockGetPurchaseBill,
      mockPostPurchaseBill,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is correct', () {
    expect(cubit.state.status, LoadStatus.initial);
    expect(cubit.state.bill, isNull);
    expect(cubit.state.isPosting, false);
    expect(cubit.state.failure, isNull);
  });

  group('load', () {
    blocTest<PurchaseBillDetailCubit, PurchaseBillDetailState>(
      'emits [loading, success] on successful load',
      build: () {
        when(() => mockGetPurchaseBill('pb-10')).thenAnswer(
          (_) async => Right(tDraftBill),
        );
        return cubit;
      },
      act: (cubit) => cubit.load('pb-10'),
      expect: () => [
        const PurchaseBillDetailState(status: LoadStatus.loading),
        PurchaseBillDetailState(
          status: LoadStatus.success,
          bill: tDraftBill,
        ),
      ],
      verify: (_) {
        verify(() => mockGetPurchaseBill('pb-10')).called(1);
      },
    );

    blocTest<PurchaseBillDetailCubit, PurchaseBillDetailState>(
      'emits [loading, failure] on failed load',
      build: () {
        when(() => mockGetPurchaseBill('pb-10')).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Bill not found')),
        );
        return cubit;
      },
      act: (cubit) => cubit.load('pb-10'),
      expect: () => [
        const PurchaseBillDetailState(status: LoadStatus.loading),
        const PurchaseBillDetailState(
          status: LoadStatus.failure,
          failure: BusinessRuleFailure('Bill not found'),
        ),
      ],
    );
  });

  group('setBill', () {
    blocTest<PurchaseBillDetailCubit, PurchaseBillDetailState>(
      'emits success with provided bill',
      build: () => cubit,
      act: (cubit) => cubit.setBill(tDraftBill),
      expect: () => [
        PurchaseBillDetailState(
          status: LoadStatus.success,
          bill: tDraftBill,
        ),
      ],
    );
  });

  group('post', () {
    blocTest<PurchaseBillDetailCubit, PurchaseBillDetailState>(
      'post success updates status to posted and exposes journalEntryId',
      build: () {
        when(() => mockPostPurchaseBill('pb-10')).thenAnswer(
          (_) async => Right(tPostedBill),
        );
        return cubit;
      },
      seed: () => PurchaseBillDetailState(
        status: LoadStatus.success,
        bill: tDraftBill,
      ),
      act: (cubit) => cubit.post(),
      expect: () => [
        PurchaseBillDetailState(
          status: LoadStatus.success,
          bill: tDraftBill,
          isPosting: true,
        ),
        PurchaseBillDetailState(
          status: LoadStatus.success,
          bill: tPostedBill,
          postSuccess: tPostedBill,
          isPosting: false,
        ),
      ],
      verify: (cubit) {
        verify(() => mockPostPurchaseBill('pb-10')).called(1);
        expect(cubit.state.bill?.status, 'posted');
        expect(cubit.state.bill?.journalEntryId, 'JRN-2026-0042');
      },
    );

    blocTest<PurchaseBillDetailCubit, PurchaseBillDetailState>(
      'post failure emits isPosting false with failure',
      build: () {
        when(() => mockPostPurchaseBill('pb-10')).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Cannot post bill')),
        );
        return cubit;
      },
      seed: () => PurchaseBillDetailState(
        status: LoadStatus.success,
        bill: tDraftBill,
      ),
      act: (cubit) => cubit.post(),
      expect: () => [
        PurchaseBillDetailState(
          status: LoadStatus.success,
          bill: tDraftBill,
          isPosting: true,
        ),
        PurchaseBillDetailState(
          status: LoadStatus.success,
          bill: tDraftBill,
          isPosting: false,
          failure: const BusinessRuleFailure('Cannot post bill'),
        ),
      ],
    );

    test('post returns false and does nothing when state.bill is null', () async {
      final result = await cubit.post();
      expect(result, false);
      verifyNever(() => mockPostPurchaseBill(any()));
    });
  });
}
