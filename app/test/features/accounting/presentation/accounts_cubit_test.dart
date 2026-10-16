import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_accounts_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/accounts_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAccountsUseCase extends Mock implements GetAccountsUseCase {}

void main() {
  late MockGetAccountsUseCase mockGetAccounts;
  late AccountsCubit cubit;

  const tAccount = Account(
    id: '1',
    name: 'Cash on Hand',
    type: 'asset',
    isBank: true,
    isActive: true,
  );

  const tPage = CursorPage<Account>(
    items: [tAccount],
    nextCursor: null,
    hasMore: false,
  );

  setUpAll(() {
    registerFallbackValue(const GetAccountsParams());
  });

  setUp(() {
    mockGetAccounts = MockGetAccountsUseCase();
    cubit = AccountsCubit(mockGetAccounts);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is AccountsState with LoadStatus.initial', () {
    expect(cubit.state, const AccountsState(status: LoadStatus.initial));
  });

  blocTest<AccountsCubit, AccountsState>(
    'load emits loading then success with accounts list',
    build: () {
      when(() => mockGetAccounts(any())).thenAnswer((_) async => const Right(tPage));
      return cubit;
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const AccountsState(status: LoadStatus.loading),
      const AccountsState(
        status: LoadStatus.success,
        accounts: [tAccount],
      ),
    ],
    verify: (_) {
      verify(
        () => mockGetAccounts(
          const GetAccountsParams(limit: 100),
        ),
      ).called(1);
    },
  );

  blocTest<AccountsCubit, AccountsState>(
    'load emits loading then failure on usecase error',
    build: () {
      when(() => mockGetAccounts(any()))
          .thenAnswer((_) async => const Left(NetworkFailure()));
      return cubit;
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const AccountsState(status: LoadStatus.loading),
      const AccountsState(
        status: LoadStatus.failure,
        failure: NetworkFailure(),
      ),
    ],
  );

  blocTest<AccountsCubit, AccountsState>(
    'filterByType updates accountType and triggers load',
    build: () {
      when(() => mockGetAccounts(any())).thenAnswer((_) async => const Right(tPage));
      return cubit;
    },
    act: (cubit) => cubit.filterByType('asset'),
    expect: () => [
      const AccountsState(
        status: LoadStatus.loading,
        accountType: 'asset',
      ),
      const AccountsState(
        status: LoadStatus.success,
        accountType: 'asset',
        accounts: [tAccount],
      ),
    ],
    verify: (_) {
      verify(
        () => mockGetAccounts(
          const GetAccountsParams(accountType: 'asset', limit: 100),
        ),
      ).called(1);
    },
  );

  blocTest<AccountsCubit, AccountsState>(
    'filterByActive updates isActive and triggers load',
    build: () {
      when(() => mockGetAccounts(any())).thenAnswer((_) async => const Right(tPage));
      return cubit;
    },
    act: (cubit) => cubit.filterByActive(true),
    expect: () => [
      const AccountsState(
        status: LoadStatus.loading,
        isActive: true,
      ),
      const AccountsState(
        status: LoadStatus.success,
        isActive: true,
        accounts: [tAccount],
      ),
    ],
    verify: (_) {
      verify(
        () => mockGetAccounts(
          const GetAccountsParams(isActive: true, limit: 100),
        ),
      ).called(1);
    },
  );

  blocTest<AccountsCubit, AccountsState>(
    'setSearch updates search query and triggers load',
    build: () {
      when(() => mockGetAccounts(any())).thenAnswer((_) async => const Right(tPage));
      return cubit;
    },
    act: (cubit) => cubit.setSearch('cash'),
    expect: () => [
      const AccountsState(
        status: LoadStatus.loading,
        search: 'cash',
      ),
      const AccountsState(
        status: LoadStatus.success,
        search: 'cash',
        accounts: [tAccount],
      ),
    ],
    verify: (_) {
      verify(
        () => mockGetAccounts(
          const GetAccountsParams(search: 'cash', limit: 100),
        ),
      ).called(1);
    },
  );

  blocTest<AccountsCubit, AccountsState>(
    'clearFilters clears type, active, and search',
    seed: () => const AccountsState(
      status: LoadStatus.success,
      accountType: 'asset',
      isActive: true,
      search: 'cash',
    ),
    build: () {
      when(() => mockGetAccounts(any())).thenAnswer((_) async => const Right(tPage));
      return cubit;
    },
    act: (cubit) => cubit.clearFilters(),
    expect: () => [
      const AccountsState(
        status: LoadStatus.loading,
        accountType: null,
        isActive: null,
        search: '',
      ),
      const AccountsState(
        status: LoadStatus.success,
        accountType: null,
        isActive: null,
        search: '',
        accounts: [tAccount],
      ),
    ],
  );
}
