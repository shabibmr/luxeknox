import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/payment.dart';
import '../entities/payment_method.dart';

abstract class PaymentsRepository {
  Future<Either<Failure, CursorPage<Payment>>> getPayments({
    String? memberId,
    String? status,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, CursorPage<Payment>>> getOutstanding({
    int? limit,
    int? offset,
  });

  Future<Either<Failure, Payment>> getPayment(String id);

  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods();

  Future<Either<Failure, PaymentMethod>> createPaymentMethod({
    required String methodName,
    bool? isDigital,
    bool? isActive,
  });
}
