import 'package:equatable/equatable.dart';

/// Value object representing post-workout completion feedback and signatures.
/// Signed-at timestamps are server-stamped and never supplied by the client.
class SessionCompletion extends Equatable {
  const SessionCompletion({
    this.clientFeedbackRating,
    this.effortRating,
    this.satisfactionRating,
    this.painDiscomfortScore,
    this.painNotes,
    this.notes,
    this.trainerNotes,
    this.nextSessionPlan,
    this.sessionFocus,
    this.warmupProtocol,
    this.cooldownProtocol,
    this.clientSigned,
    this.trainerSigned,
  });

  final int? clientFeedbackRating;
  final int? effortRating;
  final int? satisfactionRating;
  final int? painDiscomfortScore;
  final String? painNotes;
  final String? notes;
  final String? trainerNotes;
  final String? nextSessionPlan;
  final String? sessionFocus;
  final String? warmupProtocol;
  final String? cooldownProtocol;
  final bool? clientSigned;
  final bool? trainerSigned;

  SessionCompletion copyWith({
    int? clientFeedbackRating,
    int? effortRating,
    int? satisfactionRating,
    int? painDiscomfortScore,
    String? painNotes,
    String? notes,
    String? trainerNotes,
    String? nextSessionPlan,
    String? sessionFocus,
    String? warmupProtocol,
    String? cooldownProtocol,
    bool? clientSigned,
    bool? trainerSigned,
  }) {
    return SessionCompletion(
      clientFeedbackRating: clientFeedbackRating ?? this.clientFeedbackRating,
      effortRating: effortRating ?? this.effortRating,
      satisfactionRating: satisfactionRating ?? this.satisfactionRating,
      painDiscomfortScore: painDiscomfortScore ?? this.painDiscomfortScore,
      painNotes: painNotes ?? this.painNotes,
      notes: notes ?? this.notes,
      trainerNotes: trainerNotes ?? this.trainerNotes,
      nextSessionPlan: nextSessionPlan ?? this.nextSessionPlan,
      sessionFocus: sessionFocus ?? this.sessionFocus,
      warmupProtocol: warmupProtocol ?? this.warmupProtocol,
      cooldownProtocol: cooldownProtocol ?? this.cooldownProtocol,
      clientSigned: clientSigned ?? this.clientSigned,
      trainerSigned: trainerSigned ?? this.trainerSigned,
    );
  }

  @override
  List<Object?> get props => [
    clientFeedbackRating,
    effortRating,
    satisfactionRating,
    painDiscomfortScore,
    painNotes,
    notes,
    trainerNotes,
    nextSessionPlan,
    sessionFocus,
    warmupProtocol,
    cooldownProtocol,
    clientSigned,
    trainerSigned,
  ];
}
