import '../domain/entities/workout_plan_status.dart';

abstract final class WorkoutStrings {
  static const listTitle = 'Workout plans';
  static const detailTitle = 'Workout plan';
  static const createTitle = 'Create workout plan';
  static const editTitle = 'Edit workout plan';
  static const versionsTitle = 'Plan versions';
  static const activeTitle = 'Active workout';

  static const noneFound = 'No workout plans yet.';
  static const retry = 'Retry';
  static const save = 'Save';
  static const publish = 'Publish';
  static const archive = 'Archive';
  static const edit = 'Edit';
  static const addExercise = 'Add exercise';
  static const searchExercises = 'Search exercises';
  static const noExercises = 'No exercises match.';
  static const dayLabel = 'Day';
  static const moveToDay = 'Move to day';
  static const remove = 'Remove';
  static const titleLabel = 'Title';
  static const titleRequired = 'Title is required';
  static const descriptionLabel = 'Description';
  static const targetGoalLabel = 'Target goal';
  static const difficultyLabel = 'Difficulty';
  static const durationWeeksLabel = 'Duration (weeks)';
  static const isTemplateLabel = 'Template';
  static const memberIdLabel = 'Member ID';
  static const exercisesSection = 'Exercises';
  static const emptyDay = 'No exercises on this day.';
  static const saved = 'Plan saved';
  static const published = 'Plan published';
  static const archived = 'Plan archived';
  static const saveFailed = 'Could not save plan';
  static const actionFailed = 'Action failed';

  static const filterAll = 'All';
  static const filterDraft = 'Draft';
  static const filterActive = 'Active';
  static const filterArchived = 'Archived';

  static const statusDraft = 'Draft';
  static const statusActive = 'Active';
  static const statusArchived = 'Archived';

  static const setsLabel = 'Sets';
  static const repsLabel = 'Reps';
  static const weightLabel = 'Weight (kg)';
  static const restLabel = 'Rest (s)';
  static const rpeLabel = 'RPE';

  static const assignToMember = 'Assign to member';
  static const assignDialogTitle = 'Assign template';
  static const assignDialogHint = 'Member profile ID';
  static const assignConfirm = 'Assign';
  static const assignCancel = 'Cancel';
  static const assigned = 'Template assigned';
  static const viewVersions = 'Versions';
  static const noVersions = 'No versions yet.';
  static const versionExercises = 'exercises';
  static const changelogEmpty = 'No changelog';

  static const startSession = 'Start workout';
  static const startEmptySession = 'Start empty session';
  static const planIdLabel = 'Workout plan ID (optional)';
  static const exerciseIdLabel = 'Exercise ID';
  static const logSet = 'Log set';
  static const completeSession = 'Complete workout';
  static const completeConfirmTitle = 'Complete workout?';
  static const completeConfirmMessage =
      'Finish this session and save your logged sets.';
  static const completeConfirmCancel = 'Cancel';
  static const completeConfirmAction = 'Complete';
  static const notesLabel = 'Notes (optional)';
  static const ratingLabel = 'How was this workout?';
  static const sessionCompleted = 'Workout complete';
  static const missingMember = 'Sign in required to start a workout.';
  static const restTimer = 'Rest';
  static const restSkip = 'Skip';
  static const restCancel = 'Cancel';
  static const restAdd15 = '+15s';
  static const loggedSetsSection = 'Logged sets';
  static const freeFormHint = 'Enter an exercise ID to log sets.';
  static const durationLabel = 'Duration';
  static const volumeLabel = 'Volume';
  static const setsLoggedLabel = 'Sets logged';
  static const startedAtLabel = 'Started';
  static const completedAtLabel = 'Completed';
  static const startAnother = 'Start another';
  static const viewHistory = 'View workout history';

  static const historyTitleMember = 'Workout history';
  static const historyTitleTrainer = 'Client workout history';
  static const historyTitleAdmin = 'Member workout history';
  static const historyEmpty = 'No workout sessions yet.';
  static const personalRecordsSection = 'Personal records';
  static const historyInProgress = 'In progress';

  static String historyDuration(int minutes) => '$minutes min';

  static String historyVolume(num kg) => '${kg}kg volume';

  static String historyTotalVolume(num kg) => 'Total volume: ${kg}kg';

  static String personalRecordChip({
    required String exerciseId,
    required num maxKg,
  }) => 'Exercise $exerciseId · ${maxKg}kg';

  static String dayHeader(int day) => 'Day $day';

  static String statusLabel(WorkoutPlanStatus status) => switch (status) {
    WorkoutPlanStatus.draft => statusDraft,
    WorkoutPlanStatus.active => statusActive,
    WorkoutPlanStatus.archived => statusArchived,
  };

  static String exerciseSubtitle({
    int? sets,
    String? reps,
  }) {
    final parts = <String>[];
    if (sets != null) parts.add('$sets sets');
    if (reps != null && reps.isNotEmpty) parts.add('$reps reps');
    return parts.isEmpty ? '' : parts.join(' · ');
  }

  static String versionTitle(int number) => 'Version $number';

  static String restRemaining(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    if (m == 0) return '${s}s';
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  static String setLoggedLine({
    required int setNumber,
    int? reps,
    num? weight,
  }) {
    final parts = <String>['Set $setNumber'];
    if (reps != null) parts.add('$reps reps');
    if (weight != null) parts.add('${weight}kg');
    return parts.join(' · ');
  }

  static String durationMinutes(int minutes) => '$minutes min';

  static String volumeKg(num kg) => '$kg kg';

  static String setsLoggedCount(int count) => '$count';

  static String sessionTime(DateTime value) {
    final local = value.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.year}-${two(local.month)}-${two(local.day)} '
        '${two(local.hour)}:${two(local.minute)}';
  }
}
