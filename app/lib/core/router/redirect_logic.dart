import '../../session/domain/entities/user_type.dart';
import '../../session/presentation/session_cubit.dart';
import 'routes.dart';

/// Computes the redirect target according to session state and current path.
/// Exactly one redirect function to prevent redirect loops.
String? appRedirectLogic({
  required SessionState sessionState,
  required String currentPath,
}) {
  final isAuthRoute =
      currentPath == Routes.login || currentPath == Routes.splash;

  if (sessionState is SessionUnknown) {
    return currentPath == Routes.splash ? null : Routes.splash;
  }

  if (sessionState is SessionUnauthenticated) {
    return isAuthRoute
        ? (currentPath == Routes.login ? null : Routes.login)
        : Routes.login;
  }

  if (sessionState is SessionAuthenticated) {
    final role = sessionState.principal.userType;
    final roleHome = switch (role) {
      UserType.admin => Routes.adminDashboard,
      UserType.trainer => Routes.trainerHome,
      UserType.employee || UserType.member => Routes.memberHome,
    };

    // If currently on login or splash, redirect to role home
    if (isAuthRoute) {
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

    return null;
  }

  return null;
}
