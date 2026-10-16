import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/entities/payment_voucher.dart';
import 'package:luxeknox/features/accounting/domain/usecases/create_payment_voucher_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/payment_voucher_form_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockCreatePaymentVoucherUseCase extends Mock
    implements CreatePaymentVoucherUseCase {}

void main() {
  late MockCreatePaymentVoucherUseCase mockCreatePaymentVoucher;
  late PaymentVoucherFormCubit cubit;

  final tDate = DateTime(2026, 10, 15);

  const tBankAccount = Account(
    id: 'acc-bank',
    name: 'Operating Bank Account',
    type: 'asset',
    isActive: true,
    isBank: true,
  );

  final tCreatedVoucher = PaymentVoucher(
    id: 'pv-100',
    voucherNumber: 'PV-2026-0100',
    voucherDate: tDate,
    vendorId: 'ven-1',
    bankAccountId: 'acc-bank',
    amount: '300.00',
    status: 'draft',
  );

  setUpAll(() {
    registerFallbackValue(
      CreatePaymentVoucherParams(
        paymentDate: DateTime(2026, 1, 1),
        bankAccountId: 'acc-bank',
        totalAmount: '100.00',
        allocations: const [],
      ),
    );
  });

  setUp(() {
    mockCreatePaymentVoucher = MockCreatePaymentVoucherUseCase();
    cubit = PaymentVoucherFormCubit(mockCreatePaymentVoucher);
  });

  tearDown(() {
    cubit.close();
  });

  group('initial state', () {
    test('has 1 empty allocation and cannot submit initially', () {
      expect(cubit.state.status, LoadStatus.initial);
      expect(cubit.state.bankAccount, isNull);
      expect(cubit.state.totalAmount, isEmpty);
      expect(cubit.state.allocations.length, 1);
      expect(cubit.state.canSubmit, isFalse);
      expect(cubit.state.allocationsSum, 0.0);
    });
  });

  group('CRITICAL ACC-095: verifies allocations sum must equal total amount', () {
    test('allocations sum mismatch flags mismatch and disables submit', () {
      cubit.setBankAccount(tBankAccount);
      cubit.setTotalAmount('300.00');

      cubit.updateAllocation(
        0,
        targetType: 'bill',
        targetId: 'bill-1',
        amount: '200.00',
      );

      // Allocations sum is 200, total amount is 300 -> MISMATCH!
      expect(cubit.state.allocationsSum, 200.0);
      expect(cubit.state.parsedTotalAmount, 300.0);
      expect(cubit.state.isAllocationsMatching, isFalse);
      expect(cubit.state.hasAllocationMismatch, isTrue);
      expect(cubit.state.canSubmit, isFalse);

      // Add another allocation to balance it: 200 + 100 = 300 -> MATCH!
      cubit.addAllocation(
        targetType: 'expense',
        targetId: 'exp-1',
        amount: '100.00',
      );

      expect(cubit.state.allocationsSum, 300.0);
      expect(cubit.state.parsedTotalAmount, 300.0);
      expect(cubit.state.isAllocationsMatching, isTrue);
      expect(cubit.state.hasAllocationMismatch, isFalse);
      expect(cubit.state.canSubmit, isTrue);
    });

    test('over-allocation flags mismatch and prevents submit', () {
      cubit.setBankAccount(tBankAccount);
      cubit.setTotalAmount('150.00');
      cubit.updateAllocation(
        0,
        targetType: 'bill',
        targetId: 'bill-1',
        amount: '200.00',
      );

      expect(cubit.state.allocationsSum, 200.0);
      expect(cubit.state.parsedTotalAmount, 150.0);
      expect(cubit.state.isAllocationsMatching, isFalse);
      expect(cubit.state.hasAllocationMismatch, isTrue);
      expect(cubit.state.canSubmit, isFalse);
    });
  });

  group('allocation list manipulation', () {
    test('addAllocation adds allocation and removeAllocation removes it', () {
      cubit.addAllocation(targetType: 'bill', targetId: 'b-2', amount: '50');
      expect(cubit.state.allocations.length, 2);

      cubit.removeAllocation(1);
      expect(cubit.state.allocations.length, 1);

      // Cannot remove last remaining allocation
      cubit.removeAllocation(0);
      expect(cubit.state.allocations.length, 1);
    });
  });

  group('submit', () {
    blocTest<PaymentVoucherFormCubit, PaymentVoucherFormState>(
      'submits when allocations sum exactly equals total amount',
      build: () {
        when(() => mockCreatePaymentVoucher(any()))
            .thenAnswer((_) async => Right(tCreatedVoucher));
        return cubit;
      },
      seed: () {
        final state = PaymentVoucherFormState(
          paymentDate: tDate,
          bankAccount: tBankAccount,
          totalAmount: '300.00',
        );
        return state.copyWith(
          allocations: const [
            PaymentVoucherAllocationDraft(
              targetType: 'bill',
              targetId: 'bill-1',
              amount: '300.00',
            ),
          ],
        );
      },
      act: (c) => c.submit(),
      expect: () => [
        predicate<PaymentVoucherFormState>((s) => s.isSubmitting == true),
        predicate<PaymentVoucherFormState>(
          (s) =>
              s.isSubmitting == false &&
              s.status == LoadStatus.success &&
              s.createdVoucher == tCreatedVoucher,
        ),
      ],
      verify: (_) {
        verify(
          () => mockCreatePaymentVoucher(
            CreatePaymentVoucherParams(
              paymentDate: DateTime(2026, 10, 15),
              bankAccountId: 'acc-bank',
              totalAmount: '300.00',
              memo: null,
              allocations: const [
                {
                  'purchaseBillId': 'bill-1',
                  'amount': '300.00',
                },
              ],
            ),
          ),
        ).called(1);
      },
    );

    blocTest<PaymentVoucherFormCubit, PaymentVoucherFormState>(
      'emits failure when submission fails',
      build: () {
        when(() => mockCreatePaymentVoucher(any())).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Invalid target')),
        );
        return cubit;
      },
      seed: () {
        final state = PaymentVoucherFormState(
          paymentDate: tDate,
          bankAccount: tBankAccount,
          totalAmount: '100.00',
        );
        return state.copyWith(
          allocations: const [
            PaymentVoucherAllocationDraft(
              targetType: 'expense',
              targetId: 'exp-1',
              amount: '100.00',
            ),
          ],
        );
      },
      act: (c) => c.submit(),
      expect: () => [
        predicate<PaymentVoucherFormState>((s) => s.isSubmitting == true),
        predicate<PaymentVoucherFormState>(
          (s) =>
              s.isSubmitting == false &&
              s.status == LoadStatus.failure &&
              s.failure != null,
        ),
      ],
    );
  });
}
