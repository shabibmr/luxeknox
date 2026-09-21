/// Path-prefix → permission slug gates for [appRedirectLogic].
///
/// Longer / more specific prefixes must appear first. Missing capability
/// redirects to the caller's role home (UI convenience only — server re-checks).
abstract final class RouteCapabilities {
  static const List<(String prefix, String slug)> requirements = [
    ('/admin/memberships/create', 'memberships.create'),
    ('/admin/members/add', 'members.create'),
    ('/admin/notifications/broadcast', 'notifications.send'),
    ('/admin/attendance/manual', 'attendance.override'),
    ('/admin/attendance/scan', 'attendance.checkin'),
    ('/admin/payments/record', 'payments.create'),
    ('/admin/payments/methods', 'payments.read'),
    ('/admin/payments/outstanding', 'payments.read'),
    ('/admin/reports', 'reports.read'),
    ('/admin/settings', 'settings.read'),
    ('/trainer/plans/workouts/create', 'workouts.write'),
  ];

  /// Returns the required capability slug for [path], or null if unrestricted
  /// beyond role-boundary checks.
  static String? requiredSlug(String path) {
    // Edit is nested under :id — match suffix so list/detail stay ungated.
    if (path.startsWith('/trainer/plans/workouts/') && path.endsWith('/edit')) {
      return 'workouts.write';
    }
    for (final (prefix, slug) in requirements) {
      if (path == prefix || path.startsWith('$prefix/')) {
        return slug;
      }
    }
    return null;
  }
}
