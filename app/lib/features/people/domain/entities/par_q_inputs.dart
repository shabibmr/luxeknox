import 'package:equatable/equatable.dart';

import 'par_q_screening.dart';

/// Client-side submission of the seven PAR-Q+ answers, the legal
/// declaration, and the member's drawn signature for [memberId].
class ParQSubmission extends Equatable {
  static const questionCount = 7;

  final int memberId;
  final List<ParQAnswer> answers;
  final bool declarationAccepted;

  /// Stroke payload or data URL. Empty when the member has not signed.
  final String clientSignature;

  // Not const: the assert reads `answers.length`.
  // ignore: prefer_const_constructors_in_immutables
  ParQSubmission({
    required this.memberId,
    required this.answers,
    required this.declarationAccepted,
    required this.clientSignature,
  }) : assert(
         answers.length == questionCount,
         'PAR-Q+ has exactly $questionCount questions',
       );

  @override
  List<Object?> get props => [
    memberId,
    answers,
    declarationAccepted,
    clientSignature,
  ];
}

/// Trainer's screening notes and optional doctor-referral decision.
class ParQTrainerReviewInput extends Equatable {
  final int memberId;
  final String trainerScreeningNotes;
  final bool referralRequired;
  final String? referralReason;

  const ParQTrainerReviewInput({
    required this.memberId,
    required this.trainerScreeningNotes,
    required this.referralRequired,
    this.referralReason,
  });

  @override
  List<Object?> get props => [
    memberId,
    trainerScreeningNotes,
    referralRequired,
    referralReason,
  ];
}

/// Final outcome of a pending-clearance screening.
enum ParQClearanceDecision { cleared, rejected }

class ParQClearanceInput extends Equatable {
  final int memberId;
  final ParQClearanceDecision decision;

  const ParQClearanceInput({required this.memberId, required this.decision});

  @override
  List<Object?> get props => [memberId, decision];
}
