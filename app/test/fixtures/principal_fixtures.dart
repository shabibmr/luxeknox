import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';

/// Shared principals / capabilities for unit and widget tests.
abstract final class PrincipalFixtures {
  static const member = Principal(
    userId: 'user-member-1',
    userType: UserType.member,
    displayName: 'Member One',
    profileId: 'profile-member-1',
  );

  static const trainer = Principal(
    userId: 'user-trainer-1',
    userType: UserType.trainer,
    displayName: 'Trainer One',
    profileId: 'profile-trainer-1',
  );

  static const admin = Principal(
    userId: 'user-admin-1',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'profile-admin-1',
  );

  static const emptyCapabilities = Capabilities(slugs: []);

  static const memberReadCapabilities = Capabilities(
    slugs: ['exercises.read', 'foods.read'],
  );

  static const staffWriteCapabilities = Capabilities(
    slugs: [
      'exercises.read',
      'exercises.write',
      'foods.read',
      'foods.write',
      'members.read',
    ],
  );
}
