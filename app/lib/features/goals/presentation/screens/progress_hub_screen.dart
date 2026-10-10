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
import '../../../../session/domain/entities/user_type.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../../people/domain/usecases/get_member_usecase.dart';
import '../../domain/helpers/assigned_trainer.dart';
import '../cubit/goals_list_cubit.dart';
import '../goal_view_actions.dart';
import '../goals_strings.dart';
import '../widgets/goal_progress_bar.dart';

/// Route `extra` for the dossier goals hub routes.
class ProgressHubArgs {
  const ProgressHubArgs({
    required this.canCreateGoals,
    required this.isAssignedTrainer,
  });

  final bool canCreateGoals;
  final bool isAssignedTrainer;
}

class ProgressHubScreen extends StatelessWidget {
  const ProgressHubScreen({
    super.key,
    this.memberId,
    this.canCreateGoals = false,
    this.isAssignedTrainer,
  });

  /// When null, uses the authenticated member's profileId.
  final String? memberId;
  final bool canCreateGoals;

  /// When non-null, skips the member fetch for trainer assignment (C4.1).
  final bool? isAssignedTrainer;

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
    return session.capabilities.can('goals.write');
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
        initialAssignedTrainer: isAssignedTrainer,
      ),
    );
  }
}

class _ProgressHubBody extends StatefulWidget {
  const _ProgressHubBody({
    required this.memberId,
    required this.canCreateGoals,
    required this.initialAssignedTrainer,
  });

  final String memberId;
  final bool canCreateGoals;
  final bool? initialAssignedTrainer;

  @override
  State<_ProgressHubBody> createState() => _ProgressHubBodyState();
}

class _ProgressHubBodyState extends State<_ProgressHubBody> {
  bool _isAssignedTrainer = false;
  var _assignmentReady = false;

  @override
  void initState() {
    super.initState();
    final known = widget.initialAssignedTrainer;
    if (known != null) {
      _isAssignedTrainer = known;
      _assignmentReady = true;
    } else {
      _resolveAssignment();
    }
  }

  Future<void> _resolveAssignment() async {
    final session = getIt<SessionCubit>().state;
    if (session is! SessionAuthenticated ||
        session.principal.userType != UserType.trainer) {
      if (mounted) setState(() => _assignmentReady = true);
      return;
    }
    final memberId = int.tryParse(widget.memberId.trim());
    if (memberId == null) {
      if (mounted) setState(() => _assignmentReady = true);
      return;
    }
    final result = await getIt<GetMemberUseCase>()(memberId);
    if (!mounted) return;
    final assigned = result.fold(
      (_) => false,
      (p) => resolveIsAssignedTrainer(
        isTrainerPrincipal: true,
        sessionProfileId: session.principal.profileId,
        assignedTrainerId: p.assignedTrainerId,
      ),
    );
    setState(() {
      _isAssignedTrainer = assigned;
      _assignmentReady = true;
    });
  }

