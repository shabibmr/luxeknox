import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/attendance/domain/entities/attendance_enums.dart';
import 'package:luxeknox/features/attendance/domain/entities/attendance_record.dart';
import 'package:luxeknox/features/attendance/domain/usecases/attendance_usecases.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric_category.dart';
import 'package:luxeknox/features/goals/domain/entities/measurement.dart';
import 'package:luxeknox/features/goals/domain/usecases/goal_metrics_usecases.dart';
import 'package:luxeknox/features/goals/domain/usecases/measurements_usecases.dart';
import 'package:luxeknox/features/goals/presentation/cubit/progress_overview_cubit.dart';
import 'package:luxeknox/features/goals/presentation/goals_strings.dart';
import 'package:luxeknox/features/goals/presentation/screens/progress_overview_screen.dart';
import 'package:luxeknox/features/people/domain/entities/health_info.dart';
import 'package:luxeknox/features/people/domain/usecases/list_health_history_usecase.dart';

class _MockListGoalMetrics extends Mock implements ListGoalMetricsUseCase {}

class _MockGetMeasurementChart extends Mock
    implements GetMeasurementChartUseCase {}

class _MockListAttendances extends Mock implements ListAttendancesUseCase {}

class _MockListHealthHistory extends Mock implements ListHealthHistoryUseCase {}

