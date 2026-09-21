import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/diet_plan_version.dart';
import '../cubit/diet_plan_versions_cubit.dart';
import '../diet_strings.dart';

class DietPlanVersionsScreen extends StatelessWidget {
  const DietPlanVersionsScreen({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DietPlanVersionsCubit>()..load(planId),
      child: _VersionsBody(planId: planId),
    );
  }
}

class _VersionsBody extends StatelessWidget {
  const _VersionsBody({required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(DietStrings.versionsTitle)),
      body: BlocBuilder<DietPlanVersionsCubit, DietPlanVersionsState>(
        builder: (context, state) {
          return switch (state) {
            DietPlanVersionsLoading() => const AppLoading(),
            DietPlanVersionsFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () =>
                  context.read<DietPlanVersionsCubit>().load(planId),
            ),
            DietPlanVersionsLoaded(:final versions, :final expandedId) =>
              versions.isEmpty
                  ? const Center(child: Text(DietStrings.noVersions))
                  : ListView.builder(
                      itemCount: versions.length,
                      itemBuilder: (context, index) {
                        final v = versions[index];
                        return _DietVersionTile(
                          version: v,
                          expanded: expandedId == v.id,
                          onTap: () => context
                              .read<DietPlanVersionsCubit>()
                              .toggleExpanded(v.id),
                        );
                      },
                    ),
          };
        },
      ),
    );
  }
}

class _DietVersionTile extends StatelessWidget {
  const _DietVersionTile({
    required this.version,
    required this.expanded,
    required this.onTap,
  });

  final DietPlanVersion version;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = version.createdAt;
    final subtitle = [
      if (version.changelog != null && version.changelog!.isNotEmpty)
        version.changelog!
      else
        DietStrings.changelogEmpty,
      if (date != null) date.toLocal().toString().split('.').first,
      '${version.meals.length} ${DietStrings.versionMeals}',
    ].join(' · ');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      DietStrings.versionTitle(version.versionNumber),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: theme.textTheme.bodySmall),
              if (expanded) ...[
                const Divider(height: 24),
                if (version.meals.isEmpty)
                  const Text(DietStrings.emptyMeals)
                else
                  for (final meal in version.meals) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              meal.mealName,
                              style: theme.textTheme.titleSmall,
                            ),
                          ),
                          if (meal.scheduledTime != null)
                            Text(
                              meal.scheduledTime!,
                              style: theme.textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                    if (meal.foods.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          DietStrings.noFoods,
                          style: theme.textTheme.bodySmall,
                        ),
                      )
                    else
                      for (final food in meal.foods)
                        ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(left: 8),
                          title: Text(food.foodName ?? 'Food #${food.foodId}'),
                          subtitle: Text(
                            DietStrings.foodLineSubtitle(
                              quantity: food.quantity,
                              servingUnit: food.servingUnit,
                            ),
                          ),
                        ),
                  ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
