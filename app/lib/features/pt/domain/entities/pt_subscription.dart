import 'package:equatable/equatable.dart';

import 'pt_product.dart';

enum PtSubscriptionStatus { scheduled, active, completed, cancelled }

/// How much a trainer may do on a member's hub: full while their PT with the
/// member is active, read-only once it has ended (until renewed).
enum TrainerAccess { full, readOnly }

/// A member's PT: one active trainer, a fixed recurring one-hour slot on
/// [weekdays] (0=Sunday … 6=Saturday), for [startDate]–[endDate].
///
/// Couple PTs are two linked rows (ADR-0011): [partnerSubscriptionId] points
/// at the other row; [isPrimary] marks the billing/session owner.
class PtSubscription extends Equatable {
  const PtSubscription({
    required this.id,
    required this.memberId,
    required this.ptProductId,
    required this.trainerId,
    required this.startDate,
    required this.endDate,
    required this.weekdays,
    required this.slotStart,
    required this.status,
    required this.rowVersion,
    required this.productName,
    required this.sessionsPerWeek,
    required this.trainerName,
    required this.slotLabel,
    this.packageType = PtPackageType.single,
    this.isPrimary = true,
    this.partnerSubscriptionId,
    this.partnerMemberId,
    this.partnerMemberName,
  });

  final int id;
  final int memberId;
  final int ptProductId;
  final int trainerId;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> weekdays;

  /// Gym wall-clock "HH:00:00".
  final String slotStart;
  final PtSubscriptionStatus status;
  final int rowVersion;
  final String productName;
  final int sessionsPerWeek;
  final String trainerName;

  /// e.g. "17:00-18:00".
  final String slotLabel;
  final PtPackageType packageType;
  final bool isPrimary;
  final int? partnerSubscriptionId;
  final int? partnerMemberId;
  final String? partnerMemberName;

  bool get isCouple => partnerSubscriptionId != null;

  bool get isOpen =>
      status == PtSubscriptionStatus.scheduled ||
      status == PtSubscriptionStatus.active;

  @override
  List<Object?> get props => [
    id,
    memberId,
    ptProductId,
    trainerId,
    startDate,
    endDate,
    weekdays,
    slotStart,
    status,
    rowVersion,
    productName,
    sessionsPerWeek,
    trainerName,
    slotLabel,
    packageType,
    isPrimary,
    partnerSubscriptionId,
    partnerMemberId,
    partnerMemberName,
  ];
}

class MemberPtSummary extends Equatable {
  const MemberPtSummary({
    this.current,
    this.history = const [],
    this.trainerAccess,
  });

  /// Scheduled or active PT, if any.
  final PtSubscription? current;
  final List<PtSubscription> history;

  /// Only set when the caller is a trainer.
  final TrainerAccess? trainerAccess;

  /// Most recent ended PT (for "expired" display) when there is no current one.
  PtSubscription? get lastEnded {
    if (current != null) return null;
    PtSubscription? latest;
    for (final s in history) {
      if (s.status == PtSubscriptionStatus.completed ||
          s.status == PtSubscriptionStatus.cancelled) {
        if (latest == null ||
            s.startDate.isAfter(latest.startDate) ||
            (s.startDate.isAtSameMomentAs(latest.startDate) &&
                s.endDate.isAfter(latest.endDate)) ||
            (s.startDate.isAtSameMomentAs(latest.startDate) &&
                s.endDate.isAtSameMomentAs(latest.endDate) &&
                s.id > latest.id)) {
          latest = s;
        }
      }
    }
    return latest;
  }

  @override
  List<Object?> get props => [current, history, trainerAccess];
}
