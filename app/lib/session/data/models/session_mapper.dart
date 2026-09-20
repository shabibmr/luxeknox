import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/capabilities.dart';
import '../../domain/entities/principal.dart';
import '../../domain/entities/user_type.dart';

class SessionMapper {
  static UserType _mapUserType(api.UserType type) {
    // api.UserType is a built_value EnumClass — map by wire name.
    return switch (type.name) {
      'member' => UserType.member,
      'trainer' => UserType.trainer,
      'employee' => UserType.employee,
      'admin' => UserType.admin,
      _ => UserType.member,
    };
  }

  static (Principal, Capabilities) fromSessionResponse(
    api.SessionResponse response,
  ) {
    final p = response.principal;
    final principal = Principal(
      userId: p.userId.toString(),
      userType: _mapUserType(p.userType),
      displayName: p.role,
      profileId: p.profileId?.toString() ?? '',
    );
    final capabilities = Capabilities(slugs: p.permissions.toList());
    return (principal, capabilities);
  }

  static (Principal, Capabilities) fromMeResponse(api.MeResponse response) {
    final p = response.principal;
    final u = response.user;
    final displayName = u.email ?? u.phoneNumber ?? p.role;
    final principal = Principal(
      userId: p.userId.toString(),
      userType: _mapUserType(p.userType),
      displayName: displayName,
      profileId: p.profileId?.toString() ?? '',
    );
    final capabilities = Capabilities(slugs: p.permissions.toList());
    return (principal, capabilities);
  }
}
