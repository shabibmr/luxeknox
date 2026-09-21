import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/workout_plan_version.dart';
import '../cubit/workout_plan_versions_cubit.dart';
import '../workout_strings.dart';

class WorkoutPlanVersionsScreen extends StatelessWidget {
  const WorkoutPlanVersionsScreen({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WorkoutPlanVersionsCubit>()..load(planId),
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
      appBar: AppBar(title: const Text(WorkoutStrings.versionsTitle)),
      body: BlocBuilder<WorkoutPlanVersionsCubit, WorkoutPlanVersionsState>(
        builder: (context, state) {
          return switch (state) {
            WorkoutPlanVersionsLoading() => const AppLoading(),
            WorkoutPlanVersionsFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () =>
                  context.read<WorkoutPlanVersionsCubit>().load(planId),
            ),
            WorkoutPlanVersionsLoaded(:final versions, :final expandedId) =>
              versions.isEmpty
                  ? const Center(child: Text(WorkoutStrings.noVersions))
                  : ListView.builder(
                      itemCount: versions.length,
                      itemBuilder: (context, index) {
                        final v = versions[index];
                        return _VersionTile(
                          version: v,
                          expanded: expandedId == v.id,
                          onTap: () => context
                              .read<WorkoutPlanVersionsCubit>()
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

class _VersionTile extends StatelessWidget {
  const _VersionTile({
    required this.version,
    required this.expanded,
    required this.onTap,
  });

  final WorkoutPlanVersion version;
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
        WorkoutStrings.changelogEmpty,
      if (date != null) date.toLocal().toString().split('.').first,
      '${version.exercises.length} ${WorkoutStrings.versionExercises}',
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
                      WorkoutStrings.versionTitle(version.versionNumber),
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
                if (version.exercises.isEmpty)
                  const Text(WorkoutStrings.emptyDay)
                else
                  for (final e in version.exercises)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        e.exerciseName ?? 'Exercise #${e.exerciseId}',
                      ),
                      subtitle: Text(
                        WorkoutStrings.exerciseSubtitle(
                          sets: e.targetSets,
                          reps: e.targetReps,
                        ),
                      ),
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
