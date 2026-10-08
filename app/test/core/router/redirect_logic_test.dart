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
          uri: Uri.parse(Routes.login),
        ),
        Routes.splash,
      );
      expect(
        appRedirectLogic(
          sessionState: const SessionUnknown(),
          uri: Uri.parse(Routes.splash),
        ),
        isNull,
      );
    });

    test('unknown session on login keeps its parked redirect', () {
      expect(
        appRedirectLogic(
          sessionState: const SessionUnknown(),
          uri: Uri.parse(Routes.loginWithRedirect('/admin/members?q=a')),
        ),
        Routes.splashWithRedirect('/admin/members?q=a'),
      );
    });

    test('unauthenticated session leaves public auth screens alone', () {
      for (final path in [
        Routes.login,
        Routes.forgotPassword,
        Routes.resetPassword,
      ]) {
        expect(
          appRedirectLogic(
            sessionState: const SessionUnauthenticated(explicitSignOut: true),
            uri: Uri.parse(path),
          ),
          isNull,
          reason: path,
        );
      }
    });

    test(
      'unknown session with protected deep link preserves redirect query to splash',
      () {
        expect(
          appRedirectLogic(
            sessionState: const SessionUnknown(),
            uri: Uri.parse(Routes.adminMembers),
          ),
          Routes.splashWithRedirect(Routes.adminMembers),
        );
      },
    );

    test(
      'unauthenticated on splash with redirect query routes to login with redirect',
      () {
        expect(
          appRedirectLogic(
            sessionState: const SessionUnauthenticated(),
            uri: Uri.parse(Routes.splashWithRedirect(Routes.adminMembers)),
          ),
          Routes.loginWithRedirect(Routes.adminMembers),
        );
      },
    );

    test(
      'authenticated on splash with redirect query restores intended route',
      () {
        expect(
          appRedirectLogic(
            sessionState: const SessionAuthenticated(
              principal: principal,
              capabilities: capabilities,
            ),
            uri: Uri.parse(Routes.splashWithRedirect(Routes.adminMembers)),
          ),
          Routes.adminMembers,
        );
      },
    );

    test('unauthenticated allows forgot/reset password routes; '
        'explicit sign-out drops the stale deep link', () {
      expect(
        appRedirectLogic(
          sessionState: const SessionUnauthenticated(),
          uri: Uri.parse(Routes.forgotPassword),
        ),
        isNull,
      );
      expect(
        appRedirectLogic(
          sessionState: const SessionUnauthenticated(),
          uri: Uri.parse(Routes.resetPassword),
        ),
        isNull,
      );
      expect(
        appRedirectLogic(
          sessionState: const SessionUnauthenticated(explicitSignOut: true),
          uri: Uri.parse(Routes.trainerHome),
        ),
        Routes.login,
      );
      expect(
        appRedirectLogic(
          sessionState: const SessionUnauthenticated(),
          uri: Uri.parse(Routes.adminMembers),
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
          uri: Uri.parse(Routes.login),
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
          uri: Uri.parse(Routes.adminMembershipsCreate),
        ),
        Routes.adminDashboard,
      );
      expect(
        appRedirectLogic(
          sessionState: const SessionAuthenticated(
            principal: principal,
            capabilities: Capabilities(slugs: ['memberships.create']),
          ),
          uri: Uri.parse(Routes.adminMembershipsCreate),
        ),
        isNull,
      );
    });

    test('trainer cannot open admin assign-membership', () {
      expect(
        appRedirectLogic(
          sessionState: const SessionAuthenticated(
            principal: Principal(
              userId: '2',
              userType: UserType.trainer,
              displayName: 'Trainer',
              profileId: 't1',
            ),
            capabilities: Capabilities(slugs: ['memberships.read']),
          ),
          uri: Uri.parse('/admin/members/42/assign-membership'),
        ),
        Routes.trainerHome,
      );
    });

    test('admin without memberships.create cannot assign membership', () {
      expect(
        appRedirectLogic(
          sessionState: const SessionAuthenticated(
            principal: principal,
            capabilities: Capabilities(slugs: ['memberships.read']),
          ),
          uri: Uri.parse('/admin/members/42/assign-membership'),
        ),
        Routes.adminDashboard,
      );
    });
  });
}
