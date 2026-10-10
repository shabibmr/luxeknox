import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric_category.dart';
import 'package:luxeknox/features/goals/domain/entities/measurement.dart';
import 'package:luxeknox/features/goals/domain/entities/measurement_list_page.dart';
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
    registerFallbackValue(const ListGoalMetricsParams());
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
        (_) async => const Right(
          CursorPage(
            items: [
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
          MeasurementListPage(
            items: [
              MeasurementSession(
                id: '9',
                memberId: '10',
                recordedAt: DateTime.utc(2026, 1, 1),
                values: const [MeasurementValueEntry(metricId: '1', value: 80)],
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
    'stores mandatory_metric_ids from the list payload',
    build: () {
      when(() => listMetrics(any())).thenAnswer(
        (_) async => const Right(
          CursorPage<GoalMetric>(items: [], nextCursor: null, hasMore: false),
        ),
      );
      when(() => listMeasurements(any())).thenAnswer(
        (_) async => const Right(
          MeasurementListPage(
            items: [],
            nextCursor: null,
            hasMore: false,
            mandatoryMetricIds: ['4', '7'],
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
          .having(
            (s) => s.mandatoryMetricIds,
            'mandatoryMetricIds',
            ['4', '7'],
          ),
    ],
  );

  blocTest<MeasurementsCubit, MeasurementsState>(
    'emits failure when list fails',
    build: () {
      when(() => listMetrics(any())).thenAnswer(
        (_) async => const Right(
          CursorPage<GoalMetric>(items: [], nextCursor: null, hasMore: false),
        ),
      );
      when(
        () => listMeasurements(any()),
      ).thenAnswer((_) async => const Left(NetworkFailure()));
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

  blocTest<MeasurementsCubit, MeasurementsState>(
    'loadMore appends new sessions and updates hasMore and nextCursor',
    build: () {
      when(() => listMetrics(any())).thenAnswer(
        (_) async => const Right(
          CursorPage<GoalMetric>(items: [], nextCursor: null, hasMore: false),
        ),
      );
      var call = 0;
      when(() => listMeasurements(any())).thenAnswer((_) async {
        call++;
        if (call == 1) {
          return Right(
            MeasurementListPage(
              items: [
                MeasurementSession(
                  id: '1',
                  memberId: '10',
                  recordedAt: DateTime.utc(2026, 1, 1),
                  values: const [MeasurementValueEntry(metricId: '1', value: 80)],
                ),
              ],
              nextCursor: 'cursor_1',
              hasMore: true,
              mandatoryMetricIds: const ['1'],
            ),
          );
        }
        return Right(
          MeasurementListPage(
            items: [
              MeasurementSession(
                id: '2',
                memberId: '10',
                recordedAt: DateTime.utc(2026, 1, 2),
                values: const [MeasurementValueEntry(metricId: '1', value: 81)],
              ),
            ],
            nextCursor: 'cursor_2',
            hasMore: false,
            mandatoryMetricIds: const ['1'],
          ),
        );
      });
      return MeasurementsCubit(
        listMeasurements,
        createMeasurement,
        listMetrics,
      );
    },
    act: (cubit) async {
      await cubit.load('10');
      await cubit.loadMore();
    },
    expect: () => [
      isA<MeasurementsState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<MeasurementsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.sessions.length, 'sessions', 1)
          .having((s) => s.hasMore, 'hasMore', true)
          .having((s) => s.nextCursor, 'nextCursor', 'cursor_1'),
      isA<MeasurementsState>()
          .having((s) => s.loadingMore, 'loadingMore', true)
          .having((s) => s.sessions.length, 'sessions', 1),
      isA<MeasurementsState>()
          .having((s) => s.loadingMore, 'loadingMore', false)
          .having((s) => s.sessions.length, 'sessions', 2)
          .having((s) => s.sessions.map((s) => s.id).toList(), 'ids', ['1', '2'])
          .having((s) => s.hasMore, 'hasMore', false)
          .having((s) => s.nextCursor, 'nextCursor', 'cursor_2'),
    ],
    verify: (_) {
      verify(
        () => listMeasurements(
          const ListMeasurementsParams(memberId: '10', limit: 50),
        ),
      ).called(1);
      verify(
        () => listMeasurements(
          const ListMeasurementsParams(
            memberId: '10',
            cursor: 'cursor_1',
            limit: 50,
          ),
        ),
      ).called(1);
    },
  );

  blocTest<MeasurementsCubit, MeasurementsState>(
    'loadMore does nothing when hasMore is false or nextCursor is null',
    build: () {
      when(() => listMetrics(any())).thenAnswer(
        (_) async => const Right(
          CursorPage<GoalMetric>(items: [], nextCursor: null, hasMore: false),
        ),
      );
      when(() => listMeasurements(any())).thenAnswer(
        (_) async => Right(
          MeasurementListPage(
            items: [
              MeasurementSession(
                id: '1',
                memberId: '10',
                recordedAt: DateTime.utc(2026, 1, 1),
                values: const [MeasurementValueEntry(metricId: '1', value: 80)],
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
    act: (cubit) async {
      await cubit.load('10');
      await cubit.loadMore();
    },
    expect: () => [
      isA<MeasurementsState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<MeasurementsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.sessions.length, 'sessions', 1)
          .having((s) => s.hasMore, 'hasMore', false)
          .having((s) => s.nextCursor, 'nextCursor', isNull),
    ],
    verify: (_) {
      verify(
        () => listMeasurements(
          const ListMeasurementsParams(memberId: '10', limit: 50),
        ),
      ).called(1);
      verifyNoMoreInteractions(listMeasurements);
    },
  );

  blocTest<MeasurementsCubit, MeasurementsState>(
    'loadMore emits failure and resets loadingMore when list fails',
    build: () {
      when(() => listMetrics(any())).thenAnswer(
        (_) async => const Right(
          CursorPage<GoalMetric>(items: [], nextCursor: null, hasMore: false),
        ),
      );
      var call = 0;
      when(() => listMeasurements(any())).thenAnswer((_) async {
        call++;
        if (call == 1) {
          return Right(
            MeasurementListPage(
              items: [
                MeasurementSession(
                  id: '1',
                  memberId: '10',
                  recordedAt: DateTime.utc(2026, 1, 1),
                  values: const [MeasurementValueEntry(metricId: '1', value: 80)],
                ),
              ],
              nextCursor: 'cursor_1',
              hasMore: true,
            ),
          );
        }
        return const Left(NetworkFailure());
      });
      return MeasurementsCubit(
        listMeasurements,
        createMeasurement,
        listMetrics,
      );
    },
    act: (cubit) async {
      await cubit.load('10');
      await cubit.loadMore();
    },
    expect: () => [
      isA<MeasurementsState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<MeasurementsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.sessions.length, 'sessions', 1)
          .having((s) => s.hasMore, 'hasMore', true)
          .having((s) => s.nextCursor, 'nextCursor', 'cursor_1'),
      isA<MeasurementsState>()
          .having((s) => s.loadingMore, 'loadingMore', true),
      isA<MeasurementsState>()
          .having((s) => s.loadingMore, 'loadingMore', false)
          .having((s) => s.failure, 'failure', isA<NetworkFailure>())
          .having((s) => s.sessions.length, 'sessions', 1),
    ],
  );
}
