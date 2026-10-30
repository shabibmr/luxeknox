import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/router/session_route_ids.dart';
import '../../../../core/widgets/adaptive_shell.dart';
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
import '../widgets/post_workout_feedback_modal.dart';

const _wideSessionWidth = 840.0;
const _sessionColumnKey = ValueKey<String>('active-workout-column');

String? _errorText(ActiveWorkoutState state) {
  if (state.message != null && state.message!.isNotEmpty) return state.message;
  final failure = state.failure;
  if (failure == null) return null;
  return failureMessage(failure);
}

class _SetFieldsResult {
  const _SetFieldsResult({
    this.reps,
    this.weightKg,
    this.rpe,
    this.rir,
    this.durationSeconds,
    this.notes,
  });

  final int? reps;
  final num? weightKg;
  final num? rpe;
  final num? rir;
  final int? durationSeconds;
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
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
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
                                icon: const Icon(
                                  Icons.comment_outlined,
                                  size: 20,
                                ),
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
                          for (
                            var i = 0;
                            i < _selectedPlan!.exercises.length;
                            i++
                          )
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
                                        color: theme
                                            .colorScheme
                                            .onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _selectedPlan!
                                              .exercises[i]
                                              .exerciseName ??
                                          'Exercise #${_selectedPlan!.exercises[i].exerciseId}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    [
                                      if (_selectedPlan!
                                              .exercises[i]
                                              .targetSets !=
                                          null)
                                        '${_selectedPlan!.exercises[i].targetSets} sets',
                                      if (_selectedPlan!
                                              .exercises[i]
                                              .targetReps !=
                                          null)
                                        '${_selectedPlan!.exercises[i].targetReps} reps',
                                      if (_selectedPlan!
                                              .exercises[i]
                                              .targetWeightKg !=
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
  final _rirController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();
  Exercise? _selectedFreeExercise;
  String? _lastSyncedExerciseId;
  bool _isDurationMode = false;
  int _stopwatchSeconds = 0;
  Timer? _stopwatchTimer;
  bool _isStopwatchRunning = false;

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
        _weightController.text = w % 1 == 0
            ? w.toInt().toString()
            : w.toString();
      } else if (planEx.targetWeightKg != null) {
        final w = planEx.targetWeightKg!;
        _weightController.text = w % 1 == 0
            ? w.toInt().toString()
            : w.toString();
      } else {
        _weightController.text = '';
      }

      if (planEx.targetReps != null && planEx.targetReps!.isNotEmpty) {
        _repsController.text = planEx.targetReps!;
      } else {
        _repsController.text = '';
      }

