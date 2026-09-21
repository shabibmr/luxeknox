import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/router/session_route_ids.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/workout_plan_exercise.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/usecases/complete_workout_session_usecase.dart';
import '../../domain/usecases/get_workout_plan_usecase.dart';
import '../../domain/usecases/log_workout_set_usecase.dart';
import '../../domain/usecases/start_workout_session_usecase.dart';
import '../cubit/active_workout_cubit.dart';
import '../cubit/rest_timer_cubit.dart';
import '../widgets/rest_timer_widget.dart';
import '../workout_strings.dart';

class _CompleteFeedback {
  const _CompleteFeedback({this.notes, this.rating});

  final String? notes;
  final int? rating;
}

class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({super.key, this.workoutPlanId});

  final String? workoutPlanId;

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  late final RestTimerCubit _restTimer;
  late final ActiveWorkoutCubit _cubit;
  var _configured = false;

  @override
  void initState() {
    super.initState();
    _restTimer = RestTimerCubit();
    _cubit = ActiveWorkoutCubit(
      getIt<StartWorkoutSessionUseCase>(),
      getIt<LogWorkoutSetUseCase>(),
      getIt<CompleteWorkoutSessionUseCase>(),
      getIt<GetWorkoutPlanUseCase>(),
      _restTimer,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_configured) return;
    _configured = true;
    final memberId = sessionProfileId(context);
    if (memberId != null) {
      _cubit.configure(
        memberId: memberId.toString(),
        workoutPlanId: widget.workoutPlanId,
      );
    }
  }

  @override
  void dispose() {
    _cubit.close();
    _restTimer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RestTimerCubit>.value(value: _restTimer),
        BlocProvider<ActiveWorkoutCubit>.value(value: _cubit),
      ],
      child: const _ActiveWorkoutBody(),
    );
  }
}

class _ActiveWorkoutBody extends StatelessWidget {
  const _ActiveWorkoutBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(WorkoutStrings.activeTitle)),
      body: BlocBuilder<ActiveWorkoutCubit, ActiveWorkoutState>(
        builder: (context, state) {
          return switch (state) {
            ActiveWorkoutIdle() => _StartPanel(state: state),
            ActiveWorkoutStarting() ||
            ActiveWorkoutCompleting() =>
              const AppLoading(),
            ActiveWorkoutFailure(:final message, :final initialPlanId) =>
              _StartPanel(
                state: ActiveWorkoutIdle(
                  initialPlanId: initialPlanId,
                  message: message,
                ),
              ),
            ActiveWorkoutInProgress() => _InProgressPanel(state: state),
            ActiveWorkoutCompleted(
              :final session,
              :final loggedSetCount,
            ) =>
              _CompletedPanel(
                session: session,
                loggedSetCount: loggedSetCount,
              ),
          };
        },
      ),
    );
  }
}

class _StartPanel extends StatefulWidget {
  const _StartPanel({required this.state});

  final ActiveWorkoutIdle state;

  @override
  State<_StartPanel> createState() => _StartPanelState();
}

class _StartPanelState extends State<_StartPanel> {
  late final TextEditingController _planIdController;

  @override
  void initState() {
    super.initState();
    _planIdController = TextEditingController(
      text: widget.state.initialPlanId ?? '',
    );
  }

  @override
  void dispose() {
    _planIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memberId = sessionProfileId(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.state.message != null) ...[
            Text(
              widget.state.message!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 12),
          ],
          if (memberId == null)
            const Text(WorkoutStrings.missingMember)
          else ...[
            TextField(
              controller: _planIdController,
              decoration: const InputDecoration(
                labelText: WorkoutStrings.planIdLabel,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final raw = _planIdController.text.trim();
                context.read<ActiveWorkoutCubit>().start(
                  workoutPlanId: raw.isEmpty ? null : raw,
                );
              },
              child: const Text(WorkoutStrings.startSession),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () =>
                  context.read<ActiveWorkoutCubit>().start(workoutPlanId: null),
              child: const Text(WorkoutStrings.startEmptySession),
            ),
          ],
        ],
      ),
    );
  }
}

class _InProgressPanel extends StatefulWidget {
  const _InProgressPanel({required this.state});

  final ActiveWorkoutInProgress state;

  @override
  State<_InProgressPanel> createState() => _InProgressPanelState();
}

