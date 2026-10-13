import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/entities/accounting_period.dart';
import 'package:luxeknox/features/accounting/domain/entities/accounting_reports.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_accounting_periods_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_accounts_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_open_items_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/accounting_home_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetOpenItemsUseCase extends Mock implements GetOpenItemsUseCase {}

class MockGetAccountsUseCase extends Mock implements GetAccountsUseCase {}

class MockGetAccountingPeriodsUseCase extends Mock
    implements GetAccountingPeriodsUseCase {}

void main() {
  late MockGetOpenItemsUseCase mockGetOpenItems;
  late MockGetAccountsUseCase mockGetAccounts;
  late MockGetAccountingPeriodsUseCase mockGetAccountingPeriods;
  late AccountingHomeCubit cubit;

  final tDate = DateTime.utc(2026, 1, 1);

  const tArReport = OpenItemsReport(
    kind: 'ar',
    totalOpenAmount: '1200.00',
    items: [],
  );

  const tApReport = OpenItemsReport(
    kind: 'ap',
    totalOpenAmount: '800.00',
    items: [],
  );

  const tBankAccount = Account(
    id: '1',
    code: '1000',
    name: 'HDFC Bank',
    type: 'asset',
    isBank: true,
    isActive: true,
  );

  const tExpenseAccount = Account(
    id: '2',
    code: '5000',
    name: 'Rent',
    type: 'expense',
    isBank: false,
    isActive: true,
  );

  final tAccountsPage = const CursorPage<Account>(
    items: [tBankAccount, tExpenseAccount],
    nextCursor: null,
    hasMore: false,
  );

  final tOpenPeriod = AccountingPeriod(
    id: '1',
    fiscalYearId: '1',
    periodNumber: 1,
    name: 'Jan 2026',
    startDate: tDate,
    endDate: tDate,
    isLocked: false,
  );

  final tLockedPeriod = AccountingPeriod(
    id: '2',
    fiscalYearId: '1',
    periodNumber: 2,
    name: 'Dec 2025',
    startDate: tDate,
    endDate: tDate,
    isLocked: true,
  );

  setUpAll(() {
    registerFallbackValue(const GetOpenItemsParams(kind: 'ar'));
    registerFallbackValue(const GetAccountsParams());
    registerFallbackValue(const GetAccountingPeriodsParams());
  });

  setUp(() {
    mockGetOpenItems = MockGetOpenItemsUseCase();
    mockGetAccounts = MockGetAccountsUseCase();
    mockGetAccountingPeriods = MockGetAccountingPeriodsUseCase();
    cubit = AccountingHomeCubit(
      mockGetOpenItems,
      mockGetAccounts,
      mockGetAccountingPeriods,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has LoadStatus.initial and null reports', () {
    expect(cubit.state, const AccountingHomeState(status: LoadStatus.initial));
  });

  blocTest<AccountingHomeCubit, AccountingHomeState>(
    'load emits loading then success with AR, AP, bank accounts, and current period',
    build: () {
      when(
        () => mockGetOpenItems(const GetOpenItemsParams(kind: 'ar')),
      ).thenAnswer((_) async => const Right(tArReport));
      when(
        () => mockGetOpenItems(const GetOpenItemsParams(kind: 'ap')),
      ).thenAnswer((_) async => const Right(tApReport));
      when(
        () => mockGetAccounts(
          const GetAccountsParams(limit: 100, isActive: true),
        ),
      ).thenAnswer((_) async => Right(tAccountsPage));
      when(
        () => mockGetAccountingPeriods(const GetAccountingPeriodsParams()),
      ).thenAnswer((_) async => Right([tLockedPeriod, tOpenPeriod]));
      return cubit;
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const AccountingHomeState(status: LoadStatus.loading),
      AccountingHomeState(
        status: LoadStatus.success,
        openAr: tArReport,
        openAp: tApReport,
        bankAndCashAccounts: const [tBankAccount],
        currentPeriod: tOpenPeriod,
      ),
    ],
  );

  blocTest<AccountingHomeCubit, AccountingHomeState>(
    'load falls back to first period if all periods are locked',
    build: () {
      when(
        () => mockGetOpenItems(any()),
      ).thenAnswer((_) async => const Right(tArReport));
      when(
        () => mockGetAccounts(any()),
      ).thenAnswer((_) async => Right(tAccountsPage));
      when(
        () => mockGetAccountingPeriods(any()),
      ).thenAnswer((_) async => Right([tLockedPeriod]));
      return cubit;
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const AccountingHomeState(status: LoadStatus.loading),
      AccountingHomeState(
        status: LoadStatus.success,
        openAr: tArReport,
        openAp: tArReport,
        bankAndCashAccounts: const [tBankAccount],
        currentPeriod: tLockedPeriod,
      ),
    ],
  );

  blocTest<AccountingHomeCubit, AccountingHomeState>(
    'load emits failure when AR, AP, and accounts all fail',
    build: () {
      when(
        () => mockGetOpenItems(any()),
      ).thenAnswer((_) async => const Left(NetworkFailure()));
      when(
        () => mockGetAccounts(any()),
      ).thenAnswer((_) async => const Left(NetworkFailure()));
      when(
        () => mockGetAccountingPeriods(any()),
      ).thenAnswer((_) async => const Left(NetworkFailure()));
      return cubit;
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const AccountingHomeState(status: LoadStatus.loading),
      const AccountingHomeState(
        status: LoadStatus.failure,
        failure: NetworkFailure(),
      ),
    ],
  );

  group('Accounting period resolution', () {
    final tJanPeriod = AccountingPeriod(
      id: '1',
      fiscalYearId: '1',
      periodNumber: 1,
      name: 'Jan 2026',
      startDate: DateTime.utc(2026, 1, 1),
      endDate: DateTime.utc(2026, 1, 31),
      isLocked: false,
    );

    final tFebPeriod = AccountingPeriod(
      id: '2',
      fiscalYearId: '1',
      periodNumber: 2,
      name: 'Feb 2026',
      startDate: DateTime.utc(2026, 2, 1),
      endDate: DateTime.utc(2026, 2, 28),
      isLocked: false,
    );

    final tLockedPeriod1 = AccountingPeriod(
      id: '10',
      fiscalYearId: '1',
      periodNumber: 1,
      name: 'Jan 2025',
      startDate: DateTime.utc(2025, 1, 1),
      endDate: DateTime.utc(2025, 1, 31),
      isLocked: true,
    );

    final tLockedPeriod2 = AccountingPeriod(
      id: '11',
      fiscalYearId: '1',
      periodNumber: 2,
      name: 'Feb 2025',
      startDate: DateTime.utc(2025, 2, 1),
      endDate: DateTime.utc(2025, 2, 28),
      isLocked: true,
    );

    blocTest<AccountingHomeCubit, AccountingHomeState>(
      'picks unlocked period where current date falls between startDate and endDate',
      build: () {
        when(() => mockGetOpenItems(any()))
            .thenAnswer((_) async => const Right(tArReport));
        when(() => mockGetAccounts(any()))
            .thenAnswer((_) async => Right(tAccountsPage));
        when(() => mockGetAccountingPeriods(any()))
            .thenAnswer((_) async => Right([tJanPeriod, tFebPeriod]));
        return AccountingHomeCubit.withClock(
          mockGetOpenItems,
          mockGetAccounts,
          mockGetAccountingPeriods,
          now: () => DateTime.utc(2026, 2, 15),
        );
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const AccountingHomeState(status: LoadStatus.loading),
        AccountingHomeState(
          status: LoadStatus.success,
          openAr: tArReport,
          openAp: tArReport,
          bankAndCashAccounts: const [tBankAccount],
          currentPeriod: tFebPeriod,
        ),
      ],
    );

    blocTest<AccountingHomeCubit, AccountingHomeState>(
      'picks first unlocked period when current date is outside range of all unlocked periods',
      build: () {
        when(() => mockGetOpenItems(any()))
            .thenAnswer((_) async => const Right(tArReport));
        when(() => mockGetAccounts(any()))
            .thenAnswer((_) async => Right(tAccountsPage));
        when(() => mockGetAccountingPeriods(any()))
            .thenAnswer((_) async => Right([tJanPeriod, tFebPeriod]));
        return AccountingHomeCubit.withClock(
          mockGetOpenItems,
          mockGetAccounts,
          mockGetAccountingPeriods,
          now: () => DateTime.utc(2026, 5, 1),
        );
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const AccountingHomeState(status: LoadStatus.loading),
        AccountingHomeState(
          status: LoadStatus.success,
          openAr: tArReport,
          openAp: tArReport,
          bankAndCashAccounts: const [tBankAccount],
          currentPeriod: tJanPeriod,
        ),
      ],
    );

    blocTest<AccountingHomeCubit, AccountingHomeState>(
      'falls back to periods.first when all periods are locked',
      build: () {
        when(() => mockGetOpenItems(any()))
            .thenAnswer((_) async => const Right(tArReport));
        when(() => mockGetAccounts(any()))
            .thenAnswer((_) async => Right(tAccountsPage));
        when(() => mockGetAccountingPeriods(any()))
            .thenAnswer((_) async => Right([tLockedPeriod1, tLockedPeriod2]));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const AccountingHomeState(status: LoadStatus.loading),
        AccountingHomeState(
          status: LoadStatus.success,
          openAr: tArReport,
          openAp: tArReport,
          bankAndCashAccounts: const [tBankAccount],
          currentPeriod: tLockedPeriod1,
        ),
      ],
    );
  });

  group('Cash and Bank account sorting', () {
    const acc2000 = Account(
      id: '20',
      code: '2000',
      name: 'ICICI Current A/C',
      type: 'asset',
      isBank: true,
      isActive: true,
    );
    const acc1000 = Account(
      id: '10',
      code: '1000',
      name: 'HDFC Main A/C',
      type: 'asset',
      isBank: true,
      isActive: true,
    );
    const acc1050 = Account(
      id: '15',
      code: '1050',
      name: 'Cash in Hand',
      type: 'asset',
      isBank: true,
      isActive: true,
    );
    const nonBankAcc = Account(
      id: '50',
      code: '5000',
      name: 'Office Rent',
      type: 'expense',
      isBank: false,
      isActive: true,
    );

    blocTest<AccountingHomeCubit, AccountingHomeState>(
      'filters isBank == true and sorts accounts ascending by code',
      build: () {
        when(() => mockGetOpenItems(any()))
            .thenAnswer((_) async => const Right(tArReport));
        when(() => mockGetAccounts(any())).thenAnswer(
          (_) async => const Right(
            CursorPage<Account>(
              items: [acc2000, nonBankAcc, acc1050, acc1000],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        when(() => mockGetAccountingPeriods(any()))
            .thenAnswer((_) async => Right([tOpenPeriod]));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const AccountingHomeState(status: LoadStatus.loading),
        AccountingHomeState(
          status: LoadStatus.success,
          openAr: tArReport,
          openAp: tArReport,
          bankAndCashAccounts: const [acc1000, acc1050, acc2000],
          currentPeriod: tOpenPeriod,
        ),
      ],
    );
  });

  group('Partial failure handling', () {
    blocTest<AccountingHomeCubit, AccountingHomeState>(
      'emits success when only AR succeeds and other calls fail',
      build: () {
        when(
          () => mockGetOpenItems(const GetOpenItemsParams(kind: 'ar')),
        ).thenAnswer((_) async => const Right(tArReport));
        when(
          () => mockGetOpenItems(const GetOpenItemsParams(kind: 'ap')),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        when(
          () => mockGetAccounts(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        when(
          () => mockGetAccountingPeriods(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const AccountingHomeState(status: LoadStatus.loading),
        const AccountingHomeState(
          status: LoadStatus.success,
          openAr: tArReport,
          openAp: null,
          bankAndCashAccounts: [],
          currentPeriod: null,
        ),
      ],
    );

    blocTest<AccountingHomeCubit, AccountingHomeState>(
      'emits success when only AP succeeds and other calls fail',
      build: () {
        when(
          () => mockGetOpenItems(const GetOpenItemsParams(kind: 'ar')),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        when(
          () => mockGetOpenItems(const GetOpenItemsParams(kind: 'ap')),
        ).thenAnswer((_) async => const Right(tApReport));
        when(
          () => mockGetAccounts(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        when(
          () => mockGetAccountingPeriods(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const AccountingHomeState(status: LoadStatus.loading),
        const AccountingHomeState(
          status: LoadStatus.success,
          openAr: null,
          openAp: tApReport,
          bankAndCashAccounts: [],
          currentPeriod: null,
        ),
      ],
    );

    blocTest<AccountingHomeCubit, AccountingHomeState>(
      'emits success when only accounts succeeds and other calls fail',
      build: () {
        when(
          () => mockGetOpenItems(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        when(
          () => mockGetAccounts(any()),
        ).thenAnswer((_) async => Right(tAccountsPage));
        when(
          () => mockGetAccountingPeriods(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const AccountingHomeState(status: LoadStatus.loading),
        const AccountingHomeState(
          status: LoadStatus.success,
          openAr: null,
          openAp: null,
          bankAndCashAccounts: [tBankAccount],
          currentPeriod: null,
        ),
      ],
    );
  });
}
