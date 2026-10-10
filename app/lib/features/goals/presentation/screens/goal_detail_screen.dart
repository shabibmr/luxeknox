import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../../people/domain/usecases/get_member_usecase.dart';
import '../../../people/presentation/widgets/member_trainer_header.dart';
import '../../domain/entities/member_goal.dart';
import '../../domain/helpers/assigned_trainer.dart';
import '../cubit/goal_detail_cubit.dart';
import '../goal_view_actions.dart';
import '../goals_strings.dart';
import '../widgets/goal_history_section.dart';
import '../widgets/goal_identity_facts.dart';
import '../widgets/goal_latest_reading.dart';
import '../widgets/goal_progress_bar.dart';
import 'goal_form_screen.dart';

class GoalDetailScreen extends StatelessWidget {
  const GoalDetailScreen({
    super.key,
    required this.goalId,
    this.isAssignedTrainer = false,
  });

  final String goalId;

  /// When known by the caller (dossier). Otherwise trainer shell resolves it.
  final bool isAssignedTrainer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GoalDetailCubit>()..load(goalId),
      child: _GoalDetailBody(
        goalId: goalId,
        initialAssignedTrainer: isAssignedTrainer,
      ),
    );
  }
}

class _GoalDetailBody extends StatefulWidget {
  const _GoalDetailBody({
    required this.goalId,
    required this.initialAssignedTrainer,
  });

  final String goalId;
  final bool initialAssignedTrainer;

  @override
  State<_GoalDetailBody> createState() => _GoalDetailBodyState();
}

class _GoalDetailBodyState extends State<_GoalDetailBody> {
  late bool _isAssignedTrainer = widget.initialAssignedTrainer;
  var _resolvedAssignment = false;

  GoalViewActions _actions(BuildContext context, MemberGoal goal) {
    final path = GoRouterState.of(context).uri.path;
    final session = getIt<SessionCubit>().state;
    final canWrite =
        session is SessionAuthenticated &&
        session.capabilities.can('goals.write');
    return resolveGoalViewActions(
      canWriteGoals: canWrite,
      isAssignedTrainer: _isAssignedTrainer,
      status: goal.status,
      shell: goalDetailShellForPath(path),
    );
  }

  Future<void> _resolveAssignedTrainer(MemberGoal goal) async {
    if (_resolvedAssignment || widget.initialAssignedTrainer) {
      _resolvedAssignment = true;
      return;
    }
    final path = GoRouterState.of(context).uri.path;
    if (goalDetailShellForPath(path) != GoalDetailShell.trainer) {
      _resolvedAssignment = true;
      return;
    }
    final session = getIt<SessionCubit>().state;
    if (session is! SessionAuthenticated) {
      _resolvedAssignment = true;
      return;
    }
    final memberId = int.tryParse(goal.memberId.trim());
    if (memberId == null) {
      _resolvedAssignment = true;
      return;
    }
    final person = await getIt<GetMemberUseCase>()(memberId);
    if (!mounted) return;
    final assigned = person.fold(
      (_) => false,
      (p) => resolveIsAssignedTrainer(
        isTrainerPrincipal: session.principal.userType == UserType.trainer,
        sessionProfileId: session.principal.profileId,
        assignedTrainerId: p.assignedTrainerId,
      ),
    );
    setState(() {
      _isAssignedTrainer = assigned;
      _resolvedAssignment = true;
    });
  }

