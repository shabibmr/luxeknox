import 'dart:ui';

/// A single labeled value used by [AppBarChart].
class AppChartPoint {
  const AppChartPoint({required this.label, required this.value});

  final String label;
  final double value;
}

/// A named series of (x, y) values used by [AppLineChart]. `points.dx` is
/// the shared x-axis value (an index, a timestamp in millis, etc.) and
/// `points.dy` is the series value at that point.
class AppLineSeries {
  const AppLineSeries({required this.name, required this.points, this.color});

  final String name;
  final List<Offset> points;
  final Color? color;
}
