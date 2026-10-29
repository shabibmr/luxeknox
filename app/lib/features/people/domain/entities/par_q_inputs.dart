import 'package:equatable/equatable.dart';

import 'par_q_screening.dart';

/// Client-side submission of the seven PAR-Q+ answers and the legal
/// declaration for [memberId].
class ParQSubmission extends Equatable {
  static const questionCount = 7;

  final int memberId;
  final List<ParQAnswer> answers;
  final bool declarationAccepted;

  // Not const: the assert reads `answers.length`.
  // ignore: prefer_const_constructors_in_immutables
  ParQSubmission({
    required this.memberId,
    required this.answers,
    required this.declarationAccepted,
  }) : assert(
         answers.length == questionCount,
         'PAR-Q+ has exactly $questionCount questions',
       );

  @override
  List<Object?> get props => [memberId, answers, declarationAccepted];
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
