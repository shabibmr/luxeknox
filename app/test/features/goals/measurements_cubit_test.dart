import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric_category.dart';
import 'package:luxeknox/features/goals/domain/entities/measurement.dart';
import 'package:luxeknox/features/goals/domain/usecases/goal_metrics_usecases.dart';
import 'package:luxeknox/features/goals/domain/usecases/measurements_usecases.dart';
import 'package:luxeknox/features/goals/presentation/cubit/measurements_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockListMeasurements extends Mock implements ListMeasurementsUseCase {}

class _MockCreateMeasurement extends Mock implements CreateMeasurementUseCase {}

class _MockListMetrics extends Mock implements ListGoalMetricsUseCase {}

void main() {
  late _MockListMeasurements listMeasurements;
  late _MockCreateMeasurement createMeasurement;
  late _MockListMetrics listMetrics;

  setUpAll(() {
    registerFallbackValue(const ListMeasurementsParams(memberId: '0'));
    registerFallbackValue(
      const CreateMeasurementParams(memberId: '0', values: []),
    );
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    listMeasurements = _MockListMeasurements();
    createMeasurement = _MockCreateMeasurement();
    listMetrics = _MockListMetrics();
  });

  blocTest<MeasurementsCubit, MeasurementsState>(
    'loads sessions and metrics',
    build: () {
      when(() => listMetrics(any())).thenAnswer(
        (_) async => Right(
          CursorPage(
            items: const [
              GoalMetric(
                id: '1',
                name: 'Weight',
                unitOfMeasure: 'kg',
                category: GoalMetricCategory.bodyComposition,
                isActive: true,
              ),
            ],
            nextCursor: null,
            hasMore: false,
          ),
        ),
      );
      when(() => listMeasurements(any())).thenAnswer(
        (_) async => Right(
          CursorPage(
            items: [
              MeasurementSession(
                id: '9',
                memberId: '10',
                recordedAt: DateTime.utc(2026, 1, 1),
                values: const [
                  MeasurementValueEntry(metricId: '1', value: 80),
                ],
              ),
            ],
            nextCursor: null,
            hasMore: false,
          ),
        ),
      );
      return MeasurementsCubit(
        listMeasurements,
        createMeasurement,
        listMetrics,
      );
    },
    act: (cubit) => cubit.load('10'),
    expect: () => [
      isA<MeasurementsState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<MeasurementsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.sessions.length, 'sessions', 1)
          .having((s) => s.metrics.length, 'metrics', 1),
    ],
  );

  blocTest<MeasurementsCubit, MeasurementsState>(
    'emits failure when list fails',
    build: () {
      when(() => listMetrics(any())).thenAnswer(
        (_) async => Right(
          CursorPage<GoalMetric>(
            items: const [],
            nextCursor: null,
            hasMore: false,
          ),
        ),
      );
      when(() => listMeasurements(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return MeasurementsCubit(
        listMeasurements,
        createMeasurement,
        listMetrics,
      );
    },
    act: (cubit) => cubit.load('10'),
    expect: () => [
      isA<MeasurementsState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<MeasurementsState>()
          .having((s) => s.status, 'status', LoadStatus.failure)
          .having((s) => s.failure, 'failure', isA<NetworkFailure>())
          .having((s) => s.sessions, 'sessions', isEmpty),
    ],
  );
}
