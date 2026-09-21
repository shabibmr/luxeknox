import 'package:equatable/equatable.dart';

import 'membership_status.dart';

class MembershipFreeze extends Equatable {
  const MembershipFreeze({
    required this.id,
    required this.membershipId,
    required this.startDate,
    required this.endDate,
    this.totalFreezeDays,
    this.reason,
    required this.status,
    this.reviewedByUserId,
    this.reviewedAt,
  });

  final String id;
  final String membershipId;
  final DateTime startDate;
  final DateTime endDate;
  final int? totalFreezeDays;
  final String? reason;
  final FreezeStatus status;
  final String? reviewedByUserId;
  final DateTime? reviewedAt;

  @override
  List<Object?> get props => [
    id,
    membershipId,
    startDate,
    endDate,
    totalFreezeDays,
    reason,
    status,
    reviewedByUserId,
    reviewedAt,
  ];
}
