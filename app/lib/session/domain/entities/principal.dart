import 'package:equatable/equatable.dart';

import 'user_type.dart';

/// Represents the authenticated user's principal identity.
class Principal extends Equatable {
  /// Unique identifier for the user.
  final String userId;

  /// The user's type / role.
  final UserType userType;

  /// The user's display name.
  final String displayName;

  /// Unique identifier for the user's profile.
  final String profileId;

  const Principal({
    required this.userId,
    required this.userType,
    required this.displayName,
    required this.profileId,
  });

  @override
  List<Object?> get props => [userId, userType, displayName, profileId];
}
