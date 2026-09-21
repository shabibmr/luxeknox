import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/membership.dart';
import '../entities/membership_extension.dart';
import '../entities/membership_freeze.dart';
import '../entities/membership_history_entry.dart';
import '../entities/membership_product.dart';

abstract class MembershipRepository {
  // FR-MEMB-001/002 — package catalog.
  Future<Either<Failure, CursorPage<MembershipProduct>>> getProducts({
    String? q,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, MembershipProduct>> getProduct(String id);

  Future<Either<Failure, MembershipProduct>> createProduct(
    MembershipProduct product,
  );

  Future<Either<Failure, MembershipProduct>> updateProduct(
    MembershipProduct product,
  );

  // FR-MEMB-005/008 — contracts.
  Future<Either<Failure, CursorPage<Membership>>> getMemberships({
    String? memberId,
    String? status,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, Membership>> getMembership(String id);

  Future<Either<Failure, Membership>> createMembership({
    required String memberId,
    required String productId,
    required DateTime startDate,
    String? lockerNumber,
    bool? autoRenew,
  });

  Future<Either<Failure, CursorPage<MembershipHistoryEntry>>> getHistory(
    String membershipId, {
    String? cursor,
    int? limit,
  });

  // FR-MEMB-009/010/011 — renew/upgrade/cancel all require row_version
  // (FR-API-009 optimistic concurrency).
  Future<Either<Failure, Membership>> renew(
    String id, {
    String? productId,
    required int rowVersion,
    String? reason,
  });

  Future<Either<Failure, Membership>> upgrade(
    String id, {
    required String productId,
    required int rowVersion,
    String? reason,
  });

  Future<Either<Failure, Membership>> cancel(
    String id, {
    required int rowVersion,
    String? reason,
  });

  // FR-MEMB-014 through FR-MEMB-019 — freezes.
  Future<Either<Failure, CursorPage<MembershipFreeze>>> getFreezes(
    String membershipId,
  );

  Future<Either<Failure, MembershipFreeze>> requestFreeze(
    String membershipId, {
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  });

  Future<Either<Failure, MembershipFreeze>> approveFreeze(String freezeId);

  Future<Either<Failure, MembershipFreeze>> rejectFreeze(
    String freezeId, {
    String? reason,
  });

  // FR-MEMB-020 — extension.
  Future<Either<Failure, MembershipExtension>> extend(
    String membershipId, {
    required int daysExtended,
    String? reason,
  });
}
