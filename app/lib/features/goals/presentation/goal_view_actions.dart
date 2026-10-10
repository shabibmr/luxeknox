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

/// Role gates for goal detail (ADR-0006 §7). Uses shell + `goals.write` +
/// assigned-trainer — never [UserType].
GoalViewActions resolveGoalViewActions({
  required bool canWriteGoals,
  required bool isAssignedTrainer,
  required GoalStatus status,
  required GoalDetailShell shell,
}) {
  if (!canWriteGoals) {
    return const GoalViewActions(
      showEdit: false,
      showRecordMeasurement: false,
      showCheckIn: false,
    );
  }

  final inProgress = status == GoalStatus.inProgress;

  switch (shell) {
    case GoalDetailShell.member:
      return GoalViewActions(
        showEdit: false,
        showRecordMeasurement: false,
        showCheckIn: inProgress,
      );
    case GoalDetailShell.trainer:
      if (!isAssignedTrainer) {
        return const GoalViewActions(
          showEdit: false,
          showRecordMeasurement: false,
          showCheckIn: false,
        );
      }
      return GoalViewActions(
        showEdit: true,
        showRecordMeasurement: inProgress,
        showCheckIn: inProgress,
      );
    case GoalDetailShell.admin:
      return GoalViewActions(
        showEdit: true,
        showRecordMeasurement: inProgress,
        showCheckIn: inProgress,
      );
  }
}
