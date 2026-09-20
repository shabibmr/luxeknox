import 'package:flutter/material.dart';

import '../../domain/entities/food_filter.dart';
import '../foods_strings.dart';

/// Bottom sheet for the `isVerified` filter.
///
/// KNOWN CONTRACT MISMATCH: see `FoodFilter` — the OpenAPI contract has no
/// `is_active` field on `Food`; this filters client-side on `isVerified`
/// until the backend contract adds server-side support.
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
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  FoodStrings.filterTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: _clearAll,
                  child: const Text(FoodStrings.clearAll),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(FoodStrings.verifiedOnly),
              value: _isVerified ?? false,
              onChanged: (v) => setState(() => _isVerified = v),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _apply,
              child: const Text(FoodStrings.applyFilters),
            ),
          ],
        ),
      ),
    );
  }
}
