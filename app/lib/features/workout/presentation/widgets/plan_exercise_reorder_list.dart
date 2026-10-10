import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/workout_plan_exercise_input.dart';
import '../workout_strings.dart';

typedef PlanExerciseReorder = void Function(int oldIndex, int newIndex);
typedef PlanExerciseAction = void Function(int index);
typedef PlanExerciseRestChanged = void Function(int index, int? restSeconds);

const _setRestPresets = <int>[30, 60, 90, 120, 180];
const _exerciseRestPresets = <int>[60, 90, 120, 180, 240];

/// Reorderable list for exercises within a single day group.
class PlanExerciseReorderList extends StatelessWidget {
  const PlanExerciseReorderList({
    super.key,
    required this.exercises,
    required this.onReorder,
    this.onRemove,
    this.onMoveDay,
    this.onRestChanged,
    this.onExerciseRestChanged,
    this.enabled = true,
  });

  final List<WorkoutPlanExerciseInput> exercises;
  final PlanExerciseReorder onReorder;
  final PlanExerciseAction? onRemove;
  final PlanExerciseAction? onMoveDay;
  final PlanExerciseRestChanged? onRestChanged;
  final PlanExerciseRestChanged? onExerciseRestChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(WorkoutStrings.emptyDay),
      );
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: enabled,
      itemCount: exercises.length,
      onReorderItem: enabled ? onReorder : (_, _) {},
      itemBuilder: (context, index) {
        final item = exercises[index];
        final subtitle = WorkoutStrings.exerciseSubtitle(
          sets: item.targetSets,
          reps: item.targetReps,
        );
        return Column(
          key: ValueKey('day-${item.dayNumber}-$index-${item.exerciseId}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item.exerciseName ?? 'Exercise #${item.exerciseId}'),
              subtitle: subtitle.isEmpty ? null : Text(subtitle),
              trailing: enabled
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (onMoveDay != null)
                          IconButton(
                            tooltip: WorkoutStrings.moveToDay,
                            icon: const Icon(Icons.swap_horiz),
                            onPressed: () => onMoveDay!(index),
                          ),
                        if (onRemove != null)
                          IconButton(
                            tooltip: WorkoutStrings.remove,
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => onRemove!(index),
                          ),
                        const Icon(Icons.drag_handle),
                      ],
                    )
                  : null,
            ),
            if (onRestChanged != null)
              _RestSecondsEditor(
                fieldKey: 'rest-between-sets',
                label: WorkoutStrings.restBetweenSetsLabel,
                hint: WorkoutStrings.restDefaultHint,
                presets: _setRestPresets,
                restSeconds: item.restSeconds,
                enabled: enabled,
                onChanged: (value) => onRestChanged!(index, value),
              ),
            if (onExerciseRestChanged != null)
              _RestSecondsEditor(
                fieldKey: 'rest-between-exercises',
                label: WorkoutStrings.restBetweenExercisesLabel,
                hint: WorkoutStrings.restBetweenExercisesHint,
                presets: _exerciseRestPresets,
                restSeconds: item.restBetweenExercisesSeconds,
                enabled: enabled,
                onChanged: (value) => onExerciseRestChanged!(index, value),
              ),
          ],
        );
      },
    );
  }
}

class _RestSecondsEditor extends StatefulWidget {
  const _RestSecondsEditor({
    required this.fieldKey,
    required this.label,
    required this.hint,
    required this.presets,
    required this.restSeconds,
    required this.onChanged,
    required this.enabled,
  });

  final String fieldKey;
  final String label;
  final String hint;
  final List<int> presets;
  final int? restSeconds;
  final ValueChanged<int?> onChanged;
  final bool enabled;

  @override
  State<_RestSecondsEditor> createState() => _RestSecondsEditorState();
}

class _RestSecondsEditorState extends State<_RestSecondsEditor> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _textFor(widget.restSeconds));
  }

  @override
  void didUpdateWidget(covariant _RestSecondsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _textFor(widget.restSeconds);
    if (widget.restSeconds != oldWidget.restSeconds &&
        _controller.text != next) {
      _controller.text = next;
      _error = null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _textFor(int? seconds) => seconds?.toString() ?? '';

  void _commit(String raw) {
    if (!widget.enabled) return;
    if (raw.isEmpty) {
      setState(() => _error = null);
      widget.onChanged(null);
      return;
    }
    final parsed = int.tryParse(raw);
    if (parsed == null) return;
    if (parsed > 3600) {
      setState(() => _error = WorkoutStrings.restTooLong);
      return;
    }
    setState(() => _error = null);
    widget.onChanged(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ValueKey(widget.fieldKey),
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          Text(widget.label),
          Text(widget.hint, style: Theme.of(context).textTheme.bodySmall),
          SizedBox(
            width: 88,
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                isDense: true,
                hintText: '60',
                suffixText: 's',
                errorText: _error,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
              ),
              onChanged: _commit,
            ),
          ),
          for (final seconds in widget.presets)
            ChoiceChip(
              label: Text('${seconds}s'),
              selected: widget.restSeconds == seconds,
              onSelected: widget.enabled
                  ? (selected) {
                      final next = selected ? seconds : null;
                      _controller.text = _textFor(next);
                      setState(() => _error = null);
                      widget.onChanged(next);
                    }
                  : null,
            ),
        ],
      ),
    );
  }
}
