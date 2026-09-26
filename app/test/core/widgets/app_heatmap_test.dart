import 'package:luxeknox/core/widgets/app_empty_view.dart';
import 'package:luxeknox/core/widgets/app_heatmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('AppHeatmap shows empty state when values are empty', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const AppHeatmap(values: [], rowLabels: [], colLabels: []),
    );

    expect(find.byType(AppEmptyView), findsOneWidget);
  });

  testWidgets('AppHeatmap renders row and column labels with data', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const AppHeatmap(
        values: [
          [1, 2],
          [3, 4],
        ],
        rowLabels: ['Mon', 'Tue'],
        colLabels: ['9am', '10am'],
      ),
    );

    expect(find.byType(AppEmptyView), findsNothing);
    expect(find.text('Mon'), findsOneWidget);
    expect(find.text('Tue'), findsOneWidget);
    expect(find.text('9am'), findsOneWidget);
    expect(find.text('10am'), findsOneWidget);
  });

  testWidgets('AppHeatmap renders in dark mode without error', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const AppHeatmap(
        values: [
          [1, 2],
        ],
        rowLabels: ['Mon'],
        colLabels: ['9am', '10am'],
      ),
      themeMode: ThemeMode.dark,
    );

    expect(find.text('Mon'), findsOneWidget);
  });
}
