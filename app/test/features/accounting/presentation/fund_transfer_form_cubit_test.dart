import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/entities/fund_transfer.dart';
import 'package:luxeknox/features/accounting/domain/usecases/create_fund_transfer_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/fund_transfer_form_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateFundTransferUseCase extends Mock
    implements CreateFundTransferUseCase {}

void main() {
  late MockCreateFundTransferUseCase mockCreateFundTransfer;
  late FundTransferFormCubit cubit;

  const tFromAccount = Account(
    id: '101',
    name: 'Operating Cash',
    type: 'asset',
  );

  const tToAccount = Account(
    id: '102',
    name: 'Petty Cash',
    type: 'asset',
  );

  const tFeeAccount = Account(
    id: '501',
    name: 'Bank & Processing Fees',
    type: 'expense',
  );

  final tDate = DateTime.utc(2026, 10, 15);

  final tCreatedTransfer = FundTransfer(
    id: 'ft-200',
    transferNumber: 'TRF-2026-0200',
    transferDate: tDate,
    fromAccountId: '101',
    toAccountId: '102',
    amount: '300.00',
    feeAmount: '3.00',
    feeAccountId: '501',
    status: 'draft',
  );

  setUpAll(() {
    registerFallbackValue(
      CreateFundTransferParams(
        transferDate: tDate,
        fromAccountId: '101',
        toAccountId: '102',
        amount: '300.00',
      ),
    );
  });

  setUp(() {
    mockCreateFundTransfer = MockCreateFundTransferUseCase();
    cubit = FundTransferFormCubit(mockCreateFundTransfer);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has default empty values', () {
    expect(cubit.state.status, LoadStatus.initial);
    expect(cubit.state.fromAccountId, isEmpty);
    expect(cubit.state.toAccountId, isEmpty);
    expect(cubit.state.amount, isEmpty);
    expect(cubit.state.feeAmount, isEmpty);
    expect(cubit.state.isSubmitting, isFalse);
  });

  group('account selection and validation', () {
    test('fromAccountSelected updates fromAccountId and clears error', () {
      cubit.fromAccountSelected(tFromAccount);
      expect(cubit.state.fromAccountId, '101');
      expect(cubit.state.fromAccount, tFromAccount);
      expect(cubit.state.fromAccountError, isNull);
    });

    test('selecting same from and to account sets error', () {
      cubit.fromAccountSelected(tFromAccount);
      cubit.toAccountSelected(tFromAccount);

      expect(cubit.state.toAccountError,
          AccountingStrings.cannotTransferSameAccount);
    });

    test('toAccountSelected with different account is valid', () {
      cubit.fromAccountSelected(tFromAccount);
      cubit.toAccountSelected(tToAccount);

      expect(cubit.state.toAccountId, '102');
      expect(cubit.state.toAccountError, isNull);
    });

    test('feeAccountSelected updates feeAccount', () {
      cubit.feeAccountSelected(tFeeAccount);
      expect(cubit.state.feeAccountId, '501');
      expect(cubit.state.feeAccount, tFeeAccount);

      cubit.feeAccountSelected(null);
      expect(cubit.state.feeAccountId, isNull);
      expect(cubit.state.feeAccount, isNull);
    });
  });

  group('amount and fee validation', () {
    test('amountChanged validates positive numbers', () {
      cubit.amountChanged('-50');
      expect(cubit.state.amountError, isNotNull);

      cubit.amountChanged('abc');
      expect(cubit.state.amountError, isNotNull);

      cubit.amountChanged('250.00');
      expect(cubit.state.amountError, isNull);
    });

    test('feeAmountChanged validates non-negative numbers', () {
      cubit.feeAmountChanged('-5');
      expect(cubit.state.feeAmountError, isNotNull);

      cubit.feeAmountChanged('0.00');
      expect(cubit.state.feeAmountError, isNull);

      cubit.feeAmountChanged('5.00');
      expect(cubit.state.feeAmountError, isNull);
    });
  });

  group('submit', () {
    test('returns false when validation fails', () async {
      final result = await cubit.submit();

      expect(result, isFalse);
      expect(cubit.state.fromAccountError, isNotNull);
      expect(cubit.state.toAccountError, isNotNull);
      expect(cubit.state.amountError, isNotNull);
      verifyNever(() => mockCreateFundTransfer(any()));
    });

    blocTest<FundTransferFormCubit, FundTransferFormState>(
      'calls CreateFundTransferUseCase and emits [submitting, success] on valid input',
      build: () {
        when(() => mockCreateFundTransfer(any()))
            .thenAnswer((_) async => Right(tCreatedTransfer));
        return cubit;
      },
      seed: () => FundTransferFormState(
        transferDate: tDate,
        fromAccountId: '101',
        toAccountId: '102',
        amount: '300.00',
        feeAmount: '3.00',
        feeAccountId: '501',
        memo: 'Test transfer',
      ),
      act: (cubit) async => cubit.submit(),
      expect: () => [
        FundTransferFormState(
          transferDate: tDate,
          fromAccountId: '101',
          toAccountId: '102',
          amount: '300.00',
          feeAmount: '3.00',
          feeAccountId: '501',
          memo: 'Test transfer',
          isSubmitting: true,
        ),
        FundTransferFormState(
          status: LoadStatus.success,
          createdTransfer: tCreatedTransfer,
          transferDate: tDate,
          fromAccountId: '101',
          toAccountId: '102',
          amount: '300.00',
          feeAmount: '3.00',
          feeAccountId: '501',
          memo: 'Test transfer',
          isSubmitting: false,
        ),
      ],
      verify: (_) {
        verify(() => mockCreateFundTransfer(
              CreateFundTransferParams(
                transferDate: tDate,
                fromAccountId: '101',
                toAccountId: '102',
                amount: '300.00',
                feeAmount: '3.00',
                feeAccountId: '501',
                memo: 'Test transfer',
              ),
            )).called(1);
      },
    );

    blocTest<FundTransferFormCubit, FundTransferFormState>(
      'emits failure when create use case fails',
      build: () {
        when(() => mockCreateFundTransfer(any())).thenAnswer(
            (_) async => const Left(BusinessRuleFailure('Insufficient funds')));
        return cubit;
      },
      seed: () => FundTransferFormState(
        transferDate: tDate,
        fromAccountId: '101',
        toAccountId: '102',
        amount: '300.00',
      ),
      act: (cubit) async => cubit.submit(),
      expect: () => [
        FundTransferFormState(
          transferDate: tDate,
          fromAccountId: '101',
          toAccountId: '102',
          amount: '300.00',
          isSubmitting: true,
        ),
        FundTransferFormState(
          status: LoadStatus.failure,
          failure: const BusinessRuleFailure('Insufficient funds'),
          transferDate: tDate,
          fromAccountId: '101',
          toAccountId: '102',
          amount: '300.00',
          isSubmitting: false,
        ),
      ],
    );
  });
}
