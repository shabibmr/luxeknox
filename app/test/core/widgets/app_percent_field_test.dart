import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/widgets/app_percent_field.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('pads partial percent on blur', (tester) async {
    final controller = TextEditingController(text: '18');
    final otherFocus = FocusNode();

    await pumpApp(
      tester,
      Scaffold(
        body: Column(
          children: [
            AppPercentField(controller: controller, label: 'Tax'),
            TextField(focusNode: otherFocus),
          ],
        ),
      ),
    );

    await tester.tap(find.byType(TextFormField).first);
    await tester.pump();
    otherFocus.requestFocus();
    await tester.pumpAndSettle();

    expect(controller.text, '18.00');
  });

  testWidgets('empty becomes 0.00 on validate', (tester) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await pumpApp(
      tester,
      Scaffold(
        body: Form(
          key: formKey,
          child: AppPercentField(controller: controller, label: 'Tax'),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isTrue);
    expect(controller.text, '0.00');
  });
}
