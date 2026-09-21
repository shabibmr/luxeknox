import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/unsaved_changes_scope.dart';
import '../cubit/workout_plan_builder_cubit.dart';
import '../widgets/exercise_picker_sheet.dart';
import '../widgets/plan_exercise_reorder_list.dart';
import '../workout_strings.dart';

class WorkoutPlanBuilderScreen extends StatelessWidget {
  const WorkoutPlanBuilderScreen({super.key, this.planId});

  final String? planId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WorkoutPlanBuilderCubit>()..init(planId: planId),
      child: _BuilderBody(planId: planId),
    );
  }
}

class _BuilderBody extends StatelessWidget {
  const _BuilderBody({this.planId});

  final String? planId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutPlanBuilderCubit, WorkoutPlanBuilderState>(
      builder: (context, state) {
        return switch (state) {
          WorkoutPlanBuilderLoading() => Scaffold(
            appBar: AppBar(title: const Text(WorkoutStrings.createTitle)),
            body: const AppLoading(),
          ),
          WorkoutPlanBuilderFailure(:final message) => Scaffold(
            appBar: AppBar(title: const Text(WorkoutStrings.editTitle)),
            body: AppErrorView(
              message: message,
              onRetry: () => context
                  .read<WorkoutPlanBuilderCubit>()
                  .init(planId: planId),
            ),
          ),
          WorkoutPlanBuilderReady() => UnsavedChangesScope(
            hasUnsavedChanges: state.dirty && !state.saving,
            child: _BuilderForm(state: state),
          ),
        };
      },
    );
  }
}

class _BuilderForm extends StatefulWidget {
  const _BuilderForm({required this.state});

  final WorkoutPlanBuilderReady state;

  @override
  State<_BuilderForm> createState() => _BuilderFormState();
}

