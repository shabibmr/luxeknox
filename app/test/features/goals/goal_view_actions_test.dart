import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_status.dart';
import 'package:luxeknox/features/goals/presentation/goal_view_actions.dart';

void main() {
  GoalViewActions actions({
    bool canWriteGoals = true,
    bool isTrainerUser = false,
    GoalStatus status = GoalStatus.inProgress,
    GoalDetailShell shell = GoalDetailShell.member,
  }) {
    return resolveGoalViewActions(
      canWriteGoals: canWriteGoals,
      isTrainerUser: isTrainerUser,
      status: status,
      shell: shell,
    );
  }

  test('member path is view only', () {
    final result = actions(isTrainerUser: true);
    expect(result.showEdit, isFalse);
    expect(result.showRecordMeasurement, isFalse);
    expect(result.showCheckIn, isFalse);
  });

  test('trainer on the trainer path can edit, record, and check in', () {
    final result = actions(
      isTrainerUser: true,
      shell: GoalDetailShell.trainer,
    );
    expect(result.showEdit, isTrue);
    expect(result.showRecordMeasurement, isTrue);
    expect(result.showCheckIn, isTrue);
  });

  test('admin on a trainer path can edit and cannot record or check in', () {
    final result = actions(shell: GoalDetailShell.trainer);
    expect(result.showEdit, isTrue);
    expect(result.showRecordMeasurement, isFalse);
    expect(result.showCheckIn, isFalse);
  });

  test('admin path is edit only', () {
    final result = actions(
      isTrainerUser: false,
      shell: GoalDetailShell.admin,
    );
    expect(result.showEdit, isTrue);
    expect(result.showRecordMeasurement, isFalse);
    expect(result.showCheckIn, isFalse);
  });

  test('achieved trainer goal keeps edit and hides record and check-in', () {
    final result = actions(
      isTrainerUser: true,
      shell: GoalDetailShell.trainer,
      status: GoalStatus.achieved,
    );
    expect(result.showEdit, isTrue);
    expect(result.showRecordMeasurement, isFalse);
    expect(result.showCheckIn, isFalse);
  });

  test('write permission is required for every action', () {
    final result = actions(
      canWriteGoals: false,
      isTrainerUser: true,
      shell: GoalDetailShell.trainer,
    );
    expect(result.showEdit, isFalse);
    expect(result.showRecordMeasurement, isFalse);
    expect(result.showCheckIn, isFalse);
  });
}
