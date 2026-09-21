import 'package:app/core/error/failures.dart';
import 'package:app/core/pagination/cursor_page.dart';
import 'package:app/features/workout/domain/entities/workout_personal_record.dart';
import 'package:app/features/workout/domain/entities/workout_session.dart';
import 'package:app/features/workout/domain/entities/workout_session_set.dart';
import 'package:app/features/workout/domain/usecases/list_workout_sessions_usecase.dart';
import 'package:app/features/workout/presentation/cubit/workout_history_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockListSessions extends Mock implements ListWorkoutSessionsUseCase {}

void main() {
  late _MockListSessions listSessions;

  WorkoutSession session({
    required String id,
    DateTime? completedAt,
    num? totalVolumeKg,
    List<WorkoutSessionSet> sets = const [],
  }) {
    return WorkoutSession(
      id: id,
      memberId: '7',
      startedAt: DateTime.utc(2026, 1, 1),
      completedAt: completedAt ?? DateTime.utc(2026, 1, 1, 1),
      totalVolumeKg: totalVolumeKg,
      durationMinutes: 45,
      sets: sets,
    );
  }

  WorkoutSessionSet set({
    required String id,
    required String exerciseId,
    required num? weight,
  }) {
    return WorkoutSessionSet(
      id: id,
      workoutSessionId: 's1',
      exerciseId: exerciseId,
      setNumber: 1,
      weightLiftedKg: weight,
      isCompleted: true,
    );
  }

  setUp(() {
    listSessions = _MockListSessions();
    registerFallbackValue(const ListWorkoutSessionsParams());
  });

  blocTest<WorkoutHistoryCubit, WorkoutHistoryState>(
    'loads sessions and derives personal records from sets',
    build: () {
      when(() => listSessions(any())).thenAnswer(
        (_) async => Right(
          CursorPage(
            items: [
              session(
                id: '1',
                totalVolumeKg: 100,
                sets: [
                  set(id: 'a', exerciseId: '10', weight: 50),
                  set(id: 'b', exerciseId: '10', weight: 60),
                  set(id: 'c', exerciseId: '20', weight: 40),
                ],
              ),
              session(
                id: '2',
                totalVolumeKg: 80,
                sets: [
                  set(id: 'd', exerciseId: '10', weight: 55),
                  set(id: 'e', exerciseId: '20', weight: null),
                ],
              ),
            ],
            nextCursor: 'c2',
            hasMore: true,
          ),
        ),
      );
      return WorkoutHistoryCubit(listSessions);
    },
    act: (cubit) => cubit.load(memberId: '7'),
    expect: () => [
      isA<WorkoutHistoryLoading>(),
      isA<WorkoutHistoryLoaded>()
          .having((s) => s.items.map((e) => e.id).toList(), 'ids', ['1', '2'])
          .having((s) => s.hasMore, 'hasMore', true)
          .having((s) => s.nextCursor, 'cursor', 'c2')
          .having((s) => s.totalVolumeKg, 'volume', 180)
          .having(
            (s) => s.personalRecords,
            'prs',
            [
              const WorkoutPersonalRecord(exerciseId: '10', maxWeightKg: 60),
              const WorkoutPersonalRecord(exerciseId: '20', maxWeightKg: 40),
            ],
          ),
    ],
  );

  blocTest<WorkoutHistoryCubit, WorkoutHistoryState>(
    'emits failure on repository error',
    build: () {
      when(() => listSessions(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return WorkoutHistoryCubit(listSessions);
    },
    act: (cubit) => cubit.load(memberId: '7'),
    expect: () => [
      isA<WorkoutHistoryLoading>(),
      isA<WorkoutHistoryFailure>(),
    ],
  );

  blocTest<WorkoutHistoryCubit, WorkoutHistoryState>(
    'loadMore appends items and recomputes personal records',
    build: () {
      var call = 0;
      when(() => listSessions(any())).thenAnswer((_) async {
        call++;
        if (call == 1) {
          return Right(
            CursorPage(
              items: [
                session(
                  id: '1',
                  totalVolumeKg: 100,
                  sets: [set(id: 'a', exerciseId: '10', weight: 50)],
                ),
              ],
              nextCursor: 'next',
              hasMore: true,
            ),
          );
        }
        return Right(
          CursorPage(
            items: [
              session(
                id: '2',
                totalVolumeKg: 50,
                sets: [set(id: 'b', exerciseId: '10', weight: 80)],
              ),
            ],
            nextCursor: null,
            hasMore: false,
          ),
        );
      });
      return WorkoutHistoryCubit(listSessions);
    },
    act: (cubit) async {
      await cubit.load(memberId: '7');
      await cubit.loadMore();
    },
    expect: () => [
      isA<WorkoutHistoryLoading>(),
      isA<WorkoutHistoryLoaded>()
          .having((s) => s.items.length, 'len', 1)
          .having(
            (s) => s.personalRecords.single.maxWeightKg,
            'pr',
            50,
          ),
      isA<WorkoutHistoryLoaded>().having((s) => s.loadingMore, 'loading', true),
      isA<WorkoutHistoryLoaded>()
          .having((s) => s.items.map((e) => e.id).toList(), 'ids', ['1', '2'])
          .having((s) => s.hasMore, 'hasMore', false)
          .having((s) => s.totalVolumeKg, 'volume', 150)
          .having(
            (s) => s.personalRecords.single.maxWeightKg,
            'pr',
            80,
          ),
    ],
  );

  test('computePersonalRecords ignores null weights and keeps max', () {
    final records = computePersonalRecords([
      session(
        id: '1',
        sets: [
          set(id: 'a', exerciseId: '3', weight: null),
          set(id: 'b', exerciseId: '3', weight: 100),
          set(id: 'c', exerciseId: '3', weight: 90),
        ],
      ),
    ]);
    expect(
      records,
      [const WorkoutPersonalRecord(exerciseId: '3', maxWeightKg: 100)],
    );
  });
}
