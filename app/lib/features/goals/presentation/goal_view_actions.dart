import '../domain/entities/goal_status.dart';

enum GoalDetailShell { member, trainer, admin }

class GoalViewActions {
  const GoalViewActions({
    required this.showEdit,
    required this.showRecordMeasurement,
    required this.showCheckIn,
  });

  final bool showEdit;
  final bool showRecordMeasurement;
  final bool showCheckIn;
}

GoalDetailShell goalDetailShellForPath(String path) {
  if (path.startsWith('/admin/members/')) return GoalDetailShell.admin;
  if (path.startsWith('/trainer/members/')) return GoalDetailShell.trainer;
  return GoalDetailShell.member;
}

GoalViewActions resolveGoalViewActions({
  required bool canWriteGoals,
  required bool isTrainerUser,
  required GoalStatus status,
  required GoalDetailShell shell,
}) {
  final trainerProgress =
      isTrainerUser &&
      canWriteGoals &&
      shell == GoalDetailShell.trainer &&
      status == GoalStatus.inProgress;
  return GoalViewActions(
    showEdit: canWriteGoals && shell != GoalDetailShell.member,
    showRecordMeasurement: trainerProgress,
    showCheckIn: trainerProgress,
  );
}
