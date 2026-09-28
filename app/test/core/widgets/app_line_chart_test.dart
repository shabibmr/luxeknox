import 'dart:ui';

import 'package:luxeknox/core/widgets/app_chart_types.dart';
import 'package:luxeknox/core/widgets/app_empty_view.dart';
import 'package:luxeknox/core/widgets/app_line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('AppLineChart shows empty state when all series are empty', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const AppLineChart(series: [AppLineSeries(name: 'Visits', points: [])]),
    );

    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.byType(LineChart), findsNothing);
  });

  testWidgets('AppLineChart renders a line chart with data', (tester) async {
    await pumpApp(
      tester,
      const AppLineChart(
        series: [
          AppLineSeries(
            name: 'Visits',
            points: [Offset(0, 1), Offset(1, 4), Offset(2, 2)],
          ),
        ],
      ),
    );

    expect(find.byType(LineChart), findsOneWidget);
    expect(find.byType(AppEmptyView), findsNothing);
  });

  testWidgets('AppLineChart renders multiple series in dark mode', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const AppLineChart(
        series: [
          AppLineSeries(name: 'A', points: [Offset(0, 1), Offset(1, 2)]),
          AppLineSeries(name: 'B', points: [Offset(0, 2), Offset(1, 1)]),
        ],
      ),
      themeMode: ThemeMode.dark,
    );

    expect(find.byType(LineChart), findsOneWidget);
  });

  testWidgets('AppLineChart bottom titles only at data x values', (
    tester,
  ) async {
    await pumpApp(
      tester,
      AppLineChart(
        series: const [
          AppLineSeries(
            name: 'Visits',
            points: [Offset(0, 1), Offset(1, 4), Offset(2, 2)],
          ),
        ],
        xLabelFormatter: (x) => 'x${x.toInt()}',
      ),
    );

    final chart = tester.widget<LineChart>(find.byType(LineChart));
    final bottom = chart.data.titlesData.bottomTitles.sideTitles;
    expect(bottom.interval, 1.0);

    TitleMeta metaFor(double value) => TitleMeta(
      min: 0,
      max: 2,
      parentAxisSize: 200,
      axisPosition: 0,
      appliedInterval: 1,
      sideTitles: bottom,
      formattedValue: value.toStringAsFixed(0),
      axisSide: AxisSide.bottom,
      rotationQuarterTurns: 0,
    );

    expect(bottom.getTitlesWidget(0.5, metaFor(0.5)), isA<SizedBox>());
    expect(bottom.getTitlesWidget(0, metaFor(0)), isA<Padding>());
    expect(bottom.getTitlesWidget(1, metaFor(1)), isA<Padding>());
    expect(bottom.getTitlesWidget(2, metaFor(2)), isA<Padding>());

    expect(find.text('x0'), findsOneWidget);
    expect(find.text('x1'), findsOneWidget);
    expect(find.text('x2'), findsOneWidget);
  });

  test('appLineChart helpers derive unique xs and interval', () {
    const series = [
      AppLineSeries(name: 'A', points: [Offset(0, 1), Offset(2, 3)]),
      AppLineSeries(name: 'B', points: [Offset(0, 2), Offset(1, 1)]),
    ];
    final xs = appLineChartUniqueXs(series);
    expect(xs, [0.0, 1.0, 2.0]);
    expect(appLineChartAxisInterval(xs), 1.0);
    expect(appLineChartIsDataX(0.5, xs, 0.25), isFalse);
    expect(appLineChartIsDataX(1.0, xs, 0.25), isTrue);
  });
}
