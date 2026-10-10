import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/widgets/decimal_text_input.dart';

void main() {
  group('normalizeDecimalText', () {
    test('pads partial decimals', () {
      expect(normalizeDecimalText('49', decimalDigits: 2), '49.00');
      expect(normalizeDecimalText('49.9', decimalDigits: 2), '49.90');
      expect(normalizeDecimalText('18.00', decimalDigits: 2), '18.00');
    });

    test('empty returns null unless emptyToZero', () {
      expect(normalizeDecimalText('', decimalDigits: 2), isNull);
      expect(
        normalizeDecimalText('', decimalDigits: 2, emptyToZero: true),
        '0.00',
      );
    });

    test('rejects unparseable input', () {
      expect(normalizeDecimalText('abc', decimalDigits: 2), isNull);
    });

    test('zero-decimal currencies round to whole numbers', () {
      expect(normalizeDecimalText('49.7', decimalDigits: 0), '50');
    });
  });

  group('applyNormalizedDecimal', () {
    test('updates the controller text', () {
      final controller = TextEditingController(text: '12.5');
      final normalized = applyNormalizedDecimal(controller, decimalDigits: 2);
      expect(normalized, '12.50');
      expect(controller.text, '12.50');
    });
  });
}
