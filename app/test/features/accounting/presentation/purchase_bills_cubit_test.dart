import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/purchase_bill.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_purchase_bills_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/purchase_bills_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPurchaseBillsUseCase extends Mock
    implements GetPurchaseBillsUseCase {}

void main() {
  late MockGetPurchaseBillsUseCase mockGetPurchaseBills;
  late PurchaseBillsCubit cubit;

  final tDate = DateTime.utc(2026, 10, 15);

  final tBill1 = PurchaseBill(
    id: 'pb-1',
    billNumber: 'BILL-001',
    vendorId: 'v-101',
    vendorName: 'Acme Corp',
    billDate: tDate,
    dueDate: tDate.add(const Duration(days: 30)),
    subtotal: '100.00',
    taxAmount: '18.00',
    totalAmount: '118.00',
    status: 'draft',
    allocatedAmount: '0.00',
    lines: const [
      PurchaseBillLine(
        id: 'pbl-1',
        billId: 'pb-1',
        accountId: 'acc-1',
        quantity: '1',
        unitPrice: '100.00',
        amount: '100.00',
        taxCodeId: 'tc-1',
        taxAmount: '18.00',
      ),
    ],
  );

  final tBill2 = PurchaseBill(
    id: 'pb-2',
    billNumber: 'BILL-002',
    vendorId: 'v-102',
    vendorName: 'Global Supplies',
    billDate: tDate,
    dueDate: tDate.add(const Duration(days: 15)),
    subtotal: '200.00',
    taxAmount: '0.00',
    totalAmount: '200.00',
    status: 'posted',
    allocatedAmount: '0.00',
    journalEntryId: 'JRN-2026-0099',
    lines: const [
      PurchaseBillLine(
        id: 'pbl-2',
        billId: 'pb-2',
        accountId: 'acc-2',
        quantity: '2',
        unitPrice: '100.00',
        amount: '200.00',
      ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(const GetPurchaseBillsParams());
  });

  setUp(() {
    mockGetPurchaseBills = MockGetPurchaseBillsUseCase();
    cubit = PurchaseBillsCubit(mockGetPurchaseBills);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is correct', () {
    expect(cubit.state.status, LoadStatus.initial);
    expect(cubit.state.bills, isEmpty);
    expect(cubit.state.offset, 0);
    expect(cubit.state.hasMore, false);
    expect(cubit.state.isLoadingMore, false);
  });

  group('load', () {
    blocTest<PurchaseBillsCubit, PurchaseBillsState>(
      'emits [loading, success] on successful fetch',
      build: () {
        when(() => mockGetPurchaseBills(any())).thenAnswer(
          (_) async => Right(
            CursorPage<PurchaseBill>(
              items: [tBill1, tBill2],
              nextCursor: 'c-2',
              hasMore: true,
            ),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const PurchaseBillsState(status: LoadStatus.loading),
        PurchaseBillsState(
          status: LoadStatus.success,
          bills: [tBill1, tBill2],
          hasMore: true,
          offset: 2,
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetPurchaseBills(
            const GetPurchaseBillsParams(offset: 0, limit: 20),
          ),
        ).called(1);
      },
    );

    blocTest<PurchaseBillsCubit, PurchaseBillsState>(
      'emits [loading, failure] on failure',
      build: () {
        when(() => mockGetPurchaseBills(any())).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Error fetching bills')),
        );
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const PurchaseBillsState(status: LoadStatus.loading),
        const PurchaseBillsState(
          status: LoadStatus.failure,
          failure: BusinessRuleFailure('Error fetching bills'),
        ),
      ],
    );
  });

  group('pagination / loadMore', () {
    blocTest<PurchaseBillsCubit, PurchaseBillsState>(
      'appends items when loadMore is called',
      build: () {
        when(
          () => mockGetPurchaseBills(
            const GetPurchaseBillsParams(offset: 2, limit: 20),
          ),
        ).thenAnswer(
          (_) async => Right(
            CursorPage<PurchaseBill>(
              items: [tBill2],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      seed: () => PurchaseBillsState(
        status: LoadStatus.success,
        bills: [tBill1, tBill2],
        offset: 2,
        hasMore: true,
      ),
      act: (cubit) => cubit.loadMore(),
      expect: () => [
        PurchaseBillsState(
          status: LoadStatus.success,
          bills: [tBill1, tBill2],
          offset: 2,
          hasMore: true,
          isLoadingMore: true,
        ),
        PurchaseBillsState(
          status: LoadStatus.success,
          bills: [tBill1, tBill2, tBill2],
          offset: 3,
          hasMore: false,
          isLoadingMore: false,
        ),
      ],
    );

    blocTest<PurchaseBillsCubit, PurchaseBillsState>(
      'does nothing when hasMore is false',
      build: () => cubit,
      seed: () => PurchaseBillsState(
        status: LoadStatus.success,
        bills: [tBill1],
        offset: 1,
        hasMore: false,
      ),
      act: (cubit) => cubit.loadMore(),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockGetPurchaseBills(any()));
      },
    );
  });

  group('filters', () {
    blocTest<PurchaseBillsCubit, PurchaseBillsState>(
      'filterByStatus updates status and loads',
      build: () {
        when(() => mockGetPurchaseBills(any())).thenAnswer(
          (_) async => Right(
            CursorPage<PurchaseBill>(
              items: [tBill1],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.filterByStatus('draft'),
      expect: () => [
        const PurchaseBillsState(
          status: LoadStatus.loading,
          statusFilter: 'draft',
        ),
        PurchaseBillsState(
          status: LoadStatus.success,
          statusFilter: 'draft',
          bills: [tBill1],
          offset: 1,
          hasMore: false,
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetPurchaseBills(
            const GetPurchaseBillsParams(
              status: 'draft',
              offset: 0,
              limit: 20,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<PurchaseBillsCubit, PurchaseBillsState>(
      'filterByVendor updates vendorId and loads',
      build: () {
        when(() => mockGetPurchaseBills(any())).thenAnswer(
          (_) async => Right(
            CursorPage<PurchaseBill>(
              items: [tBill1],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.filterByVendor('v-101'),
      expect: () => [
        const PurchaseBillsState(
          status: LoadStatus.loading,
          vendorId: 'v-101',
        ),
        PurchaseBillsState(
          status: LoadStatus.success,
          vendorId: 'v-101',
          bills: [tBill1],
          offset: 1,
          hasMore: false,
        ),
      ],
    );

    blocTest<PurchaseBillsCubit, PurchaseBillsState>(
      'filterByDateRange updates dates and loads',
      build: () {
        when(() => mockGetPurchaseBills(any())).thenAnswer(
          (_) async => Right(
            CursorPage<PurchaseBill>(
              items: [tBill1],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.filterByDateRange(tDate, tDate),
      expect: () => [
        PurchaseBillsState(
          status: LoadStatus.loading,
          fromDate: tDate,
          toDate: tDate,
        ),
        PurchaseBillsState(
          status: LoadStatus.success,
          fromDate: tDate,
          toDate: tDate,
          bills: [tBill1],
          offset: 1,
          hasMore: false,
        ),
      ],
    );

    blocTest<PurchaseBillsCubit, PurchaseBillsState>(
      'searchBills updates query and loads',
      build: () {
        when(() => mockGetPurchaseBills(any())).thenAnswer(
          (_) async => Right(
            CursorPage<PurchaseBill>(
              items: [tBill1],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.searchBills('BILL-001'),
      expect: () => [
        const PurchaseBillsState(
          status: LoadStatus.loading,
          search: 'BILL-001',
        ),
        PurchaseBillsState(
          status: LoadStatus.success,
          search: 'BILL-001',
          bills: [tBill1],
          offset: 1,
          hasMore: false,
        ),
      ],
    );

    blocTest<PurchaseBillsCubit, PurchaseBillsState>(
      'clearFilters resets all filter parameters',
      build: () {
        when(() => mockGetPurchaseBills(any())).thenAnswer(
          (_) async => const Right(
            CursorPage<PurchaseBill>(
              items: [],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      seed: () => PurchaseBillsState(
        statusFilter: 'draft',
        vendorId: 'v-101',
        fromDate: tDate,
        toDate: tDate,
        search: 'test',
      ),
      act: (cubit) => cubit.clearFilters(),
      expect: () => [
        const PurchaseBillsState(status: LoadStatus.loading),
        const PurchaseBillsState(
          status: LoadStatus.success,
          bills: [],
          offset: 0,
          hasMore: false,
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetPurchaseBills(
            const GetPurchaseBillsParams(offset: 0, limit: 20),
          ),
        ).called(1);
      },
    );
  });
}
