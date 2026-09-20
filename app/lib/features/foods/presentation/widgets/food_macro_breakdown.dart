import 'package:flutter/material.dart';

import '../../domain/entities/food.dart';
import '../foods_strings.dart';

/// Shows the percentage of calories contributed by protein, carbs, and fat,
/// derived from grams using the standard 4/4/9 kcal-per-gram factors.
class FoodMacroBreakdown extends StatelessWidget {
  const FoodMacroBreakdown({super.key, required this.food});

  final Food food;

  @override
  Widget build(BuildContext context) {
    final protein = food.proteinGrams;
    final carbs = food.carbsGrams;
    final fat = food.fatGrams;

    if (protein == null && carbs == null && fat == null) {
      return const Text(FoodStrings.noMacroData);
    }

    final proteinKcal = (protein ?? 0) * 4;
    final carbsKcal = (carbs ?? 0) * 4;
    final fatKcal = (fat ?? 0) * 9;
    final totalKcal = proteinKcal + carbsKcal + fatKcal;

    double pct(double kcal) => totalKcal == 0 ? 0 : kcal / totalKcal * 100;

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(FoodStrings.macroBreakdown, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        _MacroRow(label: FoodStrings.protein, percent: pct(proteinKcal)),
        _MacroRow(label: FoodStrings.carbs, percent: pct(carbsKcal)),
        _MacroRow(label: FoodStrings.fat, percent: pct(fatKcal)),
      ],
    );
  }
}

class _MacroRow extends StatelessWidget {
  const _MacroRow({required this.label, required this.percent});

  final String label;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 72, child: Text(label)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent / 100,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 44,
            child: Text(
              '${percent.toStringAsFixed(0)}%',
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
