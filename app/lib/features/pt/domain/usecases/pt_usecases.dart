import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/pt_product.dart';
import '../entities/pt_schedule_grid.dart';
import '../entities/pt_subscription.dart';
import '../repositories/pt_repository.dart';

@lazySingleton
class GetPtProductsUseCase implements UseCase<List<PtProduct>, NoParams> {
  const GetPtProductsUseCase(this._repository);
  final PtRepository _repository;

  @override
  Future<Either<Failure, List<PtProduct>>> call(NoParams params) =>
      _repository.getProducts();
}

@lazySingleton
class SavePtProductUseCase implements UseCase<PtProduct, PtProduct> {
  const SavePtProductUseCase(this._repository);
  final PtRepository _repository;

  /// Creates when [PtProduct.id] is 0, otherwise updates.
  @override
  Future<Either<Failure, PtProduct>> call(PtProduct product) => product.id == 0
      ? _repository.createProduct(product)
      : _repository.updateProduct(product);
}

class GetPtScheduleGridParams extends Equatable {
  const GetPtScheduleGridParams({
    required this.memberId,
    required this.ptProductId,
    required this.startDate,
    required this.weekdays,
    this.excludeSubscriptionId,
  });

  final int memberId;
  final int ptProductId;
  final DateTime startDate;
  final List<int> weekdays;
  final int? excludeSubscriptionId;

  @override
  List<Object?> get props => [
    memberId,
    ptProductId,
    startDate,
    weekdays,
    excludeSubscriptionId,
  ];
}

@lazySingleton
class GetPtScheduleGridUseCase
    implements UseCase<PtScheduleGrid, GetPtScheduleGridParams> {
  const GetPtScheduleGridUseCase(this._repository);
  final PtRepository _repository;

  @override
  Future<Either<Failure, PtScheduleGrid>> call(GetPtScheduleGridParams p) =>
      _repository.getScheduleGrid(
        memberId: p.memberId,
        ptProductId: p.ptProductId,
        startDate: p.startDate,
        weekdays: p.weekdays,
        excludeSubscriptionId: p.excludeSubscriptionId,
      );
}

class PurchasePtParams extends Equatable {
  const PurchasePtParams({
    required this.memberId,
    required this.ptProductId,
    required this.trainerId,
    required this.startDate,
    required this.weekdays,
    required this.slotStart,
    required this.payment,
    this.idempotencyKey,
  });

  final int memberId;
  final int ptProductId;
  final int trainerId;
  final DateTime startDate;
  final List<int> weekdays;
  final String slotStart;
  final PtPayment payment;

  /// Not part of [props]: it identifies the user's intent, not the request.
  final String? idempotencyKey;

  @override
  List<Object?> get props => [
    memberId,
    ptProductId,
    trainerId,
    startDate,
    weekdays,
    slotStart,
    payment,
  ];
}

@lazySingleton
class PurchasePtUseCase implements UseCase<PtSubscription, PurchasePtParams> {
  const PurchasePtUseCase(this._repository);
  final PtRepository _repository;

  @override
  Future<Either<Failure, PtSubscription>> call(PurchasePtParams p) =>
      _repository.purchase(
        memberId: p.memberId,
        ptProductId: p.ptProductId,
        trainerId: p.trainerId,
        startDate: p.startDate,
        weekdays: p.weekdays,
        slotStart: p.slotStart,
        payment: p.payment,
        idempotencyKey: p.idempotencyKey,
      );
}

class RenewPtParams extends Equatable {
  const RenewPtParams({required this.subscriptionId, required this.payment});
  final int subscriptionId;
  final PtPayment payment;

  @override
  List<Object?> get props => [subscriptionId, payment];
}

@lazySingleton
class RenewPtUseCase implements UseCase<PtSubscription, RenewPtParams> {
  const RenewPtUseCase(this._repository);
  final PtRepository _repository;

  @override
  Future<Either<Failure, PtSubscription>> call(RenewPtParams p) =>
      _repository.renew(p.subscriptionId, payment: p.payment);
}

/// Mid-PT change: new trainer and/or new weekdays+hour from [effectiveDate].
class ReplanPtParams extends Equatable {
  const ReplanPtParams({
    required this.subscription,
    required this.trainerId,
    required this.weekdays,
    required this.slotStart,
    required this.effectiveDate,
    this.reason,
  });

  final PtSubscription subscription;
  final int trainerId;
  final List<int> weekdays;
  final String slotStart;
  final DateTime effectiveDate;
  final String? reason;

  bool get trainerChanged => trainerId != subscription.trainerId;
  bool get slotChanged {
    final a = [...weekdays]..sort();
    final b = [...subscription.weekdays]..sort();
    return ptSlotKey(slotStart) != ptSlotKey(subscription.slotStart) ||
        a.join(',') != b.join(',');
  }

  @override
  List<Object?> get props => [
    subscription,
    trainerId,
    weekdays,
    slotStart,
    effectiveDate,
    reason,
  ];
}

/// Applies a trainer reassignment and/or slot change in one atomic server call.
@lazySingleton
class ReplanPtUseCase implements UseCase<PtSubscription, ReplanPtParams> {
  const ReplanPtUseCase(this._repository);
  final PtRepository _repository;

  @override
  Future<Either<Failure, PtSubscription>> call(ReplanPtParams p) async {
    if (p.slotChanged) {
      return _repository.changeSlot(
        p.subscription.id,
        weekdays: p.weekdays,
        slotStart: p.slotStart,
        trainerId: p.trainerChanged ? p.trainerId : null,
        effectiveDate: p.effectiveDate,
        reason: p.reason,
      );
    }
    if (p.trainerChanged) {
      return _repository.reassignTrainer(
        p.subscription.id,
        trainerId: p.trainerId,
        effectiveDate: p.effectiveDate,
        reason: p.reason,
      );
    }
    return Right(p.subscription);
  }
}

@lazySingleton
class GetMemberPtSummaryUseCase implements UseCase<MemberPtSummary, int> {
  const GetMemberPtSummaryUseCase(this._repository);
  final PtRepository _repository;

  @override
  Future<Either<Failure, MemberPtSummary>> call(int memberId) =>
      _repository.getMemberSummary(memberId);
}
