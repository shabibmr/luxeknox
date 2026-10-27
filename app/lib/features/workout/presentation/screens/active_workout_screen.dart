import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/router/session_route_ids.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/entities/workout_plan_exercise.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/entities/workout_session_set.dart';
import '../../../exercises/domain/entities/exercise.dart';
import '../bloc/active_workout_bloc.dart';
import '../cubit/rest_timer_cubit.dart';
import '../widgets/exercise_history_sheet.dart';
import '../widgets/exercise_picker_sheet.dart';
import '../widgets/post_rest_prompt_sheet.dart';
import '../widgets/rest_timer_widget.dart';
import '../widgets/session_comments_sheet.dart';
import '../widgets/skip_reason_dialog.dart';
import '../widgets/workout_plan_picker_sheet.dart';
import '../workout_strings.dart';

String? _errorText(ActiveWorkoutState state) {
  if (state.message != null && state.message!.isNotEmpty) return state.message;
  final failure = state.failure;
  if (failure == null) return null;
  return failureMessage(failure);
}

class _CompleteFeedback {
  const _CompleteFeedback({this.notes, this.rating});

  final String? notes;
  final int? rating;
}

class _SetFieldsResult {
  const _SetFieldsResult({
    this.reps,
    this.weightKg,
    this.rpe,
    this.notes,
  });

  final int? reps;
  final num? weightKg;
  final num? rpe;
  final String? notes;
}

class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({
    super.key,
    this.workoutPlanId,
    this.memberId,
    this.historyPath,
  });

  final String? workoutPlanId;

  /// Member whose session this is. When omitted (member app), falls back to
  /// the authenticated member's own profile id.
  final String? memberId;

  /// Where "View workout history" navigates once the session is complete.
  /// When omitted, falls back to the member app's own history screen.
  final String? historyPath;

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  late final ActiveWorkoutBloc _bloc;
  var _configured = false;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<ActiveWorkoutBloc>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_configured) return;
    _configured = true;
    final memberId = widget.memberId ?? sessionProfileId(context)?.toString();
    if (memberId != null) {
      _bloc.add(
        ActiveWorkoutConfigured(
          memberId: memberId,
          workoutPlanId: widget.workoutPlanId,
        ),
      );
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memberId = widget.memberId ?? sessionProfileId(context)?.toString();
    final historyPath = widget.historyPath ?? Routes.memberHomeWorkoutHistory;
    return MultiBlocProvider(
      providers: [
        BlocProvider<ActiveWorkoutBloc>.value(value: _bloc),
        BlocProvider<RestTimerCubit>.value(value: _bloc.restTimer),
      ],
      child: _ActiveWorkoutBody(memberId: memberId, historyPath: historyPath),
    );
  }
}

class _ActiveWorkoutBody extends StatelessWidget {
  const _ActiveWorkoutBody({required this.memberId, required this.historyPath});

  final String? memberId;
  final String historyPath;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActiveWorkoutBloc, ActiveWorkoutState>(
      listenWhen: (previous, current) =>
          (!previous.resumed && current.resumed) ||
          (previous.failure != current.failure && current.failure != null),
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.failure != null) {
          messenger.showSnackBar(
            SnackBar(content: Text(_errorText(state) ?? '')),
          );
        } else if (state.resumed) {
          messenger.showSnackBar(
            const SnackBar(content: Text(WorkoutStrings.resumedSession)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text(WorkoutStrings.activeTitle)),
        body: BlocBuilder<ActiveWorkoutBloc, ActiveWorkoutState>(
          builder: (context, state) {
            final session = state.session;
            if (state.completed && session != null) {
              return _CompletedPanel(
                session: session,
                loggedSetCount: state.loggedSetCount ?? state.loggedSets.length,
                historyPath: historyPath,
              );
            }
            if (session != null) {
              return _InProgressPanel(state: state, memberId: memberId);
            }
            if (state.status == LoadStatus.loading) {
              return const AppLoading();
            }
            return _StartPanel(state: state, memberId: memberId);
          },
        ),
      ),
    );
  }
}

class _StartPanel extends StatefulWidget {
  const _StartPanel({required this.state, required this.memberId});

  final ActiveWorkoutState state;
  final String? memberId;

