import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
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
          final versions = state.versions;
          if (state.status == LoadStatus.loading && !state.hasLoaded) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && !state.hasLoaded) {
            return AppErrorView(
              message: state.failure == null
                  ? 'Something went wrong'
                  : failureMessage(state.failure!),
              onRetry: () =>
                  context.read<WorkoutPlanVersionsCubit>().load(planId),
            );
          }
          if (versions.isEmpty) {
            return const Center(child: Text(WorkoutStrings.noVersions));
          }
          return ListView.builder(
            itemCount: versions.length,
            itemBuilder: (context, index) {
              final v = versions[index];
              return _VersionTile(
                version: v,
                expanded: state.expandedId == v.id,
                onTap: () => context
                    .read<WorkoutPlanVersionsCubit>()
                    .toggleExpanded(v.id),
              );
            },
          );
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
