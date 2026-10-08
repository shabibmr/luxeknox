import 'package:flutter/material.dart';

import '../../domain/entities/food.dart';

/// Displays a single [Food] summary. Pure presentation — the caller
/// supplies the data and reacts to taps; this widget never fetches.
class FoodListItem extends StatelessWidget {
  const FoodListItem({super.key, required this.food, this.onTap});

  final Food food;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final calories = food.calories;
    final macroLabel =
        'P${_fmt(food.proteinGrams)} · C${_fmt(food.carbsGrams)} · F${_fmt(food.fatGrams)}';

    return ListTile(
      onTap: onTap,
      title: Text(food.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        calories == null
            ? macroLabel
            : '${calories.toStringAsFixed(0)} kcal · $macroLabel',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 110),
        child: Chip(
          label: Text(
            food.servingUnit,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  String _fmt(double? value) => value == null ? '-' : value.toStringAsFixed(0);
}
