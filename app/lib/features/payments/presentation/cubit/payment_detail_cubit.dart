import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/payment.dart';
import '../../domain/usecases/get_payment_usecase.dart';

sealed class PaymentDetailState extends Equatable {
  const PaymentDetailState();

  @override
  List<Object?> get props => [];
}

final class PaymentDetailLoading extends PaymentDetailState {
  const PaymentDetailLoading();
}

final class PaymentDetailLoaded extends PaymentDetailState {
  const PaymentDetailLoaded(this.payment);

  final Payment payment;

  @override
  List<Object?> get props => [payment];
}

final class PaymentDetailFailure extends PaymentDetailState {
  const PaymentDetailFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class PaymentDetailCubit extends Cubit<PaymentDetailState> {
  PaymentDetailCubit(this._getPayment) : super(const PaymentDetailLoading());

  final GetPaymentUseCase _getPayment;

  Future<void> load(String paymentId) async {
    emit(const PaymentDetailLoading());
    final result = await _getPayment(paymentId);
    result.fold(
      (failure) => emit(PaymentDetailFailure(failureMessage(failure))),
      (payment) => emit(PaymentDetailLoaded(payment)),
    );
  }
}
