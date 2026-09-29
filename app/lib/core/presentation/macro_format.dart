/// Shared numeric formatting for macro values (calories/grams/percent)
/// across the diet and foods features.
class MacroFormat {
  const MacroFormat._();

  /// Formats a calorie/gram value, dropping the decimal when it's a whole
  /// number (e.g. `12` instead of `12.0`, but `12.5` stays as-is).
  static String grams(double value, {String suffix = ''}) {
    final rounded = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
    return '$rounded$suffix';
  }

  /// Formats a percentage of calories, rounded to the nearest whole percent.
  static String percent(double value) => '${value.toStringAsFixed(0)}%';
}