void main() {
  const memberId = 'mem-101';

  final weightMetric = const GoalMetric(
    id: '1',
    name: 'Weight',
    unitOfMeasure: 'kg',
    category: GoalMetricCategory.bodyComposition,
    isActive: true,
  );

  final bodyFatMetric = const GoalMetric(
    id: '2',
    name: 'Body Fat %',
    unitOfMeasure: '%',
    category: GoalMetricCategory.bodyComposition,
    isActive: true,
  );

  final waistMetric = const GoalMetric(
    id: '3',
    name: 'Waist',
    unitOfMeasure: 'cm',
    category: GoalMetricCategory.circumference,
    isActive: true,
  );

  final samplePoints = [
    ChartDataPoint(
      recordedAt: DateTime(2026, 1, 1),
      value: 80.0,
      metricName: 'Weight',
      unitOfMeasure: 'kg',
    ),
    ChartDataPoint(
      recordedAt: DateTime(2026, 1, 15),
      value: 78.5,
      metricName: 'Weight',
      unitOfMeasure: 'kg',
    ),
  ];

  final sampleFatPoints = [
    ChartDataPoint(
      recordedAt: DateTime(2026, 1, 1),
      value: 20.0,
      metricName: 'Body Fat %',
      unitOfMeasure: '%',
    ),
    ChartDataPoint(
      recordedAt: DateTime(2026, 1, 15),
      value: 19.2,
      metricName: 'Body Fat %',
      unitOfMeasure: '%',
    ),
  ];

  final sampleWaistPoints = [
    ChartDataPoint(
      recordedAt: DateTime(2026, 1, 1),
      value: 85.0,
      metricName: 'Waist',
      unitOfMeasure: 'cm',
    ),
  ];

  final sampleAttendance = <AttendanceRecord>[
    AttendanceRecord(
      id: 'att-1',
      userId: memberId,
      checkInTime: DateTime.now().subtract(const Duration(days: 3)),
      method: AttendanceCheckInMethod.qrCode,
    ),
    AttendanceRecord(
      id: 'att-2',
      userId: memberId,
      checkInTime: DateTime.now().subtract(const Duration(days: 10)),
      method: AttendanceCheckInMethod.qrCode,
    ),
  ];

  late _MockListGoalMetrics listMetrics;
  late _MockGetMeasurementChart getChart;
  late _MockListAttendances listAttendances;
  late _MockListHealthHistory listHealth;

  setUpAll(() {
    registerFallbackValue(const ListGoalMetricsParams());
    registerFallbackValue(
      const GetMeasurementChartParams(memberId: '0', metricId: '0'),
    );
    registerFallbackValue(const ListAttendancesParams());
  });

  setUp(() {
    listMetrics = _MockListGoalMetrics();
    getChart = _MockGetMeasurementChart();
    listAttendances = _MockListAttendances();
    listHealth = _MockListHealthHistory();
    when(() => listHealth(any())).thenAnswer((_) async => const Right([]));

    when(() => listMetrics(any())).thenAnswer(
      (_) async => Right(
        CursorPage(
          items: [weightMetric, bodyFatMetric, waistMetric],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );

    when(() => getChart(any())).thenAnswer((inv) async {
      final params = inv.positionalArguments.first as GetMeasurementChartParams;
      if (params.metricId == '1') {
        return Right(samplePoints);
      } else if (params.metricId == '2') {
        return Right(sampleFatPoints);
      } else if (params.metricId == '3') {
        return Right(sampleWaistPoints);
      }
      return const Right([]);
    });

    when(() => listAttendances(any())).thenAnswer(
      (_) async => Right(
        CursorPage(
          items: sampleAttendance,
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
  });

  tearDown(() => getIt.reset());

  Widget buildTestWidget({
    required ProgressOverviewCubit cubit,
    bool isTrainerContext = false,
  }) {
    return MaterialApp(
      home: BlocProvider<ProgressOverviewCubit>.value(
        value: cubit,
        child: ProgressOverviewScreen(
          memberId: memberId,
          isTrainerContext: isTrainerContext,
        ),
      ),
    );
  }

  testWidgets('renders weight, body composition and attendance charts for member', (
    tester,
  ) async {
    final cubit = ProgressOverviewCubit(listMetrics, getChart, listAttendances, listHealth);
    await cubit.load(memberId, includeCircumference: false);

    await tester.pumpWidget(buildTestWidget(cubit: cubit));
    await tester.pumpAndSettle();

    expect(find.text(GoalsStrings.overviewTitle), findsOneWidget);
    expect(find.text(GoalsStrings.weightTrendTitle), findsOneWidget);
    expect(find.text(GoalsStrings.attendanceWeeklyTitle), findsOneWidget);
    expect(find.text(GoalsStrings.bodyCompositionTitle), findsOneWidget);
    expect(find.text('Body Fat %'), findsOneWidget);

    // Member view should NOT show circumference metrics
    expect(find.text(GoalsStrings.circumferenceTitle), findsNothing);
    expect(find.text('Waist'), findsNothing);
  });

  testWidgets('renders circumference charts in trainer context', (
    tester,
  ) async {
    final cubit = ProgressOverviewCubit(listMetrics, getChart, listAttendances, listHealth);
    await cubit.load(memberId, includeCircumference: true);

    await tester.pumpWidget(
      buildTestWidget(cubit: cubit, isTrainerContext: true),
    );
    await tester.pumpAndSettle();

    expect(find.text(GoalsStrings.overviewTitle), findsOneWidget);
    expect(find.text(GoalsStrings.weightTrendTitle), findsOneWidget);
    expect(find.text(GoalsStrings.attendanceWeeklyTitle), findsOneWidget);
    expect(find.text(GoalsStrings.bodyCompositionTitle), findsOneWidget);
    expect(find.text('Body Fat %'), findsOneWidget);

    // Trainer view includes circumference
    expect(find.text(GoalsStrings.circumferenceTitle), findsOneWidget);
    expect(find.text('Waist'), findsOneWidget);
  });

  testWidgets('renders empty view when no data points exist', (
    tester,
  ) async {
    when(() => listMetrics(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(items: [], nextCursor: null, hasMore: false),
      ),
    );
    when(() => listAttendances(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(items: [], nextCursor: null, hasMore: false),
      ),
    );

    final cubit = ProgressOverviewCubit(listMetrics, getChart, listAttendances, listHealth);
    await cubit.load(memberId);

    await tester.pumpWidget(buildTestWidget(cubit: cubit));
    await tester.pumpAndSettle();

    expect(find.text(GoalsStrings.chartsEmpty), findsOneWidget);
  });

  testWidgets('renders error view on failure', (
    tester,
  ) async {
    when(() => listMetrics(any())).thenAnswer(
      (_) async => const Left(BusinessRuleFailure('Failed to load metrics')),
    );

    final cubit = ProgressOverviewCubit(listMetrics, getChart, listAttendances, listHealth);
    await cubit.load(memberId);

    await tester.pumpWidget(buildTestWidget(cubit: cubit));
    await tester.pumpAndSettle();

    expect(find.text('Failed to load metrics'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('shows BMI when height and latest weight exist', (tester) async {
    const numericId = '101';
    when(() => listHealth(any())).thenAnswer(
      (_) async => Right([
        HealthInfo(
          id: 1,
          memberId: 101,
          heightCm: 180,
          recordedAt: DateTime(2026, 1, 1),
        ),
      ]),
    );

    final cubit = ProgressOverviewCubit(
      listMetrics,
      getChart,
      listAttendances,
      listHealth,
    );
    await cubit.load(numericId);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProgressOverviewCubit>.value(
          value: cubit,
          child: const ProgressOverviewScreen(memberId: numericId),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(GoalsStrings.bmiTitle), findsOneWidget);
    // 78.5 kg / (1.8^2) ≈ 24.2
    expect(find.text('24.2'), findsOneWidget);
  });

  testWidgets('shows height empty state when height is missing', (
    tester,
  ) async {
    final cubit = ProgressOverviewCubit(
      listMetrics,
      getChart,
      listAttendances,
      listHealth,
    );
    await cubit.load(memberId);

    await tester.pumpWidget(buildTestWidget(cubit: cubit));
    await tester.pumpAndSettle();

    expect(find.text(GoalsStrings.bmiTitle), findsOneWidget);
    expect(find.text(GoalsStrings.bmiHeightMissing), findsOneWidget);
  });
}
