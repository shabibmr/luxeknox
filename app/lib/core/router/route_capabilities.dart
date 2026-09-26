/// Path-prefix → permission slug gates for [appRedirectLogic].
///
/// Longer / more specific prefixes must appear first. Missing capability
/// redirects to the caller's role home (UI convenience only — server re-checks).
abstract final class RouteCapabilities {
  static const List<(String prefix, String slug)> requirements = [
    ('/admin/memberships/create', 'memberships.create'),
    ('/admin/members/add', 'members.create'),
    ('/admin/trainers/create', 'trainers.create'),
    ('/admin/employees/create', 'employees.create'),
    ('/admin/notifications/broadcast', 'notifications.send'),
    ('/trainer/notifications/broadcast', 'notifications.send'),
    ('/admin/attendance/manual', 'attendance.override'),
    ('/admin/attendance/scan', 'attendance.checkin'),
    ('/admin/payments/record', 'payments.create'),
    ('/admin/payments/methods', 'payments.read'),
    ('/admin/payments/outstanding', 'payments.read'),
    ('/admin/reports', 'reports.read'),
    ('/admin/goal-metrics', 'goals.create'),
    ('/admin/settings', 'settings.read'),
    ('/admin/schedules/create', 'schedules.write'),
    ('/trainer/plans/workouts/create', 'workouts.write'),
    ('/trainer/plans/diets/create', 'diets.write'),
  ];

  /// Returns the required capability slug for [path], or null if unrestricted
  /// beyond role-boundary checks.
  static String? requiredSlug(String path) {
    // Edit is nested under :id — match suffix so list/detail stay ungated.
    if (path.startsWith('/admin/employees/') && path.endsWith('/edit')) {
      return 'employees.update';
    }
    if (path.startsWith('/admin/schedules/') && path.endsWith('/edit')) {
      return 'schedules.write';
    }
    if (path.startsWith('/admin/memberships/') && path.endsWith('/renew')) {
      return 'memberships.approve';
    }
    if (path.startsWith('/admin/memberships/') && path.endsWith('/freeze')) {
      return 'memberships.update';
    }
    if (path.startsWith('/trainer/plans/workouts/') && path.endsWith('/edit')) {
      return 'workouts.write';
    }
    if (path.startsWith('/trainer/plans/diets/') && path.endsWith('/edit')) {
      return 'diets.write';
    }
    for (final (prefix, slug) in requirements) {
      if (path == prefix || path.startsWith('$prefix/')) {
        return slug;
      }
    }
    return null;
  }
}
