import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/widgets/app_picker_form_field.dart';

void main() {
  group('AppPickerFormField', () {
    testWidgets('displays hintText when value is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPickerFormField<String>(
              hintText: 'Choose option',
              value: null,
              onPick: (_) async => null,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Choose option'), findsOneWidget);
    });

    testWidgets('displays formatted label when value is present', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPickerFormField<String>(
              value: 'selected_val',
              labelBuilder: (v) => 'Formatted: $v',
              onPick: (_) async => null,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Formatted: selected_val'), findsOneWidget);
    });

    testWidgets('tapping field triggers onPick and calls onChanged', (tester) async {
      String? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPickerFormField<String>(
              fieldKey: const Key('my_picker_field'),
              value: null,
              onPick: (_) async => 'new_choice',
              onChanged: (val) => selected = val,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('my_picker_field')));
      await tester.pumpAndSettle();

      expect(selected, 'new_choice');
    });

    testWidgets('tapping clear button emits null to onChanged', (tester) async {
      String? selected = 'existing';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppPickerFormField<String>(
              clearButtonKey: const Key('my_clear_btn'),
              value: 'existing',
              onPick: (_) async => null,
              onChanged: (val) => selected = val,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('my_clear_btn')), findsOneWidget);
      await tester.tap(find.byKey(const Key('my_clear_btn')));
      await tester.pumpAndSettle();

      expect(selected, isNull);
    });
  });
}
