import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_enums.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_session.dart';
import 'package:luxeknox/features/scheduling/presentation/cubit/schedule_calendar_cubit.dart';
import 'package:luxeknox/features/scheduling/presentation/screens/schedule_calendar_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockScheduleCalendarCubit extends MockCubit<ScheduleCalendarState>
    implements ScheduleCalendarCubit {}

class MockSessionCubit extends MockCubit<SessionState> implements SessionCubit {}

void main() {
  final session = ScheduleSession(
    id: 's1',
    scheduleTypeId: 'type',
    title: 'Morning PT',
    startTime: DateTime.utc(2026, 9, 21, 9),
    endTime: DateTime.utc(2026, 9, 21, 10),
    status: ScheduleSessionStatus.scheduled,
    rowVersion: 1,
  );
  final from = DateTime.utc(2026, 9, 21);
  final to = from.add(const Duration(days: 7));

  const memberPrincipal = Principal(
    userId: '1',
    userType: UserType.member,
    displayName: 'Member One',
    profileId: 'p1',
  );
  const trainerPrincipal = Principal(
    userId: '2',
    userType: UserType.trainer,
    displayName: 'Trainer One',
    profileId: 'p2',
  );
  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'p3',
  );

  late MockScheduleCalendarCubit calendar;

  setUp(() {
    calendar = MockScheduleCalendarCubit();
    whenListen(
      calendar,
      const Stream<ScheduleCalendarState>.empty(),
      initialState: ScheduleCalendarState(
        status: LoadStatus.success,
        hasLoaded: true,
        items: [session],
        from: from,
        to: to,
      ),
    );
    when(
      () => calendar.load(
        trainerId: any(named: 'trainerId'),
        memberId: any(named: 'memberId'),
      ),
    ).thenAnswer((_) async {});
    when(() => calendar.shiftRange(any())).thenAnswer((_) async {});
    when(() => calendar.close()).thenAnswer((_) async {});
    when(() => calendar.isClosed).thenReturn(false);
    getIt.registerFactory<ScheduleCalendarCubit>(() => calendar);
  });

  tearDown(() => getIt.reset());

  Widget wrap(Widget child, Principal principal) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: principal,
        capabilities: const Capabilities(slugs: []),
      ),
    );
    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(value: sessionCubit, child: child),
    );
  }

  testWidgets('member branch shows book actions and the sessions', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const ScheduleCalendarScreen(role: ScheduleCalendarRole.member),
        memberPrincipal,
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.person_add_alt), findsOneWidget);
    expect(find.byIcon(Icons.groups_outlined), findsOneWidget);
    expect(find.byIcon(Icons.event_available_outlined), findsNothing);
    expect(find.byIcon(Icons.apartment_outlined), findsNothing);
    expect(find.text('Morning PT'), findsOneWidget);
  });

  testWidgets('trainer branch shows availability and not booking', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const ScheduleCalendarScreen(role: ScheduleCalendarRole.trainer),
        trainerPrincipal,
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.event_available_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_add_alt), findsNothing);
    expect(find.byIcon(Icons.groups_outlined), findsNothing);
    expect(find.byIcon(Icons.apartment_outlined), findsNothing);
    expect(find.text('Morning PT'), findsOneWidget);
  });

  testWidgets('admin branch shows facilities and not booking', (tester) async {
    await tester.pumpWidget(
      wrap(
        const ScheduleCalendarScreen(role: ScheduleCalendarRole.admin),
        adminPrincipal,
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.apartment_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_add_alt), findsNothing);
    expect(find.byIcon(Icons.groups_outlined), findsNothing);
    expect(find.byIcon(Icons.event_available_outlined), findsNothing);
    expect(find.text('Morning PT'), findsOneWidget);
  });

  testWidgets('shows recurring indicator when session is recurring', (
    tester,
  ) async {
    final recurringSession = ScheduleSession(
      id: 's2',
      seriesId: 'series-123',
      scheduleTypeId: 'type',
      title: 'Recurring PT',
      startTime: DateTime.utc(2026, 9, 21, 9),
      endTime: DateTime.utc(2026, 9, 21, 10),
      status: ScheduleSessionStatus.scheduled,
      rowVersion: 1,
    );

    whenListen(
      calendar,
      const Stream<ScheduleCalendarState>.empty(),
      initialState: ScheduleCalendarState(
        status: LoadStatus.success,
        hasLoaded: true,
        items: [recurringSession],
        from: from,
        to: to,
      ),
    );

    await tester.pumpWidget(
      wrap(
        const ScheduleCalendarScreen(role: ScheduleCalendarRole.admin),
        adminPrincipal,
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('recurring_indicator')), findsOneWidget);
  });
}
