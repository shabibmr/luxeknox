import 'package:api_client/api_client.dart' as api;
import 'package:built_value/json_object.dart';

import '../../domain/entities/app_report_type.dart';
import '../../domain/entities/report_result.dart';

api.ReportType toApiReportType(AppReportType type) {
  return switch (type) {
    AppReportType.members => api.ReportType.members,
    AppReportType.memberships => api.ReportType.memberships,
    AppReportType.attendance => api.ReportType.attendance,
    AppReportType.payments => api.ReportType.payments,
    AppReportType.trainers => api.ReportType.trainers,
    AppReportType.workouts => api.ReportType.workouts,
    AppReportType.diets => api.ReportType.diets,
    AppReportType.progress => api.ReportType.progress,
    AppReportType.trainerOwn => api.ReportType.trainerOwn,
  };
}

AppReportType appReportTypeFromApi(api.ReportType type) {
  return switch (type) {
    api.ReportType.members => AppReportType.members,
    api.ReportType.memberships => AppReportType.memberships,
    api.ReportType.attendance => AppReportType.attendance,
    api.ReportType.payments => AppReportType.payments,
    api.ReportType.trainers => AppReportType.trainers,
    api.ReportType.workouts => AppReportType.workouts,
    api.ReportType.diets => AppReportType.diets,
    api.ReportType.progress => AppReportType.progress,
    api.ReportType.trainerOwn => AppReportType.trainerOwn,
    _ => AppReportType.members,
  };
}

api.Date? toApiDate(DateTime? value) {
  if (value == null) return null;
  return api.Date(value.year, value.month, value.day);
}

DateTime fromApiDate(api.Date value) =>
    DateTime(value.year, value.month, value.day);

Object? jsonObjectToDart(JsonObject? object) {
  if (object == null) return null;
  return object.value;
}

extension ReportModelMapper on api.Report {
  ReportResult toDomain() {
    return ReportResult(
      type: appReportTypeFromApi(type),
      from: fromApiDate(from),
      to: fromApiDate(to),
      rows: rows
          .map(
            (row) => <String, dynamic>{
              for (final entry in row.entries)
                entry.key: jsonObjectToDart(entry.value),
            },
          )
          .toList(),
    );
  }
}
