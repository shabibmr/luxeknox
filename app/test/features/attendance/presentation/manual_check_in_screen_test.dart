import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/features/attendance/domain/usecases/attendance_usecases.dart';
import 'package:luxeknox/features/attendance/presentation/attendance_strings.dart';
import 'package:luxeknox/features/attendance/presentation/bloc/check_in_bloc.dart';
import 'package:luxeknox/features/attendance/presentation/screens/admin_attendance_screen.dart';
import 'package:luxeknox/features/scheduling/presentation/scheduling_strings.dart';
import 'package:mocktail/mocktail.dart';

class _MockCheckInUseCase extends Mock implements CheckInUseCase {}

void main() {
  setUp(() {
    getIt.registerFactory<CheckInBloc>(
      () => CheckInBloc(_MockCheckInUseCase()),
    );
  });

  tearDown(() => getIt.reset());

  testWidgets('manual check-in separates members and trainers', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ManualCheckInScreen()));

    expect(find.text(AttendanceStrings.membersTab), findsOneWidget);
    expect(find.text(AttendanceStrings.trainersTab), findsOneWidget);
    expect(find.text('Select member for check-in'), findsOneWidget);
    expect(find.byKey(const Key('manual_check_in_member')), findsOneWidget);
    expect(find.byKey(const Key('trainer_picker_field')), findsNothing);

    await tester.tap(find.text(AttendanceStrings.trainersTab));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('trainer_picker_field')), findsOneWidget);
    expect(
      find.text(SchedulingStrings.trainerFieldPlaceholder),
      findsOneWidget,
    );
    expect(find.byKey(const Key('manual_check_in_trainer')), findsOneWidget);
    expect(find.text('Select member for check-in'), findsNothing);
  });
}
