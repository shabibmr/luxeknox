import 'package:equatable/equatable.dart';

/// Full trainer record for self-edit (Edit Profile) and detail views.
class TrainerProfile extends Equatable {
  const TrainerProfile({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.bio,
    this.specializations = const [],
    this.hourlyRate,
    this.rating,
    this.maxClientsCapacity,
    this.assignedActiveCount,
    this.isActive = true,
    this.phoneNumber,
    this.email,
  });

  final int id;
  final int userId;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? bio;
  final List<String> specializations;
  final String? hourlyRate;
  final double? rating;
  final int? maxClientsCapacity;
  final int? assignedActiveCount;
  final bool isActive;
  final String? phoneNumber;
  final String? email;

  String get fullName => '$firstName $lastName';

  TrainerProfile copyWith({
    int? id,
    int? userId,
    String? firstName,
    String? lastName,
    String? gender,
    String? bio,
    List<String>? specializations,
    String? hourlyRate,
    double? rating,
    int? maxClientsCapacity,
    int? assignedActiveCount,
    bool? isActive,
    String? phoneNumber,
    String? email,
  }) {
    return TrainerProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      specializations: specializations ?? this.specializations,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      rating: rating ?? this.rating,
      maxClientsCapacity: maxClientsCapacity ?? this.maxClientsCapacity,
      assignedActiveCount: assignedActiveCount ?? this.assignedActiveCount,
      isActive: isActive ?? this.isActive,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    firstName,
    lastName,
    gender,
    bio,
    specializations,
    hourlyRate,
    rating,
    maxClientsCapacity,
    assignedActiveCount,
    isActive,
    phoneNumber,
    email,
  ];
}
