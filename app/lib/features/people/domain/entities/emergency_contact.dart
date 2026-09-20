import 'package:equatable/equatable.dart';

/// Mirrors `EmergencyContact` (screen 06: Emergency Contacts).
class EmergencyContact extends Equatable {
  final int id;
  final int userId;
  final String contactName;
  final String? relationship;
  final String phonePrimary;
  final String? phoneSecondary;
  final bool isPrimary;

  const EmergencyContact({
    required this.id,
    required this.userId,
    required this.contactName,
    this.relationship,
    required this.phonePrimary,
    this.phoneSecondary,
    required this.isPrimary,
  });

  EmergencyContact copyWith({
    int? id,
    int? userId,
    String? contactName,
    String? relationship,
    String? phonePrimary,
    String? phoneSecondary,
    bool? isPrimary,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      contactName: contactName ?? this.contactName,
      relationship: relationship ?? this.relationship,
      phonePrimary: phonePrimary ?? this.phonePrimary,
      phoneSecondary: phoneSecondary ?? this.phoneSecondary,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    contactName,
    relationship,
    phonePrimary,
    phoneSecondary,
    isPrimary,
  ];
}
