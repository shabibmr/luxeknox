import 'package:equatable/equatable.dart';

class MembershipExtension extends Equatable {
  const MembershipExtension({
    required this.id,
    required this.membershipId,
    required this.daysExtended,
    this.reason,
    required this.grantedByUserId,
    required this.createdAt,
  });

  final String id;
  final String membershipId;
  final int daysExtended;
  final String? reason;
  final String grantedByUserId;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    membershipId,
    daysExtended,
    reason,
    grantedByUserId,
    createdAt,
  ];
}
