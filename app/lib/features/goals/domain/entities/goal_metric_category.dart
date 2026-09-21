enum GoalMetricCategory {
  bodyComposition,
  circumference,
  strength;

  static GoalMetricCategory fromWire(String? value) {
    return switch (value) {
      'body_composition' || 'bodyComposition' =>
        GoalMetricCategory.bodyComposition,
      'circumference' => GoalMetricCategory.circumference,
      'strength' => GoalMetricCategory.strength,
      _ => GoalMetricCategory.bodyComposition,
    };
  }

  String get wire => switch (this) {
    GoalMetricCategory.bodyComposition => 'body_composition',
    GoalMetricCategory.circumference => 'circumference',
    GoalMetricCategory.strength => 'strength',
  };
}
