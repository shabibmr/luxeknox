/// UI strings for the Exercise Library feature.
abstract final class ExerciseStrings {
  static const libraryTitle = 'Exercise Library';
  static const detailsTitle = 'Exercise Details';
  static const formTitle = 'Exercise';
  static const addTitle = 'Add Exercise';
  static const editTitle = 'Edit Exercise';
  static const selectExercise = 'Select an exercise to view details';
  static const retry = 'Retry';
  static const noneFound = 'No exercises found.';
  static const deactivateTitle = 'Deactivate exercise';
  static String deactivateConfirm(String name) =>
      'Deactivate "$name"? It will no longer appear in the active library.';
  static const cancel = 'Cancel';
  static const deactivate = 'Deactivate';
  static const noPermission = 'You do not have permission to view this page.';
  static const active = 'Active';
  static const activeSubtitle =
      'Inactive exercises are hidden from Member/Trainer browsing';
  static const instructions = 'Instructions';
  static const secondaryMuscles = 'Secondary muscles';
  static const equipment = 'Equipment';
  static const noEquipment = 'No equipment needed';
  static const noEquipmentShort = 'No equipment';
  static const videoOpenFailed = 'Could not open the video link.';
  static const watchVideo = 'Watch video';
  static const clearAll = 'Clear all';
  static const applyFilters = 'Apply filters';
  static const filterTitle = 'Filter exercises';
  static const muscleGroup = 'Muscle group';
  static const difficulty = 'Difficulty';
  static const addTooltip = 'Add exercise';
  static const editTooltip = 'Edit exercise';
  static const deactivateTooltip = 'Deactivate';
  static const filterTooltip = 'Filter';
  static const searchHint = 'Search exercises';
  static const nameLabel = 'Name';
  static const nameRequired = 'Enter a name.';
  static const primaryMuscleLabel = 'Primary muscle group';
  static const primaryMuscleRequired = 'Enter a primary muscle group.';
  static const secondaryMusclesLabel = 'Secondary muscles';
  static const equipmentNeededLabel = 'Equipment needed';
  static const commaSeparatedHelper = 'Comma-separated';
  static const difficultyLabel = 'Difficulty level';
  static const difficultyRequired = 'Enter a difficulty level.';
  static const instructionsLabel = 'Instructions';
  static const instructionsRequired = 'Enter instructions.';
  static const videoUrlLabel = 'Video URL (optional)';
  static const gifUrlLabel = 'Gif URL (optional)';
  static const saveChanges = 'Save changes';
  static const createExercise = 'Create exercise';
  static const noMedia = 'No media available.';
  static const previewUnavailable = 'Preview unavailable.';
}
