import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_enums.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_session.dart';
import 'package:luxeknox/features/scheduling/presentation/cubit/schedule_detail_cubit.dart';
import 'package:luxeknox/features/scheduling/presentation/scheduling_strings.dart';
import 'package:luxeknox/features/scheduling/presentation/widgets/move_booking_sheet.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDetailCubit extends MockCubit<ScheduleDetailState>
    implements ScheduleDetailCubit {}

void main() {
  late _MockDetailCubit cubit;

  final current = ScheduleSession(
    id: '1',
    scheduleTypeId: '10',
    title: 'Yoga A',
    startTime: DateTime(2026, 9, 25, 10),
    endTime: DateTime(2026, 9, 25, 11),
    status: ScheduleSessionStatus.scheduled,
    rowVersion: 1,
    maxCapacity: 10,
    participants: const [
      ScheduleParticipantEntry(
        id: 'p1',
        scheduleId: '1',
        memberId: '9',
        bookingStatus: BookingStatus.booked,
      ),
    ],
  );

  final alternative = ScheduleSession(
    id: '2',
    scheduleTypeId: '10',
    title: 'Yoga B',
    startTime: DateTime(2026, 9, 26, 10),
    endTime: DateTime(2026, 9, 26, 11),
    status: ScheduleSessionStatus.scheduled,
    rowVersion: 1,
    maxCapacity: 10,
  );

  setUp(() {
    cubit = _MockDetailCubit();
    when(() => cubit.state).thenReturn(
      ScheduleDetailState(status: LoadStatus.success, session: current),
    );
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(
      () => cubit.moveBooking(
        targetScheduleId: any(named: 'targetScheduleId'),
        memberId: any(named: 'memberId'),
      ),
    ).thenAnswer((_) async => true);
  });

  Widget wrap(Widget child) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
      ),
      home: BlocProvider<ScheduleDetailCubit>.value(
        value: cubit,
        child: Scaffold(body: child),
      ),
    );
  }

  testWidgets('lists alternatives and moves on tap', (tester) async {
    await tester.pumpWidget(
      wrap(
        MoveBookingSheet(
          session: current,
          memberId: '9',
          alternatives: [alternative],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(SchedulingStrings.moveBookingTitle), findsOneWidget);
    expect(find.text('Yoga B'), findsOneWidget);

    await tester.tap(find.text(SchedulingStrings.moveBookingSubmit));
    await tester.pumpAndSettle();

    verify(
      () => cubit.moveBooking(targetScheduleId: '2', memberId: '9'),
    ).called(1);
  });

  testWidgets('shows empty state when no alternatives', (tester) async {
    await tester.pumpWidget(
      wrap(
        MoveBookingSheet(
          session: current,
          memberId: '9',
          alternatives: const [],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(SchedulingStrings.moveBookingEmpty), findsOneWidget);
  });
}
