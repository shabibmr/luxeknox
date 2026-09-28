import 'package:equatable/equatable.dart';

import 'membership_status.dart';

/// Append-only row (FR-MEMB-013) — no update/delete operations exist for it.
class MembershipHistoryEntry extends Equatable {
  const MembershipHistoryEntry({
    required this.id,
    required this.membershipId,
    required this.action,
    this.oldEndDate,
    this.newEndDate,
    required this.performedByUserId,
    required this.timestamp,
  });

  final String id;
  final String membershipId;
  final MembershipHistoryAction action;
  final DateTime? oldEndDate;
  final DateTime? newEndDate;
  final String performedByUserId;
  final DateTime timestamp;

  @override
  List<Object?> get props => [
    id,
    membershipId,
    action,
    oldEndDate,
    newEndDate,
    performedByUserId,
    timestamp,
  ];
}
