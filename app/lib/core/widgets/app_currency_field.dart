import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../currency/gym_currency_provider.dart';
import '../di/injector.dart';
import 'decimal_text_input.dart';

/// Reusable input for a monetary amount.
///
/// Currency and decimal precision default to the gym's public settings. The
/// widget keeps validation side-effect-free: values are normalized when focus
/// is lost, while callers may explicitly normalize immediately before submit.
class AppCurrencyField extends StatefulWidget {
  const AppCurrencyField({
    super.key,
    required this.controller,
    required this.label,
    this.currencyCode,
    this.decimalDigits,
    this.enabled = true,
    this.readOnly = false,
    this.required = true,
    this.minValue,
    this.maxValue,
    this.helperText,
    this.errorText,
    this.requiredMessage,
    this.invalidMessage,
    this.minValueMessage,
    this.maxValueMessage,
    this.validator,
    this.onChanged,
  }) : assert(minValue == null || maxValue == null || minValue <= maxValue),
       assert(decimalDigits == null || decimalDigits >= 0);

  final TextEditingController controller;
  final String label;
  final String? currencyCode;
  final int? decimalDigits;
  final bool enabled;
  final bool readOnly;
  final bool required;
  final num? minValue;
  final num? maxValue;
  final String? helperText;
  final String? errorText;
  final String? requiredMessage;
  final String? invalidMessage;
  final String? minValueMessage;
  final String? maxValueMessage;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  @override
  State<AppCurrencyField> createState() => _AppCurrencyFieldState();
}

class _AppCurrencyFieldState extends State<AppCurrencyField> {
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocusChange);
  String? _resolvedCurrencyCode;

  String? get _currencyCode => widget.currencyCode ?? _resolvedCurrencyCode;

  int get _digits =>
      widget.decimalDigits ?? currencyDecimalDigits(_currencyCode);

  @override
  void initState() {
    super.initState();
    unawaited(_loadCurrencyCode());
  }

  @override
  void didUpdateWidget(covariant AppCurrencyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currencyCode != widget.currencyCode &&
        widget.currencyCode == null) {
      unawaited(_loadCurrencyCode());
    }
  }

  Future<void> _loadCurrencyCode() async {
    if (widget.currencyCode != null ||
        !getIt.isRegistered<GymCurrencyProvider>()) {
      return;
    }
    try {
      final code = await getIt<GymCurrencyProvider>().currencyCode();
      if (!mounted || code == _resolvedCurrencyCode) return;
      setState(() => _resolvedCurrencyCode = code);
    } catch (_) {
      // Currency settings are optional for rendering; helper functions use
      // their documented INR/2-decimal fallback when no code is available.
    }
  }

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

  String _example(int digits) =>
      digits > 0 ? '49.' + List.filled(digits, '9').join() : '50';

  String? _commonValidator(String? raw) {
    final value = raw?.trim() ?? '';
    if (value.isEmpty) {
      if (widget.required) {
        return widget.requiredMessage ?? '${widget.label} is required';
      }
      return widget.validator?.call(raw);
    }

    final number = num.tryParse(value);
    if (number == null || !number.isFinite || number < 0) {
      return widget.invalidMessage ?? 'Enter a valid amount';
    }

    final validPattern = _digits > 0
        ? RegExp(r'^\d+(\.\d{0,' + _digits.toString() + r'})?$')
        : RegExp(r'^\d+$');
    if (!validPattern.hasMatch(value)) {
      return widget.invalidMessage ??
          (_digits == 0
              ? 'Enter a whole number'
              : 'Enter an amount with up to $_digits decimal places');
    }
    if (widget.minValue != null && number < widget.minValue!) {
      return widget.minValueMessage ??
          '${widget.label} must be at least ${widget.minValue}';
    }
    if (widget.maxValue != null && number > widget.maxValue!) {
      return widget.maxValueMessage ??
          '${widget.label} must be at most ${widget.maxValue}';
    }
    return widget.validator?.call(raw);
  }

  @override
  Widget build(BuildContext context) {
    final digits = _digits;
    final symbol = currencySymbol(_currencyCode);
    final pattern = digits > 0
        ? RegExp(r'^\d+(\.\d{0,' + digits.toString() + r'})?$')
        : RegExp(r'^\d+$');

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.isEmpty) return newValue;
          return pattern.hasMatch(newValue.text) ? newValue : oldValue;
        }),
      ],
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixText: '$symbol ',
        errorText: widget.errorText,
        helperText:
            widget.helperText ??
            (digits > 0
                ? 'Amount with up to $digits decimal places, e.g. ${_example(digits)}'
                : 'Whole amount, e.g. 50'),
      ),
      validator: _commonValidator,
    );
  }
}

/// Money input that owns its controller, for rows that only have an initial value.
class AppCurrencyInput extends StatefulWidget {
  const AppCurrencyInput({
    super.key,
    required this.initialValue,
    required this.label,
    required this.onChanged,
    this.required = true,
    this.helperText,
  });

  final String initialValue;
  final String label;
  final ValueChanged<String> onChanged;
  final bool required;
  final String? helperText;

  @override
  State<AppCurrencyInput> createState() => _AppCurrencyInputState();
}

class _AppCurrencyInputState extends State<AppCurrencyInput> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppCurrencyField(
    controller: _controller,
    label: widget.label,
    required: widget.required,
    helperText: widget.helperText,
    onChanged: widget.onChanged,
  );
}
