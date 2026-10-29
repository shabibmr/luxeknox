import 'package:equatable/equatable.dart';

/// Mirrors `ParQScreeningClearanceStatusEnum`. `pendingClearance` blocks PT
/// booking until a doctor or manager clears the member.
enum ParQClearanceStatus { passed, pendingClearance, cleared, rejected }

/// One PAR-Q+ answer: YES/NO plus the free-text detail captured on YES.
class ParQAnswer extends Equatable {
  final bool yes;
  final String? details;

  const ParQAnswer({required this.yes, this.details});

  static const no = ParQAnswer(yes: false);

  @override
  List<Object?> get props => [yes, details];
}

/// Mirrors `ParQScreening` (screen 04: PAR-Q+ screening).
class ParQScreening extends Equatable {
  final int id;
  final int memberId;
  final String version;

  /// The seven PAR-Q+ answers in questionnaire order (Q1..Q7).
  final List<ParQAnswer> answers;
  final bool hasPositiveAnswer;
  final String? trainerScreeningNotes;
  final bool referralRequired;
  final String? referralReason;
  final bool declarationAccepted;
  final DateTime? clientSignedAt;
  final DateTime? trainerSignedAt;
  final ParQClearanceStatus clearanceStatus;
  final DateTime? clearedAt;
  final int? clearedByUserId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ParQScreening({
    required this.id,
    required this.memberId,
    required this.version,
    required this.answers,
    required this.hasPositiveAnswer,
    this.trainerScreeningNotes,
    required this.referralRequired,
    this.referralReason,
    required this.declarationAccepted,
    this.clientSignedAt,
    this.trainerSignedAt,
    required this.clearanceStatus,
    this.clearedAt,
    this.clearedByUserId,
    required this.createdAt,
    this.updatedAt,
  });

  /// True while the member may not book PT sessions.
  bool get isPendingClearance =>
      clearanceStatus == ParQClearanceStatus.pendingClearance;

  @override
  List<Object?> get props => [
    id,
    memberId,
    version,
    answers,
    hasPositiveAnswer,
    trainerScreeningNotes,
    referralRequired,
    referralReason,
    declarationAccepted,
    clientSignedAt,
    trainerSignedAt,
    clearanceStatus,
    clearedAt,
    clearedByUserId,
    createdAt,
    updatedAt,
  ];
}
