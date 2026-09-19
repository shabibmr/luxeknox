import 'package:app/core/router/redirect_logic.dart';
import 'package:app/core/router/routes.dart';
import 'package:app/session/domain/entities/capabilities.dart';
import 'package:app/session/domain/entities/principal.dart';
import 'package:app/session/presentation/session_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Router Redirect Logic (G3)', () {
    const memberPrincipal = Principal(
      userId: '1',
      userType: 'member',
      displayName: 'Member One',
      profileId: 'p1',
    );
    const trainerPrincipal = Principal(
      userId: '2',
      userType: 'trainer',
      displayName: 'Trainer One',
      profileId: 'p2',
    );
    const adminPrincipal = Principal(
      userId: '3',
      userType: 'admin',
      displayName: 'Admin One',
      profileId: 'p3',
    );
    const emptyCaps = Capabilities(slugs: []);

    test('signed-out user on protected route redirects to /login', () {
      final redirect = appRedirectLogic(
        sessionState: const SessionUnauthenticated(),
        currentPath: Routes.memberHome,
      );
      expect(redirect, Routes.login);
    });

    test('signed-out user already on /login does not redirect (no loop)', () {
      final redirect = appRedirectLogic(
        sessionState: const SessionUnauthenticated(),
        currentPath: Routes.login,
      );
      expect(redirect, isNull);
    });

    test('unknown session on /login redirects to /splash', () {
      final redirect = appRedirectLogic(
        sessionState: const SessionUnknown(),
        currentPath: Routes.login,
      );
      expect(redirect, Routes.splash);
    });

    test('unknown session on /splash does not redirect (no loop)', () {
      final redirect = appRedirectLogic(
        sessionState: const SessionUnknown(),
        currentPath: Routes.splash,
      );
      expect(redirect, isNull);
    });

    test('signed-in member on /login redirects to /home', () {
      final redirect = appRedirectLogic(
        sessionState: const SessionAuthenticated(
          principal: memberPrincipal,
          capabilities: emptyCaps,
        ),
        currentPath: Routes.login,
      );
      expect(redirect, Routes.memberHome);
    });

    test('signed-in trainer on /login redirects to /trainer/home', () {
      final redirect = appRedirectLogic(
        sessionState: const SessionAuthenticated(
          principal: trainerPrincipal,
          capabilities: emptyCaps,
        ),
        currentPath: Routes.login,
      );
      expect(redirect, Routes.trainerHome);
    });

    test('signed-in admin on /login redirects to /admin/dashboard', () {
      final redirect = appRedirectLogic(
        sessionState: const SessionAuthenticated(
          principal: adminPrincipal,
          capabilities: emptyCaps,
        ),
        currentPath: Routes.login,
      );
      expect(redirect, Routes.adminDashboard);
    });

    test(
      'member accessing out-of-role route /admin/dashboard is redirected to /home',
      () {
        final redirect = appRedirectLogic(
          sessionState: const SessionAuthenticated(
            principal: memberPrincipal,
            capabilities: emptyCaps,
          ),
          currentPath: Routes.adminDashboard,
        );
        expect(redirect, Routes.memberHome);
      },
    );

    test(
      'admin accessing /admin/workout-library stays on path (no redirect)',
      () {
        final redirect = appRedirectLogic(
          sessionState: const SessionAuthenticated(
            principal: adminPrincipal,
            capabilities: emptyCaps,
          ),
          currentPath: Routes.adminWorkoutLibrary,
        );
        expect(redirect, isNull);
      },
    );
  });
}
