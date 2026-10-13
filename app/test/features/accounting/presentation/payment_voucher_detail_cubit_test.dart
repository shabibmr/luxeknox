import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/payment_voucher.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_payment_voucher_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/post_payment_voucher_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/payment_voucher_detail_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPaymentVoucherUseCase extends Mock
    implements GetPaymentVoucherUseCase {}

class MockPostPaymentVoucherUseCase extends Mock
    implements PostPaymentVoucherUseCase {}

void main() {
  late MockGetPaymentVoucherUseCase mockGetPaymentVoucher;
  late MockPostPaymentVoucherUseCase mockPostPaymentVoucher;
  late PaymentVoucherDetailCubit cubit;

  final tDate = DateTime(2026, 10, 15);

  final tDraftVoucher = PaymentVoucher(
    id: 'pv-1',
    voucherNumber: 'PV-2026-0001',
    voucherDate: tDate,
    vendorId: 'ven-1',
    bankAccountId: 'acc-bank',
    amount: '400.00',
    status: 'draft',
    allocations: const [
      PaymentVoucherAllocation(
        id: 'pva-1',
        paymentVoucherId: 'pv-1',
        purchaseBillId: 'bill-1',
        amount: '400.00',
      ),
    ],
  );

  final tPostedVoucher = PaymentVoucher(
    id: 'pv-1',
    voucherNumber: 'PV-2026-0001',
    voucherDate: tDate,
    vendorId: 'ven-1',
    bankAccountId: 'acc-bank',
    amount: '400.00',
    status: 'posted',
    journalEntryId: 'j-888',
    allocations: const [
      PaymentVoucherAllocation(
        id: 'pva-1',
        paymentVoucherId: 'pv-1',
        purchaseBillId: 'bill-1',
        amount: '400.00',
      ),
    ],
  );

  setUp(() {
    mockGetPaymentVoucher = MockGetPaymentVoucherUseCase();
    mockPostPaymentVoucher = MockPostPaymentVoucherUseCase();
    cubit = PaymentVoucherDetailCubit(
      mockGetPaymentVoucher,
      mockPostPaymentVoucher,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('initial state', () {
    test('has initial load status and null voucher', () {
      expect(cubit.state.status, LoadStatus.initial);
      expect(cubit.state.voucher, isNull);
      expect(cubit.state.isPosting, isFalse);
      expect(cubit.state.failure, isNull);
    });
  });

  group('load', () {
    blocTest<PaymentVoucherDetailCubit, PaymentVoucherDetailState>(
      'emits loading then success when GetPaymentVoucherUseCase succeeds',
      build: () {
        when(() => mockGetPaymentVoucher('pv-1'))
            .thenAnswer((_) async => Right(tDraftVoucher));
        return cubit;
      },
      act: (c) => c.load('pv-1'),
      expect: () => [
        const PaymentVoucherDetailState(
          status: LoadStatus.loading,
          voucher: null,
        ),
        PaymentVoucherDetailState(
          status: LoadStatus.success,
          voucher: tDraftVoucher,
        ),
      ],
    );

    blocTest<PaymentVoucherDetailCubit, PaymentVoucherDetailState>(
      'emits loading then failure when GetPaymentVoucherUseCase fails',
      build: () {
        when(() => mockGetPaymentVoucher('pv-1')).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Not found')),
        );
        return cubit;
      },
      act: (c) => c.load('pv-1'),
      expect: () => [
        const PaymentVoucherDetailState(
          status: LoadStatus.loading,
          voucher: null,
        ),
        const PaymentVoucherDetailState(
          status: LoadStatus.failure,
          failure: BusinessRuleFailure('Not found'),
        ),
      ],
    );
  });

  group('setVoucher', () {
    test('emits success with given voucher', () {
      cubit.setVoucher(tDraftVoucher);
      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.voucher, tDraftVoucher);
    });
  });

  group('post', () {
    blocTest<PaymentVoucherDetailCubit, PaymentVoucherDetailState>(
      'posts voucher and updates state with posted status and journalEntryId',
      seed: () => PaymentVoucherDetailState(
        status: LoadStatus.success,
        voucher: tDraftVoucher,
      ),
      build: () {
        when(() => mockPostPaymentVoucher('pv-1'))
            .thenAnswer((_) async => Right(tPostedVoucher));
        return cubit;
      },
      act: (c) => c.post(),
      expect: () => [
        PaymentVoucherDetailState(
          status: LoadStatus.success,
          voucher: tDraftVoucher,
          isPosting: true,
        ),
        PaymentVoucherDetailState(
          status: LoadStatus.success,
          voucher: tPostedVoucher,
          postSuccess: tPostedVoucher,
          isPosting: false,
        ),
      ],
      verify: (_) {
        expect(cubit.state.voucher?.status, 'posted');
        expect(cubit.state.voucher?.journalEntryId, 'j-888');
      },
    );

    blocTest<PaymentVoucherDetailCubit, PaymentVoucherDetailState>(
      'emits failure when post fails',
      seed: () => PaymentVoucherDetailState(
        status: LoadStatus.success,
        voucher: tDraftVoucher,
      ),
      build: () {
        when(() => mockPostPaymentVoucher('pv-1')).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Post failed')),
        );
        return cubit;
      },
      act: (c) => c.post(),
      expect: () => [
        PaymentVoucherDetailState(
          status: LoadStatus.success,
          voucher: tDraftVoucher,
          isPosting: true,
        ),
        PaymentVoucherDetailState(
          status: LoadStatus.success,
          voucher: tDraftVoucher,
          failure: const BusinessRuleFailure('Post failed'),
          isPosting: false,
        ),
      ],
    );
  });
}
