import 'package:equatable/equatable.dart';

import '../../../../session/domain/entities/user_type.dart';

/// The member's own current-membership summary (mirrors DSH-002).
class DashboardMembershipSummary extends Equatable {
  const DashboardMembershipSummary({
    required this.status,
    required this.endDate,
    required this.daysRemaining,
  });

  final String status;
  final String endDate;
  final int daysRemaining;

  @override
  List<Object?> get props => [status, endDate, daysRemaining];
}

class DashboardAssignedTrainer extends Equatable {
  const DashboardAssignedTrainer({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

/// Present only when the caller is a member with `dashboard.member` (DSH-002, DSH-005).
class DashboardMemberWidget extends Equatable {
  const DashboardMemberWidget({this.membership, this.assignedTrainer});

  final DashboardMembershipSummary? membership;
  final DashboardAssignedTrainer? assignedTrainer;

  @override
  List<Object?> get props => [membership, assignedTrainer];
}

class DashboardAssignedMemberPreview extends Equatable {
  const DashboardAssignedMemberPreview({
    required this.id,
    required this.name,
    required this.membershipNumber,
  });

  final String id;
  final String name;
  final String membershipNumber;

  @override
  List<Object?> get props => [id, name, membershipNumber];
}

/// Present only when the caller is a trainer with `dashboard.trainer` (DSH-003, DSH-005).
class DashboardTrainerWidget extends Equatable {
  const DashboardTrainerWidget({
    required this.assignedMembersCount,
    required this.assignedMembers,
  });

  final int assignedMembersCount;
  final List<DashboardAssignedMemberPreview> assignedMembers;

  @override
  List<Object?> get props => [assignedMembersCount, assignedMembers];
}

class DashboardExpiringSoon extends Equatable {
  const DashboardExpiringSoon({required this.days, required this.count});

  final int days;
  final int count;

  @override
  List<Object?> get props => [days, count];
}

/// Present only when the caller holds `dashboard.admin` (DSH-004, DSH-005).
class DashboardAdminWidget extends Equatable {
  const DashboardAdminWidget({
    required this.membersTotal,
    required this.trainersTotal,
    required this.trainersActive,
    required this.employeesTotal,
    required this.employeesActive,
    required this.membershipsByStatus,
    required this.expiringSoon,
  });

  final int membersTotal;
  final int trainersTotal;
  final int trainersActive;
  final int employeesTotal;
  final int employeesActive;
  final Map<String, int> membershipsByStatus;
  final DashboardExpiringSoon expiringSoon;

  @override
  List<Object?> get props => [
    membersTotal,
    trainersTotal,
    trainersActive,
    employeesTotal,
    employeesActive,
    membershipsByStatus,
    expiringSoon,
  ];
}

/// Role-specific home snapshot (`GET /dashboard`). A missing section means the
/// caller is unauthorized for it or has no matching profile — never an error
/// (DSH-005 mirrored client-side: render only the sections that are present).
class DashboardSnapshot extends Equatable {
  const DashboardSnapshot({
    required this.role,
    this.member,
    this.trainer,
    this.admin,
  });

  final UserType? role;
  final DashboardMemberWidget? member;
  final DashboardTrainerWidget? trainer;
  final DashboardAdminWidget? admin;

  bool get isEmpty => member == null && trainer == null && admin == null;

  @override
  List<Object?> get props => [role, member, trainer, admin];
}
