import '../../../session/domain/entities/user_type.dart';
import '../../membership/domain/entities/membership.dart';
import '../../pt/domain/entities/pt_subscription.dart';

/// PT status shown on the member dossier, derived from the member's PT
/// subscriptions (PT is its own package, not part of the gym membership).
enum PtDossierStatus { active, scheduled, expired, notPurchased }

PtDossierStatus ptDossierStatus(MemberPtSummary? summary) {
  final current = summary?.current;
  if (current != null) {
    return current.status == PtSubscriptionStatus.active
        ? PtDossierStatus.active
        : PtDossierStatus.scheduled;
  }
  if (summary?.lastEnded != null) return PtDossierStatus.expired;
  return PtDossierStatus.notPurchased;
}

Membership? preferActiveMembership(List<Membership> items) {
  if (items.isEmpty) return null;
  return items.firstWhere((m) => m.isActiveOrFrozen, orElse: () => items.first);
}

/// Gym membership sales are admin-only. Selling while a contract is already
/// active/frozen extends the end date on the server (assign-or-renew).
bool canSellMembership({
  required UserType userType,
  required bool canCreateMembership,
}) =>
    userType == UserType.admin && canCreateMembership;

/// PT can be added only while the gym membership is active and unexpired, and
/// only one PT runs at a time (renew instead). Selling is admin/staff only.
bool canSellPt({
  required UserType userType,
  required bool canCreatePt,
  required Membership? membership,
  required MemberPtSummary? pt,
  DateTime? now,
}) {
  if (userType != UserType.admin || !canCreatePt) return false;
  if (pt?.current != null) return false;
  if (membership == null || membership.status.name != 'active') return false;
  final today = now ?? DateTime.now();
  final end = DateTime(membership.endDate.year, membership.endDate.month, membership.endDate.day);
  return !end.isBefore(DateTime(today.year, today.month, today.day));
}

/// Mid-PT trainer/slot change and renewal are admin actions.
bool canManagePt({required UserType userType, required bool canManage}) =>
    userType == UserType.admin && canManage;

/// Trainers see goals/plans read-only once their PT with the member has ended.
bool trainerHubReadOnly(MemberPtSummary? pt) => pt?.trainerAccess == TrainerAccess.readOnly;

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
