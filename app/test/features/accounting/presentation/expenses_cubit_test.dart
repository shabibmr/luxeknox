import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/expense_voucher.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_expenses_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/expenses_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetExpensesUseCase extends Mock implements GetExpensesUseCase {}

void main() {
  late MockGetExpensesUseCase mockGetExpenses;
  late ExpensesCubit cubit;

  final tDate = DateTime.utc(2026, 10, 15);

  final tExpense1 = ExpenseVoucher(
    id: 'exp-1',
    voucherNumber: 'EXP-2026-0001',
    expenseDate: tDate,
    bankAccountId: 'acc-1',
    totalAmount: '250.00',
    taxAmount: '0.00',
    status: 'draft',
    memo: 'Office supplies',
  );

  final tExpense2 = ExpenseVoucher(
    id: 'exp-2',
    voucherNumber: 'EXP-2026-0002',
    expenseDate: tDate,
    bankAccountId: 'acc-1',
    totalAmount: '120.00',
    taxAmount: '0.00',
    status: 'posted',
    journalEntryId: 'j-99',
    memo: 'Coffee supplies',
  );

  setUpAll(() {
    registerFallbackValue(const GetExpensesParams());
  });

  setUp(() {
    mockGetExpenses = MockGetExpensesUseCase();
    cubit = ExpensesCubit(mockGetExpenses);
  });

  tearDown(() {
    cubit.close();
  });

  group('initial state', () {
    test('has correct default values', () {
      expect(cubit.state.status, LoadStatus.initial);
      expect(cubit.state.expenses, isEmpty);
      expect(cubit.state.hasMore, isFalse);
      expect(cubit.state.isLoadingMore, isFalse);
      expect(cubit.state.offset, 0);
      expect(cubit.state.failure, isNull);
    });
  });

  group('load', () {
    blocTest<ExpensesCubit, ExpensesState>(
      'emits loading then success when usecase succeeds',
      build: () {
        when(() => mockGetExpenses(any())).thenAnswer(
          (_) async => Right(
            CursorPage<ExpenseVoucher>(
              items: [tExpense1, tExpense2],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      act: (c) => c.load(),
      expect: () => [
        const ExpensesState(
          status: LoadStatus.loading,
          expenses: [],
          offset: 0,
        ),
        ExpensesState(
          status: LoadStatus.success,
          expenses: [tExpense1, tExpense2],
          offset: 2,
          hasMore: false,
        ),
      ],
    );

    blocTest<ExpensesCubit, ExpensesState>(
      'emits loading then failure when usecase fails',
      build: () {
        when(() => mockGetExpenses(any())).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Server error')),
        );
        return cubit;
      },
      act: (c) => c.load(),
      expect: () => [
        const ExpensesState(
          status: LoadStatus.loading,
          expenses: [],
          offset: 0,
        ),
        const ExpensesState(
          status: LoadStatus.failure,
          failure: BusinessRuleFailure('Server error'),
          offset: 0,
        ),
      ],
    );
  });

  group('loadMore', () {
    final tExpense3 = ExpenseVoucher(
      id: 'exp-3',
      voucherNumber: 'EXP-2026-0003',
      expenseDate: tDate,
      totalAmount: '45.00',
      taxAmount: '0.00',
      status: 'draft',
    );

    blocTest<ExpensesCubit, ExpensesState>(
      'appends items when hasMore is true',
      seed: () => ExpensesState(
        status: LoadStatus.success,
        expenses: [tExpense1],
        hasMore: true,
        offset: 1,
      ),
      build: () {
        when(() => mockGetExpenses(any())).thenAnswer(
          (_) async => Right(
            CursorPage<ExpenseVoucher>(
              items: [tExpense3],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      act: (c) => c.loadMore(),
      expect: () => [
        ExpensesState(
          status: LoadStatus.success,
          expenses: [tExpense1],
          hasMore: true,
          isLoadingMore: true,
          offset: 1,
        ),
        ExpensesState(
          status: LoadStatus.success,
          expenses: [tExpense1, tExpense3],
          hasMore: false,
          isLoadingMore: false,
          offset: 2,
        ),
      ],
    );

    blocTest<ExpensesCubit, ExpensesState>(
      'does nothing when hasMore is false',
      seed: () => ExpensesState(
        status: LoadStatus.success,
        expenses: [tExpense1],
        hasMore: false,
      ),
      build: () => cubit,
      act: (c) => c.loadMore(),
      expect: () => [],
    );
  });

  group('filtering and search', () {
    blocTest<ExpensesCubit, ExpensesState>(
      'filterByStatus updates statusFilter and reloads',
      build: () {
        when(() => mockGetExpenses(any())).thenAnswer(
          (_) async => Right(
            CursorPage<ExpenseVoucher>(
              items: [tExpense1],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      act: (c) => c.filterByStatus('draft'),
      verify: (_) {
        verify(
          () => mockGetExpenses(
            const GetExpensesParams(
              status: 'draft',
              limit: 20,
              offset: 0,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<ExpensesCubit, ExpensesState>(
      'filterByVendor updates vendorId and reloads',
      build: () {
        when(() => mockGetExpenses(any())).thenAnswer(
          (_) async => Right(
            CursorPage<ExpenseVoucher>(
              items: [tExpense1],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      act: (c) => c.filterByVendor('v-123'),
      verify: (_) {
        verify(
          () => mockGetExpenses(
            const GetExpensesParams(
              vendorId: 'v-123',
              limit: 20,
              offset: 0,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<ExpensesCubit, ExpensesState>(
      'clearFilters resets filters and reloads',
      seed: () => ExpensesState(
        statusFilter: 'draft',
        vendorId: 'v-1',
        search: 'paper',
        fromDate: DateTime(2026, 1, 1),
        toDate: DateTime(2026, 1, 31),
      ),
      build: () {
        when(() => mockGetExpenses(any())).thenAnswer(
          (_) async => const Right(
            CursorPage<ExpenseVoucher>(
              items: [],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      act: (c) => c.clearFilters(),
      verify: (_) {
        verify(
          () => mockGetExpenses(
            const GetExpensesParams(
              status: null,
              vendorId: null,
              from: null,
              to: null,
              search: null,
              limit: 20,
              offset: 0,
            ),
          ),
        ).called(1);
      },
    );
  });
}
