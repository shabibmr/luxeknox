import '../../session/domain/entities/capabilities.dart';
import '../../session/domain/entities/user_type.dart';
import '../../session/presentation/session_cubit.dart';
import 'route_capabilities.dart';
import 'routes.dart';

/// Computes the redirect target according to session state and current path.
/// Exactly one redirect function to prevent redirect loops.
///
/// [uri] carries query params (e.g. `?redirect=` for deep-link restore after
/// login). [matchedLocation] is the path without query.
String? appRedirectLogic({
  required SessionState sessionState,
  required String currentPath,
  Uri? uri,
}) {
  final isPublicAuthRoute =
      currentPath == Routes.login ||
      currentPath == Routes.splash ||
      currentPath == Routes.forgotPassword ||
      currentPath == Routes.resetPassword;

  if (sessionState is SessionUnknown) {
    return currentPath == Routes.splash ? null : Routes.splash;
  }

  if (sessionState is SessionUnauthenticated) {
    if (isPublicAuthRoute) {
      return currentPath == Routes.splash ? Routes.login : null;
    }
    // Preserve intended deep link for restore after sign-in.
    return Routes.loginWithRedirect(currentPath);
  }

  if (sessionState is SessionAuthenticated) {
    final role = sessionState.principal.userType;
    final capabilities = sessionState.capabilities;
    final roleHome = _roleHome(role);

    if (isPublicAuthRoute) {
      final intended = uri?.queryParameters[Routes.redirectQueryParam];
      if (intended != null &&
          intended.isNotEmpty &&
          _isAllowedForRole(intended, role)) {
        final slug = RouteCapabilities.requiredSlug(intended);
        if (slug == null || capabilities.can(slug)) {
          return intended;
        }
      }
      return roleHome;
    }

    // Role boundary checks: prevent users from cross-navigating other role paths
    if (Routes.isAdminPath(currentPath) && role != UserType.admin) {
      return roleHome;
    }
    if (Routes.isTrainerPath(currentPath) &&
        role != UserType.trainer &&
        role != UserType.admin) {
      return roleHome;
    }

    // Capability gates (UI convenience; server still enforces).
    final required = RouteCapabilities.requiredSlug(currentPath);
    if (required != null && !capabilities.can(required)) {
      return roleHome;
    }

    return null;
  }

  return null;
}

String _roleHome(UserType role) => switch (role) {
  UserType.admin => Routes.adminDashboard,
  UserType.trainer => Routes.trainerHome,
  UserType.employee || UserType.member => Routes.memberHome,
};

bool _isAllowedForRole(String path, UserType role) {
  if (Routes.isAdminPath(path)) return role == UserType.admin;
  if (Routes.isTrainerPath(path)) {
    return role == UserType.trainer || role == UserType.admin;
  }
  // Member / shared paths — any authenticated role may deep-link here; the
  // role shell they land in is still determined by their own tree when they
  // navigate via chrome. Cross-role admin/trainer already filtered above.
  return true;
}

/// Test helper: whether [capabilities] satisfy the route gate for [path].
bool routeAllowsCapabilities(String path, Capabilities capabilities) {
  final required = RouteCapabilities.requiredSlug(path);
  if (required == null) return true;
  return capabilities.can(required);
}
