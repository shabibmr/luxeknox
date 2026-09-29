import 'package:flutter/material.dart';

import '../../../../core/widgets/app_filter_sheet_shell.dart';
import '../../domain/entities/exercise_filter.dart';
import '../exercise_strings.dart';

/// Bottom sheet for muscle group, equipment, and difficulty filters.
/// Muscle group and equipment are free text: the API defines no fixed enum for
/// these values (FR-WORK-001/002). Difficulty is a dropdown of the seeded
/// levels, keeping filter values consistent with the library data.
class ExerciseFilterSheet extends StatefulWidget {
  const ExerciseFilterSheet({super.key, required this.initialFilter});

  final ExerciseFilter initialFilter;

  /// Shows the sheet and resolves to the chosen [ExerciseFilter], or `null`
  /// if dismissed without applying.
  static Future<ExerciseFilter?> show(
    BuildContext context,
    ExerciseFilter current,
  ) {
    return showModalBottomSheet<ExerciseFilter>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ExerciseFilterSheet(initialFilter: current),
    );
  }

  @override
  State<ExerciseFilterSheet> createState() => _ExerciseFilterSheetState();
}

class _ExerciseFilterSheetState extends State<ExerciseFilterSheet> {
  late final _muscleController = TextEditingController(
    text: widget.initialFilter.muscleGroup,
  );
  late final _equipmentController = TextEditingController(
    text: widget.initialFilter.equipment,
  );
  late String? _difficulty = widget.initialFilter.difficulty;

  /// Standard levels, plus the current filter value if it is a custom one so
  /// the dropdown always has a matching item.
  late final List<String> _difficultyOptions = [
    ...ExerciseStrings.difficultyLevels,
    if (_difficulty != null &&
        !ExerciseStrings.difficultyLevels.contains(_difficulty))
      _difficulty!,
  ];

  @override
  void dispose() {
    _muscleController.dispose();
    _equipmentController.dispose();
    super.dispose();
  }

  void _clearAll() {
    _muscleController.clear();
    _equipmentController.clear();
    setState(() => _difficulty = null);
  }

  void _apply() {
    String? textOrNull(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();

    Navigator.of(context).pop(
      widget.initialFilter.copyWith(
        muscleGroup: textOrNull(_muscleController),
        equipment: textOrNull(_equipmentController),
        difficulty: _difficulty,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppFilterSheetShell(
      title: ExerciseStrings.filterTitle,
      clearAllLabel: ExerciseStrings.clearAll,
      applyLabel: ExerciseStrings.applyFilters,
      onClearAll: _clearAll,
      onApply: _apply,
      children: [
        TextField(
          controller: _muscleController,
          decoration: const InputDecoration(
            labelText: ExerciseStrings.muscleGroup,
          ),
        ),
        TextField(
          controller: _equipmentController,
          decoration: const InputDecoration(
            labelText: ExerciseStrings.equipment,
          ),
        ),
        DropdownButtonFormField<String?>(
          // ignore: deprecated_member_use
          value: _difficulty,
          decoration: const InputDecoration(
            labelText: ExerciseStrings.difficulty,
          ),
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text(ExerciseStrings.difficultyAny),
            ),
            for (final level in _difficultyOptions)
              DropdownMenuItem<String?>(value: level, child: Text(level)),
          ],
          onChanged: (v) => setState(() => _difficulty = v),
        ),
      ],
    );
  }
}
