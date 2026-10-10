import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_status.dart';
import 'package:luxeknox/features/goals/domain/entities/progress_note_type.dart';
import 'package:luxeknox/features/goals/presentation/goal_view_actions.dart';

void main() {
  GoalViewActions actions({
    bool canWriteGoals = true,
    bool isAssignedTrainer = false,
    GoalStatus status = GoalStatus.inProgress,
    GoalDetailShell shell = GoalDetailShell.member,
  }) {
    return resolveGoalViewActions(
      canWriteGoals: canWriteGoals,
      isAssignedTrainer: isAssignedTrainer,
      status: status,
      shell: shell,
    );
  }

  test('member shell shows check-in only on in-progress goals', () {
    final result = actions(shell: GoalDetailShell.member);
    expect(result.showEdit, isFalse);
    expect(result.showRecordMeasurement, isFalse);
    expect(result.showCheckIn, isTrue);
  });

  test('member shell hides check-in when goal is not in progress', () {
    final result = actions(
      shell: GoalDetailShell.member,
      status: GoalStatus.achieved,
    );
    expect(result.showCheckIn, isFalse);
  });

  test('assigned trainer on trainer shell can edit, record, and check in', () {
    final result = actions(
      isAssignedTrainer: true,
      shell: GoalDetailShell.trainer,
    );
    expect(result.showEdit, isTrue);
    expect(result.showRecordMeasurement, isTrue);
    expect(result.showCheckIn, isTrue);
  });

  test('unassigned trainer on trainer shell has no actions', () {
    final result = actions(
      isAssignedTrainer: false,
      shell: GoalDetailShell.trainer,
    );
    expect(result.showEdit, isFalse);
    expect(result.showRecordMeasurement, isFalse);
    expect(result.showCheckIn, isFalse);
  });

  test('admin shell shows edit, record, and check-in on in-progress', () {
    final result = actions(shell: GoalDetailShell.admin);
    expect(result.showEdit, isTrue);
    expect(result.showRecordMeasurement, isTrue);
    expect(result.showCheckIn, isTrue);
  });

  test('admin achieved goal keeps edit and hides record and check-in', () {
    final result = actions(
      shell: GoalDetailShell.admin,
      status: GoalStatus.achieved,
    );
    expect(result.showEdit, isTrue);
    expect(result.showRecordMeasurement, isFalse);
    expect(result.showCheckIn, isFalse);
  });

  test('achieved trainer goal keeps edit and hides record and check-in', () {
    final result = actions(
      isAssignedTrainer: true,
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
      isAssignedTrainer: true,
      shell: GoalDetailShell.trainer,
    );
    expect(result.showEdit, isFalse);
    expect(result.showRecordMeasurement, isFalse);
    expect(result.showCheckIn, isFalse);
  });

  test('goalDetailShellForPath maps admin, trainer, and member paths', () {
    expect(
      goalDetailShellForPath('/admin/members/9/goals/goal/1'),
      GoalDetailShell.admin,
    );
    expect(
      goalDetailShellForPath('/trainer/members/9/goals/goal/1'),
      GoalDetailShell.trainer,
    );
    expect(
      goalDetailShellForPath('/progress/goal/1'),
      GoalDetailShell.member,
    );
  });

  test('photo upload only on member shell with owner and write', () {
    expect(
      canUploadProgressPhoto(
        shell: GoalDetailShell.member,
        isOwner: true,
        canWriteGoals: true,
      ),
      isTrue,
    );
    expect(
      canUploadProgressPhoto(
        shell: GoalDetailShell.trainer,
        isOwner: false,
        canWriteGoals: true,
      ),
      isFalse,
    );
    expect(
      canUploadProgressPhoto(
        shell: GoalDetailShell.admin,
        isOwner: false,
        canWriteGoals: true,
      ),
      isFalse,
    );
  });

  test('photo delete for owner or moderate', () {
    expect(canDeleteProgressPhoto(isOwner: true, canModerate: false), isTrue);
    expect(canDeleteProgressPhoto(isOwner: false, canModerate: true), isTrue);
    expect(canDeleteProgressPhoto(isOwner: false, canModerate: false), isFalse);
  });

  test('note types follow shell', () {
    expect(
      allowedNoteTypesForShell(GoalDetailShell.member),
      [ProgressNoteType.memberNote],
    );
    expect(
      allowedNoteTypesForShell(GoalDetailShell.trainer),
      [ProgressNoteType.trainerAssessment],
    );
    expect(
      allowedNoteTypesForShell(GoalDetailShell.admin),
      [
        ProgressNoteType.trainerAssessment,
        ProgressNoteType.memberNote,
      ],
    );
    expect(
      defaultNoteTypeForShell(GoalDetailShell.admin),
      ProgressNoteType.trainerAssessment,
    );
  });
}