class _InProgressPanelState extends State<_InProgressPanel> {
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _rpeController = TextEditingController();
  final _freeExerciseController = TextEditingController();

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    _rpeController.dispose();
    _freeExerciseController.dispose();
    super.dispose();
  }

  String? get _selectedExerciseId {
    final fromPlan = widget.state.selectedExerciseId;
    if (fromPlan != null && fromPlan.isNotEmpty) return fromPlan;
    final free = _freeExerciseController.text.trim();
    return free.isEmpty ? null : free;
  }

  Future<void> _submit() async {
    final exerciseId = _selectedExerciseId;
    if (exerciseId == null) return;
    final reps = int.tryParse(_repsController.text.trim());
    final weight = num.tryParse(_weightController.text.trim());
    final rpe = num.tryParse(_rpeController.text.trim());
    await context.read<ActiveWorkoutCubit>().logSet(
      exerciseId: exerciseId,
      repsCompleted: reps,
      weightLiftedKg: weight,
      rpeScore: rpe,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final exercises = state.planExercises;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (state.actionError != null) ...[
          Text(
            state.actionError!,
            style: TextStyle(color: theme.colorScheme.error),
          ),
          const SizedBox(height: 8),
        ],
        const RestTimerWidget(),
        const SizedBox(height: 8),
        if (exercises.isNotEmpty) ...[
          Text(WorkoutStrings.exercisesSection, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final e in exercises) _ExerciseChoice(exercise: e, state: state),
        ] else ...[
          TextField(
            controller: _freeExerciseController,
            decoration: const InputDecoration(
              labelText: WorkoutStrings.exerciseIdLabel,
              hintText: WorkoutStrings.freeFormHint,
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),
        ],
        const SizedBox(height: 16),
        TextField(
          controller: _repsController,
          decoration: const InputDecoration(
            labelText: WorkoutStrings.repsLabel,
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _weightController,
          decoration: const InputDecoration(
            labelText: WorkoutStrings.weightLabel,
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _rpeController,
          decoration: const InputDecoration(
            labelText: WorkoutStrings.rpeLabel,
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: state.logging || _selectedExerciseId == null
              ? null
              : _submit,
          child: Text(
            state.logging
                ? '…'
                : '${WorkoutStrings.logSet} (#${_selectedExerciseId == null ? '-' : state.nextSetNumberFor(_selectedExerciseId!)})',
          ),
        ),
        const SizedBox(height: 24),
        Text(
          WorkoutStrings.loggedSetsSection,
          style: theme.textTheme.titleMedium,
        ),
        if (state.loggedSets.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('—'),
          )
        else
          for (final s in state.loggedSets.reversed)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Exercise #${s.exerciseId}'),
              subtitle: Text(
                WorkoutStrings.setLoggedLine(
                  setNumber: s.setNumber,
                  reps: s.repsCompleted,
                  weight: s.weightLiftedKg,
                ),
              ),
            ),
        const SizedBox(height: 16),
        FilledButton.tonal(
          onPressed: state.logging ? null : () => _confirmComplete(context),
          child: const Text(WorkoutStrings.completeSession),
        ),
      ],
    );
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
    await context.read<ActiveWorkoutCubit>().complete(
      notes: feedback.notes,
      clientFeedbackRating: feedback.rating,
    );
  }
}

class _ExerciseChoice extends StatelessWidget {
  const _ExerciseChoice({required this.exercise, required this.state});

  final WorkoutPlanExercise exercise;
  final ActiveWorkoutInProgress state;

  @override
  Widget build(BuildContext context) {
    final selected = state.selectedExerciseId == exercise.exerciseId;
    final logged = state.loggedSets
        .where((s) => s.exerciseId == exercise.exerciseId)
        .length;
    final target = exercise.targetSets;
    return ListTile(
      selected: selected,
      onTap: () =>
          context.read<ActiveWorkoutCubit>().selectExercise(exercise.exerciseId),
      title: Text(exercise.exerciseName ?? 'Exercise #${exercise.exerciseId}'),
      subtitle: Text(
        [
          WorkoutStrings.exerciseSubtitle(
            sets: exercise.targetSets,
            reps: exercise.targetReps,
          ),
          if (target != null) '$logged/$target logged',
        ].where((s) => s.isNotEmpty).join(' · '),
      ),
      trailing: selected ? const Icon(Icons.check_circle) : null,
    );
  }
}

class _CompletedPanel extends StatelessWidget {
  const _CompletedPanel({
    required this.session,
    required this.loggedSetCount,
  });

  final WorkoutSession session;
  final int loggedSetCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            onPressed: () => context.read<ActiveWorkoutCubit>().resetToIdle(),
            child: const Text(WorkoutStrings.startAnother),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.go(Routes.memberHomeWorkoutHistory),
            child: const Text(WorkoutStrings.viewHistory),
          ),
        ],
      ),
    );
  }
}
