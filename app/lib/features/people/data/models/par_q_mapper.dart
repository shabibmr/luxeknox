import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/par_q_inputs.dart';
import '../../domain/entities/par_q_screening.dart';

ParQClearanceStatus _statusFromApi(api.ParQScreeningClearanceStatusEnum s) {
  if (s == api.ParQScreeningClearanceStatusEnum.passed) {
    return ParQClearanceStatus.passed;
  }
  if (s == api.ParQScreeningClearanceStatusEnum.pendingClearance) {
    return ParQClearanceStatus.pendingClearance;
  }
  if (s == api.ParQScreeningClearanceStatusEnum.cleared) {
    return ParQClearanceStatus.cleared;
  }
  return ParQClearanceStatus.rejected;
}

ParQScreening parQScreeningFromApi(api.ParQScreening s) {
  return ParQScreening(
    id: s.id,
    memberId: s.memberId,
    version: s.version,
    answers: [
      ParQAnswer(yes: s.q1HeartCondition, details: s.q1Details),
      ParQAnswer(yes: s.q2ChestPainActivity, details: s.q2Details),
      ParQAnswer(yes: s.q3ChestPainRest, details: s.q3Details),
      ParQAnswer(yes: s.q4DizzinessConsciousness, details: s.q4Details),
      ParQAnswer(yes: s.q5BoneJointProblem, details: s.q5Details),
      ParQAnswer(yes: s.q6MedicationCondition, details: s.q6Details),
      ParQAnswer(yes: s.q7OtherReason, details: s.q7Details),
    ],
    hasPositiveAnswer: s.hasPositiveAnswer,
    trainerScreeningNotes: s.trainerScreeningNotes,
    referralRequired: s.referralRequired,
    referralReason: s.referralReason,
    declarationAccepted: s.declarationAccepted,
    clientSignature: s.clientSignature,
    clientSignedAt: s.clientSignedAt,
    trainerSignedAt: s.trainerSignedAt,
    clearanceStatus: _statusFromApi(s.clearanceStatus),
    clearedAt: s.clearedAt,
    clearedByUserId: s.clearedByUserId,
    createdAt: s.createdAt,
    updatedAt: s.updatedAt,
  );
}

/// The server only stores detail text for a YES answer, so a NO drops it.
String? _details(ParQAnswer a) => a.yes ? a.details : null;

api.ParQSubmit parQSubmitToApi(ParQSubmission s) {
  final a = s.answers;
  return api.ParQSubmit(
    (b) => b
      ..q1HeartCondition = a[0].yes
      ..q1Details = _details(a[0])
      ..q2ChestPainActivity = a[1].yes
      ..q2Details = _details(a[1])
      ..q3ChestPainRest = a[2].yes
      ..q3Details = _details(a[2])
      ..q4DizzinessConsciousness = a[3].yes
      ..q4Details = _details(a[3])
      ..q5BoneJointProblem = a[4].yes
      ..q5Details = _details(a[4])
      ..q6MedicationCondition = a[5].yes
      ..q6Details = _details(a[5])
      ..q7OtherReason = a[6].yes
      ..q7Details = _details(a[6])
      ..declarationAccepted = api.ParQSubmitDeclarationAcceptedEnum.true_
      ..clientSignature = s.clientSignature,
  );
}

api.ParQTrainerReview parQTrainerReviewToApi(ParQTrainerReviewInput r) {
  return api.ParQTrainerReview(
    (b) => b
      ..trainerScreeningNotes = r.trainerScreeningNotes
      ..referralRequired = r.referralRequired
      ..referralReason = r.referralRequired ? r.referralReason : null,
  );
}

api.ParQClearance parQClearanceToApi(ParQClearanceInput c) {
  return api.ParQClearance(
    (b) => b
      ..decision = switch (c.decision) {
        ParQClearanceDecision.cleared => api.ParQClearanceDecisionEnum.cleared,
        ParQClearanceDecision.rejected =>
          api.ParQClearanceDecisionEnum.rejected,
      },
  );
}
