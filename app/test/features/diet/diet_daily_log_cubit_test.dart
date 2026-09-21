import 'package:app/core/pagination/cursor_page.dart';
import 'package:app/features/diet/domain/entities/diet_log.dart';
import 'package:app/features/diet/domain/entities/diet_plan.dart';
import 'package:app/features/diet/domain/entities/diet_plan_status.dart';
import 'package:app/features/diet/domain/usecases/list_diet_logs_usecase.dart';
import 'package:app/features/diet/domain/usecases/list_diet_plans_usecase.dart';
import 'package:app/features/diet/domain/usecases/record_diet_log_usecase.dart';
import 'package:app/features/diet/presentation/cubit/diet_daily_log_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRecordDietLog extends Mock implements RecordDietLogUseCase {}
class _MockListDietLogs extends Mock implements ListDietLogsUseCase {}
class _MockListDietPlans extends Mock implements ListDietPlansUseCase {}

void main() {
  late _MockRecordDietLog recordDietLog;
  late _MockListDietLogs listDietLogs;
  late _MockListDietPlans listDietPlans;

  final testDate = DateTime(2026, 9, 21);

  setUpAll(() {
    registerFallbackValue(
      RecordDietLogParams(
        memberId: '1',
        date: testDate,
      ),
    );
    registerFallbackValue(
      const ListDietLogsParams(memberId: '1'),
    );
    registerFallbackValue(
      const ListDietPlansParams(memberId: '1'),
    );
  });

  setUp(() {
    recordDietLog = _MockRecordDietLog();
    listDietLogs = _MockListDietLogs();
    listDietPlans = _MockListDietPlans();
  });

  DietDailyLogCubit buildCubit() =>
      DietDailyLogCubit(recordDietLog, listDietLogs, listDietPlans);

  group('DietDailyLogCubit', () {
    test('initial state is initial', () {
      final cubit = buildCubit();
      expect(cubit.state.status, DietDailyLogStatus.initial);
      expect(cubit.state.waterIntakeMl, 0);
    });

    blocTest<DietDailyLogCubit, DietDailyLogState>(
      'init loads active plan target and existing log',
      build: () {
        when(() => listDietPlans(any())).thenAnswer(
          (_) async => const Right(
            CursorPage(
              items: [
                DietPlan(
                  id: 'p1',
                  title: 'Cutting Plan',
                  status: DietPlanStatus.active,
                  dailyCalorieTarget: 2000,
                  rowVersion: 1,
                  isTemplate: false,
                ),
              ],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        when(() => listDietLogs(any())).thenAnswer(
          (_) async => Right(
            CursorPage(
              items: [
                DietLog(
                  id: 'l1',
                  memberId: '42',
                  loggedDate: testDate,
                  totalCaloriesConsumed: 1900,
                  adherenceScore: 95,
                  waterIntakeMl: 1500,
                  memberNotes: 'Felt great',
                ),
              ],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );

        return buildCubit();
      },
      act: (cubit) => cubit.init('42', date: testDate),
      expect: () => [
        isA<DietDailyLogState>().having((s) => s.status, 'status', DietDailyLogStatus.loading),
        isA<DietDailyLogState>()
            .having((s) => s.status, 'status', DietDailyLogStatus.ready)
            .having((s) => s.caloriesConsumed, 'calories', 1900)
            .having((s) => s.waterIntakeMl, 'water', 1500)
            .having((s) => s.targetCalories, 'target', 2000)
            .having((s) => s.memberNotes, 'notes', 'Felt great'),
      ],
    );

    blocTest<DietDailyLogCubit, DietDailyLogState>(
      'updateCalories recalculates adherence score based on target',
      build: () {
        return buildCubit();
      },
      seed: () => DietDailyLogState(
        memberId: '42',
        date: testDate,
        targetCalories: 2000,
      ),
      act: (cubit) => cubit.updateCalories(1800),
      expect: () => [
        isA<DietDailyLogState>()
            .having((s) => s.caloriesConsumed, 'calories', 1800)
            .having((s) => s.adherenceScore, 'adherence', 90.0),
      ],
    );

    blocTest<DietDailyLogCubit, DietDailyLogState>(
      'addWater and updateWater modify water intake',
      build: () {
        return buildCubit();
      },
      seed: () => DietDailyLogState(
        memberId: '42',
        date: testDate,
        waterIntakeMl: 500,
      ),
      act: (cubit) {
        cubit.addWater(250);
        cubit.updateWater(0);
      },
      expect: () => [
        isA<DietDailyLogState>().having((s) => s.waterIntakeMl, 'water', 750),
        isA<DietDailyLogState>().having((s) => s.waterIntakeMl, 'water', 0),
      ],
    );

    blocTest<DietDailyLogCubit, DietDailyLogState>(
      'save calls recordDietLog and emits saved',
      build: () {
        when(() => recordDietLog(any())).thenAnswer(
          (_) async => Right(
            DietLog(
              id: 'l1',
              memberId: '42',
              loggedDate: testDate,
              totalCaloriesConsumed: 2100,
              adherenceScore: 95,
              waterIntakeMl: 2000,
              memberNotes: 'Good workout today',
            ),
          ),
        );
        return buildCubit();
      },
      seed: () => DietDailyLogState(
        memberId: '42',
        date: testDate,
        caloriesConsumed: 2100,
        adherenceScore: 95,
        waterIntakeMl: 2000,
        memberNotes: 'Good workout today',
      ),
      act: (cubit) => cubit.save(),
      expect: () => [
        isA<DietDailyLogState>().having((s) => s.status, 'status', DietDailyLogStatus.saving),
        isA<DietDailyLogState>()
            .having((s) => s.status, 'status', DietDailyLogStatus.saved)
            .having((s) => s.savedLog?.id, 'savedLog.id', 'l1'),
      ],
    );
  });
}
