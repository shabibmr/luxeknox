import 'package:equatable/equatable.dart';

/// Form data collected by the Add Employee form.
class NewEmployeeInput extends Equatable {
  const NewEmployeeInput({
    this.firstName = '',
    this.lastName = '',
    required this.email,
    this.phoneNumber,
    this.password,
    this.jobTitle = '',
    this.department,
    this.hireDate,
    required this.roleId,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String? password;
  final String jobTitle;
  final String? department;
  final DateTime? hireDate;
  final int roleId;

  bool get hasBasicInfo =>
      firstName.trim().isNotEmpty &&
      lastName.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      jobTitle.trim().isNotEmpty;

  NewEmployeeInput copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    String? jobTitle,
    String? department,
    DateTime? hireDate,
    int? roleId,
  }) {
    return NewEmployeeInput(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      jobTitle: jobTitle ?? this.jobTitle,
      department: department ?? this.department,
      hireDate: hireDate ?? this.hireDate,
      roleId: roleId ?? this.roleId,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phoneNumber,
    password,
    jobTitle,
    department,
    hireDate,
    roleId,
  ];
}