  Future<void> _edit(BuildContext context, MemberGoal goal) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => GoalFormScreen(memberId: goal.memberId, goalId: goal.id),
      ),
    );
    if (saved == true && context.mounted) {
      await context.read<GoalDetailCubit>().load(widget.goalId);
    }
  }

  Future<void> _record(BuildContext context, MemberGoal goal) async {
    final path = GoRouterState.of(context).uri.path;
    final shell = goalDetailShellForPath(path);
    final location = switch (shell) {
      GoalDetailShell.admin =>
        '${Routes.adminMemberGoalsAddMeasurementById(goal.memberId)}'
        '?metric=${goal.metricId}',
      GoalDetailShell.trainer =>
        '${Routes.trainerMemberGoalsAddMeasurementById(goal.memberId)}'
        '?metric=${goal.metricId}',
      GoalDetailShell.member => Routes.memberProgressMeasurements,
    };
    final saved = await context.push<bool>(location);
    if (saved == true && context.mounted) {
      await context.read<GoalDetailCubit>().load(widget.goalId);
    }
  }

  Future<void> _checkIn(BuildContext context) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<GoalDetailCubit>(),
        child: _CheckInSheet(goalId: widget.goalId),
      ),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(GoalsStrings.checkInSaved)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoalDetailCubit, GoalDetailState>(
      listener: (context, state) {
        final goal = state.goal;
        if (goal != null && !_resolvedAssignment) {
          _resolveAssignedTrainer(goal);
        }
        if (goal != null && state.failure != null && !state.submitting) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failureMessage(state.failure!))),
          );
        }
      },
      builder: (context, state) {
        final goal = state.goal;
        return Scaffold(
          appBar: AppBar(
            title: Text(goal?.metric?.name ?? GoalsStrings.goalDetailTitle),
            actions: [
              if (goal != null) ..._barActions(context, goal),
            ],
          ),
          body: _body(context, state),
        );
      },
    );
  }

  List<Widget> _barActions(BuildContext context, MemberGoal goal) {
    final actions = _actions(context, goal);
    return [
      if (actions.showCheckIn)
        IconButton(
          key: const Key('goal-view-check-in'),
          tooltip: GoalsStrings.checkInTitle,
          icon: const Icon(Icons.fact_check_outlined),
          onPressed: () => _checkIn(context),
        ),
      if (actions.showRecordMeasurement)
        IconButton(
          key: const Key('goal-view-record'),
          tooltip: GoalsStrings.addMeasurement,
          icon: const Icon(Icons.straighten),
          onPressed: () => _record(context, goal),
        ),
      if (actions.showEdit)
        IconButton(
          key: const Key('goal-view-edit'),
          tooltip: GoalsStrings.edit,
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => _edit(context, goal),
        ),
    ];
  }

  Widget _body(BuildContext context, GoalDetailState state) {
    final goal = state.goal;
    if (state.status == LoadStatus.loading && goal == null) {
      return const AppLoading();
    }
    if (state.status == LoadStatus.failure && goal == null) {
      final failure = state.failure;
      final message = failure is NotFoundFailure
          ? GoalsStrings.goalNotAvailable
          : failureMessage(failure!);
      return AppErrorView(
        message: message,
        onRetry: () => context.read<GoalDetailCubit>().load(widget.goalId),
      );
    }
    if (goal == null) return const SizedBox.shrink();
    final history = goal.history;
    final unit = goal.metric?.unitOfMeasure;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        MemberTrainerHeader(memberId: goal.memberId),
        const SizedBox(height: 12),
        GoalProgressBar(key: const Key('goal-view-progress'), goal: goal),
        const SizedBox(height: 16),
        GoalIdentityFacts(goal: goal),
        const SizedBox(height: 16),
        GoalHistorySection(
          history: history,
          unit: unit,
          showEarlier: history.length > 1,
        ),
        if (history.isNotEmpty) ...[
          const SizedBox(height: 16),
          GoalLatestReading(entry: history.first, unit: unit),
        ],
      ],
    );
  }
}

class _CheckInSheet extends StatefulWidget {
  const _CheckInSheet({required this.goalId});

  final String goalId;

  @override
  State<_CheckInSheet> createState() => _CheckInSheetState();
}

class _CheckInSheetState extends State<_CheckInSheet> {
  final _valueController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _valueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    final value = num.tryParse(_valueController.text.trim());
    if (value == null) return;
    final cubit = context.read<GoalDetailCubit>();
    final ok = await cubit.submitCheckIn(
      recordedValue: value,
      recordedDate: _date,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
    if (!mounted) return;
    Navigator.of(context).pop(ok);
  }

  @override
  Widget build(BuildContext context) {
    final submitting = context.watch<GoalDetailCubit>().state.submitting;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            GoalsStrings.checkInTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _valueController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: GoalsStrings.checkInValueLabel,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(GoalsStrings.checkInDateLabel),
            subtitle: Text(GoalsStrings.calendarDate(_date)),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: _pickDate,
            ),
          ),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: GoalsStrings.checkInNotesLabel,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: submitting ? null : _submit,
            child: submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(GoalsStrings.checkInSubmit),
          ),
        ],
      ),
    );
  }
}
