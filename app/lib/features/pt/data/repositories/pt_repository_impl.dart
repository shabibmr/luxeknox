import 'package:api_client/api_client.dart' as api;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../membership/data/models/membership_date.dart';
import '../../domain/entities/pt_product.dart';
import '../../domain/entities/pt_schedule_grid.dart';
import '../../domain/entities/pt_subscription.dart';
import '../../domain/repositories/pt_repository.dart';
import '../datasources/pt_remote_datasource.dart';
import '../models/pt_mappers.dart';

@LazySingleton(as: PtRepository)
class PtRepositoryImpl implements PtRepository {
  PtRepositoryImpl(this._remote);

  final PtRemoteDataSource _remote;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Right(await body());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  static String _hour(String slot) =>
      slot.length >= 5 ? slot.substring(0, 5) : slot;

  @override
  Future<Either<Failure, List<PtProduct>>> getProducts({String? q}) =>
      _guard(() async {
        final page = await _remote.listProducts(q: q, limit: 100);
        return page.data.map((p) => p.toDomain()).toList();
      });

  @override
  Future<Either<Failure, PtProduct>> createProduct(PtProduct product) => _guard(
    () async =>
        (await _remote.createProduct(product.toWriteModel())).toDomain(),
  );

  @override
  Future<Either<Failure, PtProduct>> updateProduct(PtProduct product) => _guard(
    () async => (await _remote.updateProduct(
      product.id,
      product.toWriteModel(),
    )).toDomain(),
  );

  @override
  Future<Either<Failure, PtScheduleGrid>> getScheduleGrid({
    required int memberId,
    required int ptProductId,
    required DateTime startDate,
    required List<int> weekdays,
    int? excludeSubscriptionId,
  }) => _guard(() async {
    final grid = await _remote.scheduleGrid(
      memberId: memberId,
      ptProductId: ptProductId,
      startDate: dateTimeToApiDate(startDate),
      weekdays: ([...weekdays]..sort()).join(','),
      excludeSubscriptionId: excludeSubscriptionId,
    );
    return grid.toDomain();
  });

  @override
  Future<Either<Failure, PtSubscription>> purchase({
    required int memberId,
    required int ptProductId,
    required int trainerId,
    required DateTime startDate,
    required List<int> weekdays,
    required String slotStart,
    required PtPayment payment,
  }) => _guard(() async {
    final result = await _remote.purchase(
      api.PtPurchaseRequest(
        (b) => b
          ..memberId = memberId
          ..ptProductId = ptProductId
          ..trainerId = trainerId
          ..startDate = dateTimeToApiDate(startDate)
          ..weekdays = weekdaysBuilder(weekdays)
          ..slotStart = _hour(slotStart)
          ..paymentMethodId = payment.paymentMethodId
          ..discountAmount = payment.discountAmount
          ..transactionReference = payment.transactionReference,
      ),
    );
    return result.subscription.toDomain();
  });

  @override
  Future<Either<Failure, PtSubscription>> renew(
    int subscriptionId, {
    required PtPayment payment,
  }) => _guard(() async {
    final result = await _remote.renew(
      subscriptionId,
      api.PtRenewRequest(
        (b) => b
          ..paymentMethodId = payment.paymentMethodId
          ..discountAmount = payment.discountAmount
          ..transactionReference = payment.transactionReference,
      ),
    );
    return result.subscription.toDomain();
  });

  @override
  Future<Either<Failure, PtSubscription>> reassignTrainer(
    int subscriptionId, {
    required int trainerId,
    required DateTime effectiveDate,
    String? reason,
  }) => _guard(() async {
    final sub = await _remote.reassignTrainer(
      subscriptionId,
      api.PtReassignTrainerRequest(
        (b) => b
          ..trainerId = trainerId
          ..effectiveDate = dateTimeToApiDate(effectiveDate)
          ..reason = reason,
      ),
    );
    return sub.toDomain();
  });

  @override
  Future<Either<Failure, PtSubscription>> changeSlot(
    int subscriptionId, {
    required List<int> weekdays,
    required String slotStart,
    int? trainerId,
    required DateTime effectiveDate,
    String? reason,
  }) => _guard(() async {
    final sub = await _remote.changeSlot(
      subscriptionId,
      api.PtChangeSlotRequest(
        (b) => b
          ..weekdays = weekdaysBuilder(weekdays)
          ..slotStart = _hour(slotStart)
          ..trainerId = trainerId
          ..effectiveDate = dateTimeToApiDate(effectiveDate)
          ..reason = reason,
      ),
    );
    return sub.toDomain();
  });

  @override
  Future<Either<Failure, MemberPtSummary>> getMemberSummary(int memberId) =>
      _guard(() async => (await _remote.memberSummary(memberId)).toDomain());
}
