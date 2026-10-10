import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/widgets/app_line_chart.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric_category.dart';
import 'package:luxeknox/features/goals/domain/entities/measurement.dart';
import 'package:luxeknox/features/goals/presentation/cubit/measurements_cubit.dart';
import 'package:luxeknox/features/goals/presentation/goals_strings.dart';
import 'package:luxeknox/features/goals/presentation/screens/measurements_history_screen.dart';
import 'package:luxeknox/features/goals/presentation/screens/measurements_screen.dart';

class MockMeasurementsCubit extends MockCubit<MeasurementsState>
    implements MeasurementsCubit {}

void main() {
  const weightMetric = GoalMetric(
    id: 'm-weight',
    name: 'Weight',
    unitOfMeasure: 'kg',
    category: GoalMetricCategory.bodyComposition,
    isActive: true,
  );

  const bodyFatMetric = GoalMetric(
    id: 'm-bodyfat',
    name: 'Body Fat %',
    unitOfMeasure: '%',
    category: GoalMetricCategory.bodyComposition,
    isActive: true,
  );

  const waistMetric = GoalMetric(
    id: 'm-waist',
    name: 'Waist',
    unitOfMeasure: 'cm',
    category: GoalMetricCategory.circumference,
    isActive: true,
  );

  const calvesMetric = GoalMetric(
    id: 'm-calves',
    name: 'Calves',
    unitOfMeasure: 'cm',
    category: GoalMetricCategory.circumference,
    isActive: true,
  );

  late MockMeasurementsCubit cubit;

  setUp(() {
    cubit = MockMeasurementsCubit();
  });

  group('MeasurementsScreen & MeasurementsHistoryScreen (A2.6)', () {
    testWidgets('empty metrics: renders measurementsEmpty message',
        (tester) async {
      whenListen(
        cubit,
        const Stream<MeasurementsState>.empty(),
        initialState: const MeasurementsState(
          status: LoadStatus.success,
          metrics: [],
          sessions: [],
        ),
      );
      when(() => cubit.load(any())).thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MeasurementsCubit>.value(
            value: cubit,
            child: const MeasurementsScreen(memberId: 'mem-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(GoalsStrings.measurementsEmpty), findsOneWidget);
    });

    testWidgets(
        'three named metrics: renders latest value cards and skips non-named metrics',
        (tester) async {
      final sessionOlder = MeasurementSession(
        id: 's-old',
        memberId: 'mem-1',
        recordedAt: DateTime(2026, 2, 1),
        values: const [
          MeasurementValueEntry(metricId: 'm-weight', value: 80.0),
          MeasurementValueEntry(metricId: 'm-bodyfat', value: 19.0),
          MeasurementValueEntry(metricId: 'm-waist', value: 84.0),
          MeasurementValueEntry(metricId: 'm-calves', value: 39.0),
        ],
      );

      final sessionLatest = MeasurementSession(
        id: 's-new',
        memberId: 'mem-1',
        recordedAt: DateTime(2026, 3, 1),
        values: const [
          MeasurementValueEntry(metricId: 'm-weight', value: 78.5),
          MeasurementValueEntry(metricId: 'm-bodyfat', value: 18.2),
          MeasurementValueEntry(metricId: 'm-waist', value: 82.0),
          MeasurementValueEntry(metricId: 'm-calves', value: 38.0),
        ],
      );

      final stateWithMetrics = MeasurementsState(
        status: LoadStatus.success,
        metrics: const [weightMetric, bodyFatMetric, waistMetric, calvesMetric],
        sessions: [sessionOlder, sessionLatest],
      );

      whenListen(
        cubit,
        const Stream<MeasurementsState>.empty(),
        initialState: stateWithMetrics,
      );
      when(() => cubit.load(any())).thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MeasurementsCubit>.value(
            value: cubit,
            child: const MeasurementsScreen(memberId: 'mem-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Named metric cards with latest session values
      expect(find.text('Weight (kg)'), findsOneWidget);
      expect(find.text('78.5'), findsOneWidget);

      expect(find.text('Body Fat % (%)'), findsOneWidget);
      expect(find.text('18.2'), findsOneWidget);

      expect(find.text('Waist (cm)'), findsOneWidget);
      expect(find.text('82.0'), findsOneWidget);

      // Calves is not one of the 6 named target metrics (A2.1); latest card must NOT be rendered
      expect(find.text('Calves (cm)'), findsNothing);
      expect(find.text('38.0'), findsNothing);
    });

    testWidgets(
        'history screen and second page: renders all metric curves, sessions, and loads second page',
        (tester) async {
      tester.view.physicalSize = const Size(800, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final streamController = StreamController<MeasurementsState>.broadcast();
      addTearDown(streamController.close);

      final session1 = MeasurementSession(
        id: 's-1',
        memberId: 'mem-1',
        recordedAt: DateTime(2026, 3, 1),
        notes: 'First batch notes',
        values: const [
          MeasurementValueEntry(metricId: 'm-weight', value: 78.5),
          MeasurementValueEntry(metricId: 'm-bodyfat', value: 18.2),
          MeasurementValueEntry(metricId: 'm-waist', value: 82.0),
          MeasurementValueEntry(metricId: 'm-calves', value: 38.0),
        ],
      );

      final session2 = MeasurementSession(
        id: 's-2',
        memberId: 'mem-1',
        recordedAt: DateTime(2026, 2, 1),
        notes: 'Second page notes',
        values: const [
          MeasurementValueEntry(metricId: 'm-weight', value: 80.0),
          MeasurementValueEntry(metricId: 'm-bodyfat', value: 19.0),
        ],
      );

      final page1State = MeasurementsState(
        status: LoadStatus.success,
        metrics: const [weightMetric, bodyFatMetric, waistMetric, calvesMetric],
        sessions: [session1],
        hasMore: true,
        nextCursor: 'cursor-page-2',
      );

      final page2State = page1State.copyWith(
        sessions: [session1, session2],
        hasMore: false,
        nextCursor: null,
      );

      whenListen(
        cubit,
        streamController.stream,
        initialState: page1State,
      );
      when(() => cubit.load(any())).thenAnswer((_) async {});
      when(() => cubit.loadMore()).thenAnswer((_) async {
        streamController.add(page2State);
      });

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MeasurementsCubit>.value(
            value: cubit,
            child: const MeasurementsHistoryScreen(memberId: 'mem-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify every metric chart is displayed (A2.2: all metrics returned, not limited to 3)
      expect(find.text('Weight (kg)'), findsOneWidget);
      expect(find.text('Body Fat % (%)'), findsOneWidget);
      expect(find.text('Waist (cm)'), findsOneWidget);
      expect(find.text('Calves (cm)'), findsOneWidget);
      expect(find.byType(AppLineChart), findsNWidgets(4));

      // 2. Verify session items are displayed
      expect(
        find.text(GoalsStrings.calendarDate(session1.recordedAt.toLocal())),
        findsOneWidget,
      );
      expect(find.textContaining('First batch notes'), findsOneWidget);
      expect(
        find.text(GoalsStrings.calendarDate(session2.recordedAt.toLocal())),
        findsNothing,
      );

      // 3. Verify "Load more" button is displayed
      final loadMoreFinder =
          find.widgetWithText(OutlinedButton, GoalsStrings.loadMore);
      expect(loadMoreFinder, findsOneWidget);

      // 4. Tap "Load more", verify cubit.loadMore() is called, and upon state emitting second page sessions, they are rendered
      await tester.tap(loadMoreFinder);
      await tester.pumpAndSettle();

      verify(() => cubit.loadMore()).called(1);

      // Second page session items now rendered
      expect(
        find.text(GoalsStrings.calendarDate(session2.recordedAt.toLocal())),
        findsOneWidget,
      );
      expect(find.textContaining('Second page notes'), findsOneWidget);

      // Load more button is gone since hasMore is false
      expect(
        find.widgetWithText(OutlinedButton, GoalsStrings.loadMore),
        findsNothing,
      );
    });
  });
}
