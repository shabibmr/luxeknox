import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../currency/gym_currency_provider.dart';
import 'decimal_text_input.dart';

/// Reusable money-amount input: shows the gym's currency symbol as a prefix
/// and pads entered amounts to exactly [decimalDigits] decimal places on blur
/// and before validate (e.g. `49` → `49.00`), matching how the currency is
/// quoted (`decimalDigits` from [currencyDecimalDigits]).
///
/// Used for any monetary amount field (base price, etc.) so validation and
/// formatting stay consistent across forms instead of being re-implemented
/// per screen.
class AppCurrencyField extends StatefulWidget {
  const AppCurrencyField({
    super.key,
    required this.controller,
    required this.label,
    this.currencyCode,
    this.decimalDigits,
    this.enabled = true,
    this.required = true,
    this.helperText,
    this.requiredMessage,
    this.invalidMessage,
  });

  final TextEditingController controller;
  final String label;

  /// ISO 4217 currency code (e.g. `USD`). When null, falls back to a `$`
  /// prefix and 2 decimal places.
  final String? currencyCode;

  /// Overrides the decimal places derived from [currencyCode].
  final int? decimalDigits;

  final bool enabled;

  /// Whether an empty value fails validation.
  final bool required;

  final String? helperText;
  final String? requiredMessage;
  final String? invalidMessage;

  @override
  State<AppCurrencyField> createState() => _AppCurrencyFieldState();
}

class _AppCurrencyFieldState extends State<AppCurrencyField> {
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocusChange);

  int get _digits =>
      widget.decimalDigits ?? currencyDecimalDigits(widget.currencyCode);

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      applyNormalizedDecimal(widget.controller, decimalDigits: _digits);
    }
  }

  String _example(int digits) => '49.${'9' * digits}';

  @override
  Widget build(BuildContext context) {
    final digits = _digits;
    final symbol = currencySymbol(widget.currencyCode);
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
        prefixText: '$symbol ',
        helperText:
            widget.helperText ??
            (digits > 0
                ? 'Amount with $digits decimal places, e.g. ${_example(digits)}'
                : 'Whole amount, e.g. 50'),
      ),
      validator: (v) {
        final value = v?.trim() ?? '';
        if (value.isEmpty) {
          return widget.required
              ? (widget.requiredMessage ?? '${widget.label} is required')
              : null;
        }
        final normalized = applyNormalizedDecimal(
          widget.controller,
          decimalDigits: digits,
        );
        if (normalized == null) {
          return widget.invalidMessage ??
              (digits > 0
                  ? 'Enter an amount with exactly $digits decimal places'
                  : 'Enter a whole number');
        }
        return null;
      },
    );
  }
}
