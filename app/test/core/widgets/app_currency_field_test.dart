import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/widgets/app_currency_field.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('pads decimals on blur', (tester) async {
    final controller = TextEditingController();
    final otherFocus = FocusNode();

    await pumpApp(
      tester,
      Scaffold(
        body: Column(
          children: [
            AppCurrencyField(
              controller: controller,
              label: 'Price',
              currencyCode: 'USD',
            ),
            TextField(focusNode: otherFocus),
          ],
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, '49.9');
    await tester.pump();
    otherFocus.requestFocus();
    await tester.pumpAndSettle();

    expect(controller.text, '49.90');
  });

  testWidgets('pads decimals during form validate', (tester) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await pumpApp(
      tester,
      Scaffold(
        body: Form(
          key: formKey,
          child: AppCurrencyField(
            controller: controller,
            label: 'Price',
            currencyCode: 'USD',
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), '49');
    await tester.pump();
    expect(formKey.currentState!.validate(), isTrue);
    expect(controller.text, '49.00');
  });
}
