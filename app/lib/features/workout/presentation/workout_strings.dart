import '../domain/entities/workout_plan_status.dart';

abstract final class WorkoutStrings {
  static const listTitle = 'Workout plans';
  static const detailTitle = 'Workout plan';
  static const createTitle = 'Create workout plan';
  static const editTitle = 'Edit workout plan';

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
}
