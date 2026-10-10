import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_history.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_metric_category.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_status.dart';
import 'package:luxeknox/features/goals/domain/entities/measurement.dart';
import 'package:luxeknox/features/goals/domain/entities/measurement_list_page.dart';
import 'package:luxeknox/features/goals/domain/entities/member_goal.dart';
import 'package:luxeknox/features/goals/domain/usecases/goals_usecases.dart';
import 'package:luxeknox/features/goals/domain/usecases/measurements_usecases.dart';
import 'package:luxeknox/features/goals/presentation/cubit/progress_timeline_cubit.dart';

class _MockListGoals extends Mock implements ListMemberGoalsUseCase {}

class _MockListMeasurements extends Mock implements ListMeasurementsUseCase {}

void main() {
  late _MockListGoals listGoals;
  late _MockListMeasurements listMeasurements;

  setUpAll(() {
    registerFallbackValue(const MemberIdParams('0'));
    registerFallbackValue(const ListMeasurementsParams(memberId: '0'));
  });

  setUp(() {
    listGoals = _MockListGoals();
    listMeasurements = _MockListMeasurements();
  });

  final metric = const GoalMetric(
    id: 'm1',
    name: 'Weight',
    unitOfMeasure: 'kg',
    category: GoalMetricCategory.bodyComposition,
    isActive: true,
  );

  final olderCheckIn = GoalHistoryEntry(
    id: 'h1',
    goalId: 'g1',
    recordedValue: 80,
    recordedDate: DateTime(2026, 1, 1),
  );
  final newerCheckIn = GoalHistoryEntry(
    id: 'h2',
    goalId: 'g1',
    recordedValue: 78,
    recordedDate: DateTime(2026, 2, 1),
  );

  final goal = MemberGoal(
    id: 'g1',
    memberId: '10',
    metricId: 'm1',
    status: GoalStatus.inProgress,
    metric: metric,
    history: [newerCheckIn, olderCheckIn],
  );

  final session = MeasurementSession(
    id: 's1',
    memberId: '10',
    recordedAt: DateTime(2026, 1, 15),
    values: const [
      MeasurementValueEntry(metricId: 'm1', value: 79),
    ],
  );

  blocTest<ProgressTimelineCubit, ProgressTimelineState>(
    'merges goal histories and sessions newest first',
    build: () {
      when(() => listGoals(any())).thenAnswer(
        (_) async => Right(
          CursorPage(items: [goal], nextCursor: null, hasMore: false),
        ),
      );
      when(() => listMeasurements(any())).thenAnswer(
        (_) async => Right(
          MeasurementListPage(
            items: [session],
            nextCursor: null,
            hasMore: false,
          ),
        ),
      );
      return ProgressTimelineCubit(listGoals, listMeasurements);
    },
    act: (cubit) => cubit.load('10'),
    expect: () => [
      isA<ProgressTimelineState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<ProgressTimelineState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.items.length, 'count', 3)
          .having(
            (s) => s.items.map((e) => e.id).toList(),
            'order',
            ['goal-h2', 'meas-s1', 'goal-h1'],
          ),
    ],
  );
}