  String _goalLocation(GoalDetailShell shell, String goalId) {
    return switch (shell) {
      GoalDetailShell.admin =>
        Routes.adminMemberGoalById(widget.memberId, goalId),
      GoalDetailShell.trainer =>
        Routes.trainerMemberGoalById(widget.memberId, goalId),
      GoalDetailShell.member => Routes.memberProgressGoalById(goalId),
    };
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final shell = goalDetailShellForPath(path);
    final isDossierShell = shell != GoalDetailShell.member;

    return Scaffold(
      appBar: AppBar(title: const Text(GoalsStrings.hubTitle)),
      floatingActionButton: widget.canCreateGoals
          ? FloatingActionButton(
              tooltip: GoalsStrings.goalFormCreateTitle,
              onPressed: () async {
                final location = switch (shell) {
                  GoalDetailShell.admin =>
                    Routes.adminMemberGoalsNewById(widget.memberId),
                  GoalDetailShell.trainer =>
                    Routes.trainerMemberGoalsNewById(widget.memberId),
                  GoalDetailShell.member => null,
                };
                if (location == null) return;
                final saved = await context.push<bool>(location);
                if (saved == true && context.mounted) {
                  context.read<GoalsListCubit>().load(widget.memberId);
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
                  label: const Text(GoalsStrings.overviewLink),
                  onPressed: () {
                    if (shell == GoalDetailShell.admin) {
                      context.push(
                        Routes.adminMemberGoalsOverviewById(widget.memberId),
                      );
                    } else if (shell == GoalDetailShell.trainer) {
                      context.push(
                        Routes.trainerMemberGoalsOverviewById(widget.memberId),
                      );
                    } else {
                      context.push(Routes.memberProgressOverview);
                    }
                  },
                ),
                ActionChip(
                  label: const Text(GoalsStrings.chartsLink),
                  onPressed: () {
                    if (shell == GoalDetailShell.admin) {
                      context.push(
                        Routes.adminMemberGoalsOverviewById(widget.memberId),
                      );
                    } else if (shell == GoalDetailShell.trainer) {
                      context.push(
                        Routes.trainerMemberGoalsOverviewById(widget.memberId),
                      );
                    } else {
                      context.push(Routes.memberProgressOverview);
                    }
                  },
                ),
                ActionChip(
                  label: const Text(GoalsStrings.measurementsLink),
                  onPressed: () {
                    if (shell == GoalDetailShell.admin) {
                      context.push(
                        Routes.adminMemberGoalsMeasurementsById(
                          widget.memberId,
                        ),
                      );
                    } else if (shell == GoalDetailShell.trainer) {
                      context.push(
                        Routes.trainerMemberGoalsMeasurementsById(
                          widget.memberId,
                        ),
                      );
                    } else {
                      context.go(Routes.memberProgressMeasurements);
                    }
                  },
                ),
                ActionChip(
                  label: const Text(GoalsStrings.photosLink),
                  onPressed: () {
                    if (isDossierShell) {
                      // Wait until assignment is known so admin never inherits
                      // a trainer bypass (C4.3).
                      final assigned = shell == GoalDetailShell.trainer &&
                          _assignmentReady &&
                          _isAssignedTrainer;
                      final location = shell == GoalDetailShell.admin
                          ? Routes.adminMemberGoalsPhotosById(widget.memberId)
                          : Routes.trainerMemberGoalsPhotosById(
                              widget.memberId,
                            );
                      context.push(location, extra: assigned);
                    } else {
                      context.go(Routes.memberProgressPhotos);
                    }
                  },
                ),
                ActionChip(
                  label: const Text(GoalsStrings.notesLink),
                  onPressed: () {
                    if (isDossierShell) {
                      final location = shell == GoalDetailShell.admin
                          ? Routes.adminMemberGoalsNotesById(widget.memberId)
                          : Routes.trainerMemberGoalsNotesById(
                              widget.memberId,
                            );
                      context.push(location);
                    } else {
                      context.go(Routes.memberProgressNotes);
                    }
                  },
                ),
                if (isDossierShell)
                  ActionChip(
                    label: const Text(GoalsStrings.timelineLink),
                    onPressed: () {
                      final location = shell == GoalDetailShell.admin
                          ? Routes.adminMemberGoalsTimelineById(
                              widget.memberId,
                            )
                          : Routes.trainerMemberGoalsTimelineById(
                              widget.memberId,
                            );
                      context.push(location);
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
                    state.status == LoadStatus.success ||
                    state.items.isNotEmpty;
                if (state.status == LoadStatus.loading && !showData) {
                  return const AppLoading();
                }
                if (state.status == LoadStatus.failure && !showData) {
                  return AppErrorView(
                    message: failureMessage(state.failure!),
                    onRetry: () =>
                        context.read<GoalsListCubit>().load(widget.memberId),
                  );
                }
                final items = state.items;
                return items.isEmpty
                    ? const AppEmptyView(message: GoalsStrings.noneGoals)
                    : RefreshIndicator(
                        onRefresh: () =>
                            context.read<GoalsListCubit>().load(widget.memberId),
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
                                  await context.push(
                                    _goalLocation(shell, goal.id),
                                  );
                                  if (context.mounted && isDossierShell) {
                                    context.read<GoalsListCubit>().load(
                                      widget.memberId,
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
                                      if (widget.canCreateGoals)
                                        IconButton(
                                          tooltip: GoalsStrings.edit,
                                          icon: const Icon(Icons.edit_outlined),
                                          onPressed: () async {
                                            final location = switch (shell) {
                                              GoalDetailShell.admin =>
                                                Routes.adminMemberGoalEditById(
                                                  widget.memberId,
                                                  goal.id,
                                                ),
                                              GoalDetailShell.trainer =>
                                                Routes.trainerMemberGoalEditById(
                                                  widget.memberId,
                                                  goal.id,
                                                ),
                                              GoalDetailShell.member => null,
                                            };
                                            if (location == null) return;
                                            final saved = await context
                                                .push<bool>(location);
                                            if (saved == true &&
                                                context.mounted) {
                                              context
                                                  .read<GoalsListCubit>()
                                                  .load(widget.memberId);
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
