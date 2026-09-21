import 'package:app/core/error/failures.dart';
import 'package:app/core/pagination/cursor_page.dart';
import 'package:app/features/diet/domain/entities/diet_log.dart';
import 'package:app/features/diet/domain/usecases/list_diet_logs_usecase.dart';
import 'package:app/features/diet/presentation/cubit/diet_history_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockListDietLogs extends Mock implements ListDietLogsUseCase {}

void main() {
  late _MockListDietLogs listDietLogs;

  setUpAll(() {
    registerFallbackValue(
      const ListDietLogsParams(memberId: '1'),
    );
  });

  setUp(() {
    listDietLogs = _MockListDietLogs();
  });

  DietHistoryCubit buildCubit() => DietHistoryCubit(listDietLogs);

  group('DietHistoryCubit', () {
    test('initial state is loading', () {
      expect(buildCubit().state, isA<DietHistoryLoading>());
    });

    blocTest<DietHistoryCubit, DietHistoryState>(
      'loads logs and computes correct metrics',
      build: () {
        when(() => listDietLogs(any())).thenAnswer(
          (_) async => Right(
            CursorPage(
              items: [
                DietLog(
                  id: '1',
                  memberId: '10',
                  loggedDate: DateTime(2026, 9, 20),
                  totalCaloriesConsumed: 2000,
                  adherenceScore: 90,
                  waterIntakeMl: 2500,
                ),
                DietLog(
                  id: '2',
                  memberId: '10',
                  loggedDate: DateTime(2026, 9, 21),
                  totalCaloriesConsumed: 2200,
                  adherenceScore: 80,
                  waterIntakeMl: 1500,
                ),
              ],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.load(memberId: '10'),
      expect: () => [
        isA<DietHistoryLoading>(),
        isA<DietHistoryLoaded>()
            .having((s) => s.logs.length, 'count', 2)
            .having((s) => s.averageAdherenceScore, 'avgAdherence', 85.0)
            .having((s) => s.averageCaloriesConsumed, 'avgCalories', 2100.0)
            .having((s) => s.averageWaterIntakeMl, 'avgWater', 2000)
            .having((s) => s.totalLoggedDays, 'totalDays', 2),
      ],
    );

    blocTest<DietHistoryCubit, DietHistoryState>(
      'emits failure on missing memberId',
      build: () => buildCubit(),
      act: (cubit) => cubit.load(memberId: null),
      expect: () => [
        isA<DietHistoryFailure>(),
      ],
    );

    blocTest<DietHistoryCubit, DietHistoryState>(
      'emits failure on usecase error',
      build: () {
        when(() => listDietLogs(any())).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Error fetching logs')),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.load(memberId: '10'),
      expect: () => [
        isA<DietHistoryLoading>(),
        isA<DietHistoryFailure>().having((s) => s.message, 'message', 'Error fetching logs'),
      ],
    );
  });
}
