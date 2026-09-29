import '../../../core/router/routes.dart';
import '../../membership/domain/entities/membership.dart';

/// Whether [membership] is (or was) a personal-training package.
///
/// Prefers nested [Membership.product.ptSessionsIncluded]; when the product is
/// omitted (trainer-scoped MEMB reads), falls back to [Membership.remainingPtSessions].
bool membershipIncludesPt(Membership membership) {
  final included = membership.product?.ptSessionsIncluded;
  if (included != null) return included > 0;
  final remaining = membership.remainingPtSessions;
  return remaining != null && remaining > 0;
}

/// Active/frozen membership that includes PT sessions.
bool isPtPurchased(Membership? membership) {
  if (membership == null || !membership.isActiveOrFrozen) return false;
  return membershipIncludesPt(membership);
}

/// PT package present but expired (or end date in the past).
bool isPtExpired(Membership? membership) {
  if (membership == null) return false;
  if (!membershipIncludesPt(membership)) return false;
  if (membership.status.name == 'expired') return true;
  return membership.daysUntilExpiry < 0;
}

Membership? preferActiveMembership(List<Membership> items) {
  if (items.isEmpty) return null;
  return items.firstWhere((m) => m.isActiveOrFrozen, orElse: () => items.first);
}

/// Create is rejected when an active/frozen contract already exists (FR-MEMB-006).
String addPersonalTrainingLocation({
  required int memberId,
  Membership? membership,
}) {
  if (membership != null && membership.isActiveOrFrozen) {
    return Routes.adminMembershipById(membership.id);
  }
  return Routes.adminMembersAssignMembership.replaceFirst(
    ':id',
    memberId.toString(),
  );
}

String formatCalendarDate(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// Human-readable days relative to [endDate] (date-only comparison).
String formatDaysRelative(DateTime endDate, {DateTime? now}) {
  final today = now ?? DateTime.now();
  final end = DateTime(endDate.year, endDate.month, endDate.day);
  final start = DateTime(today.year, today.month, today.day);
  final days = end.difference(start).inDays;
  if (days > 0) return '($days days left)';
  if (days == 0) return '(expires today)';
  return '(expired ${-days} days ago)';
}
