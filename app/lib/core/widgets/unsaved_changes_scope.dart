import 'package:flutter/material.dart';

import '../l10n/shell_strings.dart';

/// Blocks system/back pops while [hasUnsavedChanges] is true and prompts to
/// discard. Wrap form scaffolds so deep-link / AppBar back / OS back agree.
class UnsavedChangesScope extends StatelessWidget {
  const UnsavedChangesScope({
    super.key,
    required this.hasUnsavedChanges,
    required this.child,
    this.title = ShellStrings.unsavedTitle,
    this.message = ShellStrings.unsavedMessage,
    this.stayLabel = ShellStrings.unsavedStay,
    this.leaveLabel = ShellStrings.unsavedLeave,
  });

  final bool hasUnsavedChanges;
  final Widget child;
  final String title;
  final String message;
  final String stayLabel;
  final String leaveLabel;

  Future<bool> _confirmLeave(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(stayLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(leaveLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || !hasUnsavedChanges) return;
        final leave = await _confirmLeave(context);
        if (leave && context.mounted) {
          Navigator.of(context).pop(result);
        }
      },
      child: child,
    );
  }
}
