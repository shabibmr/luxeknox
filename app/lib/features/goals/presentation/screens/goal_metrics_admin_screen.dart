import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/goal_metric_category.dart';
import '../cubit/goal_metrics_admin_cubit.dart';
import '../goals_strings.dart';

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
    final nameController = TextEditingController(text: existing?.name ?? '');
    var unit = existing?.unitOfMeasure ?? GoalsStrings.unitKg;
    var category = existing?.category ?? GoalMetricCategory.bodyComposition;
    var isActive = existing?.isActive ?? true;
    const units = [
      GoalsStrings.unitKg,
      GoalsStrings.unitLbs,
      GoalsStrings.unitCm,
      GoalsStrings.unitIn,
      GoalsStrings.unitPercent,
    ];

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return AlertDialog(
              title: Text(
                existing == null
                    ? GoalsStrings.createMetric
                    : GoalsStrings.editMetric,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: GoalsStrings.metricNameLabel,
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      // ignore: deprecated_member_use
                      value: unit,
                      decoration: const InputDecoration(
                        labelText: GoalsStrings.metricUnitLabel,
                      ),
                      items: [
                        for (final u in units)
                          DropdownMenuItem(value: u, child: Text(u)),
                      ],
                      onChanged: (v) {
                        if (v != null) setLocal(() => unit = v);
                      },
                    ),
                    DropdownButtonFormField<GoalMetricCategory>(
                      // ignore: deprecated_member_use
                      value: category,
                      decoration: const InputDecoration(
                        labelText: GoalsStrings.metricCategoryLabel,
                      ),
                      items: [
                        for (final c in GoalMetricCategory.values)
                          DropdownMenuItem(
                            value: c,
                            child: Text(GoalsStrings.categoryLabelFor(c)),
                          ),
                      ],
                      onChanged: (v) {
                        if (v != null) setLocal(() => category = v);
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(GoalsStrings.metricActiveLabel),
                      value: isActive,
                      onChanged: (v) => setLocal(() => isActive = v),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text(GoalsStrings.cancel),
                ),
                FilledButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    final ok = await context.read<GoalMetricsAdminCubit>().save(
                      id: existing?.id,
                      name: name,
                      unitOfMeasure: unit,
                      category: category,
                      isActive: isActive,
                    );
                    if (ctx.mounted) Navigator.of(ctx).pop(ok);
                  },
                  child: const Text(GoalsStrings.save),
                ),
              ],
            );
          },
        );
      },
    );
    nameController.dispose();
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(GoalsStrings.metricSaved)),
      );
    }
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
          if (state is GoalMetricsAdminLoaded && state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          return switch (state) {
            GoalMetricsAdminLoading() => const AppLoading(),
            GoalMetricsAdminFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<GoalMetricsAdminCubit>().load(),
            ),
            GoalMetricsAdminLoaded(:final items) => items.isEmpty
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
                  ),
          };
        },
      ),
    );
  }
}
