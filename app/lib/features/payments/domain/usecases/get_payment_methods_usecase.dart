import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment_method.dart';
import '../repositories/payments_repository.dart';

@lazySingleton
class GetPaymentMethodsUseCase
    implements UseCase<List<PaymentMethod>, NoParams> {
  const GetPaymentMethodsUseCase(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Either<Failure, List<PaymentMethod>>> call(NoParams params) {
    return _repository.getPaymentMethods();
  }
}
