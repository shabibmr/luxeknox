import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/create_payment_method_usecase.dart';
import '../../domain/usecases/get_payment_methods_usecase.dart';

part 'payment_methods_cubit.freezed.dart';

@freezed
abstract class PaymentMethodsState with _$PaymentMethodsState {
  const factory PaymentMethodsState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<PaymentMethod>[]) List<PaymentMethod> items,
    @Default(false) bool creating,
    Failure? failure,
  }) = _PaymentMethodsState;
}

@injectable
class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  PaymentMethodsCubit(this._getMethods, this._createMethod)
    : super(const PaymentMethodsState());

  final GetPaymentMethodsUseCase _getMethods;
  final CreatePaymentMethodUseCase _createMethod;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        creating: false,
      ),
    );
    final result = await _getMethods(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (items) => emit(
        state.copyWith(
          status: LoadStatus.success,
          items: items,
          failure: null,
          creating: false,
        ),
      ),
    );
  }

  Future<void> createMethod(
    String name, {
    bool? isDigital,
    bool? isActive,
  }) async {
    if (state.status != LoadStatus.success || state.creating) return;
    emit(state.copyWith(creating: true, failure: null));
    final result = await _createMethod(
      CreatePaymentMethodParams(
        methodName: name,
        isDigital: isDigital,
        isActive: isActive,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(creating: false, failure: failure),
      ),
      (_) => load(),
    );
  }
}
