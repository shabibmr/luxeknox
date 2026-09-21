import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../attendance_strings.dart';
import '../cubit/attendance_history_cubit.dart';

class AttendanceSummaryScreen extends StatelessWidget {
  const AttendanceSummaryScreen({super.key, this.memberId});

  final String? memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<AttendanceSummaryCubit>()..load(memberId: memberId),
      child: _AttendanceSummaryBody(memberId: memberId),
    );
  }
}

class _AttendanceSummaryBody extends StatelessWidget {
  const _AttendanceSummaryBody({this.memberId});

  final String? memberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AttendanceStrings.summaryTitle)),
      body: BlocBuilder<AttendanceSummaryCubit, AttendanceSummaryState>(
        builder: (context, state) {
          return switch (state) {
            AttendanceSummaryLoading() => const AppLoading(),
            AttendanceSummaryFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context
                  .read<AttendanceSummaryCubit>()
                  .load(memberId: memberId),
            ),
            AttendanceSummaryLoaded(:final summary, :final heatmapDays) =>
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _StatTile(
                    label: AttendanceStrings.streak,
                    value: '${summary.streakDays ?? 0}',
                  ),
                  _StatTile(
                    label: AttendanceStrings.visitsMonth,
                    value: '${summary.visitsThisMonth ?? 0}',
                  ),
                  _StatTile(
                    label: AttendanceStrings.lastCheckIn,
                    value: summary.lastCheckIn?.toString() ?? '—',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AttendanceStrings.heatmap,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _HeatmapGrid(days: heatmapDays),
                ],
              ),
          };
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _HeatmapGrid extends StatelessWidget {
  const _HeatmapGrid({required this.days});

  final Set<DateTime> days;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 55));
    final cells = <Widget>[];
    for (var i = 0; i < 56; i++) {
      final day = start.add(Duration(days: i));
      final key = DateTime(day.year, day.month, day.day);
      final active = days.contains(key);
      cells.add(
        Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: active
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }
    return Wrap(children: cells);
  }
}
