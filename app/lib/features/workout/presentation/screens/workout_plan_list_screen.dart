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
              buildWhen: (p, n) => p.filter != n.filter,
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
                final items = state.items;
                if (state.status == LoadStatus.loading && !state.hasLoaded) {
                  return const AppLoading();
                }
                if (state.status == LoadStatus.failure && !state.hasLoaded) {
                  return AppErrorView(
                    message: state.failure == null
                        ? 'Something went wrong'
                        : failureMessage(state.failure!),
                    onRetry: () =>
                        context.read<WorkoutPlanListCubit>().load(),
                  );
                }
                if (items.isEmpty) {
                  return const AppEmptyView(
                    message: WorkoutStrings.noneFound,
                  );
                }
                return RefreshIndicator(
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
                );
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
