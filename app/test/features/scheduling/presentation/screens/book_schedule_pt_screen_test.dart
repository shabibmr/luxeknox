import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/people/domain/entities/trainer_summary.dart';
import 'package:luxeknox/features/scheduling/domain/entities/open_slot.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_enums.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_session.dart';
import 'package:luxeknox/features/scheduling/presentation/bloc/book_schedule_bloc.dart';
import 'package:luxeknox/features/scheduling/presentation/cubit/open_slots_cubit.dart';
import 'package:luxeknox/features/scheduling/presentation/scheduling_strings.dart';
import 'package:luxeknox/features/scheduling/presentation/screens/book_schedule_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockOpenSlotsCubit extends MockCubit<OpenSlotsState>
    implements OpenSlotsCubit {}

class _MockBookBloc extends MockBloc<BookScheduleEvent, BookScheduleState>
    implements BookScheduleBloc {}

class _MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late _MockOpenSlotsCubit openSlots;
  late _MockBookBloc bookBloc;
  late _MockSessionCubit sessionCubit;

  const trainer = TrainerSummary(
    id: 3,
    userId: 30,
    fullName: 'Alex Trainer',
  );

  final day = DateTime(2026, 9, 25);
  final slot = BookableOpenSlot(
    scheduleId: '42',
    start: DateTime(2026, 9, 25, 9),
    end: DateTime(2026, 9, 25, 10),
    title: 'PT',
  );

  const memberPrincipal = Principal(
    userId: '1',
    userType: UserType.member,
    displayName: 'Member',
    profileId: '9',
  );

  OpenSlotsState loadedState({
    bool stale = false,
    List<BookableOpenSlot>? slots,
  }) {
    return OpenSlotsState(
      status: LoadStatus.success,
      hasLoaded: true,
      trainer: trainer,
      days: [day, day.add(const Duration(days: 1))],
      selectedDay: day,
      slots: slots ?? [slot],
      staleSlot: stale,
    );
  }

  setUpAll(() {
    registerFallbackValue(
      const BookScheduleRequested(scheduleId: '0', memberId: '0'),
    );
    registerFallbackValue(DateTime(2026, 9, 25));
  });

  setUp(() {
    openSlots = _MockOpenSlotsCubit();
    bookBloc = _MockBookBloc();
    sessionCubit = _MockSessionCubit();

    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: const SessionAuthenticated(
        principal: memberPrincipal,
        capabilities: Capabilities(slugs: ['schedules.book']),
      ),
    );
    when(() => sessionCubit.close()).thenAnswer((_) async {});
    when(() => sessionCubit.isClosed).thenReturn(false);

    whenListen(
      openSlots,
      const Stream<OpenSlotsState>.empty(),
      initialState: loadedState(),
    );
    when(() => openSlots.load(any())).thenAnswer((_) async {});
    when(() => openSlots.refresh()).thenAnswer((_) async {});
    when(() => openSlots.refreshAfterStaleSlot()).thenAnswer((_) async {});
    when(() => openSlots.slotsForSelectedDay()).thenReturn([slot]);
    when(() => openSlots.selectDay(any())).thenReturn(null);
    when(() => openSlots.close()).thenAnswer((_) async {});
    when(() => openSlots.isClosed).thenReturn(false);

    whenListen(
      bookBloc,
      const Stream<BookScheduleState>.empty(),
      initialState: const BookScheduleState(),
    );
    when(() => bookBloc.close()).thenAnswer((_) async {});
    when(() => bookBloc.isClosed).thenReturn(false);
  });

  Widget wrap() {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
      ),
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: BookScheduleScreen(
          isPt: true,
          openSlotsCubit: openSlots,
          bookBloc: bookBloc,
        ),
      ),
    );
  }

  testWidgets('shows assigned trainer and open slot chips', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(find.text(SchedulingStrings.bookPtTitle), findsOneWidget);
    expect(find.text('Alex Trainer'), findsOneWidget);
    expect(find.byKey(const Key('open_slot_chip_42')), findsOneWidget);
  });

  testWidgets('books selected slot via BookScheduleBloc', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pump();

    await tester.tap(find.byKey(const Key('open_slot_chip_42')));
    await tester.pump();
    await tester.tap(find.text(SchedulingStrings.openSlotsBook));
    await tester.pump();

    final captured = verify(() => bookBloc.add(captureAny())).captured;
    expect(captured, hasLength(1));
    final event = captured.single as BookScheduleRequested;
    expect(event.scheduleId, '42');
    expect(event.memberId, '9');
  });

  testWidgets('409 conflict refreshes slots and shows stale copy', (
    tester,
  ) async {
    whenListen(
      bookBloc,
      Stream.fromIterable([
        const BookScheduleState(status: LoadStatus.loading, scheduleId: '42'),
        const BookScheduleState(
          status: LoadStatus.failure,
          failure: ConflictFailure(),
          scheduleId: '42',
        ),
      ]),
      initialState: const BookScheduleState(),
    );

    await tester.pumpWidget(wrap());
    await tester.pump();
    await tester.pump();

    verify(() => openSlots.refreshAfterStaleSlot()).called(1);
    expect(find.text(SchedulingStrings.openSlotsStale), findsWidgets);
  });

  testWidgets('shows no-trainer empty state', (tester) async {
    whenListen(
      openSlots,
      const Stream<OpenSlotsState>.empty(),
      initialState: const OpenSlotsState(
        status: LoadStatus.success,
        hasLoaded: true,
        missingTrainer: true,
      ),
    );
    when(() => openSlots.slotsForSelectedDay()).thenReturn(const []);

    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(find.text(SchedulingStrings.openSlotsNoTrainer), findsOneWidget);
  });

  testWidgets('success booking shows snackbar and refreshes', (tester) async {
    whenListen(
      bookBloc,
      Stream.fromIterable([
        const BookScheduleState(status: LoadStatus.loading, scheduleId: '42'),
        const BookScheduleState(
          status: LoadStatus.success,
          scheduleId: '42',
          participant: ScheduleParticipantEntry(
            id: 'p1',
            scheduleId: '42',
            memberId: '9',
            bookingStatus: BookingStatus.booked,
          ),
        ),
      ]),
      initialState: const BookScheduleState(),
    );

    await tester.pumpWidget(wrap());
    await tester.pump();
    await tester.pump();

    expect(find.text(SchedulingStrings.bookSuccess), findsOneWidget);
    verify(() => openSlots.refresh()).called(1);
  });
}
