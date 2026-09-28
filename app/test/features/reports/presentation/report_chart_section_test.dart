import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/attendance/domain/entities/attendance_occupancy.dart';
import 'package:luxeknox/features/attendance/domain/usecases/attendance_usecases.dart';
import 'package:luxeknox/features/reports/domain/entities/app_report_type.dart';
import 'package:luxeknox/features/reports/presentation/report_strings.dart';
import 'package:luxeknox/features/reports/presentation/widgets/report_chart_section.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionCubit extends MockCubit<SessionState> implements SessionCubit {}

class MockGetAttendanceOccupancyUseCase extends Mock
    implements GetAttendanceOccupancyUseCase {}

void main() {
  const adminPrincipal = Principal(
    userId: '1',
    userType: UserType.admin,
    displayName: 'Admin',
    profileId: 'p1',
  );

  late MockGetAttendanceOccupancyUseCase occupancyUseCase;

  setUp(() {
    occupancyUseCase = MockGetAttendanceOccupancyUseCase();
    when(() => occupancyUseCase(const NoParams())).thenAnswer(
      (_) async => Right(
        AttendanceOccupancy(
          checkedInNow: 7,
          asOf: DateTime(2026, 1, 1, 10, 30),
          byGate: const [],
        ),
      ),
    );
    getIt.registerFactory<GetAttendanceOccupancyUseCase>(() => occupancyUseCase);
  });

  tearDown(() => getIt.reset());

  Widget wrap(Widget child, {Capabilities capabilities = const Capabilities(slugs: [])}) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: adminPrincipal,
        capabilities: capabilities,
      ),
    );
    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: Scaffold(body: child),
      ),
    );
  }

  testWidgets('renders nothing for payments (blocked)', (tester) async {
    await tester.pumpWidget(
      wrap(
        const ReportChartSection(type: AppReportType.payments, rows: []),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(ReportStrings.chartsTitle), findsNothing);
  });

  testWidgets('renders a bar chart for members and can be collapsed', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        ReportChartSection(
          type: AppReportType.members,
          rows: const [
            {'category': 'summary', 'metric': 'active_members', 'count': 10},
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(ReportStrings.chartsTitle), findsOneWidget);
    expect(find.byType(BarChart), findsOneWidget);

    await tester.tap(find.byTooltip(ReportStrings.hideCharts));
    await tester.pumpAndSettle();

    expect(find.byType(BarChart), findsNothing);
  });

  testWidgets('shows live occupancy tile for attendance with capability', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        ReportChartSection(
          type: AppReportType.attendance,
          rows: [
            for (var h = 0; h < 24; h++)
              {'category': 'peak_hour_heatmap', 'hour': h, 'checkin_count': 0},
          ],
        ),
        capabilities: const Capabilities(slugs: ['attendance.read']),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('7 checked in now'), findsOneWidget);
  });

  testWidgets('hides live occupancy tile without capability', (tester) async {
    await tester.pumpWidget(
      wrap(
        ReportChartSection(
          type: AppReportType.attendance,
          rows: [
            for (var h = 0; h < 24; h++)
              {'category': 'peak_hour_heatmap', 'hour': h, 'checkin_count': 0},
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('7 checked in now'), findsNothing);
  });
}
