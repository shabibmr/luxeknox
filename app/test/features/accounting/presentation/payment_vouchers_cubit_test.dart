import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/payment_voucher.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_payment_vouchers_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/payment_vouchers_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPaymentVouchersUseCase extends Mock
    implements GetPaymentVouchersUseCase {}

void main() {
  late MockGetPaymentVouchersUseCase mockGetPaymentVouchers;
  late PaymentVouchersCubit cubit;

  final tDate = DateTime.utc(2026, 10, 15);

  final tVoucher1 = PaymentVoucher(
    id: 'pv-1',
    voucherNumber: 'PV-2026-0001',
    voucherDate: tDate,
    vendorId: 'ven-1',
    bankAccountId: 'acc-1',
    amount: '300.00',
    status: 'draft',
    memo: 'Supplier settlement',
  );

  final tVoucher2 = PaymentVoucher(
    id: 'pv-2',
    voucherNumber: 'PV-2026-0002',
    voucherDate: tDate,
    vendorId: 'ven-2',
    bankAccountId: 'acc-1',
    amount: '150.00',
    status: 'posted',
    journalEntryId: 'j-77',
    memo: 'Contractor payout',
  );

  setUpAll(() {
    registerFallbackValue(const GetPaymentVouchersParams());
  });

  setUp(() {
    mockGetPaymentVouchers = MockGetPaymentVouchersUseCase();
    cubit = PaymentVouchersCubit(mockGetPaymentVouchers);
  });

  tearDown(() {
    cubit.close();
  });

  group('initial state', () {
    test('has correct default values', () {
      expect(cubit.state.status, LoadStatus.initial);
      expect(cubit.state.vouchers, isEmpty);
      expect(cubit.state.hasMore, isFalse);
      expect(cubit.state.isLoadingMore, isFalse);
      expect(cubit.state.offset, 0);
      expect(cubit.state.failure, isNull);
    });
  });

  group('load', () {
    blocTest<PaymentVouchersCubit, PaymentVouchersState>(
      'emits loading then success when usecase succeeds',
      build: () {
        when(() => mockGetPaymentVouchers(any())).thenAnswer(
          (_) async => Right(
            CursorPage<PaymentVoucher>(
              items: [tVoucher1, tVoucher2],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      act: (c) => c.load(),
      expect: () => [
        const PaymentVouchersState(
          status: LoadStatus.loading,
          vouchers: [],
          offset: 0,
        ),
        PaymentVouchersState(
          status: LoadStatus.success,
          vouchers: [tVoucher1, tVoucher2],
          offset: 2,
          hasMore: false,
        ),
      ],
    );

    blocTest<PaymentVouchersCubit, PaymentVouchersState>(
      'emits loading then failure when usecase fails',
      build: () {
        when(() => mockGetPaymentVouchers(any())).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Database error')),
        );
        return cubit;
      },
      act: (c) => c.load(),
      expect: () => [
        const PaymentVouchersState(
          status: LoadStatus.loading,
          vouchers: [],
          offset: 0,
        ),
        const PaymentVouchersState(
          status: LoadStatus.failure,
          failure: BusinessRuleFailure('Database error'),
          offset: 0,
        ),
      ],
    );
  });

  group('loadMore', () {
    final tVoucher3 = PaymentVoucher(
      id: 'pv-3',
      voucherNumber: 'PV-2026-0003',
      voucherDate: tDate,
      vendorId: 'ven-3',
      bankAccountId: 'acc-1',
      amount: '500.00',
      status: 'draft',
    );

    blocTest<PaymentVouchersCubit, PaymentVouchersState>(
      'appends items when hasMore is true',
      seed: () => PaymentVouchersState(
        status: LoadStatus.success,
        vouchers: [tVoucher1],
        hasMore: true,
        offset: 1,
      ),
      build: () {
        when(() => mockGetPaymentVouchers(any())).thenAnswer(
          (_) async => Right(
            CursorPage<PaymentVoucher>(
              items: [tVoucher3],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      act: (c) => c.loadMore(),
      expect: () => [
        PaymentVouchersState(
          status: LoadStatus.success,
          vouchers: [tVoucher1],
          hasMore: true,
          isLoadingMore: true,
          offset: 1,
        ),
        PaymentVouchersState(
          status: LoadStatus.success,
          vouchers: [tVoucher1, tVoucher3],
          hasMore: false,
          isLoadingMore: false,
          offset: 2,
        ),
      ],
    );

    blocTest<PaymentVouchersCubit, PaymentVouchersState>(
      'does nothing when hasMore is false',
      seed: () => PaymentVouchersState(
        status: LoadStatus.success,
        vouchers: [tVoucher1],
        hasMore: false,
      ),
      build: () => cubit,
      act: (c) => c.loadMore(),
      expect: () => [],
    );
  });

  group('filtering and search', () {
    blocTest<PaymentVouchersCubit, PaymentVouchersState>(
      'filterByStatus updates statusFilter and reloads',
      build: () {
        when(() => mockGetPaymentVouchers(any())).thenAnswer(
          (_) async => Right(
            CursorPage<PaymentVoucher>(
              items: [tVoucher1],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      act: (c) => c.filterByStatus('posted'),
      verify: (_) {
        verify(
          () => mockGetPaymentVouchers(
            const GetPaymentVouchersParams(
              status: 'posted',
              limit: 20,
              offset: 0,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<PaymentVouchersCubit, PaymentVouchersState>(
      'filterByBankAccount updates bankAccountId and reloads',
      build: () {
        when(() => mockGetPaymentVouchers(any())).thenAnswer(
          (_) async => Right(
            CursorPage<PaymentVoucher>(
              items: [tVoucher1],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return cubit;
      },
      act: (c) => c.filterByBankAccount('acc-bank-1'),
      verify: (_) {
        verify(
          () => mockGetPaymentVouchers(
            const GetPaymentVouchersParams(
              bankAccountId: 'acc-bank-1',
              limit: 20,
              offset: 0,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<PaymentVouchersCubit, PaymentVouchersState>(
      'clearFilters resets filters and reloads',
      seed: () => const PaymentVouchersState(
        statusFilter: 'draft',
        bankAccountId: 'acc-1',
        search: 'vendor',
      ),
      build: () {
        when(() => mockGetPaymentVouchers(any())).thenAnswer(
          (_) async => const Right(
            CursorPage<PaymentVoucher>(
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
          () => mockGetPaymentVouchers(
            const GetPaymentVouchersParams(
              status: null,
              bankAccountId: null,
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
