import 'package:luxeknox/features/reports/domain/entities/app_report_type.dart';
import 'package:luxeknox/features/reports/presentation/charts/report_chart_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildReportChartBlocks', () {
    test('payments returns no blocks (blocked pending financial charts)', () {
      final blocks = buildReportChartBlocks(AppReportType.payments, [
        {'category': 'collections', 'metric': 'gross_collections', 'amount': '10.00'},
      ]);
      expect(blocks, isEmpty);
    });

    test('empty rows return no blocks', () {
      expect(buildReportChartBlocks(AppReportType.members, const []), isEmpty);
    });

    test('attendance builds hourly heatmap and bar blocks', () {
      final rows = [
        {'category': 'summary', 'metric': 'total_footfall', 'value': 12},
        for (var h = 0; h < 24; h++)
          {'category': 'peak_hour_heatmap', 'hour': h, 'checkin_count': h == 9 ? 5 : 0},
      ];

      final blocks = buildReportChartBlocks(AppReportType.attendance, rows);

      expect(blocks, hasLength(2));
      final heatmap = blocks[0] as HeatmapChartBlock;
      expect(heatmap.rowLabels, ['All days']);
      expect(heatmap.colLabels, hasLength(24));
      expect(heatmap.values.single[9], 5);

      final bars = blocks[1] as BarChartBlock;
      expect(bars.points, hasLength(24));
      expect(bars.points[9].value, 5);
      expect(bars.points[9].label, '09');
    });

    test('members builds a status distribution bar', () {
      final rows = [
        {'category': 'summary', 'metric': 'acquisition_new_members', 'count': 3},
        {'category': 'summary', 'metric': 'active_members', 'count': 40},
        {'category': 'summary', 'metric': 'inactive_members', 'count': 2},
        {'category': 'summary', 'metric': 'suspended_members', 'count': 1},
        {'category': 'summary', 'metric': 'churned_members', 'count': 4},
      ];

      final blocks = buildReportChartBlocks(AppReportType.members, rows);

      expect(blocks, hasLength(1));
      final bars = (blocks.single as BarChartBlock).points;
      expect(bars.map((p) => p.label), ['New', 'Active', 'Inactive', 'Suspended', 'Churned']);
      expect(bars.map((p) => p.value), [3, 40, 2, 1, 4]);
    });

    test('memberships builds package mix and renewal/freeze bars', () {
      final rows = [
        {
          'category': 'package_mix',
          'product_id': 1,
          'product_name': 'Gold',
          'total_purchased': 10,
          'active_count': 8,
          'frozen_count': 1,
          'avg_duration_days': 30,
        },
        {'category': 'summary', 'metric': 'total_renewals', 'count': 6},
        {'category': 'summary', 'metric': 'total_freezes', 'count': 2},
      ];

      final blocks = buildReportChartBlocks(AppReportType.memberships, rows);

      expect(blocks, hasLength(2));
      final packageMix = (blocks[0] as BarChartBlock).points;
      expect(packageMix.single.label, 'Gold');
      expect(packageMix.single.value, 10);

      final renewals = (blocks[1] as BarChartBlock).points;
      expect(renewals.map((p) => p.value), [6, 2]);
    });

    test('trainers builds sessions and assigned-client bars', () {
      final rows = [
        {
          'trainer_id': 1,
          'trainer_name': 'Alex',
          'sessions_delivered': 12,
          'sessions_scheduled': 15,
          'assigned_members': 5,
          'active_members': 4,
        },
      ];

      for (final type in [AppReportType.trainers, AppReportType.trainerOwn]) {
        final blocks = buildReportChartBlocks(type, rows);
        expect(blocks, hasLength(2));
        expect((blocks[0] as BarChartBlock).points.single.value, 12);
        expect((blocks[1] as BarChartBlock).points.single.value, 5);
      }
    });

    test('workouts builds top-plans and top-exercises bars', () {
      final rows = [
        {'category': 'summary', 'metric': 'total_sessions_started', 'value': 20},
        {
          'category': 'top_workout_plans',
          'plan_id': 1,
          'plan_title': 'Push Pull Legs',
          'assigned_count': 9,
        },
        {
          'category': 'top_exercises',
          'exercise_id': 1,
          'exercise_name': 'Bench Press',
          'logged_sets': 40,
        },
      ];

      final blocks = buildReportChartBlocks(AppReportType.workouts, rows);

      expect(blocks, hasLength(2));
      expect((blocks[0] as BarChartBlock).points.single.label, 'Push Pull Legs');
      expect((blocks[1] as BarChartBlock).points.single.label, 'Bench Press');
    });

    test('diets and progress build summary bars', () {
      final dietRows = [
        {'category': 'summary', 'metric': 'active_foods_in_library', 'count': 100},
        {'category': 'summary', 'metric': 'verified_foods', 'count': 80},
      ];
      final dietBlocks = buildReportChartBlocks(AppReportType.diets, dietRows);
      expect(dietBlocks, hasLength(1));

      final progressRows = [
        {'category': 'summary', 'metric': 'goals_achieved', 'count': 5},
        {'category': 'summary', 'metric': 'measurement_sessions', 'count': 12},
        {'category': 'summary', 'metric': 'progress_photos_uploaded', 'count': 3},
      ];
      final progressBlocks = buildReportChartBlocks(AppReportType.progress, progressRows);
      expect(progressBlocks, hasLength(1));
    });
  });
}
