import 'package:flutter/material.dart';

/// A reusable form field that displays a selected entity [value] (formatted by [labelBuilder])
/// and opens a picker bottom sheet or dialog on tap via [onPick].
class AppPickerFormField<T> extends StatelessWidget {
  const AppPickerFormField({
    super.key,
    required this.onChanged,
    required this.onPick,
    this.value,
    this.labelBuilder,
    this.labelText = 'Select',
    this.hintText = 'Tap to select',
    this.errorText,
    this.enabled = true,
    this.allowClear = true,
    this.clearTooltip = 'Clear selection',
    this.fieldKey,
    this.clearButtonKey,
  });

  /// The currently selected entity, or `null` if none selected.
  final T? value;

  /// Function mapping the selected item to a display string.
  /// If omitted, defaults to `value.toString()`.
  final String Function(T item)? labelBuilder;

  /// Triggered when a new item is selected or when cleared (with `null`).
  final ValueChanged<T?> onChanged;

  /// Callback to launch the picker sheet/dialog, returning `Future<T?>`.
  final Future<T?> Function(BuildContext context) onPick;

  final String labelText;
  final String hintText;
  final String? errorText;
  final bool enabled;
  final bool allowClear;
  final String clearTooltip;
  final Key? fieldKey;
  final Key? clearButtonKey;

  String? get _displayLabel {
    if (value == null) return null;
    return labelBuilder != null ? labelBuilder!(value as T) : value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final text = _displayLabel;
    final theme = Theme.of(context);

    return InkWell(
      key: fieldKey,
      onTap: enabled
          ? () async {
              final picked = await onPick(context);
              if (picked != null) {
                onChanged(picked);
              }
            }
          : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          errorText: errorText,
          border: const OutlineInputBorder(),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (text != null && enabled && allowClear)
                IconButton(
                  key: clearButtonKey,
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () => onChanged(null),
                  tooltip: clearTooltip,
                ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        child: Text(
          text ?? hintText,
          style: text == null
              ? theme.inputDecorationTheme.hintStyle ??
                  TextStyle(color: theme.hintColor)
              : theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
