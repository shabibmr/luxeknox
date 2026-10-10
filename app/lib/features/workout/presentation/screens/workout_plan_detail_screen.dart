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
import '../widgets/workout_day_section.dart';
import '../widgets/workout_plan_header_card.dart';
import '../widgets/workout_stats_overview.dart';
import '../workout_strings.dart';
import '../../../people/presentation/widgets/member_picker_sheet.dart';

class WorkoutPlanDetailScreen extends StatelessWidget {
  const WorkoutPlanDetailScreen({
    super.key,
    required this.planId,
    this.isViewOnly = false,
  });

  final String planId;
  final bool isViewOnly;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WorkoutPlanDetailCubit>()..load(planId),
      child: _WorkoutPlanDetailBody(planId: planId, isViewOnly: isViewOnly),
    );
  }
}

class _WorkoutPlanDetailBody extends StatelessWidget {
  const _WorkoutPlanDetailBody({
    required this.planId,
    required this.isViewOnly,
  });

  final String planId;
  final bool isViewOnly;

  Future<void> _assign(BuildContext context) async {
    final member = await showMemberPickerSheet(context);
    if (member == null || !context.mounted) return;

    final cubit = context.read<WorkoutPlanDetailCubit>();
    await cubit.assignToMember(member.id.toString());
    if (!context.mounted) return;
    final next = cubit.state;
    if (next.status == LoadStatus.success && next.assignedPlan != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(WorkoutStrings.assigned)));
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failureMessage(failure))));
      },
      builder: (context, state) {
        final plan = state.plan;
        final inFlight = state.actionInFlight;

        return Scaffold(
          appBar: AppBar(
            title: const Text(WorkoutStrings.detailTitle),
            actions: [
              if (plan != null && !isViewOnly) ...[
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
                // Rule 2: Every plan acts as a template; any plan can be copied to a new member
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
                            final cubit = context
                                .read<WorkoutPlanDetailCubit>();
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
                            final cubit = context
                                .read<WorkoutPlanDetailCubit>();
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
                        onRetry: () =>
                            context.read<WorkoutPlanDetailCubit>().load(planId),
                      )
                    : state.status == LoadStatus.loading
                    ? const AppLoading()
                    : const SizedBox.shrink()
              : Stack(
                  children: [
                    _DetailContent(plan: plan, isViewOnly: isViewOnly),
                    if (inFlight)
                      const ColoredBox(
                        color: Color(0x33000000),
                        child: AppLoading(),
                      ),
                  ],
                ),
          bottomNavigationBar: (plan != null && isViewOnly)
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: FilledButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: const Text(WorkoutStrings.startSession),
                      onPressed: () => context.push(
                        '${Routes.memberHomeWorkoutActive}?workoutPlanId=${plan.id}',
                      ),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.plan, required this.isViewOnly});

  final WorkoutPlan plan;
  final bool isViewOnly;

  @override
  Widget build(BuildContext context) {
    final byDay = <int, List<WorkoutPlanExercise>>{};
    for (final e in plan.exercises) {
      byDay.putIfAbsent(e.dayNumber, () => []).add(e);
    }
    for (final list in byDay.values) {
      list.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    }
    final days = byDay.keys.toList()..sort();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            WorkoutPlanHeaderCard(plan: plan),
            const SizedBox(height: 12),
            WorkoutStatsOverview(exercises: plan.exercises),
            const SizedBox(height: 16),
            Text(
              WorkoutStrings.exercisesSection,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (days.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  WorkoutStrings.emptyDay,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              )
            else
              for (final day in days)
                WorkoutDaySection(
                  dayNumber: day,
                  exercises: byDay[day]!,
                  onExerciseTap: (e) {
                    if (isViewOnly) {
                      context.push(Routes.memberHomeWorkoutExerciseById(e.exerciseId));
                    }
                  },
                  onStartDay: isViewOnly
                      ? () => context.push(
                          '${Routes.memberHomeWorkoutActive}?workoutPlanId=${plan.id}',
                        )
                      : null,
                ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
