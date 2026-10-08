import '../../session/domain/entities/capabilities.dart';
import '../../session/domain/entities/user_type.dart';
import '../../session/presentation/session_cubit.dart';
import 'route_capabilities.dart';
import 'routes.dart';

/// Computes the redirect target according to session state and current [uri].
/// Exactly one redirect function to prevent redirect loops.
///
/// Deep links are parked in `?redirect=` while on splash/login and restored
/// after sign-in.
String? appRedirectLogic({
  required SessionState sessionState,
  required Uri uri,
}) {
  final path = uri.path;
  final isRoot = path.isEmpty || path == '/';
  // Keep the query string (e.g. `?token=` on reset-password, list filters) when
  // the location is parked in the `redirect` param across splash/login.
  final location = uri.hasQuery ? '$path?${uri.query}' : path;
  final intended = uri.queryParameters[Routes.redirectQueryParam] ?? '';

  switch (sessionState) {
    case SessionUnknown():
      if (path == Routes.splash) return null;
      if (isRoot) return Routes.splash;
      if (path == Routes.login) {
        return intended.isEmpty
            ? Routes.splash
            : Routes.splashWithRedirect(intended);
      }
      return Routes.splashWithRedirect(location);

    case SessionUnauthenticated(:final explicitSignOut):
      if (path == Routes.splash) {
        if (intended.isEmpty) return Routes.login;
        // Password-recovery links are public: land on them, not on login.
        if (Routes.isRecoveryPath(Uri.tryParse(intended)?.path ?? '')) {
          return intended;
        }
        return Routes.loginWithRedirect(intended);
      }
      if (Routes.isPublicAuthPath(path)) return null;
      // After an explicit sign-out, don't carry the previous account's path
      // into the next login — otherwise a different user signing in can land
      // on a screen left over from the prior session (e.g. an admin seeing a
      // trainer page).
      if (isRoot || explicitSignOut) return Routes.login;
      return Routes.loginWithRedirect(location);

    case SessionAuthenticated(:final principal, :final capabilities):
      final role = principal.userType;
      final roleHome = _roleHome(role);
      if (isRoot) return roleHome;
      if (Routes.isPublicAuthPath(path)) {
        final restore =
            intended.isNotEmpty &&
            intended != '/' &&
            _canOpen(intended, role, capabilities);
        return restore ? intended : roleHome;
      }
      return _canOpen(path, role, capabilities) ? null : roleHome;
  }
}

String _roleHome(UserType role) => switch (role) {
  UserType.admin => Routes.adminDashboard,
  UserType.trainer => Routes.trainerHome,
  UserType.employee || UserType.member => Routes.memberHome,
};

/// Role boundary plus capability gate (UI convenience; server still enforces).
bool _canOpen(String path, UserType role, Capabilities capabilities) =>
    _isAllowedForRole(path, role) &&
    routeAllowsCapabilities(path, capabilities);

bool _isAllowedForRole(String path, UserType role) {
  if (Routes.isAdminPath(path)) return role == UserType.admin;
  if (Routes.isTrainerPath(path)) {
    return role == UserType.trainer || role == UserType.admin;
  }
  // Member / shared paths — any authenticated role may deep-link here; the
  // role shell they land in is still determined by their own tree when they
  // navigate via chrome.
  return true;
}

/// Whether [capabilities] satisfy the route gate for [path].
bool routeAllowsCapabilities(String path, Capabilities capabilities) {
  final required = RouteCapabilities.requiredSlug(path);
  return required == null || capabilities.can(required);
}
