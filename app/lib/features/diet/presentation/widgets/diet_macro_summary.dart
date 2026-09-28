import 'package:flutter/material.dart';

import '../../domain/entities/diet_macros.dart';
import '../diet_strings.dart';

/// Shows calories + P/C/F grams (and optional plan targets).
class DietMacroSummary extends StatelessWidget {
  const DietMacroSummary({
    super.key,
    required this.macros,
    this.calorieTarget,
    this.proteinTargetG,
    this.carbsTargetG,
    this.fatTargetG,
    this.title = DietStrings.macrosSection,
  });

  final DietMacros macros;
  final int? calorieTarget;
  final num? proteinTargetG;
  final num? carbsTargetG;
  final num? fatTargetG;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (macros.isEmpty &&
        calorieTarget == null &&
        proteinTargetG == null &&
        carbsTargetG == null &&
        fatTargetG == null) {
      return Text(DietStrings.noMacroData, style: theme.textTheme.bodyMedium);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _MacroChip(
              label: DietStrings.caloriesLabel,
              value: DietStrings.macroValue(macros.calories, suffix: ' kcal'),
              target: calorieTarget == null
                  ? null
                  : DietStrings.macroValue(calorieTarget!.toDouble()),
            ),
            _MacroChip(
              label: DietStrings.proteinLabel,
              value: DietStrings.macroValue(macros.proteinGrams, suffix: ' g'),
              target: proteinTargetG == null
                  ? null
                  : DietStrings.macroValue(proteinTargetG!.toDouble(), suffix: ' g'),
            ),
            _MacroChip(
              label: DietStrings.carbsLabel,
              value: DietStrings.macroValue(macros.carbsGrams, suffix: ' g'),
              target: carbsTargetG == null
                  ? null
                  : DietStrings.macroValue(carbsTargetG!.toDouble(), suffix: ' g'),
            ),
            _MacroChip(
              label: DietStrings.fatLabel,
              value: DietStrings.macroValue(macros.fatGrams, suffix: ' g'),
              target: fatTargetG == null
                  ? null
                  : DietStrings.macroValue(fatTargetG!.toDouble(), suffix: ' g'),
            ),
          ],
        ),
      ],
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({
    required this.label,
    required this.value,
    this.target,
  });

  final String label;
  final String value;
  final String? target;

  @override
  Widget build(BuildContext context) {
    final text = target == null ? value : '$value / $target';
    return Chip(
      label: Text('$label: $text'),
    );
  }
}
