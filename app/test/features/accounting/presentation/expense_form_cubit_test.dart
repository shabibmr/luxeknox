import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/entities/expense_voucher.dart';
import 'package:luxeknox/features/accounting/domain/entities/vendor.dart';
import 'package:luxeknox/features/accounting/domain/usecases/create_expense_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/expense_form_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateExpenseUseCase extends Mock implements CreateExpenseUseCase {}

void main() {
  late MockCreateExpenseUseCase mockCreateExpense;
  late ExpenseFormCubit cubit;

  final tDate = DateTime(2026, 10, 15);

  const tBank = Account(
    id: 'acc-bank',
    code: '1020',
    name: 'Operating Bank Account',
    type: 'asset',
    isActive: true,
    isBank: true,
  );

  const tExpenseAccount = Account(
    id: 'acc-exp',
    code: '6010',
    name: 'Office Expenses',
    type: 'expense',
    isActive: true,
  );

  const tVendor = Vendor(
    id: 'ven-1',
    name: 'Stationery Supplier Co',
  );

  final tCreatedExpense = ExpenseVoucher(
    id: 'exp-100',
    voucherNumber: 'EXP-2026-0100',
    expenseDate: tDate,
    bankAccountId: 'acc-bank',
    totalAmount: '150.00',
    taxAmount: '0.00',
    status: 'draft',
  );

  setUpAll(() {
    registerFallbackValue(
      CreateExpenseParams(
        expenseDate: DateTime(2026, 1, 1),
        lines: const [],
      ),
    );
  });

  setUp(() {
    mockCreateExpense = MockCreateExpenseUseCase();
    cubit = ExpenseFormCubit(mockCreateExpense);
  });

  tearDown(() {
    cubit.close();
  });

  group('initial state', () {
    test('has 1 empty line and cannot submit initially', () {
      expect(cubit.state.status, LoadStatus.initial);
      expect(cubit.state.lines.length, 1);
      expect(cubit.state.paidFromAccount, isNull);
      expect(cubit.state.vendor, isNull);
      expect(cubit.state.payeeName, isNull);
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.canSubmit, isFalse);
      expect(cubit.state.subtotal, 0.0);
      expect(cubit.state.totalAmount, 0.0);
    });
  });

  group('line manipulation and totals calculation', () {
    test('addLine adds an empty line', () {
      cubit.addLine();
      expect(cubit.state.lines.length, 2);
    });

    test('removeLine removes line at index but does not remove if only 1 line remains', () {
      cubit.addLine();
      expect(cubit.state.lines.length, 2);

      cubit.removeLine(0);
      expect(cubit.state.lines.length, 1);

      cubit.removeLine(0);
      expect(cubit.state.lines.length, 1);
    });

    test('updateLine updates line details and recalculates totals', () {
      cubit.updateLine(
        0,
        account: tExpenseAccount,
        description: 'Printer ink',
        amount: '85.50',
      );

      expect(cubit.state.lines[0].account, tExpenseAccount);
      expect(cubit.state.lines[0].description, 'Printer ink');
      expect(cubit.state.lines[0].amount, '85.50');
      expect(cubit.state.subtotal, 85.50);
      expect(cubit.state.totalAmount, 85.50);
    });
  });

  group('credit expense vs paid expense validation', () {
    test('paid from bank account allows submit with valid line without payee', () {
      cubit.setPaidFromAccount(tBank);
      cubit.updateLine(
        0,
        account: tExpenseAccount,
        amount: '50.00',
      );

      expect(cubit.state.isCreditExpense, isFalse);
      expect(cubit.state.hasValidPayee, isTrue);
      expect(cubit.state.canSubmit, isTrue);
    });

    test('credit expense (paidFromAccount == null) requires vendor or payeeName', () {
      cubit.setPaidFromAccount(null);
      cubit.updateLine(
        0,
        account: tExpenseAccount,
        amount: '50.00',
      );

      expect(cubit.state.isCreditExpense, isTrue);
      expect(cubit.state.hasValidPayee, isFalse);
      expect(cubit.state.canSubmit, isFalse);

      cubit.setPayeeName('Local Hardware Store');
      expect(cubit.state.hasValidPayee, isTrue);
      expect(cubit.state.canSubmit, isTrue);

      cubit.setPayeeName(null);
      cubit.setVendor(tVendor);
      expect(cubit.state.hasValidPayee, isTrue);
      expect(cubit.state.canSubmit, isTrue);
    });
  });

  group('submit', () {
    blocTest<ExpenseFormCubit, ExpenseFormState>(
      'emits success and sets createdExpense when submission succeeds',
      build: () {
        when(() => mockCreateExpense(any()))
            .thenAnswer((_) async => Right(tCreatedExpense));
        return cubit;
      },
      seed: () {
        final state = ExpenseFormState(
          expenseDate: tDate,
          paidFromAccount: tBank,
        );
        return state.copyWith(
          lines: const [
            ExpenseFormLineDraft(
              account: tExpenseAccount,
              amount: '150.00',
              description: 'Desk chairs',
            ),
          ],
        );
      },
      act: (c) => c.submit(),
      expect: () => [
        predicate<ExpenseFormState>((s) => s.isSubmitting == true),
        predicate<ExpenseFormState>(
          (s) =>
              s.isSubmitting == false &&
              s.status == LoadStatus.success &&
              s.createdExpense == tCreatedExpense,
        ),
      ],
    );

    blocTest<ExpenseFormCubit, ExpenseFormState>(
      'emits failure when submission fails',
      build: () {
        when(() => mockCreateExpense(any())).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Invalid account')),
        );
        return cubit;
      },
      seed: () {
        final state = ExpenseFormState(
          expenseDate: tDate,
          paidFromAccount: tBank,
        );
        return state.copyWith(
          lines: const [
            ExpenseFormLineDraft(
              account: tExpenseAccount,
              amount: '150.00',
            ),
          ],
        );
      },
      act: (c) => c.submit(),
      expect: () => [
        predicate<ExpenseFormState>((s) => s.isSubmitting == true),
        predicate<ExpenseFormState>(
          (s) =>
              s.isSubmitting == false &&
              s.status == LoadStatus.failure &&
              s.failure != null,
        ),
      ],
    );
  });
}
