import 'package:flutter/material.dart';

/// Shared chrome for a filter bottom sheet: title + "Clear all", the filter
/// fields, and a full-width "Apply filters" button. Callers own the fields
/// and their state; this only owns the shell.
class AppFilterSheetShell extends StatelessWidget {
  const AppFilterSheetShell({
    super.key,
    required this.title,
    required this.onClearAll,
    required this.onApply,
    required this.children,
    this.clearAllLabel = 'Clear all',
    this.applyLabel = 'Apply filters',
  });

  final String title;
  final VoidCallback onClearAll;
  final VoidCallback onApply;
  final List<Widget> children;
  final String clearAllLabel;
  final String applyLabel;

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
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: onClearAll,
                      child: Text(
                        clearAllLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              children[i],
            ],
            const SizedBox(height: 24),
            FilledButton(onPressed: onApply, child: Text(applyLabel)),
          ],
        ),
      ),
    );
  }
}
