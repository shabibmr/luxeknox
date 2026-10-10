import 'package:luxeknox/features/goals/domain/entities/goal_status.dart';
import 'package:luxeknox/features/goals/domain/helpers/goal_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('goalProgressFraction', () {
    test('increase toward target', () {
      expect(
        goalProgressFraction(baseline: 100, current: 150, target: 200),
        0.5,
      );
    });

    test('decrease toward target', () {
      expect(goalProgressFraction(baseline: 100, current: 75, target: 50), 0.5);
    });

    test('clamps above 1 and below 0', () {
      expect(goalProgressFraction(baseline: 0, current: 200, target: 100), 1.0);
      expect(goalProgressFraction(baseline: 0, current: -50, target: 100), 0.0);
    });

    test('nulls yield 0', () {
      expect(goalProgressFraction(baseline: null, current: 1, target: 2), 0);
    });

    test('zero span achieved when current equals target', () {
      expect(goalProgressFraction(baseline: 10, current: 10, target: 10), 1);
      expect(goalProgressFraction(baseline: 10, current: 11, target: 10), 0);
    });
  });

  group('isGoalAchievedStatus', () {
    test('only server achieved status', () {
      expect(isGoalAchievedStatus(GoalStatus.achieved), isTrue);
      expect(isGoalAchievedStatus(GoalStatus.inProgress), isFalse);
      expect(isGoalAchievedStatus(GoalStatus.abandoned), isFalse);
    });
  });

  group('goalDirection', () {
    test('increase when target is above baseline', () {
      expect(
        goalDirection(baseline: 70, target: 80),
        GoalDirection.increase,
      );
    });

    test('decrease when target is below baseline', () {
      expect(
        goalDirection(baseline: 90, target: 75),
        GoalDirection.decrease,
      );
    });

    test('hold when target equals baseline', () {
      expect(goalDirection(baseline: 80, target: 80), GoalDirection.hold);
    });

    test('null when either endpoint is missing', () {
      expect(goalDirection(baseline: null, target: 80), isNull);
      expect(goalDirection(baseline: 80, target: null), isNull);
    });
  });

  group('projectedGoalValue', () {
    final start = DateTime(2026, 1, 1);
    final end = DateTime(2026, 1, 11);

    test('midpoint is halfway from baseline to target', () {
      expect(
        projectedGoalValue(
          baseline: 100,
          target: 80,
          startDate: start,
          targetDate: end,
          asOf: DateTime(2026, 1, 6),
        ),
        90,
      );
    });

    test('before start returns baseline', () {
      expect(
        projectedGoalValue(
          baseline: 100,
          target: 80,
          startDate: start,
          targetDate: end,
          asOf: DateTime(2025, 12, 31),
        ),
        100,
      );
    });

    test('on or after target date returns target', () {
      expect(
        projectedGoalValue(
          baseline: 100,
          target: 80,
          startDate: start,
          targetDate: end,
          asOf: DateTime(2026, 1, 11),
        ),
        80,
      );
    });

    test('null when dates or values missing', () {
      expect(
        projectedGoalValue(
          baseline: null,
          target: 80,
          startDate: start,
          targetDate: end,
        ),
        isNull,
      );
      expect(
        projectedGoalValue(
          baseline: 100,
          target: 80,
          startDate: end,
          targetDate: start,
        ),
        isNull,
      );
    });
  });
}
