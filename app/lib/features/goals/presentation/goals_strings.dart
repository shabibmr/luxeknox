import '../domain/entities/goal_metric_category.dart';
import '../domain/entities/goal_status.dart';
import '../domain/entities/photo_pose.dart';
import '../domain/entities/progress_note_type.dart';

abstract final class GoalsStrings {
  static const hubTitle = 'Progress';
  static const goalsSection = 'Goals';
  static const noneGoals = 'No goals yet.';
  static const retry = 'Retry';
  static const save = 'Save';
  static const cancel = 'Cancel';
  static const delete = 'Delete';
  static const edit = 'Edit';
  static const create = 'Create';
  static const add = 'Add';

  static const measurementsLink = 'Measurements';
  static const photosLink = 'Progress photos';
  static const notesLink = 'Notes';
  static const chartsLink = 'Charts';

  static const goalDetailTitle = 'Goal';
  static const checkInTitle = 'Check in';
  static const checkInValueLabel = 'Recorded value';
  static const checkInDateLabel = 'Date';
  static const checkInNotesLabel = 'Notes';
  static const checkInSubmit = 'Submit check-in';
  static const checkInSaved = 'Check-in recorded';
  static const checkInFailed = 'Could not record check-in';
  static const baselineLabel = 'Baseline';
  static const targetLabel = 'Target';
  static const currentLabel = 'Current';
  static const startDateLabel = 'Start date';
  static const targetDateLabel = 'Target date';
  static const statusLabel = 'Status';
  static const metricLabel = 'Metric';
  static const progressLabel = 'Progress';

  static const goalFormCreateTitle = 'Create goal';
  static const goalFormEditTitle = 'Edit goal';
  static const goalSaved = 'Goal saved';
  static const goalSaveFailed = 'Could not save goal';
  static const metricRequired = 'Select a metric';
  static const pickMetric = 'Choose metric';

  static const statusInProgress = 'In progress';
  static const statusAchieved = 'Achieved';
  static const statusAbandoned = 'Abandoned';

  static const measurementsTitle = 'Measurements';
  static const measurementsEmpty = 'No measurement sessions yet.';
  static const addMeasurement = 'Add measurement';
  static const measurementNotesLabel = 'Session notes';
  static const measurementSaved = 'Measurement saved';
  static const measurementSaveFailed = 'Could not save measurement';
  static const mandatoryMissing = 'Mandatory metrics are required';
  static const chartsSection = 'Trends';
  static const chartsEmpty = 'Not enough data to chart yet.';
  static const valueLabel = 'Value';
  static const recordedAtLabel = 'Recorded at';

  static const metricsAdminTitle = 'Goal metrics';
  static const metricsEmpty = 'No metrics defined.';
  static const metricNameLabel = 'Name';
  static const metricUnitLabel = 'Unit';
  static const metricCategoryLabel = 'Category';
  static const metricActiveLabel = 'Active';
  static const metricNameRequired = 'Name is required';
  static const metricUnitRequired = 'Unit is required';
  static const metricSaved = 'Metric saved';
  static const metricSaveFailed = 'Could not save metric';
  static const createMetric = 'Create metric';
  static const editMetric = 'Edit metric';

  static const categoryBodyComposition = 'Body composition';
  static const categoryCircumference = 'Circumference';
  static const categoryStrength = 'Strength';

  static const unitKg = 'kg';
  static const unitLbs = 'lbs';
  static const unitCm = 'cm';
  static const unitIn = 'in';
  static const unitPercent = '%';

  static const photosTitle = 'Progress photos';
  static const photosEmpty = 'No progress photos yet.';
  static const addPhoto = 'Add photo';
  static const photoUrlLabel = 'Photo URL';
  static const photoUrlRequired = 'Photo URL is required';
  static const poseLabel = 'Pose';
  static const takenDateLabel = 'Taken date';
  static const privateLabel = 'Private';
  static const photoSaved = 'Photo saved';
  static const photoSaveFailed = 'Could not save photo';
  static const photoDeleted = 'Photo deleted';
  static const compareTitle = 'Compare';
  static const compareMode = 'Comparison';
  static const compareDateA = 'Date A';
  static const compareDateB = 'Date B';
  static const comparePose = 'Pose';
  static const compareEmpty = 'Pick two dates with photos for this pose.';
  static const poseFront = 'Front';
  static const poseSide = 'Side';
  static const poseBack = 'Back';

  static const notesTitle = 'Progress notes';
  static const notesEmpty = 'No notes yet.';
  static const composeNote = 'Add note';
  static const noteTextLabel = 'Note';
  static const noteTextRequired = 'Note text is required';
  static const noteSaved = 'Note saved';
  static const noteSaveFailed = 'Could not save note';
  static const noteTypeMember = 'Member note';
  static const noteTypeTrainer = 'Trainer assessment';

  static String statusLabelFor(GoalStatus status) => switch (status) {
    GoalStatus.inProgress => statusInProgress,
    GoalStatus.achieved => statusAchieved,
    GoalStatus.abandoned => statusAbandoned,
  };

  static String categoryLabelFor(GoalMetricCategory category) =>
      switch (category) {
        GoalMetricCategory.bodyComposition => categoryBodyComposition,
        GoalMetricCategory.circumference => categoryCircumference,
        GoalMetricCategory.strength => categoryStrength,
      };

  static String poseLabelFor(PhotoPose pose) => switch (pose) {
    PhotoPose.front => poseFront,
    PhotoPose.side => poseSide,
    PhotoPose.back => poseBack,
  };

  static String noteTypeLabelFor(ProgressNoteType type) => switch (type) {
    ProgressNoteType.memberNote => noteTypeMember,
    ProgressNoteType.trainerAssessment => noteTypeTrainer,
  };

  static String percentLabel(double fraction) =>
      '${(fraction * 100).round()}%';
}
