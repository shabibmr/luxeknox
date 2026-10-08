import 'package:flutter/material.dart';

/// Normalizes a decimal text input to exactly [decimalDigits] places.
///
/// Returns `null` when [raw] is empty and [emptyToZero] is false, or when the
/// value cannot be parsed as a number. When [emptyToZero] is true, an empty
/// input becomes zero padded to [decimalDigits] (e.g. `0.00`).
String? normalizeDecimalText(
  String raw, {
  required int decimalDigits,
  bool emptyToZero = false,
}) {
  final value = raw.trim();
  if (value.isEmpty) {
    if (!emptyToZero) return null;
    return decimalDigits > 0 ? 0.0.toStringAsFixed(decimalDigits) : '0';
  }
  final number = double.tryParse(value);
  if (number == null) return null;
  if (decimalDigits <= 0) return number.round().toString();
  return number.toStringAsFixed(decimalDigits);
}

/// Writes the normalized decimal into [controller] when it differs.
///
/// Returns the normalized text, or `null` when normalization is not possible
/// (empty without [emptyToZero], or unparseable).
String? applyNormalizedDecimal(
  TextEditingController controller, {
  required int decimalDigits,
  bool emptyToZero = false,
}) {
  final normalized = normalizeDecimalText(
    controller.text,
    decimalDigits: decimalDigits,
    emptyToZero: emptyToZero,
  );
  if (normalized == null) return null;
  if (controller.text != normalized) {
    controller.value = TextEditingValue(
      text: normalized,
      selection: TextSelection.collapsed(offset: normalized.length),
    );
  }
  return normalized;
}
