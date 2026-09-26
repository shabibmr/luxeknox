import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/dashboard/presentation/cubit/dashboard_agenda_cubit.dart';
import 'package:luxeknox/features/dashboard/presentation/dashboard_strings.dart';
import 'package:luxeknox/features/dashboard/presentation/widgets/dashboard_agenda_section.dart';
import 'package:luxeknox/features/dashboard/presentation/widgets/today_agenda_card.dart';
import 'package:luxeknox/features/dashboard/presentation/widgets/upcoming_agenda_list.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_enums.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_session.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardAgendaCubit extends MockCubit<DashboardAgendaState>
    implements DashboardAgendaCubit {}

void main() {
  late MockDashboardAgendaCubit agendaCubit;

  ScheduleSession session({
    required String id,
    required String title,
    required DateTime start,
  }) {
    return ScheduleSession(
      id: id,
      scheduleTypeId: '1',
      title: title,
      startTime: start,
      endTime: start.add(const Duration(hours: 1)),
      status: ScheduleSessionStatus.scheduled,
      rowVersion: 1,
    );
  }

  Widget wrap(Widget child) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
      ),
      home: Scaffold(
        body: BlocProvider<DashboardAgendaCubit>.value(
          value: agendaCubit,
          child: child,
        ),
      ),
    );
  }

  setUp(() {
    agendaCubit = MockDashboardAgendaCubit();
  });

  group('TodayAgendaCard', () {
    testWidgets('renders sessions and reports taps', (tester) async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day, 10);
      ScheduleSession? tapped;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodayAgendaCard(
              items: [
                session(id: '1', title: 'Morning HIIT', start: today),
              ],
              title: DashboardStrings.todayAgendaMemberTitle,
              emptyMessage: DashboardStrings.todayAgendaMemberEmpty,
              onTapSession: (s) => tapped = s,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('today_agenda_card')), findsOneWidget);
      expect(find.text('Morning HIIT'), findsOneWidget);
      expect(find.text(DashboardStrings.todayAgendaMemberTitle), findsOneWidget);

      await tester.tap(find.text('Morning HIIT'));
      await tester.pump();
      expect(tapped?.id, '1');
    });

    testWidgets('shows empty message when there are no items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodayAgendaCard(
              items: const [],
              title: DashboardStrings.todayAgendaTrainerTitle,
              emptyMessage: DashboardStrings.todayAgendaTrainerEmpty,
              onTapSession: (_) {},
            ),
          ),
        ),
      );

      expect(
        find.text(DashboardStrings.todayAgendaTrainerEmpty),
        findsOneWidget,
      );
    });
  });

  group('UpcomingAgendaList', () {
    testWidgets('renders upcoming rows and reports taps', (tester) async {
      final start = DateTime.now().add(const Duration(days: 2, hours: 3));
      ScheduleSession? tapped;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpcomingAgendaList(
              items: [
                session(id: '9', title: 'Yoga flow', start: start),
              ],
              onTapSession: (s) => tapped = s,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('upcoming_agenda_list')), findsOneWidget);
      expect(find.text(DashboardStrings.upcomingAgendaTitle), findsOneWidget);
      expect(find.text('Yoga flow'), findsOneWidget);

      await tester.tap(find.text('Yoga flow'));
      await tester.pump();
      expect(tapped?.id, '9');
    });

    testWidgets('shows empty copy', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UpcomingAgendaList(
              items: const [],
              onTapSession: (_) {},
            ),
          ),
        ),
      );

      expect(
        find.text(DashboardStrings.upcomingAgendaEmpty),
        findsOneWidget,
      );
    });
  });

  group('DashboardAgendaSection', () {
    testWidgets('shows section loading without crashing', (tester) async {
      when(() => agendaCubit.state).thenReturn(
        const DashboardAgendaState(
          status: LoadStatus.loading,
          role: UserType.member,
        ),
      );
      whenListen(
        agendaCubit,
        Stream<DashboardAgendaState>.empty(),
        initialState: const DashboardAgendaState(
          status: LoadStatus.loading,
          role: UserType.member,
        ),
      );

      await tester.pumpWidget(wrap(const DashboardAgendaSection()));
      expect(find.byKey(const Key('agenda_section_loading')), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error with retry that calls refresh', (tester) async {
      when(() => agendaCubit.state).thenReturn(
        const DashboardAgendaState(
          status: LoadStatus.failure,
          role: UserType.trainer,
          failure: NetworkFailure(),
        ),
      );
      whenListen(
        agendaCubit,
        Stream<DashboardAgendaState>.empty(),
        initialState: const DashboardAgendaState(
          status: LoadStatus.failure,
          role: UserType.trainer,
          failure: NetworkFailure(),
        ),
      );
      when(() => agendaCubit.refresh()).thenAnswer((_) async {});

      await tester.pumpWidget(wrap(const DashboardAgendaSection()));
      expect(find.byKey(const Key('agenda_section_error')), findsOneWidget);
      expect(find.text(DashboardStrings.retry), findsOneWidget);

      await tester.tap(find.text(DashboardStrings.retry));
      await tester.pump();
      verify(() => agendaCubit.refresh()).called(1);
    });

    testWidgets('renders today + upcoming for a loaded member', (tester) async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day, 11);
      final soon = today.add(const Duration(days: 3));
      final loaded = DashboardAgendaState(
        status: LoadStatus.success,
        hasLoaded: true,
        role: UserType.member,
        todayItems: [
          session(id: '1', title: 'PT block', start: today),
        ],
        upcomingItems: [
          session(id: '2', title: 'Spin class', start: soon),
        ],
      );
      when(() => agendaCubit.state).thenReturn(loaded);
      whenListen(
        agendaCubit,
        Stream<DashboardAgendaState>.empty(),
        initialState: loaded,
      );

      await tester.pumpWidget(wrap(const DashboardAgendaSection()));

      expect(find.byKey(const Key('today_agenda_card')), findsOneWidget);
      expect(find.byKey(const Key('upcoming_agenda_list')), findsOneWidget);
      expect(
        find.text(DashboardStrings.todayAgendaMemberTitle),
        findsOneWidget,
      );
      expect(find.text('PT block'), findsOneWidget);
      expect(find.text('Spin class'), findsOneWidget);
    });

    testWidgets('hides for admin role', (tester) async {
      when(() => agendaCubit.state).thenReturn(
        const DashboardAgendaState(
          status: LoadStatus.success,
          hasLoaded: true,
          role: UserType.admin,
        ),
      );
      whenListen(
        agendaCubit,
        Stream<DashboardAgendaState>.empty(),
        initialState: const DashboardAgendaState(
          status: LoadStatus.success,
          hasLoaded: true,
          role: UserType.admin,
        ),
      );

      await tester.pumpWidget(wrap(const DashboardAgendaSection()));
      expect(find.byKey(const Key('today_agenda_card')), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
