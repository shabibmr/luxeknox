import '../../../../core/widgets/app_chart_types.dart';
import '../../domain/entities/app_report_type.dart';

/// A single renderable chart block within a [ReportChartSection].
sealed class ReportChartBlock {
  const ReportChartBlock(this.title);

  final String title;
}

class BarChartBlock extends ReportChartBlock {
  const BarChartBlock(super.title, this.points);

  final List<AppChartPoint> points;
}

class LineChartBlock extends ReportChartBlock {
  const LineChartBlock(super.title, this.series);

  final List<AppLineSeries> series;
}

class HeatmapChartBlock extends ReportChartBlock {
  const HeatmapChartBlock(
    super.title,
    this.values,
    this.rowLabels,
    this.colLabels,
  );

  final List<List<double>> values;
  final List<String> rowLabels;
  final List<String> colLabels;
}

double _numeric(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) {
    return double.tryParse(value.replaceAll('%', '').trim()) ?? 0;
  }
  return 0;
}

String _string(dynamic value) => value?.toString() ?? '';

List<Map<String, dynamic>> _byCategory(
  List<Map<String, dynamic>> rows,
  String category,
) {
  return rows.where((r) => r['category'] == category).toList();
}

/// Reads the `count`/`value` field of the row whose `metric` equals [name],
/// or 0 if no such row exists. Written as a plain loop (rather than
/// `firstWhere(orElse: ...)`) to sidestep generic-type mismatches when the
/// caller's row maps are reified as a subtype of `Map<String, dynamic>`.
double _metric(List<Map<String, dynamic>> rows, String name) {
  for (final row in rows) {
    if (row['metric'] == name) {
      return _numeric(row['count'] ?? row['value']);
    }
  }
  return 0;
}

/// Builds the chart blocks available for a report [type] given its raw
/// [rows]. Report row shapes vary by type (see `ReportsRepository` on the
/// API); this only reads fields that exist for that type and returns an
/// empty list when the report has no chartable data (e.g. payments, which
/// is blocked pending the financial-charts vertical).
List<ReportChartBlock> buildReportChartBlocks(
  AppReportType type,
  List<Map<String, dynamic>> rows,
) {
  return switch (type) {
    AppReportType.attendance => _attendanceBlocks(rows),
    AppReportType.members => _membersBlocks(rows),
    AppReportType.memberships => _membershipsBlocks(rows),
    AppReportType.trainers ||
    AppReportType.trainerOwn => _trainersBlocks(rows),
    AppReportType.workouts => _workoutsBlocks(rows),
    AppReportType.diets => _dietsBlocks(rows),
    AppReportType.progress => _progressBlocks(rows),
    AppReportType.payments => const [],
  };
}

List<ReportChartBlock> _attendanceBlocks(List<Map<String, dynamic>> rows) {
  final hourly = _byCategory(rows, 'peak_hour_heatmap')
    ..sort((a, b) => _numeric(a['hour']).compareTo(_numeric(b['hour'])));
  if (hourly.isEmpty) return const [];

  final bars = [
    for (final row in hourly)
      AppChartPoint(
        label: _numeric(row['hour']).toInt().toString().padLeft(2, '0'),
        value: _numeric(row['checkin_count']),
      ),
  ];

  // The backend does not currently bucket check-ins by weekday, so the
  // heatmap collapses to a single "All days" row across the 24 hourly
  // columns rather than a true weekday x hour grid.
  return [
    HeatmapChartBlock(
      'Check-ins by hour',
      [bars.map((p) => p.value).toList()],
      const ['All days'],
      [for (final p in bars) p.label],
    ),
    BarChartBlock('Check-ins by hour', bars),
  ];
}

