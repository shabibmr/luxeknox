enum GoalStatus {
  inProgress,
  achieved,
  abandoned;

  static GoalStatus fromWire(String? value) {
    return switch (value) {
      'achieved' => GoalStatus.achieved,
      'abandoned' => GoalStatus.abandoned,
      'in_progress' || 'inProgress' => GoalStatus.inProgress,
      _ => GoalStatus.inProgress,
    };
  }

  String get wire => switch (this) {
    GoalStatus.inProgress => 'in_progress',
    GoalStatus.achieved => 'achieved',
    GoalStatus.abandoned => 'abandoned',
  };
}
