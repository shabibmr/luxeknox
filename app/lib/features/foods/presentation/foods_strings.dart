/// UI strings for the Food Library feature.
abstract final class FoodStrings {
  static const libraryTitle = 'Food Library';
  static const detailsTitle = 'Food Details';
  static const formTitle = 'Food';
  static const addTitle = 'Add Food';
  static const editTitle = 'Edit Food';
  static const selectFood = 'Select a food to view details';
  static const retry = 'Retry';
  static const noneFound = 'No foods found.';
  static const deactivateTitle = 'Deactivate food';
  static String deactivateConfirm(String name) =>
      'Deactivate "$name"? It will no longer appear in the active library.';
  static const cancel = 'Cancel';
  static const deactivate = 'Deactivate';
  static const noPermission = 'You do not have permission to view this page.';
  static const verified = 'Verified';
  static const verifiedSubtitle = 'Unverified foods are flagged for review';
  static const clearAll = 'Clear all';
  static const applyFilters = 'Apply filters';
  static const filterTitle = 'Filter foods';
  static const verifiedOnly = 'Verified only';
  static const addTooltip = 'Add food';
  static const editTooltip = 'Edit food';
  static const deactivateTooltip = 'Deactivate';
  static const filterTooltip = 'Filter';
  static const searchHint = 'Search foods';
  static const nameLabel = 'Name';
  static const nameRequired = 'Enter a name.';
  static const servingUnitLabel = 'Serving unit';
  static const servingUnitRequired = 'Enter a serving unit.';
  static const servingSizeLabel = 'Serving size';
  static const caloriesLabel = 'Calories';
  static const proteinLabel = 'Protein (g)';
  static const carbsLabel = 'Carbs (g)';
  static const fatLabel = 'Fat (g)';
  static const fiberLabel = 'Fiber (g)';
  static const numericInvalid = 'Enter a valid number.';
  static const saveChanges = 'Save changes';
  static const createFood = 'Create food';
  static const nutrition = 'Nutrition';
  static const macroBreakdown = 'Macro breakdown';
  static const protein = 'Protein';
  static const carbs = 'Carbs';
  static const fat = 'Fat';
  static const noMacroData = 'No macro data available.';
}
