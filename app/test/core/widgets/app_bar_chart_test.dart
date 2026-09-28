import 'package:luxeknox/core/widgets/app_bar_chart.dart';
import 'package:luxeknox/core/widgets/app_chart_types.dart';
import 'package:luxeknox/core/widgets/app_empty_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('AppBarChart shows empty state when data is empty', (
    tester,
  ) async {
    await pumpApp(tester, const AppBarChart(data: []));

    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text('No data to display'), findsOneWidget);
    expect(find.byType(BarChart), findsNothing);
  });

  testWidgets('AppBarChart renders a bar chart with data', (tester) async {
    await pumpApp(
      tester,
      const AppBarChart(
        data: [
          AppChartPoint(label: 'Mon', value: 3),
          AppChartPoint(label: 'Tue', value: 7),
        ],
      ),
    );

    expect(find.byType(BarChart), findsOneWidget);
    expect(find.byType(AppEmptyView), findsNothing);
  });

  testWidgets('AppBarChart renders in dark mode without error', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const AppBarChart(
        data: [AppChartPoint(label: 'Mon', value: 3)],
      ),
      themeMode: ThemeMode.dark,
    );

    expect(find.byType(BarChart), findsOneWidget);
  });
}
