import 'package:api_client/api_client.dart' as api;
import '../../domain/entities/capabilities.dart';
import '../../domain/entities/principal.dart';

class SessionMapper {
  static (Principal, Capabilities) fromSessionResponse(
    api.SessionResponse response,
  ) {
    final p = response.principal;
    final principal = Principal(
      userId: p.userId.toString(),
      userType: p.userType.name,
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
      userType: p.userType.name,
      displayName: displayName,
      profileId: p.profileId?.toString() ?? '',
    );
    final capabilities = Capabilities(slugs: p.permissions.toList());
    return (principal, capabilities);
  }
}
