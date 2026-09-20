import 'package:equatable/equatable.dart';

/// Mirrors `MemberHealth` (screen 04: Health Information).
class HealthInfo extends Equatable {
  final int id;
  final int memberId;
  final String? bloodGroup;
  final double? heightCm;
  final double? baselineWeightKg;
  final String? allergies;
  final String? dietaryPreferences;
  final String? physicianName;
  final String? physicianPhone;
  final DateTime? updatedAt;

  const HealthInfo({
    required this.id,
    required this.memberId,
    this.bloodGroup,
    this.heightCm,
    this.baselineWeightKg,
    this.allergies,
    this.dietaryPreferences,
    this.physicianName,
    this.physicianPhone,
    this.updatedAt,
  });

  HealthInfo copyWith({
    int? id,
    int? memberId,
    String? bloodGroup,
    double? heightCm,
    double? baselineWeightKg,
    String? allergies,
    String? dietaryPreferences,
    String? physicianName,
    String? physicianPhone,
    DateTime? updatedAt,
  }) {
    return HealthInfo(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      heightCm: heightCm ?? this.heightCm,
      baselineWeightKg: baselineWeightKg ?? this.baselineWeightKg,
      allergies: allergies ?? this.allergies,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      physicianName: physicianName ?? this.physicianName,
      physicianPhone: physicianPhone ?? this.physicianPhone,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    memberId,
    bloodGroup,
    heightCm,
    baselineWeightKg,
    allergies,
    dietaryPreferences,
    physicianName,
    physicianPhone,
    updatedAt,
  ];
}
