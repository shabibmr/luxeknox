import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/reports/domain/entities/app_report_type.dart';
import 'package:luxeknox/features/reports/domain/entities/report_query.dart';
import 'package:luxeknox/features/reports/domain/entities/report_result.dart';
import 'package:luxeknox/features/reports/presentation/cubit/report_cubit.dart';
import 'package:luxeknox/features/reports/presentation/report_strings.dart';
import 'package:luxeknox/features/reports/presentation/screens/report_viewer_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReportCubit extends MockCubit<ReportState> implements ReportCubit {}

class MockSessionCubit extends MockCubit<SessionState> implements SessionCubit {}

/// Export is shown only with `reports.export` (ADR-0006 §11).
void main() {
  final query = ReportQuery(
    type: AppReportType.members,
    from: DateTime.utc(2026, 1, 1),
    to: DateTime.utc(2026, 1, 31),
  );
  final result = ReportResult(
    type: AppReportType.members,
    from: DateTime.utc(2026, 1, 1),
    to: DateTime.utc(2026, 1, 31),
    rows: [
      {'name': 'Ada'},
    ],
  );
  final loaded = ReportState(
    status: LoadStatus.success,
    query: query,
    result: result,
  );

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

  const readOnly = Capabilities(slugs: ['reports.read']);
  const canExport = Capabilities(slugs: ['reports.read', 'reports.export']);

  late MockReportCubit report;

  setUp(() {
    report = MockReportCubit();
    whenListen(
      report,
      const Stream<ReportState>.empty(),
      initialState: loaded,
    );
    when(
      () => report.load(AppReportType.members, trainerOwnLocked: false),
    ).thenAnswer((_) async {});
    when(() => report.close()).thenAnswer((_) async {});
    getIt.registerFactory<ReportCubit>(() => report);
  });

  tearDown(() => getIt.reset());

  Widget wrap(Principal principal, Capabilities capabilities) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: principal,
        capabilities: capabilities,
      ),
    );
    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: const ReportViewerScreen(category: 'members'),
      ),
    );
  }

  testWidgets('member does not see export', (tester) async {
    await tester.pumpWidget(wrap(memberPrincipal, readOnly));
    await tester.pumpAndSettle();

    expect(find.byTooltip(ReportStrings.exportCsv), findsNothing);
    expect(find.text('Ada'), findsOneWidget);
  });

  testWidgets('trainer does not see export', (tester) async {
    await tester.pumpWidget(wrap(trainerPrincipal, readOnly));
    await tester.pumpAndSettle();

    expect(find.byTooltip(ReportStrings.exportCsv), findsNothing);
    expect(find.text('Ada'), findsOneWidget);
  });

  testWidgets('admin with reports.export sees export', (tester) async {
    await tester.pumpWidget(wrap(adminPrincipal, canExport));
    await tester.pumpAndSettle();

    expect(find.byTooltip(ReportStrings.exportCsv), findsOneWidget);
    expect(find.text('Ada'), findsOneWidget);
  });
}
