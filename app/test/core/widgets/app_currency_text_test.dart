import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/widgets/app_currency_text.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('formats a value with the requested currency', (tester) async {
    await pumpApp(
      tester,
      const Scaffold(
        body: AppCurrencyText('49.5', currencyCode: 'USD'),
      ),
    );

    expect(find.text('$49.50'), findsOneWidget);
  });

  testWidgets('shows a placeholder for invalid values', (tester) async {
    await pumpApp(
      tester,
      const Scaffold(body: AppCurrencyText('not-money', currencyCode: 'USD')),
    );

    expect(find.text('—'), findsOneWidget);
  });
}
