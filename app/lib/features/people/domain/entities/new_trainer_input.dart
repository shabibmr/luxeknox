import 'package:equatable/equatable.dart';

/// Form data collected by the Add Trainer form.
class NewTrainerInput extends Equatable {
  const NewTrainerInput({
    this.firstName = '',
    this.lastName = '',
    required this.email,
    this.phoneNumber,
    this.password,
    this.bio,
    this.specializations = const [],
    this.hourlyRate,
    this.maxClientsCapacity,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String? password;
  final String? bio;
  final List<String> specializations;
  final String? hourlyRate;
  final int? maxClientsCapacity;

  bool get hasBasicInfo =>
      firstName.trim().isNotEmpty &&
      lastName.trim().isNotEmpty &&
      email.trim().isNotEmpty;

  NewTrainerInput copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    String? bio,
    List<String>? specializations,
    String? hourlyRate,
    int? maxClientsCapacity,
  }) {
    return NewTrainerInput(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      bio: bio ?? this.bio,
      specializations: specializations ?? this.specializations,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      maxClientsCapacity: maxClientsCapacity ?? this.maxClientsCapacity,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phoneNumber,
    password,
    bio,
    specializations,
    hourlyRate,
    maxClientsCapacity,
  ];
}
