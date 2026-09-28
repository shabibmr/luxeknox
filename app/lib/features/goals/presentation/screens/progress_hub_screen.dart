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
import '../../../../session/presentation/session_cubit.dart';
import '../cubit/goals_list_cubit.dart';
import '../goals_strings.dart';
import '../widgets/goal_progress_bar.dart';
import 'goal_detail_screen.dart';
import 'goal_form_screen.dart';
import 'progress_notes_screen.dart';
import 'progress_photos_screen.dart';

class ProgressHubScreen extends StatelessWidget {
  const ProgressHubScreen({
    super.key,
    this.memberId,
    this.canCreateGoals = false,
  });

  /// When null, uses the authenticated member's profileId.
  final String? memberId;
  final bool canCreateGoals;

  String? _resolveMemberId() {
    if (memberId != null) return memberId;
    final session = getIt<SessionCubit>().state;
    if (session is SessionAuthenticated) {
      return session.principal.profileId;
    }
    return null;
  }

  bool _canMutateGoals() {
    if (!canCreateGoals) return false;
    final session = getIt<SessionCubit>().state;
    if (session is! SessionAuthenticated) return false;
    final caps = session.capabilities;
    return caps.can('goals.create') ||
        caps.can('goals.update') ||
        caps.can('goals.write');
  }

  @override
  Widget build(BuildContext context) {
    final id = _resolveMemberId();
    if (id == null || id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text(GoalsStrings.hubTitle)),
        body: const AppEmptyView(message: GoalsStrings.noneGoals),
      );
    }

    return BlocProvider(
      create: (_) => getIt<GoalsListCubit>()..load(id),
      child: _ProgressHubBody(
        memberId: id,
        canCreateGoals: _canMutateGoals(),
      ),
    );
  }
}

class _ProgressHubBody extends StatelessWidget {
  const _ProgressHubBody({
    required this.memberId,
    required this.canCreateGoals,
  });

  final String memberId;
  final bool canCreateGoals;

  @override
  Widget build(BuildContext context) {
    final isTrainerContext = canCreateGoals;

    return Scaffold(
      appBar: AppBar(title: const Text(GoalsStrings.hubTitle)),
      floatingActionButton: canCreateGoals
          ? FloatingActionButton(
              tooltip: GoalsStrings.goalFormCreateTitle,
              onPressed: () async {
                final saved = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => GoalFormScreen(memberId: memberId),
                  ),
                );
                if (saved == true && context.mounted) {
                  context.read<GoalsListCubit>().load(memberId);
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  label: const Text(GoalsStrings.measurementsLink),
                  onPressed: () {
                    if (isTrainerContext) {
                      context.push(
                        Routes.trainerMemberGoalsAddMeasurementById(memberId),
                      );
                    } else {
                      context.go(Routes.memberProgressMeasurements);
                    }
                  },
                ),
                ActionChip(
                  label: const Text(GoalsStrings.photosLink),
                  onPressed: () {
                    if (isTrainerContext) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProgressPhotosScreen(
                            memberId: memberId,
                            isAssignedTrainer: true,
                          ),
                        ),
                      );
                    } else {
                      context.go(Routes.memberProgressPhotos);
                    }
                  },
                ),
                ActionChip(
                  label: const Text(GoalsStrings.notesLink),
                  onPressed: () {
                    if (isTrainerContext) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ProgressNotesScreen(memberId: memberId),
                        ),
                      );
                    } else {
                      context.go(Routes.memberProgressNotes);
                    }
                  },
                ),
                ActionChip(
                  label: const Text(GoalsStrings.chartsLink),
                  onPressed: () {
                    if (isTrainerContext) {
                      context.push(
                        Routes.trainerMemberGoalsAddMeasurementById(memberId),
                      );
                    } else {
                      context.go(Routes.memberProgressMeasurements);
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<GoalsListCubit, GoalsListState>(
              builder: (context, state) {
                final showData =
                    state.status == LoadStatus.success || state.items.isNotEmpty;
                if (state.status == LoadStatus.loading && !showData) {
                  return const AppLoading();
                }
                if (state.status == LoadStatus.failure && !showData) {
                  return AppErrorView(
                    message: failureMessage(state.failure!),
                    onRetry: () =>
                        context.read<GoalsListCubit>().load(memberId),
                  );
                }
                final items = state.items;
                return items.isEmpty
                      ? const AppEmptyView(message: GoalsStrings.noneGoals)
                      : RefreshIndicator(
                          onRefresh: () =>
                              context.read<GoalsListCubit>().load(memberId),
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: items.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final goal = items[index];
                              return Card(
                                child: InkWell(
                                  onTap: () async {
                                    if (isTrainerContext) {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => GoalDetailScreen(
                                            goalId: goal.id,
                                          ),
                                        ),
                                      );
                                      if (context.mounted) {
                                        context
                                            .read<GoalsListCubit>()
                                            .load(memberId);
                                      }
                                    } else {
                                      context.go(
                                        Routes.memberProgressGoalById(goal.id),
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GoalProgressBar(goal: goal),
                                        ),
                                        if (canCreateGoals)
                                          IconButton(
                                            tooltip: GoalsStrings.edit,
                                            icon: const Icon(Icons.edit_outlined),
                                            onPressed: () async {
                                              final saved =
                                                  await Navigator.of(context)
                                                      .push<bool>(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      GoalFormScreen(
                                                    memberId: memberId,
                                                    goalId: goal.id,
                                                  ),
                                                ),
                                              );
                                              if (saved == true &&
                                                  context.mounted) {
                                                context
                                                    .read<GoalsListCubit>()
                                                    .load(memberId);
                                              }
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
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
