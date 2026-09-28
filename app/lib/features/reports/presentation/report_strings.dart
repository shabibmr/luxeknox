import '../domain/entities/app_report_type.dart';

abstract final class ReportStrings {
  static const hubTitle = 'Reports';
  static const viewerTitle = 'Report';
  static const retry = 'Retry';
  static const apply = 'Apply';
  static const exportCsv = 'Export CSV';
  static const exported = 'CSV copied to clipboard';
  static const exportFailed = 'Could not export report';
  static const loadFailed = 'Could not load report';
  static const emptyRows = 'No rows for this range.';
  static const unknownCategory = 'Unknown report category.';
  static const fromLabel = 'From';
  static const toLabel = 'To';
  static const productIdLabel = 'Product ID';
  static const trainerIdLabel = 'Trainer ID';
  static const filtersTitle = 'Filters';
  static const dateRangeTitle = 'Date range';
  static const pageLabel = 'Page';
  static const previousPage = 'Previous';
  static const nextPage = 'Next';
  static const rowsSummary = 'rows';
  static const chartsTitle = 'Charts';
  static const showCharts = 'Show charts';
  static const hideCharts = 'Hide charts';

  static String titleFor(AppReportType type) => switch (type) {
    AppReportType.members => 'Members',
    AppReportType.memberships => 'Memberships',
    AppReportType.attendance => 'Attendance',
    AppReportType.payments => 'Payments / revenue',
    AppReportType.trainers => 'Trainers',
    AppReportType.workouts => 'Workouts',
    AppReportType.diets => 'Diets',
    AppReportType.progress => 'Progress',
    AppReportType.trainerOwn => 'My performance',
  };

  static String subtitleFor(AppReportType type) => switch (type) {
    AppReportType.members => 'Acquisition, active vs inactive, churn',
    AppReportType.memberships => 'Package mix, renewals, freezes',
    AppReportType.attendance => 'Footfall and visit patterns',
    AppReportType.payments => 'Gross, methods, outstanding aging',
    AppReportType.trainers => 'Sessions, ratings, retention',
    AppReportType.workouts => 'Plans, exercises, completion',
    AppReportType.diets => 'Plan mix and adherence',
    AppReportType.progress => 'Goals and aggregate change',
    AppReportType.trainerOwn => 'Your sessions and retention',
  };

  static String pageStatus({
    required int page,
    required int pageCount,
    required int totalRows,
  }) =>
      'Page $page of $pageCount · $totalRows $rowsSummary';
}
