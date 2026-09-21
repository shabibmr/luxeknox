import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/change_password_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../widgets/not_found_screen.dart';
import '../../session/presentation/session_cubit.dart';
import 'admin_routes.dart';
import 'member_routes.dart';
import 'redirect_logic.dart';
import 'routes.dart';
import 'trainer_routes.dart';

export 'redirect_logic.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createRouter(SessionCubit sessionCubit) {
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: GoRouterRefreshStream(sessionCubit.stream),
    redirect: (context, state) {
      // Prefer full path for deep-link restore; fall back to matched location
      // when the route did not match (errorBuilder / unknown).
      final path = state.uri.path.isNotEmpty
          ? state.uri.path
          : state.matchedLocation;
      return appRedirectLogic(
        sessionState: sessionCubit.state,
        currentPath: path,
        uri: state.uri,
      );
    },
    errorBuilder: (context, state) => NotFoundScreen(uri: state.uri),
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.resetPassword,
        builder: (context, state) => ResetPasswordScreen(
          initialToken: state.uri.queryParameters['token'],
        ),
      ),
      GoRoute(
        path: Routes.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      createMemberBranchRoute(),
      createTrainerBranchRoute(),
      createAdminBranchRoute(),
    ],
  );
}
