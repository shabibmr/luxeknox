import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_chart_types.dart';
import '../../../attendance/domain/usecases/attendance_usecases.dart';
import '../../../people/domain/usecases/list_health_history_usecase.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/goal_metric_category.dart';
import '../../domain/entities/measurement.dart';
import '../../domain/helpers/bmi.dart';
import '../../domain/usecases/goal_metrics_usecases.dart';
import '../../domain/usecases/measurements_usecases.dart';

part 'progress_overview_cubit.freezed.dart';

class MetricChartData {
  const MetricChartData({
    required this.metric,
    required this.points,
  });

  final GoalMetric metric;
  final List<ChartDataPoint> points;
}

@freezed
abstract class ProgressOverviewState with _$ProgressOverviewState {
  const factory ProgressOverviewState({
    @Default(LoadStatus.initial) LoadStatus status,
    MetricChartData? weightData,
    @Default(<MetricChartData>[]) List<MetricChartData> bodyCompositionData,
    @Default(<MetricChartData>[]) List<MetricChartData> circumferenceData,
    @Default(<AppChartPoint>[]) List<AppChartPoint> weeklyAttendance,
    double? bmi,
    @Default(false) bool heightMissing,
    Failure? failure,
  }) = _ProgressOverviewState;
}

@injectable
class ProgressOverviewCubit extends Cubit<ProgressOverviewState> {
  ProgressOverviewCubit(
    this._listMetrics,
    this._getMeasurementChart,
    this._listAttendances,
    this._listHealthHistory,
  ) : super(const ProgressOverviewState());

  final ListGoalMetricsUseCase _listMetrics;
  final GetMeasurementChartUseCase _getMeasurementChart;
  final ListAttendancesUseCase _listAttendances;
  final ListHealthHistoryUseCase _listHealthHistory;

  String? _memberId;
  bool _includeCircumference = false;

  Future<void> load(String memberId, {bool includeCircumference = false}) async {
    _memberId = memberId;
    _includeCircumference = includeCircumference;
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    // Attendance: weekly visit counts for the last 8 weeks
    final now = DateTime.now();
    final startOfCurrentWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final fromDate = startOfCurrentWeek.subtract(const Duration(days: 7 * 7));

    final attendanceResult = await _listAttendances(
      ListAttendancesParams(
        userId: memberId,
        from: fromDate,
        to: now,
        limit: 100,
      ),
    );

    final weekBuckets = <DateTime, int>{};
    for (var i = 0; i < 8; i++) {
      final weekStart = fromDate.add(Duration(days: i * 7));
      weekBuckets[weekStart] = 0;
    }

    attendanceResult.fold((_) {}, (page) {
      for (final record in page.items) {
        final t = record.checkInTime;
        final recDay = DateTime(t.year, t.month, t.day);
        final recWeekStart = recDay.subtract(Duration(days: recDay.weekday - 1));
        if (weekBuckets.containsKey(recWeekStart)) {
          weekBuckets[recWeekStart] = (weekBuckets[recWeekStart] ?? 0) + 1;
        }
      }
    });

    final weeklyAttendance = <AppChartPoint>[
      for (final entry in weekBuckets.entries)
        AppChartPoint(
          label: DateFormat('MMM d').format(entry.key),
          value: entry.value.toDouble(),
        ),
    ];

    // Metrics & Longitudinal Charts
    final metricsResult = await _listMetrics(const ListGoalMetricsParams());
    await metricsResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: LoadStatus.failure,
            failure: failure,
            weeklyAttendance: weeklyAttendance,
          ),
        );
      },
      (page) async {
        final activeMetrics = page.items.where((m) => m.isActive).toList();

        // Weight metric
        GoalMetric? weightMetric;
        final weightCandidates = activeMetrics
            .where(
              (m) =>
                  m.name.toLowerCase().contains('weight') ||
                  m.category == GoalMetricCategory.bodyComposition,
            )
            .toList();
        if (weightCandidates.isNotEmpty) {
          weightMetric = weightCandidates.firstWhere(
            (m) => m.name.toLowerCase().contains('weight'),
            orElse: () => weightCandidates.first,
          );
        }

        // Body composition metrics (excluding weight)
        final bodyCompMetrics = activeMetrics
            .where(
              (m) =>
                  m.category == GoalMetricCategory.bodyComposition &&
                  m.id != weightMetric?.id,
            )
            .toList();

        // Circumference metrics
        final circumferenceMetrics = includeCircumference
            ? activeMetrics
                .where((m) => m.category == GoalMetricCategory.circumference)
                .toList()
            : <GoalMetric>[];

        MetricChartData? weightData;
        if (weightMetric != null) {
          final chartRes = await _getMeasurementChart(
            GetMeasurementChartParams(
              memberId: memberId,
              metricId: weightMetric.id,
            ),
          );
          chartRes.fold((_) {}, (points) {
            weightData = MetricChartData(metric: weightMetric!, points: points);
          });
        }

        final bodyCompositionData = <MetricChartData>[];
        for (final m in bodyCompMetrics) {
          final chartRes = await _getMeasurementChart(
            GetMeasurementChartParams(memberId: memberId, metricId: m.id),
          );
          chartRes.fold((_) {}, (points) {
            bodyCompositionData.add(MetricChartData(metric: m, points: points));
          });
        }

        final circumferenceData = <MetricChartData>[];
        for (final m in circumferenceMetrics) {
          final chartRes = await _getMeasurementChart(
            GetMeasurementChartParams(memberId: memberId, metricId: m.id),
          );
          chartRes.fold((_) {}, (points) {
            circumferenceData.add(MetricChartData(metric: m, points: points));
          });
        }

        double? heightCm;
        var heightMissing = true;
        final memberIdInt = int.tryParse(memberId.trim());
        if (memberIdInt != null) {
          final healthResult = await _listHealthHistory(memberIdInt);
          healthResult.fold((_) {}, (records) {
            for (final record in records) {
              final h = record.heightCm;
              if (h != null && h > 0) {
                heightCm = h;
                heightMissing = false;
                break;
              }
            }
          });
        }

        double? latestWeightKg;
        final weightPoints = weightData?.points ?? const <ChartDataPoint>[];
        if (weightPoints.isNotEmpty) {
          final latest = weightPoints.reduce(
            (a, b) => a.recordedAt.isAfter(b.recordedAt) ? a : b,
          );
          latestWeightKg = weightToKg(
            latest.value,
            weightData!.metric.unitOfMeasure,
          );
        }

        final bmi = computeBmi(weightKg: latestWeightKg, heightCm: heightCm);

        emit(
          state.copyWith(
            status: LoadStatus.success,
            weightData: weightData,
            bodyCompositionData: bodyCompositionData,
            circumferenceData: circumferenceData,
            weeklyAttendance: weeklyAttendance,
            bmi: bmi,
            heightMissing: heightMissing,
            failure: null,
          ),
        );
      },
    );
  }

  Future<void> retry() async {
    if (_memberId != null) {
      await load(_memberId!, includeCircumference: _includeCircumference);
    }
  }
}
