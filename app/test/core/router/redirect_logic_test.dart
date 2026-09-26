import 'package:luxeknox/core/router/redirect_logic.dart';
import 'package:luxeknox/core/router/routes.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const principal = Principal(
    userId: '1',
    userType: UserType.admin,
    displayName: 'Admin',
    profileId: '10',
  );
  const capabilities = Capabilities(slugs: ['people.read.any']);

  group('appRedirectLogic', () {
    test('unknown session forces splash except when already there', () {
      expect(
        appRedirectLogic(
          sessionState: const SessionUnknown(),
          currentPath: Routes.login,
        ),
        Routes.splash,
      );
      expect(
        appRedirectLogic(
          sessionState: const SessionUnknown(),
          currentPath: Routes.splash,
        ),
        isNull,
      );
    });

    test('unauthenticated allows forgot/reset password routes', () {
      expect(
        appRedirectLogic(
          sessionState: const SessionUnauthenticated(),
          currentPath: Routes.forgotPassword,
        ),
        isNull,
      );
      expect(
        appRedirectLogic(
          sessionState: const SessionUnauthenticated(),
          currentPath: Routes.resetPassword,
        ),
        isNull,
      );
      expect(
        appRedirectLogic(
          sessionState: const SessionUnauthenticated(),
          currentPath: Routes.adminMembers,
        ),
        Routes.loginWithRedirect(Routes.adminMembers),
      );
    });

    test('authenticated leaves public auth routes for role home', () {
      expect(
        appRedirectLogic(
          sessionState: const SessionAuthenticated(
            principal: principal,
            capabilities: capabilities,
          ),
          currentPath: Routes.login,
        ),
        Routes.adminDashboard,
      );
    });

    test('authenticated restores deep-link redirect query when in-role', () {
      expect(
        appRedirectLogic(
          sessionState: const SessionAuthenticated(
            principal: principal,
            capabilities: capabilities,
          ),
          currentPath: Routes.login,
          uri: Uri.parse(Routes.loginWithRedirect(Routes.adminMembers)),
        ),
        Routes.adminMembers,
      );
    });

    test('capability gate redirects when slug missing', () {
      expect(
        appRedirectLogic(
          sessionState: const SessionAuthenticated(
            principal: principal,
            capabilities: Capabilities(slugs: []),
          ),
          currentPath: Routes.adminMembershipsCreate,
        ),
        Routes.adminDashboard,
      );
      expect(
        appRedirectLogic(
          sessionState: const SessionAuthenticated(
            principal: principal,
            capabilities: Capabilities(slugs: ['memberships.create']),
          ),
          currentPath: Routes.adminMembershipsCreate,
        ),
        isNull,
      );
    });
  });
}
