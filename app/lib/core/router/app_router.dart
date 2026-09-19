import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
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
      return appRedirectLogic(
        sessionState: sessionCubit.state,
        currentPath: state.matchedLocation,
      );
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      createMemberBranchRoute(),
      createTrainerBranchRoute(),
      createAdminBranchRoute(),
    ],
  );
}
