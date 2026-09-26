import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/time/gym_timezone_provider.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_enums.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_session.dart';
import 'package:luxeknox/features/scheduling/presentation/cubit/schedule_detail_cubit.dart';
import 'package:luxeknox/features/scheduling/presentation/scheduling_strings.dart';
import 'package:luxeknox/features/scheduling/presentation/widgets/reschedule_sheet.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDetailCubit extends MockCubit<ScheduleDetailState>
    implements ScheduleDetailCubit {}

class _MockTimezoneProvider extends Mock implements GymTimezoneProvider {}

void main() {
  late _MockDetailCubit cubit;
  late _MockTimezoneProvider timezoneProvider;

  final session = ScheduleSession(
    id: '1',
    scheduleTypeId: '2',
    title: 'Yoga',
    startTime: DateTime(2026, 9, 25, 10),
    endTime: DateTime(2026, 9, 25, 11),
    status: ScheduleSessionStatus.scheduled,
    rowVersion: 1,
  );

  setUp(() {
    cubit = _MockDetailCubit();
    timezoneProvider = _MockTimezoneProvider();
    when(() => cubit.state).thenReturn(
      ScheduleDetailState(status: LoadStatus.success, session: session),
    );
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => timezoneProvider.timezone()).thenAnswer((_) async => 'UTC');
    when(() => timezoneProvider.cachedTimezone).thenReturn('UTC');
    when(
      () => cubit.reschedule(
        start: any(named: 'start'),
        end: any(named: 'end'),
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

  testWidgets('shows title and submit; submit calls reschedule', (tester) async {
    await tester.pumpWidget(
      wrap(
        RescheduleSheet(
          session: session,
          timezoneProvider: timezoneProvider,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(SchedulingStrings.rescheduleTitle), findsOneWidget);
    expect(find.byKey(const Key('reschedule_submit')), findsOneWidget);

    await tester.tap(find.byKey(const Key('reschedule_submit')));
    await tester.pumpAndSettle();

    verify(
      () => cubit.reschedule(
        start: session.startTime,
        end: session.endTime,
      ),
    ).called(1);
  });
}
