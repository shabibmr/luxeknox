import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/expense_voucher.dart';
import 'package:luxeknox/features/accounting/domain/entities/purchase_bill.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_expense_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/post_expense_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/expense_detail_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetExpenseUseCase extends Mock implements GetExpenseUseCase {}

class MockPostExpenseUseCase extends Mock implements PostExpenseUseCase {}

void main() {
  late MockGetExpenseUseCase mockGetExpense;
  late MockPostExpenseUseCase mockPostExpense;
  late ExpenseDetailCubit cubit;

  final tDate = DateTime(2026, 10, 15);

  final tDraftExpense = ExpenseVoucher(
    id: 'exp-1',
    voucherNumber: 'EXP-2026-0001',
    expenseDate: tDate,
    totalAmount: '200.00',
    taxAmount: '0.00',
    status: 'draft',
    lines: const [
      PurchaseBillLine(
        id: 'line-1',
        billId: 'exp-1',
        accountId: 'acc-6010',
        amount: '200.00',
        quantity: '1',
        unitPrice: '200.00',
        description: 'Office rent',
      ),
    ],
  );

  final tPostedExpense = ExpenseVoucher(
    id: 'exp-1',
    voucherNumber: 'EXP-2026-0001',
    expenseDate: tDate,
    totalAmount: '200.00',
    taxAmount: '0.00',
    status: 'posted',
    journalEntryId: 'j-555',
    lines: const [
      PurchaseBillLine(
        id: 'line-1',
        billId: 'exp-1',
        accountId: 'acc-6010',
        amount: '200.00',
        quantity: '1',
        unitPrice: '200.00',
        description: 'Office rent',
      ),
    ],
  );

  setUp(() {
    mockGetExpense = MockGetExpenseUseCase();
    mockPostExpense = MockPostExpenseUseCase();
    cubit = ExpenseDetailCubit(mockGetExpense, mockPostExpense);
  });

  tearDown(() {
    cubit.close();
  });

  group('initial state', () {
    test('has initial load status and null expense', () {
      expect(cubit.state.status, LoadStatus.initial);
      expect(cubit.state.expense, isNull);
      expect(cubit.state.isPosting, isFalse);
      expect(cubit.state.failure, isNull);
    });
  });

  group('load', () {
    blocTest<ExpenseDetailCubit, ExpenseDetailState>(
      'emits loading then success when GetExpenseUseCase succeeds',
      build: () {
        when(() => mockGetExpense('exp-1'))
            .thenAnswer((_) async => Right(tDraftExpense));
        return cubit;
      },
      act: (c) => c.load('exp-1'),
      expect: () => [
        const ExpenseDetailState(
          status: LoadStatus.loading,
          expense: null,
        ),
        ExpenseDetailState(
          status: LoadStatus.success,
          expense: tDraftExpense,
        ),
      ],
    );

    blocTest<ExpenseDetailCubit, ExpenseDetailState>(
      'emits loading then failure when GetExpenseUseCase fails',
      build: () {
        when(() => mockGetExpense('exp-1')).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Not found')),
        );
        return cubit;
      },
      act: (c) => c.load('exp-1'),
      expect: () => [
        const ExpenseDetailState(
          status: LoadStatus.loading,
          expense: null,
        ),
        const ExpenseDetailState(
          status: LoadStatus.failure,
          failure: BusinessRuleFailure('Not found'),
        ),
      ],
    );
  });

  group('setExpense', () {
    test('emits success with given expense', () {
      cubit.setExpense(tDraftExpense);
      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.expense, tDraftExpense);
    });
  });

  group('post', () {
    blocTest<ExpenseDetailCubit, ExpenseDetailState>(
      'posts expense and updates state with posted status and journalEntryId',
      seed: () => ExpenseDetailState(
        status: LoadStatus.success,
        expense: tDraftExpense,
      ),
      build: () {
        when(() => mockPostExpense('exp-1'))
            .thenAnswer((_) async => Right(tPostedExpense));
        return cubit;
      },
      act: (c) => c.post(),
      expect: () => [
        ExpenseDetailState(
          status: LoadStatus.success,
          expense: tDraftExpense,
          isPosting: true,
        ),
        ExpenseDetailState(
          status: LoadStatus.success,
          expense: tPostedExpense,
          postSuccess: tPostedExpense,
          isPosting: false,
        ),
      ],
      verify: (_) {
        expect(cubit.state.expense?.status, 'posted');
        expect(cubit.state.expense?.journalEntryId, 'j-555');
      },
    );

    blocTest<ExpenseDetailCubit, ExpenseDetailState>(
      'emits failure when post fails',
      seed: () => ExpenseDetailState(
        status: LoadStatus.success,
        expense: tDraftExpense,
      ),
      build: () {
        when(() => mockPostExpense('exp-1')).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Post failed')),
        );
        return cubit;
      },
      act: (c) => c.post(),
      expect: () => [
        ExpenseDetailState(
          status: LoadStatus.success,
          expense: tDraftExpense,
          isPosting: true,
        ),
        ExpenseDetailState(
          status: LoadStatus.success,
          expense: tDraftExpense,
          failure: const BusinessRuleFailure('Post failed'),
          isPosting: false,
        ),
      ],
    );
  });
}
