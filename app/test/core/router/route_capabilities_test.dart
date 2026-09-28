import 'package:luxeknox/core/router/route_capabilities.dart';
import 'package:luxeknox/core/router/routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RouteCapabilities', () {
    test('returns null for ungated paths', () {
      expect(RouteCapabilities.requiredSlug(Routes.adminDashboard), isNull);
      expect(RouteCapabilities.requiredSlug(Routes.adminMembers), isNull);
      expect(RouteCapabilities.requiredSlug(Routes.memberHome), isNull);
    });

    test('matches specific create/mutate prefixes', () {
      expect(
        RouteCapabilities.requiredSlug(Routes.adminMembershipsCreate),
        'memberships.create',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.adminMembersAdd),
        'members.create',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.adminTrainersCreate),
        'trainers.create',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.adminEmployeesCreate),
        'employees.create',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.adminEmployeesEditById(9)),
        'employees.update',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.adminEmployeeRolesById('9')),
        'roles.update',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.adminEmployees),
        isNull,
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.adminNotificationsBroadcast),
        'notifications.send',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.trainerNotificationsBroadcast),
        'notifications.send',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.adminAttendanceScan),
        'attendance.checkin',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.adminAttendanceManual),
        'attendance.override',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.adminPaymentsRecord),
        'payments.create',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.adminPaymentsMethods),
        'payments.read',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.adminPaymentsOutstanding),
        'payments.read',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.trainerPlansWorkoutsCreate),
        'workouts.write',
      );
      expect(
        RouteCapabilities.requiredSlug(
          Routes.trainerPlansWorkoutEditById('9'),
        ),
        'workouts.write',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.trainerPlansWorkoutById('9')),
        isNull,
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.trainerPlansWorkoutsHistory),
        isNull,
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.trainerPlansDietsCreate),
        'diets.write',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.trainerPlansDietEditById('9')),
        'diets.write',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.trainerPlansDietById('9')),
        isNull,
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.trainerPlansDietsHistory),
        isNull,
      );
    });

    test('matches category prefixes for reports and settings', () {
      expect(
        RouteCapabilities.requiredSlug(Routes.adminReportsCategory('revenue')),
        'reports.read',
      );
      expect(
        RouteCapabilities.requiredSlug(Routes.adminSettingsCategory('gym')),
        'settings.read',
      );
    });
  });
}
