import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/payment_status.dart';
import '../../domain/usecases/get_payments_usecase.dart';

enum PaymentsLedgerFilter { all, pending, partial, paid, refunded }

sealed class PaymentsLedgerState extends Equatable {
  const PaymentsLedgerState();

  @override
  List<Object?> get props => [];
}

final class PaymentsLedgerLoading extends PaymentsLedgerState {
  const PaymentsLedgerLoading({this.filter = PaymentsLedgerFilter.all});

  final PaymentsLedgerFilter filter;

  @override
  List<Object?> get props => [filter];
}

final class PaymentsLedgerLoaded extends PaymentsLedgerState {
  const PaymentsLedgerLoaded({required this.items, required this.filter});

  final List<Payment> items;
  final PaymentsLedgerFilter filter;

  @override
  List<Object?> get props => [items, filter];
}

final class PaymentsLedgerFailure extends PaymentsLedgerState {
  const PaymentsLedgerFailure(this.message, {required this.filter});

  final String message;
  final PaymentsLedgerFilter filter;

  @override
  List<Object?> get props => [message, filter];
}

@injectable
class PaymentsLedgerCubit extends Cubit<PaymentsLedgerState> {
  PaymentsLedgerCubit(this._getPayments)
    : super(const PaymentsLedgerLoading());

  final GetPaymentsUseCase _getPayments;
  String? _memberId;

  PaymentsLedgerFilter get _filter {
    final s = state;
    return switch (s) {
      PaymentsLedgerLoading(:final filter) => filter,
      PaymentsLedgerLoaded(:final filter) => filter,
      PaymentsLedgerFailure(:final filter) => filter,
    };
  }

  Future<void> load({
    String? memberId,
    PaymentsLedgerFilter? filter,
  }) async {
    if (memberId != null) _memberId = memberId;
    final next = filter ?? _filter;
    emit(PaymentsLedgerLoading(filter: next));
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
        PaymentsLedgerFailure(failureMessage(failure), filter: next),
      ),
      (page) => emit(
        PaymentsLedgerLoaded(items: page.items, filter: next),
      ),
    );
  }

  Future<void> setFilter(PaymentsLedgerFilter filter) =>
      load(filter: filter);
}
