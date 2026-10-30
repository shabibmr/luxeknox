import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/workout_plan_builder_cubit.dart';
import '../workout_strings.dart';

/// Step 1 of the plan builder: macrocycle objective, cadence, split and
/// progression levers. Reads and writes [WorkoutPlanBuilderCubit].
class ProgramBlueprintStep extends StatefulWidget {
  const ProgramBlueprintStep({super.key, required this.state});

  final WorkoutPlanBuilderState state;

  @override
  State<ProgramBlueprintStep> createState() => _ProgramBlueprintStepState();
}

class _ProgramBlueprintStepState extends State<ProgramBlueprintStep> {
  late final TextEditingController _objective;
  late final TextEditingController _milestone;

  @override
  void initState() {
    super.initState();
    _objective = TextEditingController(text: widget.state.primaryObjective12w);
    _milestone = TextEditingController(text: widget.state.milestone4w);
  }

  @override
  void dispose() {
    _objective.dispose();
    _milestone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cubit = context.read<WorkoutPlanBuilderCubit>();
    final errors = state.showBlueprintErrors
        ? state.blueprintErrors
        : const <String, String>{};
    final splits = [
      ...WorkoutStrings.splitOptions,
      if (state.splitType.isNotEmpty &&
          !WorkoutStrings.splitOptions.contains(state.splitType))
        state.splitType,
    ];
    final freq = state.sessionsPerWeek;
    final dur = state.targetSessionDurationMinutes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const Key('blueprint_objective'),
          controller: _objective,
          decoration: InputDecoration(
            labelText: WorkoutStrings.objective12wLabel,
            border: const OutlineInputBorder(),
            errorText: errors['objective'],
          ),
          maxLines: 2,
          onChanged: cubit.setPrimaryObjective12w,
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('blueprint_milestone'),
          controller: _milestone,
          decoration: InputDecoration(
            labelText: WorkoutStrings.milestone4wLabel,
            border: const OutlineInputBorder(),
            errorText: errors['milestone'],
          ),
          maxLines: 2,
          onChanged: cubit.setMilestone4w,
        ),
        const SizedBox(height: 12),
        InputDecorator(
          decoration: InputDecoration(
            labelText: WorkoutStrings.sessionsPerWeekLabel,
            border: const OutlineInputBorder(),
            errorText: errors['frequency'],
          ),
          child: Row(
            children: [
              IconButton(
                key: const Key('blueprint_freq_dec'),
                icon: const Icon(Icons.remove),
                onPressed: freq == null || freq <= 1
                    ? null
                    : () => cubit.setSessionsPerWeek(freq - 1),
              ),
              Text('${freq ?? '–'}'),
              IconButton(
                key: const Key('blueprint_freq_inc'),
                icon: const Icon(Icons.add),
                onPressed: freq != null && freq >= 14
                    ? null
                    : () => cubit.setSessionsPerWeek((freq ?? 0) + 1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        InputDecorator(
          decoration: InputDecoration(
            labelText: WorkoutStrings.sessionDurationLabel,
            border: const OutlineInputBorder(),
            errorText: errors['duration'],
          ),
          child: Row(
            children: [
              IconButton(
                key: const Key('blueprint_dur_dec'),
                icon: const Icon(Icons.remove),
                onPressed: dur == null || dur <= 15
                    ? null
                    : () => cubit.setTargetSessionDurationMinutes(dur - 5),
              ),
              Text('${dur ?? '–'}'),
              IconButton(
                key: const Key('blueprint_dur_inc'),
                icon: const Icon(Icons.add),
                onPressed: dur != null && dur >= 180
                    ? null
                    : () => cubit.setTargetSessionDurationMinutes(
                        dur == null ? 60 : dur + 5,
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          key: const Key('blueprint_split'),
          initialValue: state.splitType.isEmpty ? null : state.splitType,
          decoration: InputDecoration(
            labelText: WorkoutStrings.splitLabel,
            border: const OutlineInputBorder(),
            errorText: errors['split'],
          ),
          items: [
            for (final o in splits) DropdownMenuItem(value: o, child: Text(o)),
          ],
          onChanged: (v) => cubit.setSplitType(v ?? ''),
        ),
        const SizedBox(height: 12),
        Text(
          WorkoutStrings.progressionLabel,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Wrap(
          spacing: 8,
          children: [
            for (final e in WorkoutStrings.progressionOptions.entries)
              FilterChip(
                key: Key('blueprint_prog_${e.key}'),
                label: Text(e.value),
                selected: state.progressionMethods.contains(e.key),
                onSelected: (_) => cubit.toggleProgressionMethod(e.key),
              ),
          ],
        ),
      ],
    );
  }
}
