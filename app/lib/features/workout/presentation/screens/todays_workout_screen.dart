import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/router/session_route_ids.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/todays_workout_cubit.dart';
import '../widgets/todays_day_selector.dart';
import '../widgets/todays_workout_hero_card.dart';
import '../widgets/workout_exercise_card.dart';
import '../workout_strings.dart';

/// Screen displaying the member's assigned routine for today, day split selector,
/// and quick CTA to start the live workout session.
class TodaysWorkoutScreen extends StatelessWidget {
  const TodaysWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final memberId = sessionProfileId(context);

    return BlocProvider(
      create: (_) {
        final cubit = getIt<TodaysWorkoutCubit>();
        if (memberId != null) {
          cubit.load(memberId: memberId.toString());
        }
        return cubit;
      },
      child: _TodaysWorkoutBody(memberId: memberId?.toString()),
    );
  }
}

class _TodaysWorkoutBody extends StatelessWidget {
  const _TodaysWorkoutBody({required this.memberId});

  final String? memberId;

  @override
  Widget build(BuildContext context) {
    if (memberId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(WorkoutStrings.todayWorkoutTitle)),
        body: const AppEmptyView(
          icon: Icons.person_off_outlined,
          message: WorkoutStrings.missingMember,
        ),
      );
    }

    final cubit = context.read<TodaysWorkoutCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(WorkoutStrings.todayWorkoutTitle),
        actions: [
          IconButton(
            tooltip: WorkoutStrings.viewHistory,
            icon: const Icon(Icons.history),
            onPressed: () => context.push(Routes.memberHomeWorkoutHistory),
          ),
        ],
      ),
      body: BlocBuilder<TodaysWorkoutCubit, TodaysWorkoutState>(
        builder: (context, state) {
          return switch (state.status) {
            LoadStatus.initial || LoadStatus.loading => const AppLoading(),
            LoadStatus.failure => AppErrorView(
              message: state.failure != null
                  ? failureMessage(state.failure!)
                  : WorkoutStrings.actionFailed,
              onRetry: () => cubit.refresh(),
            ),
            LoadStatus.success => _SuccessContent(state: state),
          };
        },
      ),
    );
  }
}

class _SuccessContent extends StatelessWidget {
  const _SuccessContent({required this.state});

  final TodaysWorkoutState state;

  @override
  Widget build(BuildContext context) {
    final plan = state.activePlan;
    final cubit = context.read<TodaysWorkoutCubit>();

    if (plan == null) {
      return RefreshIndicator(
        onRefresh: () => cubit.refresh(),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 48),
            AppEmptyView(
              icon: Icons.fitness_center_outlined,
              message: WorkoutStrings.noActivePlanAssigned,
              actionLabel: WorkoutStrings.startEmptySession,
              action: () => context.push(Routes.memberHomeWorkoutActive),
            ),
          ],
        ),
      );
    }

    final exercises = state.exercisesForDay;
    final totalSets = exercises.fold<int>(
      0,
      (sum, e) => sum + (e.targetSets ?? 0),
    );

    return RefreshIndicator(
      onRefresh: () => cubit.refresh(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TodaysWorkoutHeroCard(
                plan: plan,
                dayNumber: state.selectedDay,
                exerciseCount: exercises.length,
                totalSets: totalSets,
                onStartWorkout: () => context.push(
                  '${Routes.memberHomeWorkoutActive}?workoutPlanId=${plan.id}',
                ),
                onViewPlan: () => context.push(
                  Routes.memberHomeWorkoutPlanById(plan.id),
                ),
              ),
              const SizedBox(height: 16),
              if (state.availableDays.length > 1) ...[
                Text(
                  'Workout Split',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TodaysDaySelector(
                  days: state.availableDays,
                  selectedDay: state.selectedDay,
                  onDaySelected: (day) => cubit.selectDay(day),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    WorkoutStrings.exercisesSection,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${exercises.length} ${WorkoutStrings.totalExercisesLabel.toLowerCase()}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (exercises.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    WorkoutStrings.emptyDay,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                )
              else
                ...exercises.map(
                  (e) => WorkoutExerciseCard(
                    exercise: e,
                    onTap: () => context.push(
                      Routes.memberHomeWorkoutExerciseById(e.exerciseId),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
