import '../../../session/domain/entities/user_type.dart';

/// Banner and Lifestyle tab: `health.read`, plus assignment for trainers.
/// Managers ([UserType.employee]) and admins see every member. The API
/// remains the authority for the actual records.
bool showMemberHealthSurfaces({
  required bool hasHealthRead,
  required UserType userType,
  required bool isAssignedTrainer,
}) {
  if (!hasHealthRead) return false;
  if (userType == UserType.trainer) return isAssignedTrainer;
  return true;
}
