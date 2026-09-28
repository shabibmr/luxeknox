import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/payment.dart';
import '../../domain/usecases/get_payment_usecase.dart';

part 'payment_detail_cubit.freezed.dart';

@freezed
abstract class PaymentDetailState with _$PaymentDetailState {
  const factory PaymentDetailState({
    @Default(LoadStatus.initial) LoadStatus status,
    Payment? payment,
    Failure? failure,
  }) = _PaymentDetailState;
}

@injectable
class PaymentDetailCubit extends Cubit<PaymentDetailState> {
  PaymentDetailCubit(this._getPayment) : super(const PaymentDetailState());

  final GetPaymentUseCase _getPayment;

  Future<void> load(String paymentId) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _getPayment(paymentId);
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (payment) => emit(
        state.copyWith(
          status: LoadStatus.success,
          payment: payment,
          failure: null,
        ),
      ),
    );
  }
}
