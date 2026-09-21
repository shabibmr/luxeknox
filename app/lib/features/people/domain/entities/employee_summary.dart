import 'package:equatable/equatable.dart';

/// Lightweight employee row for admin directory.
class EmployeeSummary extends Equatable {
  const EmployeeSummary({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.jobTitle,
    this.department,
    this.status,
    this.roleId,
  });

  final int id;
  final int userId;
  final String fullName;
  final String jobTitle;
  final String? department;
  final String? status;
  final int? roleId;

  @override
  List<Object?> get props => [
    id,
    userId,
    fullName,
    jobTitle,
    department,
    status,
    roleId,
  ];
}
