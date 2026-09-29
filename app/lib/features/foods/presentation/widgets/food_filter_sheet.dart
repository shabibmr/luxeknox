import 'package:flutter/material.dart';

import '../../../../core/widgets/app_filter_sheet_shell.dart';
import '../../domain/entities/food_filter.dart';
import '../foods_strings.dart';

/// Bottom sheet that edits the verified filter for the food catalogue list.
class FoodFilterSheet extends StatefulWidget {
  const FoodFilterSheet({super.key, required this.initialFilter});

  final FoodFilter initialFilter;

  /// Shows the sheet and resolves to the chosen [FoodFilter], or `null`
  /// if dismissed without applying.
  static Future<FoodFilter?> show(BuildContext context, FoodFilter current) {
    return showModalBottomSheet<FoodFilter>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FoodFilterSheet(initialFilter: current),
    );
  }

  @override
  State<FoodFilterSheet> createState() => _FoodFilterSheetState();
}

class _FoodFilterSheetState extends State<FoodFilterSheet> {
  late bool? _isVerified = widget.initialFilter.isVerified;

  void _clearAll() {
    setState(() => _isVerified = null);
  }

  void _apply() {
    Navigator.of(
      context,
    ).pop(widget.initialFilter.copyWith(isVerified: _isVerified));
  }

  @override
  Widget build(BuildContext context) {
    return AppFilterSheetShell(
      title: FoodStrings.filterTitle,
      clearAllLabel: FoodStrings.clearAll,
      applyLabel: FoodStrings.applyFilters,
      onClearAll: _clearAll,
      onApply: _apply,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(FoodStrings.verifiedOnly),
          value: _isVerified ?? false,
          onChanged: (v) => setState(() => _isVerified = v),
        ),
      ],
    );
  }
}
