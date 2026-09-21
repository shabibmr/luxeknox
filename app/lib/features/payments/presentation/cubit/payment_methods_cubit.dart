import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/create_payment_method_usecase.dart';
import '../../domain/usecases/get_payment_methods_usecase.dart';

sealed class PaymentMethodsState extends Equatable {
  const PaymentMethodsState();

  @override
  List<Object?> get props => [];
}

final class PaymentMethodsLoading extends PaymentMethodsState {
  const PaymentMethodsLoading();
}

final class PaymentMethodsLoaded extends PaymentMethodsState {
  const PaymentMethodsLoaded(
    this.items, {
    this.creating = false,
    this.message,
  });

  final List<PaymentMethod> items;
  final bool creating;
  final String? message;

  @override
  List<Object?> get props => [items, creating, message];
}

final class PaymentMethodsFailure extends PaymentMethodsState {
  const PaymentMethodsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  PaymentMethodsCubit(this._getMethods, this._createMethod)
    : super(const PaymentMethodsLoading());

  final GetPaymentMethodsUseCase _getMethods;
  final CreatePaymentMethodUseCase _createMethod;

  Future<void> load() async {
    emit(const PaymentMethodsLoading());
    final result = await _getMethods(const NoParams());
    result.fold(
      (failure) => emit(PaymentMethodsFailure(failureMessage(failure))),
      (items) => emit(PaymentMethodsLoaded(items)),
    );
  }

  Future<void> createMethod(
    String name, {
    bool? isDigital,
    bool? isActive,
  }) async {
    final current = state;
    if (current is! PaymentMethodsLoaded || current.creating) return;
    emit(PaymentMethodsLoaded(current.items, creating: true));
    final result = await _createMethod(
      CreatePaymentMethodParams(
        methodName: name,
        isDigital: isDigital,
        isActive: isActive,
      ),
    );
    result.fold(
      (failure) => emit(
        PaymentMethodsLoaded(
          current.items,
          message: failureMessage(failure),
        ),
      ),
      (_) => load(),
    );
  }
}