      _rpeController.text = '';
      if (planEx.targetRir != null) {
        _rirController.text = planEx.targetRir.toString();
      } else {
        _rirController.text = '';
      }
      if (planEx.targetDurationSeconds != null) {
        _durationController.text = planEx.targetDurationSeconds.toString();
        _isDurationMode = true;
      } else {
        _durationController.text = '';
      }
      _stopwatchSeconds = 0;
      _stopwatchTimer?.cancel();
      _isStopwatchRunning = false;
    }
  }

  @override
  void dispose() {
    _stopwatchTimer?.cancel();
    _repsController.dispose();
    _weightController.dispose();
    _rpeController.dispose();
    _rirController.dispose();
    _durationController.dispose();
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
    _weightController.text = updated % 1 == 0
        ? updated.toInt().toString()
        : updated.toStringAsFixed(1);
  }

  void _adjustReps(int delta) {
    final current = int.tryParse(_repsController.text.trim()) ?? 0;
    final updated = current + delta;
    if (updated < 0) return;
    _repsController.text = updated.toString();
  }

  void _adjustRir(num delta) {
    final current = num.tryParse(_rirController.text.trim()) ?? 0;
    final updated = (current + delta).clamp(0, 10);
    _rirController.text = updated % 1 == 0
        ? updated.toInt().toString()
        : updated.toString();
  }

  void _adjustDuration(int delta) {
    final current =
        int.tryParse(_durationController.text.trim()) ?? _stopwatchSeconds;
    final updated = (current + delta).clamp(0, 3600);
    _durationController.text = updated.toString();
    setState(() {
      _stopwatchSeconds = updated;
    });
  }

  void _toggleStopwatch() {
    if (_isStopwatchRunning) {
      _stopwatchTimer?.cancel();
      setState(() => _isStopwatchRunning = false);
    } else {
      _stopwatchTimer?.cancel();
      _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _stopwatchSeconds++;
          _durationController.text = _stopwatchSeconds.toString();
        });
      });
      setState(() => _isStopwatchRunning = true);
    }
  }

  void _resetStopwatch() {
    _stopwatchTimer?.cancel();
    setState(() {
      _isStopwatchRunning = false;
      _stopwatchSeconds = 0;
      _durationController.text = '';
    });
  }

  void _submit() {
    final exerciseId = _selectedExerciseId;
    if (exerciseId == null) return;
    final reps = int.tryParse(_repsController.text.trim());
    final weight = num.tryParse(_weightController.text.trim());
    final rpe = num.tryParse(_rpeController.text.trim());
    final rir = num.tryParse(_rirController.text.trim());
    final duration = _isDurationMode
        ? (int.tryParse(_durationController.text.trim()) ??
              (_stopwatchSeconds > 0 ? _stopwatchSeconds : null))
        : int.tryParse(_durationController.text.trim());
    final notes = _notesController.text.trim();

    context.read<ActiveWorkoutBloc>().add(
      ActiveWorkoutSetLogged(
        exerciseId: exerciseId,
        repsCompleted: reps,
        weightLiftedKg: weight,
        rpeScore: rpe,
        actualRir: rir,
        actualDurationSeconds: duration,
        notes: notes.isEmpty ? null : notes,
      ),
    );
    _notesController.clear();
    _rirController.clear();
    _durationController.clear();
    _resetStopwatch();
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
      initialRir: set.actualRirNum,
      initialDurationSeconds: set.actualDurationSeconds,
      initialNotes: set.notes,
    );
    if (result == null || !context.mounted) return;
    context.read<ActiveWorkoutBloc>().add(
      ActiveWorkoutSetEdited(
        setId: set.id,
        reps: result.reps,
        weightKg: result.weightKg,
        rpe: result.rpe,
        actualRir: result.rir,
        actualDurationSeconds: result.durationSeconds,
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
        : state.loggedSets
              .where((s) => s.exerciseId == currentExerciseId)
              .length;
    final targetSets = currentExercise?.targetSets;
    final isExerciseCompleted =
        targetSets != null && currentExerciseLoggedCount >= targetSets;
    final canCompleteWorkout = state.areAllPlannedExercisesCompleted;

    return BlocListener<RestTimerCubit, RestTimerState>(
      listenWhen: (previous, current) =>
          !previous.isFinished &&
          current.isFinished &&
          current.totalSeconds > 0,
      listener: (context, timerState) async {
        final exId = _selectedExerciseId;
        if (exId == null) return;
        final currentSetNum = state.nextSetNumberFor(exId);
        final totalSets = currentExercise?.targetSets;
        final nextExercise = state.nextPlanExercise;
        final isLastExercise =
            currentExercise != null &&
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
          final isWide = constraints.maxWidth >= _wideSessionWidth;
          final isPhone =
              constraints.maxWidth < AdaptiveShellBreakpoints.compact;

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
                for (final e in exercises)
                  _ExerciseChoice(exercise: e, state: state)
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
            onPressed:
                canCompleteWorkout &&
                    !state.logging &&
                    state.status != LoadStatus.loading
                ? () => _confirmComplete(context)
                : null,
            child: Text(
              canCompleteWorkout
                  ? WorkoutStrings.completeSession
                  : 'Complete Workout (Complete all planned exercises first)',
              textAlign: TextAlign.center,
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
                                title:
                                    currentExercise.exerciseName ??
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
                              _metricChip(
                                'Target: ${currentExercise.targetSets} sets',
                                constraints.maxWidth,
                              ),
                            if (currentExercise.targetReps != null)
                              _metricChip(
                                '${currentExercise.targetReps} reps',
                                constraints.maxWidth,
                              ),
                            if (currentExercise.targetWeightKg != null)
                              _metricChip(
                                '${currentExercise.targetWeightKg} kg',
                                constraints.maxWidth,
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
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
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
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.3,
                  ),
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
                              onPressed: isTimerActive
                                  ? null
                                  : () => _adjustWeight(-2.5),
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
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filledTonal(
                              onPressed: isTimerActive
                                  ? null
                                  : () => _adjustWeight(2.5),
                              icon: const Icon(Icons.add),
                              tooltip: '+2.5 kg',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Mode Toggle: Reps vs Timed / Stopwatch
                        SegmentedButton<bool>(
                          key: const ValueKey('timed-mode-toggle'),
                          segments: const [
                            ButtonSegment<bool>(
                              value: false,
                              label: Text(WorkoutStrings.timedModeToggleReps),
                              icon: Icon(Icons.repeat),
                            ),
                            ButtonSegment<bool>(
                              value: true,
                              label: Text(
                                WorkoutStrings.timedModeToggleDuration,
                              ),
                              icon: Icon(Icons.timer_outlined),
                            ),
                          ],
                          selected: {_isDurationMode},
                          onSelectionChanged: (set) =>
                              setState(() => _isDurationMode = set.first),
                        ),
                        const SizedBox(height: 12),

                        if (!_isDurationMode) ...[
                          // Reps Stepper Row
                          Row(
                            children: [
                              IconButton.filledTonal(
                                onPressed: isTimerActive
                                    ? null
                                    : () => _adjustReps(-1),
                                icon: const Icon(Icons.remove),
                                tooltip: '-1 rep',
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  key: const ValueKey('set-reps-field'),
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
                                onPressed: isTimerActive
                                    ? null
                                    : () => _adjustReps(1),
                                icon: const Icon(Icons.add),
                                tooltip: '+1 rep',
                              ),
                            ],
                          ),
                        ] else ...[
                          // Stopwatch Card & Duration Stepper
                          Card(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.timer_outlined,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${_stopwatchSeconds}s',
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      FilledButton.tonalIcon(
                                        key: const ValueKey(
                                          'stopwatch-toggle-btn',
                                        ),
                                        onPressed: isTimerActive
                                            ? null
                                            : _toggleStopwatch,
                                        icon: Icon(
                                          _isStopwatchRunning
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                        ),
                                        label: Text(
                                          _isStopwatchRunning
                                              ? WorkoutStrings.stopwatchStop
                                              : WorkoutStrings.stopwatchStart,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        key: const ValueKey(
                                          'stopwatch-reset-btn',
                                        ),
                                        tooltip: WorkoutStrings.stopwatchReset,
                                        onPressed: isTimerActive
                                            ? null
                                            : _resetStopwatch,
                                        icon: const Icon(Icons.refresh),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              IconButton.filledTonal(
                                onPressed: isTimerActive
                                    ? null
                                    : () => _adjustDuration(-5),
                                icon: const Icon(Icons.remove),
                                tooltip: '-5s',
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  key: const ValueKey('set-duration-field'),
                                  controller: _durationController,
                                  enabled: !isTimerActive,
                                  decoration: const InputDecoration(
                                    labelText:
                                        WorkoutStrings.durationSecondsLabel,
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
                                onPressed: isTimerActive
                                    ? null
                                    : () => _adjustDuration(5),
                                icon: const Icon(Icons.add),
                                tooltip: '+5s',
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),

                        // RIR Stepper Row
                        Row(
                          children: [
                            IconButton.filledTonal(
                              onPressed: isTimerActive
                                  ? null
                                  : () => _adjustRir(-1),
                              icon: const Icon(Icons.remove),
                              tooltip: '-1 RIR',
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                key: const ValueKey('set-rir-field'),
                                controller: _rirController,
                                enabled: !isTimerActive,
                                decoration: const InputDecoration(
                                  labelText: WorkoutStrings.actualRirLabel,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filledTonal(
                              onPressed: isTimerActive
                                  ? null
                                  : () => _adjustRir(1),
                              icon: const Icon(Icons.add),
                              tooltip: '+1 RIR',
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
                              child: OutlinedButton(
                                onPressed:
                                    isTimerActive ||
                                        state.logging ||
                                        state.status == LoadStatus.loading ||
                                        _selectedExerciseId == null
                                    ? null
                                    : _skip,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.skip_next_outlined),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        WorkoutStrings.skipSet,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: FilledButton(
                                onPressed:
                                    isTimerActive ||
                                        state.logging ||
                                        state.status == LoadStatus.loading ||
                                        _selectedExerciseId == null
                                    ? null
                                    : _submit,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle_outline),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        state.logging
                                            ? '…'
                                            : '${WorkoutStrings.done} · Set #$nextSetNumber',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
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
                      leading: isPhone
                          ? null
                          : CircleAvatar(
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
                        isPhone
                            ? (s.isCompleted == false
                                  ? WorkoutStrings.skippedSetLine(s.setNumber)
                                  : WorkoutStrings.setLoggedLine(
                                      setNumber: s.setNumber,
                                      reps: s.repsCompleted,
                                      weight: s.weightLiftedKg,
                                    ))
                            : _exerciseNameFor(s.exerciseId, exercises),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: isPhone
                          ? _phoneLoggedDetail(s, theme)
                          : Column(
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
                                          color:
                                              theme.colorScheme.errorContainer,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          'Skipped',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: theme
                                                .colorScheme
                                                .onErrorContainer,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (s.notes != null && s.notes!.isNotEmpty)
                                    Text(
                                      s.notes!,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
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
                                  if (s.actualRir != null &&
                                      s.actualRir!.isNotEmpty)
                                    Text(
                                      'RIR: ${s.actualRir}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  if (s.actualDurationSeconds != null)
                                    Text(
                                      'Duration: ${s.actualDurationSeconds}s',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  if (s.notes != null && s.notes!.isNotEmpty)
                                    Text(
                                      'Note: ${s.notes}',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            fontStyle: FontStyle.italic,
                                          ),
                                    ),
                                ],
                              ],
                            ),
                      trailing: isPhone
                          ? PopupMenuButton<String>(
                              tooltip: WorkoutStrings.setActions,
                              onSelected: (value) {
                                if (value == 'comments') {
                                  _showSetComments(context, s, exercises);
                                } else if (value == 'edit') {
                                  _editSet(context, s);
                                } else if (value == 'delete') {
                                  _deleteSet(context, s);
                                }
                              },
                              itemBuilder: (menuContext) => const [
                                PopupMenuItem(
                                  value: 'comments',
                                  child: Text(WorkoutStrings.setComments),
                                ),
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text(WorkoutStrings.editSet),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text(WorkoutStrings.deleteSet),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.comment_outlined,
                                    size: 18,
                                  ),
                                  tooltip: 'Set Comments',
                                  onPressed: () =>
                                      _showSetComments(context, s, exercises),
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

          final canLog =
              !isTimerActive &&
              !state.logging &&
              state.status != LoadStatus.loading &&
              _selectedExerciseId != null;
          final targetLine = currentExercise == null
              ? ''
              : WorkoutStrings.exerciseTargetLine(
                  sets: currentExercise.targetSets,
                  reps: currentExercise.targetReps,
                  weightKg: currentExercise.targetWeightKg,
                );

          if (isPhone) {
            return ListView(
              key: _sessionColumnKey,
              padding: const EdgeInsets.all(16),
              children: [
                if (_errorText(state) != null) ...[
                  Text(
                    _errorText(state)!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  const SizedBox(height: 8),
                ],
                if (isTimerActive) ...[
                  const RestTimerWidget(),
                  const SizedBox(height: 12),
                ],
                if (currentExercise != null) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentExercise.exerciseName ??
                                  'Exercise #${currentExercise.exerciseId}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (targetLine.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                targetLine,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        tooltip: WorkoutStrings.moreExerciseActions,
                        onSelected: (value) {
                          switch (value) {
                            case 'comments':
                              SessionCommentsSheet.show(
                                context,
                                entityType: 'exercise',
                                entityId: currentExercise.exerciseId,
                                title:
                                    currentExercise.exerciseName ??
                                    'Exercise #${currentExercise.exerciseId}',
                              );
                            case 'history':
                              ExerciseHistorySheet.show(
                                context,
                                memberId: widget.memberId,
                                exerciseId: currentExercise.exerciseId,
                                exerciseName: currentExercise.exerciseName,
                              );
                            case 'skip':
                              _skip();
                          }
                        },
                        itemBuilder: (menuContext) => [
                          const PopupMenuItem(
                            value: 'comments',
                            child: Text(WorkoutStrings.exerciseComments),
                          ),
                          const PopupMenuItem(
                            value: 'history',
                            child: Text(WorkoutStrings.exerciseHistoryTitle),
                          ),
                          PopupMenuItem(
                            value: 'skip',
                            enabled:
                                canLog && !isFuture && !isExerciseCompleted,
                            child: const Text(WorkoutStrings.skipSet),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ] else if (exercises.isEmpty) ...[
                  ExercisePickerField(
                    selectedExercise: _selectedFreeExercise,
                    onChanged: (picked) {
                      setState(() => _selectedFreeExercise = picked);
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                if (isFuture)
                  const Text(WorkoutStrings.futureExerciseLocked)
                else if (isExerciseCompleted)
                  const Text(WorkoutStrings.allPrescribedSetsDone)
                else ...[
                  _stepperRow(
                    onDecrement: isTimerActive
                        ? null
                        : () => _adjustWeight(-2.5),
                    onIncrement: isTimerActive
                        ? null
                        : () => _adjustWeight(2.5),
                    decrementTooltip: '-2.5 kg',
                    incrementTooltip: '+2.5 kg',
                    field: TextField(
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
                  const SizedBox(height: 12),
                  SegmentedButton<bool>(
                    key: const ValueKey('timed-mode-toggle-phone'),
                    segments: const [
                      ButtonSegment<bool>(
                        value: false,
                        label: Text(WorkoutStrings.timedModeToggleReps),
                        icon: Icon(Icons.repeat),
                      ),
                      ButtonSegment<bool>(
                        value: true,
                        label: Text(WorkoutStrings.timedModeToggleDuration),
                        icon: Icon(Icons.timer_outlined),
                      ),
                    ],
                    selected: {_isDurationMode},
                    onSelectionChanged: (set) =>
                        setState(() => _isDurationMode = set.first),
                  ),
                  const SizedBox(height: 12),
                  if (!_isDurationMode)
                    _stepperRow(
                      onDecrement: isTimerActive ? null : () => _adjustReps(-1),
                      onIncrement: isTimerActive ? null : () => _adjustReps(1),
                      decrementTooltip: '-1 rep',
                      incrementTooltip: '+1 rep',
                      field: TextField(
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
                    )
                  else ...[
                    Card(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_stopwatchSeconds}s',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                FilledButton.tonal(
                                  onPressed: isTimerActive
                                      ? null
                                      : _toggleStopwatch,
                                  child: Text(
                                    _isStopwatchRunning
                                        ? WorkoutStrings.stopwatchStop
                                        : WorkoutStrings.stopwatchStart,
                                  ),
                                ),
                                IconButton(
                                  tooltip: WorkoutStrings.stopwatchReset,
                                  onPressed: isTimerActive
                                      ? null
                                      : _resetStopwatch,
                                  icon: const Icon(Icons.refresh),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _stepperRow(
                      onDecrement: isTimerActive
                          ? null
                          : () => _adjustDuration(-5),
                      onIncrement: isTimerActive
                          ? null
                          : () => _adjustDuration(5),
                      decrementTooltip: '-5s',
                      incrementTooltip: '+5s',
                      field: TextField(
                        controller: _durationController,
                        enabled: !isTimerActive,
                        decoration: const InputDecoration(
                          labelText: WorkoutStrings.durationSecondsLabel,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  _stepperRow(
                    onDecrement: isTimerActive ? null : () => _adjustRir(-1),
                    onIncrement: isTimerActive ? null : () => _adjustRir(1),
                    decrementTooltip: '-1 RIR',
                    incrementTooltip: '+1 RIR',
                    field: TextField(
                      controller: _rirController,
                      enabled: !isTimerActive,
                      decoration: const InputDecoration(
                        labelText: WorkoutStrings.actualRirLabel,
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
                  ExpansionTile(
                    title: const Text(WorkoutStrings.setDetails),
                    children: [
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
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: canLog ? _submit : null,
                    child: Text(
                      state.logging
                          ? '…'
                          : '${WorkoutStrings.done} · Set #$nextSetNumber',
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                loggedSetsSection,
                if (exercises.isNotEmpty)
                  ExpansionTile(
                    title: const Text(WorkoutStrings.exercisesSection),
                    children: [
                      for (final e in exercises)
                        _ExerciseChoice(exercise: e, state: state, phone: true),
                    ],
                  ),
                const SizedBox(height: 16),
                sessionActionSection,
              ],
            );
          }

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

          // Single column from the phone breakpoint up to the wide session.
          return ListView(
            key: _sessionColumnKey,
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

  void _showSetComments(
    BuildContext context,
    WorkoutSessionSet set,
    List<WorkoutPlanExercise> exercises,
  ) {
    SessionCommentsSheet.show(
      context,
      entityType: 'set',
      entityId: set.id,
      title:
          'Set #${set.setNumber} (${_exerciseNameFor(set.exerciseId, exercises)})',
    );
  }

  Widget? _phoneLoggedDetail(WorkoutSessionSet set, ThemeData theme) {
    final lines = <Widget>[];
    if (set.rpeScore != null) {
      lines.add(
        Text(
          'RPE: ${set.rpeScore}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
      );
    }
    if (set.actualRir != null && set.actualRir!.isNotEmpty) {
      lines.add(
        Text(
          'RIR: ${set.actualRir}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
      );
    }
    if (set.actualDurationSeconds != null) {
      lines.add(
        Text(
          'Duration: ${set.actualDurationSeconds}s',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
      );
    }
    if (set.notes != null && set.notes!.isNotEmpty) {
      lines.add(
        Text(
          set.isCompleted == false ? set.notes! : 'Note: ${set.notes}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            fontStyle: FontStyle.italic,
            color: set.isCompleted == false ? theme.colorScheme.error : null,
          ),
        ),
      );
    }
    if (lines.isEmpty) return null;
    if (lines.length == 1) return lines.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines,
    );
  }

  String _exerciseNameFor(
    String exerciseId,
    List<WorkoutPlanExercise> planExs,
  ) {
    for (final e in planExs) {
      if (e.exerciseId == exerciseId && e.exerciseName != null) {
        return e.exerciseName!;
      }
    }
    return 'Exercise #$exerciseId';
  }

  Future<void> _confirmComplete(BuildContext context) async {
    final result = await PostWorkoutFeedbackModal.show(context);
    if (result == null || !context.mounted) return;
    context.read<ActiveWorkoutBloc>().add(
      ActiveWorkoutCompletionRequested(
        notes: result.notes,
        clientFeedbackRating: result.satisfactionRating,
        effortRating: result.effortRating,
        satisfactionRating: result.satisfactionRating,
        painDiscomfortScore: result.painDiscomfortScore,
        painNotes: result.painNotes,
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
  num? initialRir,
  int? initialDurationSeconds,
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
  final rirController = TextEditingController(
    text: initialRir?.toString() ?? '',
  );
  final durationController = TextEditingController(
    text: initialDurationSeconds?.toString() ?? '',
  );
  final notesController = TextEditingController(text: initialNotes ?? '');

  return showModalBottomSheet<_SetFieldsResult>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      final inset = MediaQuery.viewInsetsOf(sheetContext).bottom;
      return Padding(
        padding: EdgeInsets.only(bottom: inset),
        child: ListView(
          key: const ValueKey('set-editor-scroll'),
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
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
              controller: rirController,
              decoration: const InputDecoration(
                labelText: WorkoutStrings.actualRirLabel,
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(
                labelText: WorkoutStrings.durationSecondsLabel,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
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
                    rir: num.tryParse(rirController.text.trim()),
                    durationSeconds: int.tryParse(
                      durationController.text.trim(),
                    ),
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

Widget _metricChip(String label, double maxWidth) {
  final width = maxWidth > 64 ? maxWidth - 64 : maxWidth;
  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: width),
    child: Chip(
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12),
      ),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    ),
  );
}

Widget _stepperRow({
  required VoidCallback? onDecrement,
  required VoidCallback? onIncrement,
  required String decrementTooltip,
  required String incrementTooltip,
  required Widget field,
}) {
  return Row(
    children: [
      IconButton.filledTonal(
        onPressed: onDecrement,
        icon: const Icon(Icons.remove),
        tooltip: decrementTooltip,
      ),
      const SizedBox(width: 8),
      Expanded(child: field),
      const SizedBox(width: 8),
      IconButton.filledTonal(
        onPressed: onIncrement,
        icon: const Icon(Icons.add),
        tooltip: incrementTooltip,
      ),
    ],
  );
}

class _ExerciseChoice extends StatelessWidget {
  const _ExerciseChoice({
    required this.exercise,
    required this.state,
    this.phone = false,
  });

  final WorkoutPlanExercise exercise;
  final ActiveWorkoutState state;
  final bool phone;

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

    final title = exercise.exerciseName ?? 'Exercise #${exercise.exerciseId}';
    final subtitle = phone
        ? WorkoutStrings.exerciseTargetLine(
            sets: exercise.targetSets,
            reps: exercise.targetReps,
            weightKg: exercise.targetWeightKg,
          )
        : [
            WorkoutStrings.exerciseSubtitle(
              sets: exercise.targetSets,
              reps: exercise.targetReps,
            ),
            if (target != null) '$logged/$target logged',
            if (isFuture) 'Locked (Upcoming)',
          ].where((s) => s.isNotEmpty).join(' · ');

    return ListTile(
      selected: selected,
      onTap: () => context.read<ActiveWorkoutBloc>().add(
        ActiveWorkoutExerciseSelected(exercise.exerciseId),
      ),
      title: Text(
        title,
        maxLines: phone ? 2 : 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle.isEmpty
          ? null
          : Text(
              subtitle,
              maxLines: phone ? 2 : 1,
              overflow: TextOverflow.ellipsis,
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
                  subtitle: Text(
                    WorkoutStrings.volumeKg(session.totalVolumeKg!),
                  ),
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
                  subtitle: Text(
                    WorkoutStrings.sessionTime(session.completedAt!),
                  ),
                ),
              if (session.effortRating != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(WorkoutStrings.effortRatingLabel),
                  subtitle: Text('${session.effortRating} / 10'),
                ),
              if (session.satisfactionRating != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(WorkoutStrings.satisfactionRatingLabel),
                  subtitle: Text('${session.satisfactionRating} / 10'),
                ),
              if (session.painDiscomfortScore != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(WorkoutStrings.painDiscomfortLabel),
                  subtitle: Text('${session.painDiscomfortScore} / 10'),
                ),
              if (session.painNotes != null && session.painNotes!.isNotEmpty)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(WorkoutStrings.painNotesLabel),
                  subtitle: Text(session.painNotes!),
                ),
              if (session.painDiscomfortScore != null &&
                  session.painDiscomfortScore! >= 4)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.errorContainer.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          WorkoutStrings.highDiscomfortAlert,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onErrorContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
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
