import 'package:equatable/equatable.dart';

/// A member's identity + profile fields (screens 02/03/08).
///
/// The dossier-only fields ([membershipStatus], [outstandingBalance],
/// [lastCheckIn], [nextScheduleTitle]) are populated when fetched via
/// `PeopleRepository.getMember` (single-record dossier endpoint) and left
/// null when a [Person] is built from a list response — mirrors
/// `MemberDossier` extending `Member` in the contract, collapsed to one
/// flat entity since the domain layer has no use for the nesting.
class Person extends Equatable {
  final int id;
  final int userId;
  final String membershipNumber;
  final String firstName;
  final String lastName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? address;
  final int? assignedTrainerId;
  final DateTime? joinedDate;
  final String? notes;
  final String? email;
  final String? phoneNumber;
  final String? avatarUrl;
  final String? membershipStatus;
  final String? outstandingBalance;
  final DateTime? lastCheckIn;
  final String? nextScheduleTitle;

  const Person({
    required this.id,
    required this.userId,
    required this.membershipNumber,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.assignedTrainerId,
    this.joinedDate,
    this.notes,
    this.email,
    this.phoneNumber,
    this.avatarUrl,
    this.membershipStatus,
    this.outstandingBalance,
    this.lastCheckIn,
    this.nextScheduleTitle,
  });

  String get fullName => '$firstName $lastName';

  Person copyWith({
    int? id,
    int? userId,
    String? membershipNumber,
    String? firstName,
    String? lastName,
    String? gender,
    DateTime? dateOfBirth,
    String? address,
    int? assignedTrainerId,
    DateTime? joinedDate,
    String? notes,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    String? membershipStatus,
    String? outstandingBalance,
    DateTime? lastCheckIn,
    String? nextScheduleTitle,
  }) {
    return Person(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      membershipNumber: membershipNumber ?? this.membershipNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      assignedTrainerId: assignedTrainerId ?? this.assignedTrainerId,
      joinedDate: joinedDate ?? this.joinedDate,
      notes: notes ?? this.notes,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      membershipStatus: membershipStatus ?? this.membershipStatus,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      nextScheduleTitle: nextScheduleTitle ?? this.nextScheduleTitle,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    membershipNumber,
    firstName,
    lastName,
    gender,
    dateOfBirth,
    address,
    assignedTrainerId,
    joinedDate,
    notes,
    email,
    phoneNumber,
    avatarUrl,
    membershipStatus,
    outstandingBalance,
    lastCheckIn,
    nextScheduleTitle,
  ];
}
