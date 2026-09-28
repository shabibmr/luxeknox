import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/diet_adherence.dart';
import '../../domain/entities/diet_log.dart';
import '../cubit/diet_history_cubit.dart';
import '../diet_history_role.dart';
import '../diet_strings.dart';

class DietHistoryScreen extends StatelessWidget {
  const DietHistoryScreen({
    super.key,
    required this.role,
    this.memberId,
  });

  final DietHistoryRole role;
  final String? memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DietHistoryCubit>()..load(memberId: memberId),
      child: _DietHistoryBody(role: role, memberId: memberId),
    );
  }
}

class _DietHistoryBody extends StatelessWidget {
  const _DietHistoryBody({required this.role, this.memberId});

  final DietHistoryRole role;
  final String? memberId;

  String get _title => switch (role) {
    DietHistoryRole.admin => DietStrings.historyTitleAdmin,
    DietHistoryRole.member => DietStrings.historyTitleMember,
    DietHistoryRole.trainer => DietStrings.historyTitleTrainer,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          if (role == DietHistoryRole.member)
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text(DietStrings.logToday),
              onPressed: () => context.push(Routes.memberHomeDietLog),
            ),
        ],
      ),
      body: BlocBuilder<DietHistoryCubit, DietHistoryState>(
        builder: (context, state) {
          final showData =
              state.status == LoadStatus.success || state.logs.isNotEmpty;
          if (state.status == LoadStatus.loading && !showData) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && !showData) {
            return AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () =>
                  context.read<DietHistoryCubit>().load(memberId: memberId),
            );
          }
          final logs = state.logs;
          final selectedRange = state.selectedRange;
          final averageAdherenceScore = state.averageAdherenceScore;
          final averageCaloriesConsumed = state.averageCaloriesConsumed;
          final averageWaterIntakeMl = state.averageWaterIntakeMl;
          final totalLoggedDays = state.totalLoggedDays;
          return Column(
                children: [
                  // Range filters
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        _RangeChip(
                          label: DietStrings.rangeAll,
                          selected: selectedRange == DietDateRange.all,
                          onSelected: () => context
                              .read<DietHistoryCubit>()
                              .setRange(DietDateRange.all),
                        ),
                        const SizedBox(width: 8),
                        _RangeChip(
                          label: DietStrings.range7Days,
                          selected: selectedRange == DietDateRange.last7Days,
                          onSelected: () => context
                              .read<DietHistoryCubit>()
                              .setRange(DietDateRange.last7Days),
                        ),
                        const SizedBox(width: 8),
                        _RangeChip(
                          label: DietStrings.range30Days,
                          selected: selectedRange == DietDateRange.last30Days,
                          onSelected: () => context
                              .read<DietHistoryCubit>()
                              .setRange(DietDateRange.last30Days),
                        ),
                      ],
                    ),
                  ),

                  // Compliance / Metric summary card
                  if (logs.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _SummaryMetric(
                                label: DietStrings.averageAdherenceLabel,
                                value: averageAdherenceScore != null
                                    ? DietStrings.adherencePercent(averageAdherenceScore)
                                    : '—',
                                color: averageAdherenceScore != null
                                    ? (averageAdherenceScore >= 85
                                        ? Colors.green
                                        : averageAdherenceScore >= 70
                                            ? Colors.orange
                                            : Colors.red)
                                    : null,
                              ),
                              _SummaryMetric(
                                label: DietStrings.averageCaloriesLabel,
                                value: averageCaloriesConsumed != null
                                    ? DietStrings.caloriesKcal(averageCaloriesConsumed)
                                    : '—',
                              ),
                              _SummaryMetric(
                                label: DietStrings.averageWaterLabel,
                                value: averageWaterIntakeMl != null
                                    ? DietStrings.waterMl(averageWaterIntakeMl)
                                    : '—',
                                color: Colors.blue,
                              ),
                              _SummaryMetric(
                                label: DietStrings.daysLoggedLabel,
                                value: '$totalLoggedDays',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Logs list
                  Expanded(
                    child: logs.isEmpty
                        ? const AppEmptyView(message: DietStrings.historyEmpty)
                        : RefreshIndicator(
                            onRefresh: () => context
                                .read<DietHistoryCubit>()
                                .load(memberId: memberId, range: selectedRange),
                            child: ListView.builder(
                              itemCount: logs.length,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              itemBuilder: (context, index) {
                                return _DailyLogTile(
                                  log: logs[index],
                                  isReviewMode: role != DietHistoryRole.member,
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );
        },
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  const _RangeChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: theme.textTheme.labelSmall),
      ],
    );
  }
}

class _DailyLogTile extends StatelessWidget {
  const _DailyLogTile({
    required this.log,
    required this.isReviewMode,
  });

  final DietLog log;
  final bool isReviewMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat.yMMMMd().format(log.loggedDate);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    dateStr,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (log.adherenceScore != null)
                  _AdherenceRatingChip(score: log.adherenceScore!),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (log.totalCaloriesConsumed != null) ...[
                  const Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    DietStrings.caloriesKcal(log.totalCaloriesConsumed!),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                ],
                if (log.waterIntakeMl != null && log.waterIntakeMl! > 0) ...[
                  const Icon(Icons.water_drop, size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    DietStrings.waterMl(log.waterIntakeMl!),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
            if (log.memberNotes != null && log.memberNotes!.isNotEmpty) ...[
              const Divider(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      log.memberNotes!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AdherenceRatingChip extends StatelessWidget {
  const _AdherenceRatingChip({required this.score});

  final num score;

  @override
  Widget build(BuildContext context) {
    final rating = DietAdherenceRating.fromScore(score);
    final (color, label) = switch (rating) {
      DietAdherenceRating.onTarget => (Colors.green, DietStrings.complianceOnTarget),
      DietAdherenceRating.moderate => (Colors.orange, DietStrings.complianceModerate),
      DietAdherenceRating.offTarget => (Colors.red, DietStrings.complianceOffTarget),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '${DietStrings.adherencePercent(score)} · $label',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
