import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/fund_transfer.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_fund_transfers_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/fund_transfers_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFundTransfersUseCase extends Mock
    implements GetFundTransfersUseCase {}

void main() {
  late MockGetFundTransfersUseCase mockGetFundTransfers;
  late FundTransfersCubit cubit;

  final tDate = DateTime.utc(2026, 10, 15);

  final tTransfer1 = FundTransfer(
    id: 'ft-1',
    transferNumber: 'TRF-2026-0001',
    transferDate: tDate,
    fromAccountId: '101',
    toAccountId: '102',
    amount: '500.00',
    feeAmount: '5.00',
    feeAccountId: '501',
    status: 'draft',
  );

  final tTransfer2 = FundTransfer(
    id: 'ft-2',
    transferNumber: 'TRF-2026-0002',
    transferDate: tDate,
    fromAccountId: '101',
    toAccountId: '103',
    amount: '1000.00',
    feeAmount: '0.00',
    status: 'posted',
    journalEntryId: 'j-999',
  );

  final tPage = CursorPage<FundTransfer>(
    items: [tTransfer1, tTransfer2],
    nextCursor: 'cur-2',
    hasMore: true,
  );

  final tLastPage = CursorPage<FundTransfer>(
    items: [tTransfer2],
    nextCursor: null,
    hasMore: false,
  );

  setUpAll(() {
    registerFallbackValue(const GetFundTransfersParams());
  });

  setUp(() {
    mockGetFundTransfers = MockGetFundTransfersUseCase();
    cubit = FundTransfersCubit(mockGetFundTransfers);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has default values', () {
    expect(cubit.state, const FundTransfersState());
    expect(cubit.state.status, LoadStatus.initial);
    expect(cubit.state.transfers, isEmpty);
    expect(cubit.state.hasReachedMax, isFalse);
    expect(cubit.state.offset, 0);
  });

  group('load', () {
    blocTest<FundTransfersCubit, FundTransfersState>(
      'emits [loading, success] on successful fetch',
      build: () {
        when(() => mockGetFundTransfers(any()))
            .thenAnswer((_) async => Right(tPage));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const FundTransfersState(
          status: LoadStatus.loading,
          transfers: [],
          offset: 0,
        ),
        FundTransfersState(
          status: LoadStatus.success,
          transfers: [tTransfer1, tTransfer2],
          offset: 2,
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<FundTransfersCubit, FundTransfersState>(
      'emits [loading, failure] when use case returns failure',
      build: () {
        when(() => mockGetFundTransfers(any())).thenAnswer(
            (_) async => const Left(BusinessRuleFailure('Error loading transfers')));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const FundTransfersState(
          status: LoadStatus.loading,
          transfers: [],
          offset: 0,
        ),
        const FundTransfersState(
          status: LoadStatus.failure,
          failure: BusinessRuleFailure('Error loading transfers'),
          transfers: [],
          offset: 0,
        ),
      ],
    );
  });

  group('loadNextPage', () {
    blocTest<FundTransfersCubit, FundTransfersState>(
      'appends next page of transfers',
      build: () {
        when(() => mockGetFundTransfers(any()))
            .thenAnswer((_) async => Right(tLastPage));
        return cubit;
      },
      seed: () => FundTransfersState(
        status: LoadStatus.success,
        transfers: [tTransfer1],
        offset: 1,
        hasReachedMax: false,
      ),
      act: (cubit) => cubit.loadNextPage(),
      expect: () => [
        FundTransfersState(
          status: LoadStatus.loading,
          transfers: [tTransfer1],
          offset: 1,
          hasReachedMax: false,
        ),
        FundTransfersState(
          status: LoadStatus.success,
          transfers: [tTransfer1, tTransfer2],
          offset: 2,
          hasReachedMax: true,
        ),
      ],
    );

    blocTest<FundTransfersCubit, FundTransfersState>(
      'does nothing when hasReachedMax is true',
      build: () => cubit,
      seed: () => FundTransfersState(
        status: LoadStatus.success,
        transfers: [tTransfer1],
        hasReachedMax: true,
      ),
      act: (cubit) => cubit.loadNextPage(),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockGetFundTransfers(any()));
      },
    );
  });

  group('filters and search', () {
    blocTest<FundTransfersCubit, FundTransfersState>(
      'filterByStatus triggers reload with status filter',
      build: () {
        when(() => mockGetFundTransfers(any()))
            .thenAnswer((_) async => Right(tPage));
        return cubit;
      },
      act: (cubit) => cubit.filterByStatus('draft'),
      expect: () => [
        const FundTransfersState(
          status: LoadStatus.loading,
          statusFilter: 'draft',
          transfers: [],
          offset: 0,
        ),
        FundTransfersState(
          status: LoadStatus.success,
          statusFilter: 'draft',
          transfers: [tTransfer1, tTransfer2],
          offset: 2,
          hasReachedMax: false,
        ),
      ],
      verify: (_) {
        verify(() => mockGetFundTransfers(
              const GetFundTransfersParams(
                limit: 50,
                offset: 0,
                status: 'draft',
              ),
            )).called(1);
      },
    );

    blocTest<FundTransfersCubit, FundTransfersState>(
      'filterByDateRange triggers reload with date filters',
      build: () {
        when(() => mockGetFundTransfers(any()))
            .thenAnswer((_) async => Right(tPage));
        return cubit;
      },
      act: (cubit) => cubit.filterByDateRange(tDate, tDate),
      expect: () => [
        FundTransfersState(
          status: LoadStatus.loading,
          fromDate: tDate,
          toDate: tDate,
          transfers: [],
          offset: 0,
        ),
        FundTransfersState(
          status: LoadStatus.success,
          fromDate: tDate,
          toDate: tDate,
          transfers: [tTransfer1, tTransfer2],
          offset: 2,
          hasReachedMax: false,
        ),
      ],
      verify: (_) {
        verify(() => mockGetFundTransfers(
              GetFundTransfersParams(
                limit: 50,
                offset: 0,
                from: tDate,
                to: tDate,
              ),
            )).called(1);
      },
    );

    blocTest<FundTransfersCubit, FundTransfersState>(
      'filterByAccount triggers reload with accountId',
      build: () {
        when(() => mockGetFundTransfers(any()))
            .thenAnswer((_) async => Right(tPage));
        return cubit;
      },
      act: (cubit) => cubit.filterByAccount('101'),
      expect: () => [
        const FundTransfersState(
          status: LoadStatus.loading,
          accountId: '101',
          transfers: [],
          offset: 0,
        ),
        FundTransfersState(
          status: LoadStatus.success,
          accountId: '101',
          transfers: [tTransfer1, tTransfer2],
          offset: 2,
          hasReachedMax: false,
        ),
      ],
      verify: (_) {
        verify(() => mockGetFundTransfers(
              const GetFundTransfersParams(
                limit: 50,
                offset: 0,
                accountId: '101',
              ),
            )).called(1);
      },
    );

    blocTest<FundTransfersCubit, FundTransfersState>(
      'searchTransfers triggers reload with search string',
      build: () {
        when(() => mockGetFundTransfers(any()))
            .thenAnswer((_) async => Right(tPage));
        return cubit;
      },
      act: (cubit) => cubit.searchTransfers('TRF-001'),
      expect: () => [
        const FundTransfersState(
          status: LoadStatus.loading,
          search: 'TRF-001',
          transfers: [],
          offset: 0,
        ),
        FundTransfersState(
          status: LoadStatus.success,
          search: 'TRF-001',
          transfers: [tTransfer1, tTransfer2],
          offset: 2,
          hasReachedMax: false,
        ),
      ],
      verify: (_) {
        verify(() => mockGetFundTransfers(
              const GetFundTransfersParams(
                limit: 50,
                offset: 0,
                search: 'TRF-001',
              ),
            )).called(1);
      },
    );

    blocTest<FundTransfersCubit, FundTransfersState>(
      'clearFilters resets status, dates, search, and accountId',
      build: () {
        when(() => mockGetFundTransfers(any()))
            .thenAnswer((_) async => Right(tPage));
        return cubit;
      },
      seed: () => FundTransfersState(
        statusFilter: 'draft',
        fromDate: tDate,
        toDate: tDate,
        search: 'TRF',
        accountId: '101',
      ),
      act: (cubit) => cubit.clearFilters(),
      expect: () => [
        const FundTransfersState(
          status: LoadStatus.loading,
          statusFilter: null,
          fromDate: null,
          toDate: null,
          search: null,
          accountId: null,
          transfers: [],
          offset: 0,
        ),
        FundTransfersState(
          status: LoadStatus.success,
          statusFilter: null,
          fromDate: null,
          toDate: null,
          search: null,
          accountId: null,
          transfers: [tTransfer1, tTransfer2],
          offset: 2,
          hasReachedMax: false,
        ),
      ],
      verify: (_) {
        verify(() => mockGetFundTransfers(
              const GetFundTransfersParams(
                limit: 50,
                offset: 0,
                status: null,
                from: null,
                to: null,
                search: null,
                accountId: null,
              ),
            )).called(1);
      },
    );
  });
}
