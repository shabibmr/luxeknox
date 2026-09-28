import 'package:equatable/equatable.dart';

/// Form data collected by the Add Member onboarding wizard.
class NewMemberInput extends Equatable {
  const NewMemberInput({
    this.firstName = '',
    this.lastName = '',
    this.email,
    this.phoneNumber,
    this.password,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.assignedTrainerId,
    this.notes,
  });

  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final String? password;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? address;
  final int? assignedTrainerId;
  final String? notes;

  /// Basic-info step is complete once a name is present.
  bool get hasBasicInfo =>
      firstName.trim().isNotEmpty && lastName.trim().isNotEmpty;

  NewMemberInput copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    String? gender,
    DateTime? dateOfBirth,
    String? address,
    int? assignedTrainerId,
    String? notes,
  }) {
    return NewMemberInput(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      assignedTrainerId: assignedTrainerId ?? this.assignedTrainerId,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phoneNumber,
    password,
    gender,
    dateOfBirth,
    address,
    assignedTrainerId,
    notes,
  ];
}
