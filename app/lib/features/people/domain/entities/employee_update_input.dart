import 'package:equatable/equatable.dart';

/// Sentinel so [EmployeeUpdateInput.copyWith] can clear optional fields to null.
class _Sentinel {
  const _Sentinel();
}

const _sentinel = _Sentinel();

/// Form data collected by the Edit Employee form.
///
/// Mirrors Nest `EmployeeUpdate`: job title, department, hire date only.
class EmployeeUpdateInput extends Equatable {
  const EmployeeUpdateInput({this.jobTitle, this.department, this.hireDate});

  final String? jobTitle;
  final String? department;
  final DateTime? hireDate;

  /// Pass `null` for [department] / [hireDate] to clear; omit to leave unchanged.
  EmployeeUpdateInput copyWith({
    Object? jobTitle = _sentinel,
    Object? department = _sentinel,
    Object? hireDate = _sentinel,
  }) {
    return EmployeeUpdateInput(
      jobTitle: jobTitle is _Sentinel ? this.jobTitle : jobTitle as String?,
      department: department is _Sentinel
          ? this.department
          : department as String?,
      hireDate: hireDate is _Sentinel ? this.hireDate : hireDate as DateTime?,
    );
  }

  @override
  List<Object?> get props => [jobTitle, department, hireDate];
}
