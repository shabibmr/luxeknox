import '../domain/entities/diet_plan_status.dart';

abstract final class DietStrings {
  static const listTitle = 'Diet plans';
  static const detailTitle = 'Diet plan';
  static const createTitle = 'Create diet plan';
  static const editTitle = 'Edit diet plan';

  static const noneFound = 'No diet plans yet.';
  static const retry = 'Retry';
  static const save = 'Save';
  static const edit = 'Edit';
  static const remove = 'Remove';
  static const addMeal = 'Add meal';
  static const addFood = 'Add food';
  static const searchFoods = 'Search foods';
  static const noFoods = 'No foods match.';
  static const mealsSection = 'Meals';
  static const emptyMeals = 'No meals yet.';
  static const macrosSection = 'Macros';
  static const targetsSection = 'Daily targets';
  static const saved = 'Plan saved';
  static const saveFailed = 'Could not save plan';
  static const titleLabel = 'Title';
  static const titleRequired = 'Title is required';
  static const mealNameLabel = 'Meal name';
  static const mealNameRequired = 'Meal name is required';
  static const scheduledTimeLabel = 'Scheduled time';
  static const targetCaloriesLabel = 'Target calories';
  static const notesLabel = 'Notes';
  static const quantityLabel = 'Quantity';
  static const isTemplateLabel = 'Template';
  static const memberIdLabel = 'Member ID';
  static const dailyCalorieTargetLabel = 'Daily calorie target';
  static const proteinTargetLabel = 'Protein target (g)';
  static const carbsTargetLabel = 'Carbs target (g)';
  static const fatTargetLabel = 'Fat target (g)';
  static const caloriesLabel = 'Calories';
  static const proteinLabel = 'Protein';
  static const carbsLabel = 'Carbs';
  static const fatLabel = 'Fat';
  static const noMacroData = 'No macro data yet.';

  static const filterAll = 'All';
  static const filterDraft = 'Draft';
  static const filterActive = 'Active';
  static const filterArchived = 'Archived';
  static const filterTemplates = 'Templates';

  static const statusDraft = 'Draft';
  static const statusActive = 'Active';
  static const statusArchived = 'Archived';

  // Versions & Templates
  static const versionsTitle = 'Diet plan versions';
  static const viewVersions = 'View versions';
  static const noVersions = 'No versions recorded yet.';
  static String versionTitle(int number) => 'Version $number';
  static const versionMeals = 'meals';
  static const changelogEmpty = 'No changelog provided';
  static const templateBadge = 'Template';

  // Assignment & Lifecycle Actions
  static const assignToMember = 'Assign to member';
  static const assignDialogTitle = 'Assign plan to member';
  static const assignDialogHint = 'Member ID';
  static const assignConfirm = 'Assign';
  static const assignCancel = 'Cancel';
  static const assigned = 'Plan assigned to member';
  static const publish = 'Publish';
  static const published = 'Plan published';
  static const archive = 'Archive';
  static const archived = 'Plan archived';

  // Daily Log, Adherence, Water, & Review
  static const dailyLogTitle = 'Daily diet log';
  static const historyTitleMember = 'My diet history';
  static const historyTitleTrainer = 'Client diet history';
  static const historyTitleAdmin = 'Member diet history';
  static const logToday = 'Log today';
  static const logDateLabel = 'Date';
  static const caloriesConsumedLabel = 'Calories consumed (kcal)';
  static const adherenceScoreLabel = 'Adherence score';
  static const waterIntakeLabel = 'Water intake (ml)';
  static const memberNotesLabel = 'Notes / Reflections';
  static const memberNotesHint = 'E.g. feeling energized, skipped afternoon snack...';
  static const saveLog = 'Save log';
  static const logSaved = 'Daily log saved';
  static const historyEmpty = 'No diet logs recorded yet.';
  static const summarySection = 'Compliance summary';
  static const averageAdherenceLabel = 'Avg adherence';
  static const averageCaloriesLabel = 'Avg calories';
  static const averageWaterLabel = 'Avg water';
  static const daysLoggedLabel = 'Days logged';
  static const addWater250 = '+250 ml';
  static const addWater500 = '+500 ml';
  static const resetWater = 'Reset';
  static const waterGoalLabel = 'Daily goal: 2,500 ml';
  static const complianceOnTarget = 'On target';
  static const complianceModerate = 'Moderate';
  static const complianceOffTarget = 'Off target';

  // Filters for review
  static const rangeAll = 'All';
  static const range7Days = 'Past 7 days';
  static const range30Days = 'Past 30 days';

  // Verified food visibility
  static const verifiedBadge = 'Verified';
  static const unverifiedBadge = 'Unverified';
  static const verifiedOnlyToggle = 'Verified only';

  static String statusLabel(DietPlanStatus status) => switch (status) {
    DietPlanStatus.draft => statusDraft,
    DietPlanStatus.active => statusActive,
    DietPlanStatus.archived => statusArchived,
  };

  static String foodLineSubtitle({
    required num quantity,
    String? servingUnit,
  }) {
    final unit = (servingUnit == null || servingUnit.isEmpty)
        ? ''
        : ' $servingUnit';
    return '$quantity$unit';
  }

  static String macroValue(double value, {String suffix = ''}) {
    final rounded = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
    return '$rounded$suffix';
  }

  static String adherencePercent(num score) => '${score.clamp(0, 100).toStringAsFixed(0)}%';
  static String waterMl(int ml) => '$ml ml';
  static String caloriesKcal(num calories) => '${calories.toStringAsFixed(0)} kcal';
}
