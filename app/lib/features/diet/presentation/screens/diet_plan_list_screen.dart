import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/diet_plan_list_cubit.dart';
import '../diet_strings.dart';
import '../widgets/diet_plan_status_chip.dart';

class DietPlanListScreen extends StatelessWidget {
  const DietPlanListScreen({super.key, this.isTemplate});

  final bool? isTemplate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<DietPlanListCubit>()..load(isTemplate: isTemplate),
      child: const _DietPlanListBody(),
    );
  }
}

class _DietPlanListBody extends StatelessWidget {
  const _DietPlanListBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(DietStrings.listTitle)),
      floatingActionButton: FloatingActionButton(
        tooltip: DietStrings.createTitle,
        onPressed: () => context.push(Routes.trainerPlansDietsCreate),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: BlocBuilder<DietPlanListCubit, DietPlanListState>(
              buildWhen: (previous, next) => previous.filter != next.filter,
              builder: (context, state) {
                final filter = state.filter;
                return Wrap(
                  spacing: 8,
                  children: [
                    for (final entry in _filters)
                      ChoiceChip(
                        label: Text(entry.$2),
                        selected: filter == entry.$1,
                        onSelected: (_) => context
                            .read<DietPlanListCubit>()
                            .setFilter(entry.$1),
                      ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<DietPlanListCubit, DietPlanListState>(
              builder: (context, state) {
                final showData =
                    state.status == LoadStatus.success || state.items.isNotEmpty;
                if (state.status == LoadStatus.loading && !showData) {
                  return const AppLoading();
                }
                if (state.status == LoadStatus.failure && !showData) {
                  return AppErrorView(
                    message: failureMessage(state.failure!),
                    onRetry: () => context.read<DietPlanListCubit>().load(),
                  );
                }
                final items = state.items;
                return items.isEmpty
                      ? const AppEmptyView(message: DietStrings.noneFound)
                      : RefreshIndicator(
                          onRefresh: () =>
                              context.read<DietPlanListCubit>().load(),
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final plan = items[index];
                              final subtitle = plan.dailyCalorieTarget == null
                                  ? null
                                  : '${plan.dailyCalorieTarget} kcal/day';
                              return ListTile(
                                title: Row(
                                  children: [
                                    Expanded(child: Text(plan.title)),
                                    if (plan.isTemplate)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        margin: const EdgeInsets.only(left: 6),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          DietStrings.templateBadge,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle:
                                    subtitle == null ? null : Text(subtitle),
                                trailing: DietPlanStatusChip(
                                  status: plan.status,
                                ),
                                onTap: () => context.push(
                                  Routes.trainerPlansDietById(plan.id),
                                ),
                              );
                            },
                          ),
                        );
              },
            ),
          ),
        ],
      ),
    );
  }
}

const _filters = <(DietPlanListFilter, String)>[
  (DietPlanListFilter.all, DietStrings.filterAll),
  (DietPlanListFilter.draft, DietStrings.filterDraft),
  (DietPlanListFilter.active, DietStrings.filterActive),
  (DietPlanListFilter.archived, DietStrings.filterArchived),
  (DietPlanListFilter.templates, DietStrings.filterTemplates),
];

