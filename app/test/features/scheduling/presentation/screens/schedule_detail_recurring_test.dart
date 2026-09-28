import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_enums.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_session.dart';
import 'package:luxeknox/features/scheduling/presentation/cubit/schedule_detail_cubit.dart';
import 'package:luxeknox/features/scheduling/presentation/schedule_role.dart';
import 'package:luxeknox/features/scheduling/presentation/screens/schedule_detail_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockScheduleDetailCubit extends MockCubit<ScheduleDetailState>
    implements ScheduleDetailCubit {}

class MockSessionCubit extends MockCubit<SessionState> implements SessionCubit {}

void main() {
  late MockScheduleDetailCubit detailCubit;
  late MockSessionCubit sessionCubit;

  final nonRecurringSession = ScheduleSession(
    id: 's1',
    scheduleTypeId: 'st1',
    facilityId: 'f1',
    trainerId: '10',
    title: 'Morning Yoga',
    startTime: DateTime(2026, 10, 1, 9, 0),
    endTime: DateTime(2026, 10, 1, 10, 0),
    maxCapacity: 15,
    status: ScheduleSessionStatus.scheduled,
    rowVersion: 1,
  );

  final recurringSession = ScheduleSession(
    id: 's2',
    seriesId: 'series-99',
    scheduleTypeId: 'st1',
    facilityId: 'f1',
    trainerId: '10',
    title: 'Weekly Yoga',
    startTime: DateTime(2026, 10, 1, 9, 0),
    endTime: DateTime(2026, 10, 1, 10, 0),
    maxCapacity: 15,
    status: ScheduleSessionStatus.scheduled,
    rowVersion: 1,
  );

  const adminPrincipal = Principal(
    userId: '1',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'a1',
  );

  setUp(() {
    detailCubit = MockScheduleDetailCubit();
    sessionCubit = MockSessionCubit();

    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: const SessionAuthenticated(
        principal: adminPrincipal,
        capabilities: Capabilities(slugs: [
          'schedules.read',
          'schedules.write',
          'schedules.cancel',
        ]),
      ),
    );

    when(() => detailCubit.load(any())).thenAnswer((_) async {});
    when(() => detailCubit.cancel(
          reason: any(named: 'reason'),
          cancelSeries: any(named: 'cancelSeries'),
        )).thenAnswer((_) async {});
    when(() => detailCubit.close()).thenAnswer((_) async {});
    when(() => detailCubit.isClosed).thenReturn(false);

    getIt.registerFactory<ScheduleDetailCubit>(() => detailCubit);
  });

  tearDown(() => getIt.reset());

  Widget buildWidget(ScheduleDetailScreen screen) {
    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: screen,
      ),
    );
  }

  testWidgets('renders recurring series indicator on recurring session', (
    tester,
  ) async {
    whenListen(
      detailCubit,
      const Stream<ScheduleDetailState>.empty(),
      initialState: ScheduleDetailState(
        status: LoadStatus.success,
        session: recurringSession,
      ),
    );

    await tester.pumpWidget(
      buildWidget(
        const ScheduleDetailScreen(
          scheduleId: 's2',
          role: ScheduleCalendarRole.admin,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('recurring_series_indicator')), findsOneWidget);
    expect(find.text('Recurring series'), findsOneWidget);
  });

  testWidgets('does not render recurring series indicator on non-recurring session', (
    tester,
  ) async {
    whenListen(
      detailCubit,
      const Stream<ScheduleDetailState>.empty(),
      initialState: ScheduleDetailState(
        status: LoadStatus.success,
        session: nonRecurringSession,
      ),
    );

    await tester.pumpWidget(
      buildWidget(
        const ScheduleDetailScreen(
          scheduleId: 's1',
          role: ScheduleCalendarRole.admin,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('recurring_series_indicator')), findsNothing);
  });

  testWidgets('admin edit action prompts scope dialog for recurring session', (
    tester,
  ) async {
    whenListen(
      detailCubit,
      const Stream<ScheduleDetailState>.empty(),
      initialState: ScheduleDetailState(
        status: LoadStatus.success,
        session: recurringSession,
      ),
    );

    await tester.pumpWidget(
      buildWidget(
        const ScheduleDetailScreen(
          scheduleId: 's2',
          role: ScheduleCalendarRole.admin,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('admin_edit_schedule_action')));
    await tester.pumpAndSettle();

    expect(find.text('Edit recurring session'), findsOneWidget);
    expect(find.byKey(const Key('edit_whole_series_button')), findsOneWidget);
    expect(find.byKey(const Key('edit_this_session_button')), findsOneWidget);

    // Tap whole series button shows snackbar explaining backend semantics
    await tester.tap(find.byKey(const Key('edit_whole_series_button')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Series-wide editing is not supported yet. Please edit individual occurrences.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('cancel action prompts recurring dialog and calls cancelSeries when chosen', (
    tester,
  ) async {
    whenListen(
      detailCubit,
      const Stream<ScheduleDetailState>.empty(),
      initialState: ScheduleDetailState(
        status: LoadStatus.success,
        session: recurringSession,
      ),
    );

    await tester.pumpWidget(
      buildWidget(
        const ScheduleDetailScreen(
          scheduleId: 's2',
          role: ScheduleCalendarRole.admin,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('cancel_session_button')));
    await tester.pumpAndSettle();

    expect(find.text('Cancel recurring session'), findsOneWidget);
    expect(find.byKey(const Key('cancel_this_session_button')), findsOneWidget);
    expect(find.byKey(const Key('cancel_all_series_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('cancel_all_series_button')));
    await tester.pumpAndSettle();

    verify(() => detailCubit.cancel(cancelSeries: true)).called(1);
  });
}
