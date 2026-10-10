import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/goal_metric_category.dart';
import '../../domain/usecases/goal_metrics_usecases.dart';
import '../goals_strings.dart';

/// Creates or updates a goal metric. Returns the saved metric, or null when
/// the user cancels or the save fails.
Future<GoalMetric?> showGoalMetricEditorDialog(
  BuildContext context, {
  GoalMetric? existing,
}) {
  return showDialog<GoalMetric>(
    context: context,
    builder: (ctx) => _GoalMetricEditorDialog(existing: existing),
  );
}

class _GoalMetricEditorDialog extends StatefulWidget {
  const _GoalMetricEditorDialog({this.existing});

  final GoalMetric? existing;

  @override
  State<_GoalMetricEditorDialog> createState() => _GoalMetricEditorDialogState();
}

class _GoalMetricEditorDialogState extends State<_GoalMetricEditorDialog> {
  late final TextEditingController _nameController;
  late String _unit;
  late GoalMetricCategory _category;
  late bool _isActive;
  var _saving = false;
  String? _error;

  static const _units = [
    GoalsStrings.unitKg,
    GoalsStrings.unitLbs,
    GoalsStrings.unitCm,
    GoalsStrings.unitIn,
    GoalsStrings.unitPercent,
  ];

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _unit = existing?.unitOfMeasure ?? GoalsStrings.unitKg;
    if (!_units.contains(_unit)) {
      _unit = GoalsStrings.unitKg;
    }
    _category = existing?.category ?? GoalMetricCategory.bodyComposition;
    _isActive = existing?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = GoalsStrings.metricNameRequired);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

    final existing = widget.existing;
    final result = existing == null
        ? await getIt<CreateGoalMetricUseCase>()(
            CreateGoalMetricParams(
              name: name,
              unitOfMeasure: _unit,
              category: _category,
              isActive: _isActive,
            ),
          )
        : await getIt<UpdateGoalMetricUseCase>()(
            UpdateGoalMetricParams(
              id: existing.id,
              name: name,
              unitOfMeasure: _unit,
              category: _category,
              isActive: _isActive,
            ),
          );

    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _saving = false;
        _error = failureMessage(failure);
      }),
      (metric) => Navigator.of(context).pop(metric),
    );
  }

  @override
  Widget build(BuildContext context) {
    final existing = widget.existing;
    return AlertDialog(
      title: Text(
        existing == null ? GoalsStrings.createMetric : GoalsStrings.editMetric,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              enabled: !_saving,
              decoration: const InputDecoration(
                labelText: GoalsStrings.metricNameLabel,
              ),
            ),
            DropdownButtonFormField<String>(
              // ignore: deprecated_member_use
              value: _unit,
              decoration: const InputDecoration(
                labelText: GoalsStrings.metricUnitLabel,
              ),
              items: [
                for (final unit in _units)
                  DropdownMenuItem(value: unit, child: Text(unit)),
              ],
              onChanged: _saving
                  ? null
                  : (value) {
                      if (value != null) setState(() => _unit = value);
                    },
            ),
            DropdownButtonFormField<GoalMetricCategory>(
              // ignore: deprecated_member_use
              value: _category,
              decoration: const InputDecoration(
                labelText: GoalsStrings.metricCategoryLabel,
              ),
              items: [
                for (final category in GoalMetricCategory.values)
                  DropdownMenuItem(
                    value: category,
                    child: Text(GoalsStrings.categoryLabelFor(category)),
                  ),
              ],
              onChanged: _saving
                  ? null
                  : (value) {
                      if (value != null) setState(() => _category = value);
                    },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(GoalsStrings.metricActiveLabel),
              value: _isActive,
              onChanged: _saving
                  ? null
                  : (value) => setState(() => _isActive = value),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text(GoalsStrings.cancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(GoalsStrings.save),
        ),
      ],
    );
  }
}
