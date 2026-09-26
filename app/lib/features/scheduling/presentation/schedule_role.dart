enum ScheduleCalendarRole { member, trainer, admin }

extension ScheduleCalendarRoleX on ScheduleCalendarRole {
  bool get canManageLifecycle =>
      this == ScheduleCalendarRole.trainer || this == ScheduleCalendarRole.admin;

  bool get canCancelSession => this == ScheduleCalendarRole.admin;

  bool get showBookActions => this == ScheduleCalendarRole.member;

  /// Staff surface for moving a session's start/end (gated with `schedules.write`).
  bool get canRescheduleSession =>
      this == ScheduleCalendarRole.trainer || this == ScheduleCalendarRole.admin;

  /// Member surface for moving their seat to another session of the same type
  /// (gated with `schedules.book` + `schedules.cancel`).
  bool get canMoveBooking => this == ScheduleCalendarRole.member;
}
