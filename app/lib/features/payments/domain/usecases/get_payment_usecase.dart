import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment.dart';
import '../repositories/payments_repository.dart';

@lazySingleton
class GetPaymentUseCase implements UseCase<Payment, String> {
  const GetPaymentUseCase(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Either<Failure, Payment>> call(String id) {
    return _repository.getPayment(id);
  }
}
