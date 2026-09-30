import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'decimal_text_input.dart';

/// Reusable percentage input (e.g. tax %): `%` suffix, exactly
/// [decimalDigits] places. Pads on blur and before validate; empty becomes
/// zero (`0.00` by default).
class AppPercentField extends StatefulWidget {
  const AppPercentField({
    super.key,
    required this.controller,
    required this.label,
    this.decimalDigits = 2,
    this.enabled = true,
    this.helperText,
    this.invalidMessage,
  });

  final TextEditingController controller;
  final String label;

  /// Decimal places required after padding. Defaults to 2.
  final int decimalDigits;

  final bool enabled;
  final String? helperText;
  final String? invalidMessage;

  @override
  State<AppPercentField> createState() => _AppPercentFieldState();
}

class _AppPercentFieldState extends State<AppPercentField> {
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocusChange);

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      applyNormalizedDecimal(
        widget.controller,
        decimalDigits: widget.decimalDigits,
        emptyToZero: true,
      );
    }
  }

  String _example(int digits) => '18.${'0' * digits}';

  @override
  Widget build(BuildContext context) {
    final digits = widget.decimalDigits;
    final pattern = digits > 0
        ? RegExp(r'^\d+(\.\d{0,' + digits.toString() + r'})?$')
        : RegExp(r'^\d+$');

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.isEmpty) return newValue;
          return pattern.hasMatch(newValue.text) ? newValue : oldValue;
        }),
      ],
      decoration: InputDecoration(
        labelText: widget.label,
        suffixText: '%',
        helperText:
            widget.helperText ??
            (digits > 0
                ? 'Percentage with $digits decimal places, e.g. ${_example(digits)}'
                : 'Whole percentage, e.g. 18'),
      ),
      validator: (_) {
        final normalized = applyNormalizedDecimal(
          widget.controller,
          decimalDigits: digits,
          emptyToZero: true,
        );
        if (normalized == null) {
          return widget.invalidMessage ??
              (digits > 0
                  ? 'Enter a percentage with exactly $digits decimal places'
                  : 'Enter a whole percentage');
        }
        return null;
      },
    );
  }
}
