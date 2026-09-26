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
      expect(
        goalProgressFraction(baseline: 100, current: 75, target: 50),
        0.5,
      );
    });

    test('clamps above 1 and below 0', () {
      expect(
        goalProgressFraction(baseline: 0, current: 200, target: 100),
        1.0,
      );
      expect(
        goalProgressFraction(baseline: 0, current: -50, target: 100),
        0.0,
      );
    });

    test('nulls yield 0', () {
      expect(
        goalProgressFraction(baseline: null, current: 1, target: 2),
        0,
      );
    });

    test('zero span achieved when current equals target', () {
      expect(
        goalProgressFraction(baseline: 10, current: 10, target: 10),
        1,
      );
      expect(
        goalProgressFraction(baseline: 10, current: 11, target: 10),
        0,
      );
    });
  });

  group('isGoalAchievedStatus', () {
    test('only server achieved status', () {
      expect(isGoalAchievedStatus(GoalStatus.achieved), isTrue);
      expect(isGoalAchievedStatus(GoalStatus.inProgress), isFalse);
      expect(isGoalAchievedStatus(GoalStatus.abandoned), isFalse);
    });
  });
}