class _BuilderFormState extends State<_BuilderForm> {
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _targetGoal;
  late final TextEditingController _difficulty;
  late final TextEditingController _duration;
  late final TextEditingController _memberId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final s = widget.state;
    _title = TextEditingController(text: s.title);
    _description = TextEditingController(text: s.description);
    _targetGoal = TextEditingController(text: s.targetGoal);
    _difficulty = TextEditingController(text: s.difficulty);
    _duration = TextEditingController(
      text: s.durationWeeks?.toString() ?? '',
    );
    _memberId = TextEditingController(text: s.memberId);
  }

  @override
  void didUpdateWidget(covariant _BuilderForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // After save, sync controllers if plan metadata refreshed.
    if (oldWidget.state.savedPlan == null && widget.state.savedPlan != null) {
      final s = widget.state;
      _title.text = s.title;
      _description.text = s.description;
      _targetGoal.text = s.targetGoal;
      _difficulty.text = s.difficulty;
      _duration.text = s.durationWeeks?.toString() ?? '';
      _memberId.text = s.memberId;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _targetGoal.dispose();
    _difficulty.dispose();
    _duration.dispose();
    _memberId.dispose();
    super.dispose();
  }

  Future<void> _pickExercise(int dayNumber) async {
    final exercise = await showExercisePickerSheet(context);
    if (exercise == null || !mounted) return;
    context.read<WorkoutPlanBuilderCubit>().addExercise(
      exercise,
      dayNumber: dayNumber,
    );
  }

  Future<void> _promptMoveDay(int fromDay, int indexInDay) async {
    final controller = TextEditingController(text: '${fromDay + 1}');
    final toDay = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(WorkoutStrings.moveToDay),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: WorkoutStrings.dayLabel,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final parsed = int.tryParse(controller.text.trim());
              Navigator.pop(dialogContext, parsed);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (toDay == null || toDay < 1 || !mounted) return;
    context.read<WorkoutPlanBuilderCubit>().moveToDay(
      fromDay: fromDay,
      indexInDay: indexInDay,
      toDay: toDay,
    );
  }

  Future<void> _onSave({bool andPublish = false}) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final cubit = context.read<WorkoutPlanBuilderCubit>();
    final ok = await cubit.save();
    if (!mounted) return;
    if (!ok) {
      final err = cubit.state;
      final message = err is WorkoutPlanBuilderReady
          ? (err.errorMessage ?? WorkoutStrings.saveFailed)
          : WorkoutStrings.saveFailed;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    if (andPublish) {
      final published = await cubit.publish();
      if (!mounted) return;
      if (!published) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(WorkoutStrings.actionFailed)),
        );
        return;
      }
    }
    final ready = cubit.state;
    if (ready is WorkoutPlanBuilderReady && ready.planId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            andPublish ? WorkoutStrings.published : WorkoutStrings.saved,
          ),
        ),
      );
      context.go(Routes.trainerPlansWorkoutById(ready.planId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final byDay = state.exercisesByDay;
    final days = byDay.keys.toList()..sort();
    if (days.isEmpty) days.add(1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.isEditMode
              ? WorkoutStrings.editTitle
              : WorkoutStrings.createTitle,
        ),
        actions: [
          if (state.saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else ...[
            TextButton(
              onPressed: () => _onSave(),
              child: const Text(WorkoutStrings.save),
            ),
            if (state.isEditMode)
              TextButton(
                onPressed: () => _onSave(andPublish: true),
                child: const Text(WorkoutStrings.publish),
              ),
          ],
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  state.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: WorkoutStrings.titleLabel,
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty)
                  ? WorkoutStrings.titleRequired
                  : null,
              onChanged: context.read<WorkoutPlanBuilderCubit>().setTitle,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: WorkoutStrings.descriptionLabel,
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              onChanged: context.read<WorkoutPlanBuilderCubit>().setDescription,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _targetGoal,
              decoration: const InputDecoration(
                labelText: WorkoutStrings.targetGoalLabel,
                border: OutlineInputBorder(),
              ),
              onChanged: context.read<WorkoutPlanBuilderCubit>().setTargetGoal,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _difficulty,
              decoration: const InputDecoration(
                labelText: WorkoutStrings.difficultyLabel,
                border: OutlineInputBorder(),
              ),
              onChanged: context.read<WorkoutPlanBuilderCubit>().setDifficulty,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _duration,
              decoration: const InputDecoration(
                labelText: WorkoutStrings.durationWeeksLabel,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) {
                final parsed = int.tryParse(v.trim());
                context.read<WorkoutPlanBuilderCubit>().setDurationWeeks(
                  parsed,
                );
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _memberId,
              decoration: const InputDecoration(
                labelText: WorkoutStrings.memberIdLabel,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: context.read<WorkoutPlanBuilderCubit>().setMemberId,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(WorkoutStrings.isTemplateLabel),
              value: state.isTemplate,
              onChanged: (v) =>
                  context.read<WorkoutPlanBuilderCubit>().setIsTemplate(v),
            ),
            const Divider(height: 32),
            Text(
              WorkoutStrings.exercisesSection,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final day in days) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      WorkoutStrings.dayHeader(day),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: state.saving
                        ? null
                        : () => _pickExercise(day),
                    icon: const Icon(Icons.add),
                    label: const Text(WorkoutStrings.addExercise),
                  ),
                ],
              ),
              PlanExerciseReorderList(
                exercises: byDay[day] ?? const [],
                enabled: !state.saving,
                onReorder: (oldIndex, newIndex) {
                  context.read<WorkoutPlanBuilderCubit>().reorderWithinDay(
                    dayNumber: day,
                    oldIndex: oldIndex,
                    newIndex: newIndex,
                  );
                },
                onRemove: (index) {
                  context.read<WorkoutPlanBuilderCubit>().removeExercise(
                    dayNumber: day,
                    indexInDay: index,
                  );
                },
                onMoveDay: (index) => _promptMoveDay(day, index),
              ),
              const SizedBox(height: 12),
            ],
            OutlinedButton.icon(
              onPressed: state.saving
                  ? null
                  : () {
                      final nextDay =
                          (days.isEmpty ? 0 : days.reduce((a, b) => a > b ? a : b)) +
                          1;
                      _pickExercise(nextDay);
                    },
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text(
                '${WorkoutStrings.addExercise} (${WorkoutStrings.dayLabel} +)',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
