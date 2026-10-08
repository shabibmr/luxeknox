import 'package:flutter/material.dart';

/// Generic status/label chip shared by feature-specific chips (membership,
/// payment, diet plan, workout plan, achievement, ...).
///
/// Two visual modes:
/// - `tinted: true` (default): background is [color] at 15% alpha, label
///   and optional icon are drawn in [color]. This is the "status" look used
///   for draft/active/paid/expired-style chips.
/// - `tinted: false`: [color] is used as-is for the background, and
///   [foregroundColor] (required in this mode) controls label/icon color.
///   This is the "achievement" look, driven off resolved ColorScheme colors
///   rather than a semantic color + alpha blend.
class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.label,
    required this.color,
    this.foregroundColor,
    this.icon,
    this.tinted = true,
  }) : assert(
         tinted || foregroundColor != null,
         'foregroundColor is required when tinted is false',
       );

  final String label;
  final Color color;
  final Color? foregroundColor;
  final IconData? icon;
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    final fg = foregroundColor ?? color;
    final bg = tinted ? color.withValues(alpha: 0.15) : color;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Chip(
        avatar: icon != null ? Icon(icon, size: 16, color: fg) : null,
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: bg,
        labelStyle: TextStyle(color: fg, fontWeight: FontWeight.w600),
        side: BorderSide.none,
      ),
    );
  }
}
