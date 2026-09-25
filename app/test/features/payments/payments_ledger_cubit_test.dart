import 'package:app/core/error/failures.dart';
import 'package:app/core/presentation/load_status.dart';
import 'package:app/core/pagination/cursor_page.dart';
import 'package:app/features/payments/domain/entities/payment.dart';
import 'package:app/features/payments/domain/entities/payment_status.dart';
import 'package:app/features/payments/domain/usecases/get_payments_usecase.dart';
import 'package:app/features/payments/presentation/cubit/payments_ledger_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetPayments extends Mock implements GetPaymentsUseCase {}

void main() {
  late _MockGetPayments getPayments;

  Payment payment({
    required String id,
    PaymentStatus status = PaymentStatus.pending,
  }) {
    return Payment(
      id: id,
      invoiceNumber: 'INV-$id',
      memberId: '1',
      subtotal: '10.00',
      taxAmount: '0.00',
      discountAmount: '0.00',
      totalAmount: '10.00',
      amountPaid: '0.00',
      status: status,
      rowVersion: 1,
    );
  }

  setUp(() {
    getPayments = _MockGetPayments();
    registerFallbackValue(const GetPaymentsParams());
  });

  blocTest<PaymentsLedgerCubit, PaymentsLedgerState>(
    'maps filter to status param and loads items',
    build: () {
      when(() => getPayments(any())).thenAnswer(
        (_) async => Right(
          CursorPage(
            items: [payment(id: '1', status: PaymentStatus.paid)],
            nextCursor: null,
            hasMore: false,
          ),
        ),
      );
      return PaymentsLedgerCubit(getPayments);
    },
    act: (cubit) => cubit.load(filter: PaymentsLedgerFilter.paid),
    expect: () => [
      isA<PaymentsLedgerState>()
          .having((s) => s.status, 'status', LoadStatus.loading)
          .having((s) => s.filter, 'filter', PaymentsLedgerFilter.paid),
      isA<PaymentsLedgerState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.filter, 'filter', PaymentsLedgerFilter.paid)
          .having((s) => s.items.map((p) => p.id).toList(), 'ids', ['1']),
    ],
    verify: (_) {
      final captured = verify(() => getPayments(captureAny())).captured;
      expect(captured, hasLength(1));
      final params = captured.single as GetPaymentsParams;
      expect(params.status, 'paid');
      expect(params.memberId, isNull);
    },
  );

  blocTest<PaymentsLedgerCubit, PaymentsLedgerState>(
    'passes fixed memberId on subsequent filter changes',
    build: () {
      when(() => getPayments(any())).thenAnswer(
        (_) async => Right(
          CursorPage(
            items: [payment(id: '2')],
            nextCursor: null,
            hasMore: false,
          ),
        ),
      );
      return PaymentsLedgerCubit(getPayments);
    },
    act: (cubit) async {
      await cubit.load(memberId: '42');
      await cubit.setFilter(PaymentsLedgerFilter.pending);
    },
    verify: (_) {
      final captured = verify(() => getPayments(captureAny())).captured;
      expect(captured, hasLength(2));
      final second = captured[1] as GetPaymentsParams;
      expect(second.memberId, '42');
      expect(second.status, 'pending');
    },
  );

  blocTest<PaymentsLedgerCubit, PaymentsLedgerState>(
    'emits failure on repository error',
    build: () {
      when(() => getPayments(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return PaymentsLedgerCubit(getPayments);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<PaymentsLedgerState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<PaymentsLedgerState>()
          .having((s) => s.status, 'status', LoadStatus.failure)
          .having((s) => s.failure, 'failure', isA<NetworkFailure>()),
    ],
  );
}
