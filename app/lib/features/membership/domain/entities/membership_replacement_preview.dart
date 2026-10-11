import 'package:equatable/equatable.dart';

import 'membership_status.dart';

/// What a couple sale would replace for the partner (FR-MEMB-005).
/// [suggestedCredit] is a backend-computed decimal string (FR-API-005);
/// the UI never derives money itself.
class MembershipReplacementPreview extends Equatable {
  const MembershipReplacementPreview({
    required this.membershipId,
    required this.productName,
    required this.status,
    required this.endDate,
    required this.remainingDays,
    required this.isCouple,
    required this.suggestedCredit,
  });

  final String membershipId;
  final String productName;
  final MembershipStatus status;
  final DateTime endDate;
  final int remainingDays;
  final bool isCouple;
  final String suggestedCredit;

  @override
  List<Object?> get props => [
    membershipId,
    productName,
    status,
    endDate,
    remainingDays,
    isCouple,
    suggestedCredit,
  ];
}
