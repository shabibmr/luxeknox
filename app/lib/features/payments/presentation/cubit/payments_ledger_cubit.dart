import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/payment_status.dart';
import '../../domain/usecases/get_payments_usecase.dart';

part 'payments_ledger_cubit.freezed.dart';

enum PaymentsLedgerFilter { all, pending, partial, paid, refunded }

@freezed
abstract class PaymentsLedgerState with _$PaymentsLedgerState {
  const factory PaymentsLedgerState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(PaymentsLedgerFilter.all) PaymentsLedgerFilter filter,
    @Default(<Payment>[]) List<Payment> items,
    Failure? failure,
  }) = _PaymentsLedgerState;
}

@injectable
class PaymentsLedgerCubit extends Cubit<PaymentsLedgerState> {
  PaymentsLedgerCubit(this._getPayments) : super(const PaymentsLedgerState());

  final GetPaymentsUseCase _getPayments;
  String? _memberId;

  Future<void> load({
    String? memberId,
    PaymentsLedgerFilter? filter,
  }) async {
    if (memberId != null) _memberId = memberId;
    final next = filter ?? state.filter;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        filter: next,
        failure: null,
      ),
    );
    final apiStatus = switch (next) {
      PaymentsLedgerFilter.all => null,
      PaymentsLedgerFilter.pending => PaymentStatus.pending.name,
      PaymentsLedgerFilter.partial => PaymentStatus.partial.name,
      PaymentsLedgerFilter.paid => PaymentStatus.paid.name,
      PaymentsLedgerFilter.refunded => PaymentStatus.refunded.name,
    };
    final result = await _getPayments(
      GetPaymentsParams(memberId: _memberId, status: apiStatus),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          filter: next,
          failure: failure,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          items: page.items,
          filter: next,
          failure: null,
        ),
      ),
    );
  }

  Future<void> setFilter(PaymentsLedgerFilter filter) => load(filter: filter);
}
