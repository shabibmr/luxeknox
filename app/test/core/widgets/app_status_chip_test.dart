import 'package:luxeknox/core/widgets/app_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('AppStatusChip tinted mode colors label with the given color', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const Scaffold(
        body: AppStatusChip(label: 'Active', color: Colors.green),
      ),
    );

    expect(find.text('Active'), findsOneWidget);
    final chip = tester.widget<Chip>(find.byType(Chip));
    expect(chip.backgroundColor, Colors.green.withValues(alpha: 0.15));
    final labelStyle = chip.labelStyle;
    expect(labelStyle?.color, Colors.green);
    expect(labelStyle?.fontWeight, FontWeight.w600);
    expect(chip.avatar, isNull);
  });

  testWidgets('AppStatusChip untinted mode uses color/foregroundColor as-is', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const Scaffold(
        body: AppStatusChip(
          label: 'Achieved',
          color: Colors.amber,
          foregroundColor: Colors.black,
          icon: Icons.emoji_events,
          tinted: false,
        ),
      ),
    );

    final chip = tester.widget<Chip>(find.byType(Chip));
    expect(chip.backgroundColor, Colors.amber);
    expect(chip.labelStyle?.color, Colors.black);
    expect(find.byIcon(Icons.emoji_events), findsOneWidget);
  });
}
