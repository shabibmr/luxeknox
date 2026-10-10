import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_bar_chart.dart';
import '../../../../core/widgets/app_chart_types.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_line_chart.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/progress_overview_cubit.dart';
import '../goals_strings.dart';

class ProgressOverviewScreen extends StatelessWidget {
  const ProgressOverviewScreen({
    super.key,
    required this.memberId,
    this.isTrainerContext = false,
  });

  final String memberId;
  final bool isTrainerContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(GoalsStrings.overviewTitle)),
      body: BlocBuilder<ProgressOverviewCubit, ProgressOverviewState>(
        builder: (context, state) {
          if (state.status == LoadStatus.loading &&
              state.weightData == null &&
              state.bodyCompositionData.isEmpty &&
              state.weeklyAttendance.isEmpty) {
            return const AppLoading();
          }

          if (state.status == LoadStatus.failure &&
              state.weightData == null &&
              state.bodyCompositionData.isEmpty) {
            return AppErrorView(
              message: state.failure == null
                  ? ''
                  : failureMessage(state.failure!),
              onRetry: () => context.read<ProgressOverviewCubit>().retry(),
            );
          }

          final hasAnyData =
              (state.weightData != null && state.weightData!.points.isNotEmpty) ||
              state.bodyCompositionData.any((d) => d.points.isNotEmpty) ||
              state.circumferenceData.any((d) => d.points.isNotEmpty) ||
              state.weeklyAttendance.any((p) => p.value > 0);

          if (!hasAnyData &&
              state.bmi == null &&
              state.status == LoadStatus.success) {
            return RefreshIndicator(
              onRefresh: () => context.read<ProgressOverviewCubit>().retry(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  _buildBmiCard(context, state),
                  const SizedBox(height: 16),
                  const AppEmptyView(
                    message: GoalsStrings.chartsEmpty,
                    icon: Icons.trending_up,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<ProgressOverviewCubit>().retry(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBmiCard(context, state),
                  const SizedBox(height: 16),
                  // Weight & Attendance Section
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 600;
                      final weightCard = _buildWeightCard(context, state.weightData);
                      final attendanceCard = _buildAttendanceCard(
                        context,
                        state.weeklyAttendance,
                      );

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: weightCard),
                            const SizedBox(width: 16),
                            Expanded(child: attendanceCard),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            weightCard,
                            const SizedBox(height: 16),
                            attendanceCard,
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                // Body Composition Section
                if (state.bodyCompositionData.isNotEmpty) ...[
                  Text(
                    GoalsStrings.bodyCompositionTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  for (final item in state.bodyCompositionData) ...[
                    _buildMetricCard(context, item),
                    const SizedBox(height: 12),
                  ],
                ],

                // Circumference Section (Trainer / Admin view)
                if (state.circumferenceData.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    GoalsStrings.circumferenceTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  for (final item in state.circumferenceData) ...[
                    _buildMetricCard(context, item),
                    const SizedBox(height: 12),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    ),
  );
}

  Widget _buildBmiCard(BuildContext context, ProgressOverviewState state) {
    final theme = Theme.of(context);
    final valueText = state.bmi != null
        ? state.bmi!.toStringAsFixed(1)
        : state.heightMissing
        ? GoalsStrings.bmiHeightMissing
        : '—';
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(GoalsStrings.bmiTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              valueText,
              style: state.bmi == null
                  ? theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    )
                  : theme.textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightCard(BuildContext context, MetricChartData? data) {
    final theme = Theme.of(context);
    final metricName = data?.metric.name ?? 'Weight';
    final unit = data?.metric.unitOfMeasure ?? 'kg';
    final points = data?.points ?? const [];

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    GoalsStrings.weightTrendTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$metricName ($unit)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (points.isEmpty)
              const SizedBox(
                height: 180,
                child: AppEmptyView(
                  message: GoalsStrings.chartsEmpty,
                  icon: Icons.show_chart,
                ),
              )
            else
              AppLineChart(
                height: 180,
                series: [
                  AppLineSeries(
                    name: metricName,
                    color: theme.colorScheme.primary,
                    points: [
                      for (final p in points)
                        Offset(
                          p.recordedAt.millisecondsSinceEpoch.toDouble(),
                          p.value.toDouble(),
                        ),
                    ],
                  ),
                ],
                emptyMessage: GoalsStrings.chartsEmpty,
                xLabelFormatter: (x) => DateFormat('MMM d').format(
                  DateTime.fromMillisecondsSinceEpoch(x.round()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(
    BuildContext context,
    List<AppChartPoint> weeklyAttendance,
  ) {
    final theme = Theme.of(context);
    final totalVisits = weeklyAttendance.fold<double>(
      0,
      (sum, p) => sum + p.value,
    );

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    GoalsStrings.attendanceWeeklyTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${totalVisits.round()} visits total',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (weeklyAttendance.isEmpty || weeklyAttendance.every((p) => p.value == 0))
              const SizedBox(
                height: 180,
                child: AppEmptyView(
                  message: 'No visits recorded in this period',
                  icon: Icons.calendar_today,
                ),
              )
            else
              AppBarChart(
                height: 180,
                data: weeklyAttendance,
                barColor: theme.colorScheme.tertiary,
                emptyMessage: 'No visits recorded',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, MetricChartData item) {
    final theme = Theme.of(context);
    final metricName = item.metric.name;
    final unit = item.metric.unitOfMeasure;
    final points = item.points;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    metricName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  unit,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (points.isEmpty)
              const SizedBox(
                height: 140,
                child: AppEmptyView(
                  message: GoalsStrings.chartsEmpty,
                  icon: Icons.show_chart,
                ),
              )
            else
              AppLineChart(
                height: 140,
                series: [
                  AppLineSeries(
                    name: metricName,
                    color: theme.colorScheme.secondary,
                    points: [
                      for (final p in points)
                        Offset(
                          p.recordedAt.millisecondsSinceEpoch.toDouble(),
                          p.value.toDouble(),
                        ),
                    ],
                  ),
                ],
                emptyMessage: GoalsStrings.chartsEmpty,
                xLabelFormatter: (x) => DateFormat('MMM d').format(
                  DateTime.fromMillisecondsSinceEpoch(x.round()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
