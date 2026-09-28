import 'package:equatable/equatable.dart';

import 'membership_product.dart';
import 'membership_status.dart';

/// A member's contract instance (FR-MEMB-005). [product] is null when the
/// backend omits it for a trainer-scoped read (FR-MEMB-007 — trainers must
/// not see pricing, so the whole nested product is withheld rather than
/// partially redacted).
class Membership extends Equatable {
  const Membership({
    required this.id,
    required this.memberId,
    required this.productId,
    required this.startDate,
    required this.endDate,
    this.remainingPtSessions,
    required this.status,
    this.lockerNumber,
    this.autoRenew,
    required this.rowVersion,
    this.product,
  });

  final String id;
  final String memberId;
  final String productId;
  final DateTime startDate;
  final DateTime endDate;
  final int? remainingPtSessions;
  final MembershipStatus status;
  final String? lockerNumber;
  final bool? autoRenew;
  final int rowVersion;
  final MembershipProduct? product;

  bool get isActiveOrFrozen =>
      status == MembershipStatus.active || status == MembershipStatus.frozen;

  int get daysUntilExpiry => endDate.difference(DateTime.now()).inDays;

  @override
  List<Object?> get props => [
    id,
    memberId,
    productId,
    startDate,
    endDate,
    remainingPtSessions,
    status,
    lockerNumber,
    autoRenew,
    rowVersion,
    product,
  ];
}
