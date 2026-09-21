import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment_method.dart';
import '../repositories/payments_repository.dart';

class CreatePaymentMethodParams extends Equatable {
  const CreatePaymentMethodParams({
    required this.methodName,
    this.isDigital,
    this.isActive,
  });

  final String methodName;
  final bool? isDigital;
  final bool? isActive;

  @override
  List<Object?> get props => [methodName, isDigital, isActive];
}

@lazySingleton
class CreatePaymentMethodUseCase
    implements UseCase<PaymentMethod, CreatePaymentMethodParams> {
  const CreatePaymentMethodUseCase(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Either<Failure, PaymentMethod>> call(
    CreatePaymentMethodParams params,
  ) {
    return _repository.createPaymentMethod(
      methodName: params.methodName,
      isDigital: params.isDigital,
      isActive: params.isActive,
    );
  }
}