List<ReportChartBlock> _membersBlocks(List<Map<String, dynamic>> rows) {
  final summary = _byCategory(rows, 'summary');
  if (summary.isEmpty) return const [];

  final bars = [
    AppChartPoint(label: 'New', value: _metric(summary, 'acquisition_new_members')),
    AppChartPoint(label: 'Active', value: _metric(summary, 'active_members')),
    AppChartPoint(label: 'Inactive', value: _metric(summary, 'inactive_members')),
    AppChartPoint(label: 'Suspended', value: _metric(summary, 'suspended_members')),
    AppChartPoint(label: 'Churned', value: _metric(summary, 'churned_members')),
  ];

  return [BarChartBlock('Members by status', bars)];
}

List<ReportChartBlock> _membershipsBlocks(List<Map<String, dynamic>> rows) {
  final packageMix = _byCategory(rows, 'package_mix');
  final summary = _byCategory(rows, 'summary');

  final blocks = <ReportChartBlock>[];

  if (packageMix.isNotEmpty) {
    blocks.add(
      BarChartBlock('Purchases by product', [
        for (final row in packageMix)
          AppChartPoint(
            label: _string(row['product_name']),
            value: _numeric(row['total_purchased']),
          ),
      ]),
    );
  }

  if (summary.isNotEmpty) {
    blocks.add(
      BarChartBlock('Renewals vs freezes', [
        AppChartPoint(label: 'Renewals', value: _metric(summary, 'total_renewals')),
        AppChartPoint(label: 'Freezes', value: _metric(summary, 'total_freezes')),
      ]),
    );
  }

  return blocks;
}

List<ReportChartBlock> _trainersBlocks(List<Map<String, dynamic>> rows) {
  if (rows.isEmpty || !rows.first.containsKey('trainer_name')) return const [];

  return [
    BarChartBlock('Sessions delivered', [
      for (final row in rows)
        AppChartPoint(
          label: _string(row['trainer_name']),
          value: _numeric(row['sessions_delivered']),
        ),
    ]),
    BarChartBlock('Assigned clients', [
      for (final row in rows)
        AppChartPoint(
          label: _string(row['trainer_name']),
          value: _numeric(row['assigned_members']),
        ),
    ]),
  ];
}

List<ReportChartBlock> _workoutsBlocks(List<Map<String, dynamic>> rows) {
  final topPlans = _byCategory(rows, 'top_workout_plans');
  final topExercises = _byCategory(rows, 'top_exercises');

  final blocks = <ReportChartBlock>[];
  if (topPlans.isNotEmpty) {
    blocks.add(
      BarChartBlock('Most assigned plans', [
        for (final row in topPlans)
          AppChartPoint(
            label: _string(row['plan_title']),
            value: _numeric(row['assigned_count']),
          ),
      ]),
    );
  }
  if (topExercises.isNotEmpty) {
    blocks.add(
      BarChartBlock('Most logged exercises', [
        for (final row in topExercises)
          AppChartPoint(
            label: _string(row['exercise_name']),
            value: _numeric(row['logged_sets']),
          ),
      ]),
    );
  }
  return blocks;
}

List<ReportChartBlock> _dietsBlocks(List<Map<String, dynamic>> rows) {
  final summary = _byCategory(rows, 'summary');
  if (summary.isEmpty) return const [];

  return [
    BarChartBlock('Food library', [
      AppChartPoint(label: 'Active foods', value: _metric(summary, 'active_foods_in_library')),
      AppChartPoint(label: 'Verified foods', value: _metric(summary, 'verified_foods')),
    ]),
  ];
}

List<ReportChartBlock> _progressBlocks(List<Map<String, dynamic>> rows) {
  final summary = _byCategory(rows, 'summary');
  if (summary.isEmpty) return const [];

  return [
    BarChartBlock('Progress activity', [
      AppChartPoint(label: 'Goals achieved', value: _metric(summary, 'goals_achieved')),
      AppChartPoint(label: 'Measurements logged', value: _metric(summary, 'measurement_sessions')),
      AppChartPoint(label: 'Photos uploaded', value: _metric(summary, 'progress_photos_uploaded')),
    ]),
  ];
}
