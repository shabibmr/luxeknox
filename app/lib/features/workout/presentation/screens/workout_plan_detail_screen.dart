import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/entities/workout_plan_exercise.dart';
import '../../domain/entities/workout_plan_status.dart';
import '../cubit/workout_plan_detail_cubit.dart';
import '../widgets/plan_status_chip.dart';
import '../workout_strings.dart';

class WorkoutPlanDetailScreen extends StatelessWidget {
  const WorkoutPlanDetailScreen({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WorkoutPlanDetailCubit>()..load(planId),
      child: _WorkoutPlanDetailBody(planId: planId),
    );
  }
}

class _WorkoutPlanDetailBody extends StatelessWidget {
  const _WorkoutPlanDetailBody({required this.planId});

  final String planId;

  Future<void> _assign(BuildContext context) async {
    final controller = TextEditingController();
    final memberId = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(WorkoutStrings.assignDialogTitle),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: WorkoutStrings.assignDialogHint,
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(WorkoutStrings.assignCancel),
            ),
            FilledButton(
              onPressed: () {
                final raw = controller.text.trim();
                if (raw.isEmpty) return;
                Navigator.of(dialogContext).pop(raw);
              },
              child: const Text(WorkoutStrings.assignConfirm),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (memberId == null || !context.mounted) return;

    final cubit = context.read<WorkoutPlanDetailCubit>();
    await cubit.assignToMember(memberId);
    if (!context.mounted) return;
    final next = cubit.state;
    if (next.status == LoadStatus.success && next.assignedPlan != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(WorkoutStrings.assigned)),
      );
      final assignedId = next.assignedPlan!.id;
      cubit.clearAssignedPlan();
      context.push(Routes.trainerPlansWorkoutById(assignedId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkoutPlanDetailCubit, WorkoutPlanDetailState>(
      listenWhen: (previous, current) =>
          current.plan != null &&
          current.status == LoadStatus.failure &&
          current.failure != previous.failure,
      listener: (context, state) {
        final failure = state.failure;
        if (failure == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failureMessage(failure))),
        );
      },
      builder: (context, state) {
        final plan = state.plan;
        final inFlight = state.actionInFlight;

        return Scaffold(
          appBar: AppBar(
            title: const Text(WorkoutStrings.detailTitle),
            actions: [
              if (plan != null) ...[
                IconButton(
                  tooltip: WorkoutStrings.viewVersions,
                  icon: const Icon(Icons.history),
                  onPressed: inFlight
                      ? null
                      : () => context.push(
                          Routes.trainerPlansWorkoutVersionsById(plan.id),
                        ),
                ),
                IconButton(
                  tooltip: WorkoutStrings.edit,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: inFlight
                      ? null
                      : () => context.push(
                          Routes.trainerPlansWorkoutEditById(plan.id),
                        ),
                ),
                if (plan.isTemplate)
                  IconButton(
                    tooltip: WorkoutStrings.assignToMember,
                    icon: const Icon(Icons.person_add_alt_1_outlined),
                    onPressed: inFlight ? null : () => _assign(context),
                  ),
                if (plan.status == WorkoutPlanStatus.draft)
                  IconButton(
                    tooltip: WorkoutStrings.publish,
                    icon: const Icon(Icons.publish_outlined),
                    onPressed: inFlight
                        ? null
                        : () async {
                            final cubit =
                                context.read<WorkoutPlanDetailCubit>();
                            await cubit.publish();
                            if (!context.mounted) return;
                            final next = cubit.state;
                            if (next.status == LoadStatus.success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(WorkoutStrings.published),
                                ),
                              );
                            }
                          },
                  ),
                if (plan.status != WorkoutPlanStatus.archived)
                  IconButton(
                    tooltip: WorkoutStrings.archive,
                    icon: const Icon(Icons.archive_outlined),
                    onPressed: inFlight
                        ? null
                        : () async {
                            final cubit =
                                context.read<WorkoutPlanDetailCubit>();
                            await cubit.archive();
                            if (!context.mounted) return;
                            final next = cubit.state;
                            if (next.status == LoadStatus.success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(WorkoutStrings.archived),
                                ),
                              );
                            }
                          },
                  ),
              ],
            ],
          ),
          body: plan == null
              ? state.status == LoadStatus.failure
                    ? AppErrorView(
                        message: state.failure == null
                            ? 'Something went wrong'
                            : failureMessage(state.failure!),
                        onRetry: () => context
                            .read<WorkoutPlanDetailCubit>()
                            .load(planId),
                      )
                    : state.status == LoadStatus.loading
                    ? const AppLoading()
                    : const SizedBox.shrink()
              : Stack(
                  children: [
                    _DetailContent(plan: plan),
                    if (inFlight)
                      const ColoredBox(
                        color: Color(0x33000000),
                        child: AppLoading(),
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.plan});

  final WorkoutPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final byDay = <int, List<WorkoutPlanExercise>>{};
    for (final e in plan.exercises) {
      byDay.putIfAbsent(e.dayNumber, () => []).add(e);
    }
    for (final list in byDay.values) {
      list.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    }
    final days = byDay.keys.toList()..sort();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(plan.title, style: theme.textTheme.headlineSmall),
            ),
            PlanStatusChip(status: plan.status),
          ],
        ),
        if (plan.isTemplate) ...[
          const SizedBox(height: 8),
          Text(
            WorkoutStrings.isTemplateLabel,
            style: theme.textTheme.labelLarge,
          ),
        ],
        if (plan.description != null && plan.description!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(plan.description!),
        ],
        const SizedBox(height: 16),
        if (plan.targetGoal != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(WorkoutStrings.targetGoalLabel),
            subtitle: Text(plan.targetGoal!),
          ),
        if (plan.difficulty != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(WorkoutStrings.difficultyLabel),
            subtitle: Text(plan.difficulty!),
          ),
        if (plan.durationWeeks != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(WorkoutStrings.durationWeeksLabel),
            subtitle: Text('${plan.durationWeeks}'),
          ),
        if (plan.memberId != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(WorkoutStrings.memberIdLabel),
            subtitle: Text('#${plan.memberId}'),
          ),
        const Divider(height: 32),
        Text(WorkoutStrings.exercisesSection, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (days.isEmpty)
          const Text(WorkoutStrings.emptyDay)
        else
          for (final day in days) ...[
            Text(
              WorkoutStrings.dayHeader(day),
              style: theme.textTheme.titleSmall,
            ),
            for (final e in byDay[day]!)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(e.exerciseName ?? 'Exercise #${e.exerciseId}'),
                subtitle: Text(
                  WorkoutStrings.exerciseSubtitle(
                    sets: e.targetSets,
                    reps: e.targetReps,
                  ),
                ),
              ),
            const SizedBox(height: 8),
          ],
      ],
    );
  }
}
