import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/goal_metric.dart';
import '../cubit/goal_metrics_admin_cubit.dart';
import '../goals_strings.dart';
import '../widgets/goal_metric_editor_dialog.dart';

class GoalMetricsAdminScreen extends StatelessWidget {
  const GoalMetricsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GoalMetricsAdminCubit>()..load(),
      child: const _GoalMetricsAdminBody(),
    );
  }
}

class _GoalMetricsAdminBody extends StatelessWidget {
  const _GoalMetricsAdminBody();

  Future<void> _openForm(BuildContext context, {GoalMetric? existing}) async {
    final saved = await showGoalMetricEditorDialog(context, existing: existing);
    if (saved == null || !context.mounted) return;
    await context.read<GoalMetricsAdminCubit>().load();
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(GoalsStrings.metricSaved)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(GoalsStrings.metricsAdminTitle)),
      floatingActionButton: FloatingActionButton(
        tooltip: GoalsStrings.createMetric,
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<GoalMetricsAdminCubit, GoalMetricsAdminState>(
        listener: (context, state) {
          final showData =
              state.status == LoadStatus.success || state.items.isNotEmpty;
          if (state.failure != null && showData) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failureMessage(state.failure!))),
            );
          }
        },
        builder: (context, state) {
          final showData =
              state.status == LoadStatus.success || state.items.isNotEmpty;
          if (state.status == LoadStatus.loading && !showData) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && !showData) {
            return AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () => context.read<GoalMetricsAdminCubit>().load(),
            );
          }
          final items = state.items;
          return items.isEmpty
              ? const AppEmptyView(message: GoalsStrings.metricsEmpty)
              : ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final m = items[index];
                    return ListTile(
                      title: Text(m.name),
                      subtitle: Text(
                        '${m.unitOfMeasure} · ${GoalsStrings.categoryLabelFor(m.category)}'
                        '${m.isActive ? '' : ' · inactive'}',
                      ),
                      trailing: const Icon(Icons.edit_outlined),
                      onTap: () => _openForm(context, existing: m),
                    );
                  },
                );
        },
      ),
    );
  }
}
