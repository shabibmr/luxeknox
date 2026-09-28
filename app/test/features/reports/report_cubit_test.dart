import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/reports/domain/entities/app_report_type.dart';
import 'package:luxeknox/features/reports/domain/entities/report_query.dart';
import 'package:luxeknox/features/reports/domain/entities/report_result.dart';
import 'package:luxeknox/features/reports/domain/usecases/export_report_csv_usecase.dart';
import 'package:luxeknox/features/reports/domain/usecases/get_report_usecase.dart';
import 'package:luxeknox/features/reports/presentation/cubit/report_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGet extends Mock implements GetReportUseCase {}

class _MockExport extends Mock implements ExportReportCsvUseCase {}

void main() {
  late _MockGet getReport;
  late _MockExport exportCsv;

  setUpAll(() {
    registerFallbackValue(
      const ReportQuery(type: AppReportType.members),
    );
  });

  setUp(() {
    getReport = _MockGet();
    exportCsv = _MockExport();
  });

  ReportResult sample({int rows = 3}) {
    return ReportResult(
      type: AppReportType.members,
      from: DateTime(2026, 1, 1),
      to: DateTime(2026, 1, 31),
      rows: [
        for (var i = 0; i < rows; i++) {'id': i, 'name': 'M$i'},
      ],
    );
  }

  blocTest<ReportCubit, ReportState>(
    'load emits loaded report',
    build: () {
      when(() => getReport(any())).thenAnswer((_) async => Right(sample()));
      return ReportCubit(getReport, exportCsv);
    },
    act: (cubit) => cubit.load(AppReportType.members),
    expect: () => [
      isA<ReportState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<ReportState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.result?.rows.length, 'rows', 3),
    ],
  );

  blocTest<ReportCubit, ReportState>(
    'paginates large result sets client-side',
    build: () {
      when(() => getReport(any())).thenAnswer(
        (_) async => Right(sample(rows: 120)),
      );
      return ReportCubit(getReport, exportCsv);
    },
    act: (cubit) async {
      await cubit.load(AppReportType.members);
      cubit.setPage(1);
    },
    expect: () => [
      isA<ReportState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<ReportState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.pageCount, 'pageCount', 3)
          .having((s) => s.pageRows.length, 'page0', 50),
      isA<ReportState>()
          .having((s) => s.pageIndex, 'pageIndex', 1)
          .having((s) => s.pageRows.length, 'page1', 50),
    ],
  );

  blocTest<ReportCubit, ReportState>(
    'exportCsv stores csv on success',
    build: () {
      when(() => getReport(any())).thenAnswer((_) async => Right(sample()));
      when(() => exportCsv(any())).thenAnswer((_) async => const Right('a,b\n1,2\n'));
      return ReportCubit(getReport, exportCsv);
    },
    act: (cubit) async {
      await cubit.load(AppReportType.payments);
      await cubit.exportCsv();
    },
    expect: () => [
      isA<ReportState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<ReportState>().having(
        (s) => s.status,
        'status',
        LoadStatus.success,
      ),
      isA<ReportState>().having((s) => s.exporting, 'exporting', true),
      isA<ReportState>()
          .having((s) => s.exportedCsv, 'csv', 'a,b\n1,2\n')
          .having((s) => s.exporting, 'exporting', false),
    ],
  );

  blocTest<ReportCubit, ReportState>(
    'emits failure on load error',
    build: () {
      when(() => getReport(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return ReportCubit(getReport, exportCsv);
    },
    act: (cubit) => cubit.load(AppReportType.attendance),
    expect: () => [
      isA<ReportState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<ReportState>()
          .having((s) => s.status, 'status', LoadStatus.failure)
          .having((s) => s.failure, 'failure', isA<NetworkFailure>()),
    ],
  );
}