  @override
  State<_StartPanel> createState() => _StartPanelState();
}

class _StartPanelState extends State<_StartPanel> {
  String? _selectedPlanId;
  WorkoutPlan? _selectedPlan;

  @override
  void initState() {
    super.initState();
    _selectedPlanId = widget.state.initialPlanId;
  }

  @override
  Widget build(BuildContext context) {
    final memberId = widget.memberId;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          if (_errorText(widget.state) != null) ...[
            Text(
              _errorText(widget.state)!,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            const SizedBox(height: 12),
          ],
          if (memberId == null)
            const Text(WorkoutStrings.missingMember)
          else ...[
            Card(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Member Session',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Member ID: $memberId',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            WorkoutPlanPickerField(
              selectedPlan: _selectedPlan,
              memberId: memberId,
              onChanged: (plan) {
                setState(() {
                  _selectedPlan = plan;
                  _selectedPlanId = plan?.id;
                });
              },
            ),
            const SizedBox(height: 16),
            if (_selectedPlan != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedPlan!.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.comment_outlined, size: 20),
                            tooltip: 'Plan Comments',
                            onPressed: () => SessionCommentsSheet.show(
                              context,
                              entityType: 'plan',
                              entityId: _selectedPlan!.id,
                              title: _selectedPlan!.title,
                            ),
                          ),
                        ],
                      ),
                      if (_selectedPlan!.description != null &&
                          _selectedPlan!.description!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          _selectedPlan!.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'Exercises in Plan (${_selectedPlan!.exercises.length}):',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      for (var i = 0; i < _selectedPlan!.exercises.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                child: Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedPlan!.exercises[i].exerciseName ??
                                      'Exercise #${_selectedPlan!.exercises[i].exerciseId}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                [
                                  if (_selectedPlan!.exercises[i].targetSets !=
                                      null)
                                    '${_selectedPlan!.exercises[i].targetSets} sets',
                                  if (_selectedPlan!.exercises[i].targetReps !=
                                      null)
                                    '${_selectedPlan!.exercises[i].targetReps} reps',
                                  if (_selectedPlan!
                                          .exercises[i].targetWeightKg !=
                                      null)
                                    '${_selectedPlan!.exercises[i].targetWeightKg}kg',
                                ].join(' · '),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            FilledButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: Text(
                (_selectedPlan != null ||
                        (_selectedPlanId != null &&
                            _selectedPlanId!.isNotEmpty))
                    ? WorkoutStrings.startSession
                    : 'Choose a Workout Plan to Start',
              ),
              onPressed: () async {
                final planId = _selectedPlan?.id ?? _selectedPlanId;
                if (planId != null && planId.isNotEmpty) {
                  context.read<ActiveWorkoutBloc>().add(
                    ActiveWorkoutStarted(workoutPlanId: planId),
                  );
                } else {
                  final plan = await showWorkoutPlanPickerSheet(
                    context,
                    memberId: memberId,
                  );
                  if (plan != null && context.mounted) {
                    setState(() {
                      _selectedPlan = plan;
                      _selectedPlanId = plan.id;
                    });
                    context.read<ActiveWorkoutBloc>().add(
                      ActiveWorkoutStarted(workoutPlanId: plan.id),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.read<ActiveWorkoutBloc>().add(
                const ActiveWorkoutStarted(workoutPlanId: null),
              ),
              child: const Text(WorkoutStrings.startEmptySession),
            ),
          ],
        ],
      ),
    ),
    ),
    );
  }
}

class _InProgressPanel extends StatefulWidget {
  const _InProgressPanel({required this.state, this.memberId});

  final ActiveWorkoutState state;
  final String? memberId;

  @override
  State<_InProgressPanel> createState() => _InProgressPanelState();
}

class _InProgressPanelState extends State<_InProgressPanel> {
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _rpeController = TextEditingController();
  final _notesController = TextEditingController();
  Exercise? _selectedFreeExercise;
  String? _lastSyncedExerciseId;

  @override
  void initState() {
    super.initState();
    _syncInputs();
  }

