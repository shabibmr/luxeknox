import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/pt_product.dart';
import '../entities/pt_schedule_grid.dart';
import '../entities/pt_subscription.dart';

/// Payment captured together with a PT sale/renewal (single tender).
class PtPayment {
  const PtPayment({
    required this.paymentMethodId,
    this.discountAmount,
    this.transactionReference,
  });

  final int paymentMethodId;
  final String? discountAmount;
  final String? transactionReference;
}

abstract class PtRepository {
  Future<Either<Failure, List<PtProduct>>> getProducts({String? q});

  Future<Either<Failure, PtProduct>> createProduct(PtProduct product);

  Future<Either<Failure, PtProduct>> updateProduct(PtProduct product);

  Future<Either<Failure, PtScheduleGrid>> getScheduleGrid({
    required int memberId,
    required int ptProductId,
    required DateTime startDate,
    required List<int> weekdays,
    int? excludeSubscriptionId,
  });

  Future<Either<Failure, PtSubscription>> purchase({
    required int memberId,
    required int ptProductId,
    required int trainerId,
    required DateTime startDate,
    required List<int> weekdays,
    required String slotStart,
    required PtPayment payment,
  });

  Future<Either<Failure, PtSubscription>> renew(
    int subscriptionId, {
    required PtPayment payment,
  });

  Future<Either<Failure, PtSubscription>> reassignTrainer(
    int subscriptionId, {
    required int trainerId,
    required DateTime effectiveDate,
    String? reason,
  });

  /// [trainerId], when given, also moves the member to that trainer.
  Future<Either<Failure, PtSubscription>> changeSlot(
    int subscriptionId, {
    required List<int> weekdays,
    required String slotStart,
    int? trainerId,
    required DateTime effectiveDate,
    String? reason,
  });

  Future<Either<Failure, MemberPtSummary>> getMemberSummary(int memberId);
}
