import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/workout_plan_list_cubit.dart';
import '../widgets/plan_status_chip.dart';
import '../workout_strings.dart';

class WorkoutPlanListScreen extends StatelessWidget {
  const WorkoutPlanListScreen({super.key, this.isTemplate});

  final bool? isTemplate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<WorkoutPlanListCubit>()..load(isTemplate: isTemplate),
      child: const _WorkoutPlanListBody(),
    );
  }
}

class _WorkoutPlanListBody extends StatelessWidget {
  const _WorkoutPlanListBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(WorkoutStrings.listTitle)),
      floatingActionButton: FloatingActionButton(
        tooltip: WorkoutStrings.createTitle,
        onPressed: () => context.push(Routes.trainerPlansWorkoutsCreate),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: BlocBuilder<WorkoutPlanListCubit, WorkoutPlanListState>(
              buildWhen: (p, n) {
                final pf = switch (p) {
                  WorkoutPlanListLoading(:final filter) => filter,
                  WorkoutPlanListLoaded(:final filter) => filter,
                  WorkoutPlanListFailure(:final filter) => filter,
                };
                final nf = switch (n) {
                  WorkoutPlanListLoading(:final filter) => filter,
                  WorkoutPlanListLoaded(:final filter) => filter,
                  WorkoutPlanListFailure(:final filter) => filter,
                };
                return pf != nf;
              },
              builder: (context, state) {
                final filter = switch (state) {
                  WorkoutPlanListLoading(:final filter) => filter,
                  WorkoutPlanListLoaded(:final filter) => filter,
                  WorkoutPlanListFailure(:final filter) => filter,
                };
                return Wrap(
                  spacing: 8,
                  children: [
                    for (final entry in _filters)
                      ChoiceChip(
                        label: Text(entry.$2),
                        selected: filter == entry.$1,
                        onSelected: (_) => context
                            .read<WorkoutPlanListCubit>()
                            .setFilter(entry.$1),
                      ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<WorkoutPlanListCubit, WorkoutPlanListState>(
              builder: (context, state) {
                return switch (state) {
                  WorkoutPlanListLoading() => const AppLoading(),
                  WorkoutPlanListFailure(:final message) => AppErrorView(
                    message: message,
                    onRetry: () =>
                        context.read<WorkoutPlanListCubit>().load(),
                  ),
                  WorkoutPlanListLoaded(:final items) => items.isEmpty
                      ? const AppEmptyView(message: WorkoutStrings.noneFound)
                      : RefreshIndicator(
                          onRefresh: () =>
                              context.read<WorkoutPlanListCubit>().load(),
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final plan = items[index];
                              return ListTile(
                                title: Text(plan.title),
                                subtitle: plan.targetGoal == null
                                    ? null
                                    : Text(plan.targetGoal!),
                                trailing: PlanStatusChip(status: plan.status),
                                onTap: () => context.push(
                                  Routes.trainerPlansWorkoutById(plan.id),
                                ),
                              );
                            },
                          ),
                        ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

const _filters = <(WorkoutPlanListFilter, String)>[
  (WorkoutPlanListFilter.all, WorkoutStrings.filterAll),
  (WorkoutPlanListFilter.draft, WorkoutStrings.filterDraft),
  (WorkoutPlanListFilter.active, WorkoutStrings.filterActive),
  (WorkoutPlanListFilter.archived, WorkoutStrings.filterArchived),
];
