enum ProgressNoteType {
  memberNote,
  trainerAssessment;

  static ProgressNoteType fromWire(String? value) {
    return switch (value) {
      'trainer_assessment' || 'trainerAssessment' =>
        ProgressNoteType.trainerAssessment,
      'member_note' || 'memberNote' => ProgressNoteType.memberNote,
      _ => ProgressNoteType.memberNote,
    };
  }

  String get wire => switch (this) {
    ProgressNoteType.memberNote => 'member_note',
    ProgressNoteType.trainerAssessment => 'trainer_assessment',
  };
}
