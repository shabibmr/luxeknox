enum AppReportType {
  members,
  memberships,
  attendance,
  payments,
  trainers,
  workouts,
  diets,
  progress,
  trainerOwn,
}

extension AppReportTypeX on AppReportType {
  /// OpenAPI / path wire value.
  String get wireName => switch (this) {
    AppReportType.members => 'members',
    AppReportType.memberships => 'memberships',
    AppReportType.attendance => 'attendance',
    AppReportType.payments => 'payments',
    AppReportType.trainers => 'trainers',
    AppReportType.workouts => 'workouts',
    AppReportType.diets => 'diets',
    AppReportType.progress => 'progress',
    AppReportType.trainerOwn => 'trainer_own',
  };

  /// URL category segment (payments also accepts legacy `revenue`).
  String get category => wireName;

  bool get showsProductFilter => this == AppReportType.memberships;

  bool get showsTrainerFilter =>
      this == AppReportType.trainers || this == AppReportType.workouts;
}

AppReportType? parseAppReportType(String raw) {
  final key = raw.trim().toLowerCase();
  // More-hub historically linked to `revenue` for payments/revenue.
  if (key == 'revenue') return AppReportType.payments;
  for (final type in AppReportType.values) {
    if (type.wireName == key || type.name.toLowerCase() == key) {
      return type;
    }
  }
  return null;
}
