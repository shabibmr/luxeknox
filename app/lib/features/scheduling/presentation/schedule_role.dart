enum ScheduleCalendarRole { member, trainer, admin }

extension ScheduleCalendarRoleX on ScheduleCalendarRole {
  bool get canManageLifecycle =>
      this == ScheduleCalendarRole.trainer || this == ScheduleCalendarRole.admin;

  bool get canCancelSession => this == ScheduleCalendarRole.admin;

  bool get showBookActions => this == ScheduleCalendarRole.member;
}
