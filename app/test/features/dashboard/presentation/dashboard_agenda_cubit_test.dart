import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/time/gym_timezone_provider.dart';
import 'package:luxeknox/features/dashboard/presentation/cubit/dashboard_agenda_cubit.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_enums.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_session.dart';
import 'package:luxeknox/features/scheduling/domain/usecases/schedule_usecases.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockListSchedulesUseCase extends Mock implements ListSchedulesUseCase {}

class MockGymTimezoneProvider extends Mock implements GymTimezoneProvider {}

void main() {
  late MockListSchedulesUseCase listSchedules;

  setUpAll(() {
    registerFallbackValue(
      const ListSchedulesParams(),
    );
  });

  setUp(() {
    listSchedules = MockListSchedulesUseCase();
  });

  ScheduleSession session({
    required String id,
    required DateTime start,
    ScheduleSessionStatus status = ScheduleSessionStatus.scheduled,
  }) {
    return ScheduleSession(
      id: id,
      scheduleTypeId: '1',
      title: 'Session $id',
      startTime: start,
      endTime: start.add(const Duration(hours: 1)),
      status: status,
      rowVersion: 1,
    );
  }

  group('DashboardAgendaCubit', () {
    test('initial state is empty', () {
      final cubit = DashboardAgendaCubit(listSchedules);
      expect(cubit.state.status, LoadStatus.initial);
      expect(cubit.state.hasLoaded, isFalse);
      expect(cubit.state.todayItems, isEmpty);
      expect(cubit.state.upcomingItems, isEmpty);
    });

    blocTest<DashboardAgendaCubit, DashboardAgendaState>(
      'admin role emits empty success without calling listSchedules',
      build: () => DashboardAgendaCubit(listSchedules),
      act: (cubit) => cubit.load(role: UserType.admin, profileId: '9'),
      expect: () => [
        const DashboardAgendaState(
          status: LoadStatus.success,
          hasLoaded: true,
          role: UserType.admin,
        ),
      ],
      verify: (_) {
        verifyNever(() => listSchedules(any()));
      },
    );

    blocTest<DashboardAgendaCubit, DashboardAgendaState>(
      'member load splits today vs upcoming and drops cancelled',
      build: () {
        final now = DateTime.now();
        final todayStart = DateTime(now.year, now.month, now.day);
        when(() => listSchedules(any())).thenAnswer(
          (_) async => Right(
            CursorPage(
              items: [
                session(
                  id: '1',
                  start: todayStart.add(const Duration(hours: 9)),
                ),
                session(
                  id: '2',
                  start: todayStart.add(const Duration(days: 2, hours: 10)),
                ),
                session(
                  id: '3',
                  start: todayStart.add(const Duration(hours: 14)),
                  status: ScheduleSessionStatus.cancelled,
                ),
              ],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return DashboardAgendaCubit(listSchedules);
      },
      act: (cubit) => cubit.load(role: UserType.member, profileId: '42'),
      expect: () => [
        isA<DashboardAgendaState>()
            .having((s) => s.status, 'status', LoadStatus.loading)
            .having((s) => s.role, 'role', UserType.member),
        isA<DashboardAgendaState>()
            .having((s) => s.status, 'status', LoadStatus.success)
            .having((s) => s.hasLoaded, 'hasLoaded', true)
            .having((s) => s.todayItems.map((e) => e.id), 'today', ['1'])
            .having((s) => s.upcomingItems.map((e) => e.id), 'upcoming', ['2']),
      ],
      verify: (_) {
        final captured = verify(
          () => listSchedules(captureAny()),
        ).captured.single as ListSchedulesParams;
        expect(captured.memberId, '42');
        expect(captured.trainerId, isNull);
        expect(captured.limit, 100);
        expect(captured.from, isNotNull);
        expect(captured.to, isNotNull);
        expect(
          captured.to!.difference(captured.from!).inDays,
          kDashboardAgendaDaySpan,
        );
      },
    );

    blocTest<DashboardAgendaCubit, DashboardAgendaState>(
      'trainer load passes trainerId',
      build: () {
        when(() => listSchedules(any())).thenAnswer(
          (_) async => const Right(
            CursorPage(
              items: [],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return DashboardAgendaCubit(listSchedules);
      },
      act: (cubit) => cubit.load(role: UserType.trainer, profileId: '7'),
      expect: () => [
        isA<DashboardAgendaState>().having(
          (s) => s.status,
          'status',
          LoadStatus.loading,
        ),
        isA<DashboardAgendaState>()
            .having((s) => s.status, 'status', LoadStatus.success)
            .having((s) => s.role, 'role', UserType.trainer)
            .having((s) => s.hasLoaded, 'hasLoaded', true),
      ],
      verify: (_) {
        final captured = verify(
          () => listSchedules(captureAny()),
        ).captured.single as ListSchedulesParams;
        expect(captured.trainerId, '7');
        expect(captured.memberId, isNull);
      },
    );

    blocTest<DashboardAgendaCubit, DashboardAgendaState>(
      'failure keeps hasLoaded false so the section can show retry',
      build: () {
        when(
          () => listSchedules(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return DashboardAgendaCubit(listSchedules);
      },
      act: (cubit) => cubit.load(role: UserType.member, profileId: '1'),
      expect: () => [
        isA<DashboardAgendaState>().having(
          (s) => s.status,
          'status',
          LoadStatus.loading,
        ),
        isA<DashboardAgendaState>()
            .having((s) => s.status, 'status', LoadStatus.failure)
            .having((s) => s.failure, 'failure', const NetworkFailure())
            .having((s) => s.hasLoaded, 'hasLoaded', false),
      ],
    );

    blocTest<DashboardAgendaCubit, DashboardAgendaState>(
      'refresh reuses the last role and profileId',
      build: () {
        when(() => listSchedules(any())).thenAnswer(
          (_) async => const Right(
            CursorPage(items: [], nextCursor: null, hasMore: false),
          ),
        );
        return DashboardAgendaCubit(listSchedules);
      },
      act: (cubit) async {
        await cubit.load(role: UserType.trainer, profileId: '55');
        await cubit.refresh();
      },
      verify: (_) {
        verify(() => listSchedules(any())).called(2);
      },
    );

    blocTest<DashboardAgendaCubit, DashboardAgendaState>(
      'respects GymTimezoneProvider when partitioning today vs upcoming sessions',
      build: () {
        final mockTzProvider = MockGymTimezoneProvider();
        when(() => mockTzProvider.timezone()).thenAnswer((_) async => 'Asia/Kolkata');
        when(() => mockTzProvider.getOffset('Asia/Kolkata'))
            .thenReturn(const Duration(hours: 5, minutes: 30));

        final offset = const Duration(hours: 5, minutes: 30);
        final utcNow = DateTime.now().toUtc();
        final gymNow = utcNow.add(offset);
        final gymTodayMidnightUtc = DateTime.utc(gymNow.year, gymNow.month, gymNow.day).subtract(offset);

        when(() => listSchedules(any())).thenAnswer(
          (_) async => Right(
            CursorPage(
              items: [
                session(
                  id: 'today-session',
                  start: gymTodayMidnightUtc.add(const Duration(hours: 10)),
                ),
                session(
                  id: 'tomorrow-session',
                  start: gymTodayMidnightUtc.add(const Duration(days: 1, hours: 9)),
                ),
              ],
              nextCursor: null,
              hasMore: false,
            ),
          ),
        );
        return DashboardAgendaCubit(listSchedules, mockTzProvider);
      },
      act: (cubit) => cubit.load(role: UserType.member, profileId: '100'),
      expect: () => [
        isA<DashboardAgendaState>().having((s) => s.status, 'status', LoadStatus.loading),
        isA<DashboardAgendaState>()
            .having((s) => s.status, 'status', LoadStatus.success)
            .having((s) => s.todayItems.map((e) => e.id), 'today', ['today-session'])
            .having((s) => s.upcomingItems.map((e) => e.id), 'upcoming', ['tomorrow-session']),
      ],
    );
  });
}