  @override
  void didUpdateWidget(covariant _InProgressPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.selectedExerciseId != _lastSyncedExerciseId) {
      _syncInputs();
    }
  }

  void _syncInputs() {
    final selectedId = widget.state.selectedExerciseId;
    _lastSyncedExerciseId = selectedId;
    final planEx = widget.state.selectedPlanExercise;

    if (planEx != null) {
      // Find the last logged set for this exercise to carry over weight
      final pastSets = widget.state.loggedSets
          .where((s) => s.exerciseId == planEx.exerciseId)
          .toList();

      if (pastSets.isNotEmpty && pastSets.last.weightLiftedKg != null) {
        final w = pastSets.last.weightLiftedKg!;
        _weightController.text = w % 1 == 0 ? w.toInt().toString() : w.toString();
      } else if (planEx.targetWeightKg != null) {
        final w = planEx.targetWeightKg!;
        _weightController.text = w % 1 == 0 ? w.toInt().toString() : w.toString();
      } else {
        _weightController.text = '';
      }

      if (planEx.targetReps != null && planEx.targetReps!.isNotEmpty) {
        _repsController.text = planEx.targetReps!;
      } else {
        _repsController.text = '';
      }

      _rpeController.text = '';
    }
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    _rpeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? get _selectedExerciseId {
    final fromPlan = widget.state.selectedExerciseId;
    if (fromPlan != null && fromPlan.isNotEmpty) return fromPlan;
    return _selectedFreeExercise?.id;
  }

  void _adjustWeight(double delta) {
    final current = double.tryParse(_weightController.text.trim()) ?? 0.0;
    final updated = current + delta;
    if (updated < 0) return;
    _weightController.text =
        updated % 1 == 0 ? updated.toInt().toString() : updated.toStringAsFixed(1);
  }

  void _adjustReps(int delta) {
    final current = int.tryParse(_repsController.text.trim()) ?? 0;
    final updated = current + delta;
    if (updated < 0) return;
    _repsController.text = updated.toString();
  }

  void _submit() {
    final exerciseId = _selectedExerciseId;
    if (exerciseId == null) return;
    final reps = int.tryParse(_repsController.text.trim());
    final weight = num.tryParse(_weightController.text.trim());
    final rpe = num.tryParse(_rpeController.text.trim());
    final notes = _notesController.text.trim();

    context.read<ActiveWorkoutBloc>().add(
      ActiveWorkoutSetLogged(
        exerciseId: exerciseId,
        repsCompleted: reps,
        weightLiftedKg: weight,
        rpeScore: rpe,
        notes: notes.isEmpty ? null : notes,
      ),
    );
    _notesController.clear();
  }

  Future<void> _skip() async {
    final exerciseId = _selectedExerciseId;
    if (exerciseId == null) return;

    final result = await SkipReasonDialog.show(context);
    if (result == null || !mounted) return;

    context.read<ActiveWorkoutBloc>().add(
      ActiveWorkoutSetSkipped(
        exerciseId: exerciseId,
        reason: result.reason,
        comment: result.comment,
      ),
    );
  }

  Future<void> _editSet(BuildContext context, WorkoutSessionSet set) async {
    final result = await _showSetFieldsSheet(
      context,
      title: WorkoutStrings.editSet,
      initialReps: set.repsCompleted,
      initialWeightKg: set.weightLiftedKg,
      initialRpe: set.rpeScore,
      initialNotes: set.notes,
    );
    if (result == null || !context.mounted) return;
    context.read<ActiveWorkoutBloc>().add(
      ActiveWorkoutSetEdited(
        setId: set.id,
        reps: result.reps,
        weightKg: result.weightKg,
        rpe: result.rpe,
        notes: result.notes,
      ),
    );
  }

  Future<void> _deleteSet(BuildContext context, WorkoutSessionSet set) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(WorkoutStrings.deleteSet),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(WorkoutStrings.completeConfirmCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(WorkoutStrings.deleteSet),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    context.read<ActiveWorkoutBloc>().add(ActiveWorkoutSetDeleted(set.id));
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final exercises = state.planExercises;
    final currentExercise = state.selectedPlanExercise;
    final currentExerciseId = _selectedExerciseId;
    final theme = Theme.of(context);
    final nextSetNumber = currentExerciseId == null
        ? 1
        : state.nextSetNumberFor(currentExerciseId);
    final isTimerActive = context.watch<RestTimerCubit>().state.isRunning;
    final isFuture = state.isFutureExercise(currentExerciseId);
    final currentExerciseLoggedCount = currentExerciseId == null
        ? 0
        : state.loggedSets.where((s) => s.exerciseId == currentExerciseId).length;
    final targetSets = currentExercise?.targetSets;
    final isExerciseCompleted = targetSets != null && currentExerciseLoggedCount >= targetSets;
    final canCompleteWorkout = state.areAllPlannedExercisesCompleted;

    return BlocListener<RestTimerCubit, RestTimerState>(
      listenWhen: (previous, current) =>
          !previous.isFinished && current.isFinished && current.totalSeconds > 0,
      listener: (context, timerState) async {
        final exId = _selectedExerciseId;
        if (exId == null) return;
        final currentSetNum = state.nextSetNumberFor(exId);
        final totalSets = currentExercise?.targetSets;
        final nextExercise = state.nextPlanExercise;
        final isLastExercise = currentExercise != null &&
            exercises.isNotEmpty &&
            exercises.last.exerciseId == currentExercise.exerciseId;

        final action = await PostRestPromptSheet.show(
          context,
          currentExercise: currentExercise,
          currentSetNumber: currentSetNum,
          totalSets: totalSets,
          nextExercise: nextExercise,
          isLastExercise: isLastExercise,
        );

        if (!context.mounted || action == null) return;

        switch (action) {
          case PostRestAction.startNextSet:
            context.read<RestTimerCubit>().cancel();
            break;
          case PostRestAction.nextExercise:
            if (nextExercise != null) {
              context.read<ActiveWorkoutBloc>().add(
                ActiveWorkoutExerciseSelected(nextExercise.exerciseId),
              );
            }
            context.read<RestTimerCubit>().cancel();
            break;
          case PostRestAction.addMoreRest:
            context.read<RestTimerCubit>().addSeconds(30);
            break;
          case PostRestAction.completeWorkout:
            context.read<RestTimerCubit>().cancel();
            _confirmComplete(context);
            break;
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 840;

          // Widget: Exercise Navigation / Selector List
          final exerciseNavSection = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                WorkoutStrings.exercisesSection,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (exercises.isNotEmpty)
                for (final e in exercises) _ExerciseChoice(exercise: e, state: state)
              else
                ExercisePickerField(
                  selectedExercise: _selectedFreeExercise,
                  onChanged: (picked) {
                    setState(() => _selectedFreeExercise = picked);
                  },
                ),
            ],
          );

          // Widget: Session Actions (Complete Session button)
          final sessionActionSection = FilledButton.tonal(
            onPressed: canCompleteWorkout &&
                    !state.logging &&
                    state.status != LoadStatus.loading
                ? () => _confirmComplete(context)
                : null,
            child: Text(
              canCompleteWorkout
                  ? WorkoutStrings.completeSession
                  : 'Complete Workout (Complete all planned exercises first)',
            ),
          );

          // Widget: Active Exercise Focus & Details
          final activeExerciseCard = currentExercise != null
              ? Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ACTIVE EXERCISE',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currentExercise.exerciseName ??
                                        'Exercise #${currentExercise.exerciseId}',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.comment_outlined),
                              tooltip: 'Exercise Comments',
                              onPressed: () => SessionCommentsSheet.show(
                                context,
                                entityType: 'exercise',
                                entityId: currentExercise.exerciseId,
                                title: currentExercise.exerciseName ??
                                    'Exercise #${currentExercise.exerciseId}',
                              ),
                            ),
                            IconButton.filledTonal(
                              icon: const Icon(Icons.history),
                              tooltip: WorkoutStrings.exerciseHistoryTitle,
                              onPressed: () => ExerciseHistorySheet.show(
                                context,
                                memberId: widget.memberId,
                                exerciseId: currentExercise.exerciseId,
                                exerciseName: currentExercise.exerciseName,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            if (currentExercise.targetSets != null)
                              Chip(
                                label: Text(
                                  'Target: ${currentExercise.targetSets} sets',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            if (currentExercise.targetReps != null)
                              Chip(
                                label: Text(
                                  '${currentExercise.targetReps} reps',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            if (currentExercise.targetWeightKg != null)
                              Chip(
                                label: Text(
                                  '${currentExercise.targetWeightKg} kg',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink();

          // Widget: Set Form or Locked / Completed Cards
          final setFormSection = isFuture
              ? Card(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 36,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Future Exercise Locked',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You can preview details, but cannot log sets until preceding exercises are completed.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : isExerciseCompleted
                  ? Card(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 36,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'All Prescribed Sets Completed',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'All $targetSets prescribed sets have been logged or skipped. Proceed to the next exercise or complete your session.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Set Details (Set #$nextSetNumber${targetSets != null ? ' of $targetSets' : ''})',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Weight Stepper Row
                            Row(
                              children: [
                                IconButton.filledTonal(
                                  onPressed: isTimerActive ? null : () => _adjustWeight(-2.5),
                                  icon: const Icon(Icons.remove),
                                  tooltip: '-2.5 kg',
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _weightController,
                                    enabled: !isTimerActive,
                                    decoration: const InputDecoration(
                                      labelText: WorkoutStrings.weightLabel,
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton.filledTonal(
                                  onPressed: isTimerActive ? null : () => _adjustWeight(2.5),
                                  icon: const Icon(Icons.add),
                                  tooltip: '+2.5 kg',
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Reps Stepper Row
                            Row(
                              children: [
                                IconButton.filledTonal(
                                  onPressed: isTimerActive ? null : () => _adjustReps(-1),
                                  icon: const Icon(Icons.remove),
                                  tooltip: '-1 rep',
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _repsController,
                                    enabled: !isTimerActive,
                                    decoration: const InputDecoration(
                                      labelText: WorkoutStrings.repsLabel,
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton.filledTonal(
                                  onPressed: isTimerActive ? null : () => _adjustReps(1),
                                  icon: const Icon(Icons.add),
                                  tooltip: '+1 rep',
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // RPE Row
                            TextField(
                              controller: _rpeController,
                              enabled: !isTimerActive,
                              decoration: const InputDecoration(
                                labelText: WorkoutStrings.rpeLabel,
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Notes Row
                            TextField(
                              controller: _notesController,
                              enabled: !isTimerActive,
                              decoration: const InputDecoration(
                                labelText: WorkoutStrings.setNotesLabel,
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            if (isTimerActive)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  'Rest timer in progress — tap "Skip" or wait for timer to finish before logging the next set.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.error,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                            // Actions: Done & Skip
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.skip_next_outlined),
                                    label: const Text(WorkoutStrings.skipSet),
                                    onPressed: isTimerActive ||
                                            state.logging ||
                                            state.status == LoadStatus.loading ||
                                            _selectedExerciseId == null
                                        ? null
                                        : _skip,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: FilledButton.icon(
                                    icon: const Icon(Icons.check_circle_outline),
                                    label: Text(
                                      state.logging
                                          ? '…'
                                          : '${WorkoutStrings.done} · Set #$nextSetNumber',
                                    ),
                                    onPressed: isTimerActive ||
                                            state.logging ||
                                            state.status == LoadStatus.loading ||
                                            _selectedExerciseId == null
                                        ? null
                                        : _submit,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );

          // Widget: Logged Sets List
          final loggedSetsSection = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                WorkoutStrings.loggedSetsSection,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (state.loggedSets.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('— No sets logged yet —'),
                )
              else
                for (final s in state.loggedSets.reversed)
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: s.isCompleted == false
                            ? theme.colorScheme.errorContainer
                            : theme.colorScheme.primaryContainer,
                        child: Text(
                          '#${s.setNumber}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: s.isCompleted == false
                                ? theme.colorScheme.onErrorContainer
                                : theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      title: Text(
                        _exerciseNameFor(s.exerciseId, exercises),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (s.isCompleted == false) ...[
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.errorContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Skipped',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.colorScheme.onErrorContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (s.notes != null && s.notes!.isNotEmpty)
                              Text(
                                s.notes!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ] else ...[
                            Text(
                              WorkoutStrings.setLoggedLine(
                                setNumber: s.setNumber,
                                reps: s.repsCompleted,
                                weight: s.weightLiftedKg,
                              ),
                            ),
                            if (s.rpeScore != null)
                              Text(
                                'RPE: ${s.rpeScore}',
                                style: theme.textTheme.bodySmall,
                              ),
                            if (s.notes != null && s.notes!.isNotEmpty)
                              Text(
                                'Note: ${s.notes}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.comment_outlined, size: 18),
                            tooltip: 'Set Comments',
                            onPressed: () => SessionCommentsSheet.show(
                              context,
                              entityType: 'set',
                              entityId: s.id,
                              title: 'Set #${s.setNumber} (${_exerciseNameFor(s.exerciseId, exercises)})',
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _editSet(context, s);
                              } else if (value == 'delete') {
                                _deleteSet(context, s);
                              }
                            },
                            itemBuilder: (menuContext) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text(WorkoutStrings.editSet),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text(WorkoutStrings.deleteSet),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          );

          if (isWide) {
            // Adaptive Two-Column Layout for Desktop & Tablet Cockpit
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Pane: Rest Timer + Exercises Navigator + Session Completion
                  SizedBox(
                    width: 340,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_errorText(state) != null) ...[
                            Text(
                              _errorText(state)!,
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
                            const SizedBox(height: 8),
                          ],
                          const RestTimerWidget(),
                          const SizedBox(height: 16),
                          exerciseNavSection,
                          const SizedBox(height: 24),
                          sessionActionSection,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const VerticalDivider(width: 1),
                  const SizedBox(width: 16),
                  // Right Pane: Active Exercise Hero + Set Logging Steppers + Logged Sets Stream
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          activeExerciseCard,
                          const SizedBox(height: 16),
                          setFormSection,
                          const SizedBox(height: 24),
                          loggedSetsSection,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Compact Single-Column Layout (Mobile & small foldables)
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_errorText(state) != null) ...[
                        Text(
                          _errorText(state)!,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                        const SizedBox(height: 8),
                      ],
                      const RestTimerWidget(),
                      const SizedBox(height: 12),
                      activeExerciseCard,
                      const SizedBox(height: 16),
                      exerciseNavSection,
                      const SizedBox(height: 16),
                      setFormSection,
                      const SizedBox(height: 24),
                      loggedSetsSection,
                      const SizedBox(height: 24),
                      sessionActionSection,
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _exerciseNameFor(String exerciseId, List<WorkoutPlanExercise> planExs) {
    for (final e in planExs) {
      if (e.exerciseId == exerciseId && e.exerciseName != null) {
        return e.exerciseName!;
      }
    }
    return 'Exercise #$exerciseId';
  }

  Future<void> _confirmComplete(BuildContext context) async {
    final notesController = TextEditingController();
    var rating = 0;
    final feedback = await showDialog<_CompleteFeedback>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(WorkoutStrings.completeConfirmTitle),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(WorkoutStrings.completeConfirmMessage),
                    const SizedBox(height: 16),
                    const Text(WorkoutStrings.ratingLabel),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 1; i <= 5; i++)
                          IconButton(
                            onPressed: () => setDialogState(() => rating = i),
                            icon: Icon(
                              i <= rating ? Icons.star : Icons.star_border,
                            ),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: WorkoutStrings.notesLabel,
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(WorkoutStrings.completeConfirmCancel),
                ),
                FilledButton(
                  onPressed: () {
                    final raw = notesController.text.trim();
                    Navigator.of(dialogContext).pop(
                      _CompleteFeedback(
                        notes: raw.isEmpty ? null : raw,
                        rating: rating == 0 ? null : rating,
                      ),
                    );
                  },
                  child: const Text(WorkoutStrings.completeConfirmAction),
                ),
              ],
            );
          },
        );
      },
    );
    notesController.dispose();
    if (feedback == null || !context.mounted) return;
    context.read<ActiveWorkoutBloc>().add(
      ActiveWorkoutCompletionRequested(
        notes: feedback.notes,
        clientFeedbackRating: feedback.rating,
      ),
    );
  }
}

Future<_SetFieldsResult?> _showSetFieldsSheet(
  BuildContext context, {
  required String title,
  int? initialReps,
  num? initialWeightKg,
  num? initialRpe,
  String? initialNotes,
}) {
  final repsController = TextEditingController(
    text: initialReps?.toString() ?? '',
  );
  final weightController = TextEditingController(
    text: initialWeightKg?.toString() ?? '',
  );
  final rpeController = TextEditingController(
    text: initialRpe?.toString() ?? '',
  );
  final notesController = TextEditingController(
    text: initialNotes ?? '',
  );

  return showModalBottomSheet<_SetFieldsResult>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(sheetContext).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: repsController,
              decoration: const InputDecoration(
                labelText: WorkoutStrings.repsLabel,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(
                labelText: WorkoutStrings.weightLabel,
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: rpeController,
              decoration: const InputDecoration(
                labelText: WorkoutStrings.rpeLabel,
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: WorkoutStrings.notesLabel,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final notes = notesController.text.trim();
                Navigator.of(sheetContext).pop(
                  _SetFieldsResult(
                    reps: int.tryParse(repsController.text.trim()),
                    weightKg: num.tryParse(weightController.text.trim()),
                    rpe: num.tryParse(rpeController.text.trim()),
                    notes: notes.isEmpty ? null : notes,
                  ),
                );
              },
              child: const Text(WorkoutStrings.save),
            ),
          ],
        ),
      );
    },
  );
}

class _ExerciseChoice extends StatelessWidget {
  const _ExerciseChoice({required this.exercise, required this.state});

  final WorkoutPlanExercise exercise;
  final ActiveWorkoutState state;

  @override
  Widget build(BuildContext context) {
    final selected = state.selectedExerciseId == exercise.exerciseId;
    final isFuture = state.isFutureExercise(exercise.exerciseId);
    final logged = state.loggedSets
        .where((s) => s.exerciseId == exercise.exerciseId)
        .length;
    final target = exercise.targetSets;
    final isDone = target != null && logged >= target;

    Widget? trailing;
    if (selected) {
      trailing = const Icon(Icons.check_circle);
    } else if (isDone) {
      trailing = const Icon(Icons.done_all, color: Colors.green);
    } else if (isFuture) {
      trailing = const Icon(Icons.lock_outline, size: 20, color: Colors.grey);
    }

    return ListTile(
      selected: selected,
      onTap: () => context.read<ActiveWorkoutBloc>().add(
        ActiveWorkoutExerciseSelected(exercise.exerciseId),
      ),
      title: Text(exercise.exerciseName ?? 'Exercise #${exercise.exerciseId}'),
      subtitle: Text(
        [
          WorkoutStrings.exerciseSubtitle(
            sets: exercise.targetSets,
            reps: exercise.targetReps,
          ),
          if (target != null) '$logged/$target logged',
          if (isFuture) 'Locked (Upcoming)',
        ].where((s) => s.isNotEmpty).join(' · '),
      ),
      trailing: trailing,
    );
  }
}

class _CompletedPanel extends StatelessWidget {
  const _CompletedPanel({
    required this.session,
    required this.loggedSetCount,
    required this.historyPath,
  });

  final WorkoutSession session;
  final int loggedSetCount;
  final String historyPath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                WorkoutStrings.sessionCompleted,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              if (session.durationMinutes != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(WorkoutStrings.durationLabel),
                  subtitle: Text(
                    WorkoutStrings.durationMinutes(session.durationMinutes!),
                  ),
                ),
              if (session.totalVolumeKg != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(WorkoutStrings.volumeLabel),
                  subtitle: Text(WorkoutStrings.volumeKg(session.totalVolumeKg!)),
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(WorkoutStrings.setsLoggedLabel),
                subtitle: Text(WorkoutStrings.setsLoggedCount(loggedSetCount)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(WorkoutStrings.startedAtLabel),
                subtitle: Text(WorkoutStrings.sessionTime(session.startedAt)),
              ),
              if (session.completedAt != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(WorkoutStrings.completedAtLabel),
                  subtitle: Text(WorkoutStrings.sessionTime(session.completedAt!)),
                ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.read<ActiveWorkoutBloc>().add(
                  const ActiveWorkoutReset(),
                ),
                child: const Text(WorkoutStrings.startAnother),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => context.go(historyPath),
                child: const Text(WorkoutStrings.viewHistory),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
