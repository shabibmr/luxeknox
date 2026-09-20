import 'package:equatable/equatable.dart';

/// Lightweight row for the admin Members list (screen: Members list),
/// mirroring `MemberPage.data` entries — no dossier fields.
class ProfileSummary extends Equatable {
  final int id;
  final String membershipNumber;
  final String fullName;
  final String? avatarUrl;
  final int? assignedTrainerId;
  final String? membershipStatus;

  const ProfileSummary({
    required this.id,
    required this.membershipNumber,
    required this.fullName,
    this.avatarUrl,
    this.assignedTrainerId,
    this.membershipStatus,
  });

  @override
  List<Object?> get props => [
    id,
    membershipNumber,
    fullName,
    avatarUrl,
    assignedTrainerId,
    membershipStatus,
  ];
}
