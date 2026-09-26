class DashboardStrings {
  DashboardStrings._();

  static const String title = 'Dashboard';

  static const String membershipCardTitle = 'My Membership';
  static const String noMembership = 'No active membership.';
  static const String daysRemaining = 'days remaining';
  static const String assignedTrainer = 'Your trainer';

  static const String assignedMembersTitle = 'My Members';
  static const String assignedMembersCount = 'assigned members';
  static const String noAssignedMembers = 'No members assigned yet.';

  static const String overviewTitle = 'Gym Overview';
  static const String members = 'Members';
  static const String trainers = 'Trainers';
  static const String employees = 'Employees';
  static const String membershipsByStatus = 'Memberships by status';
  static const String expiringSoon = 'Expiring soon';

  static const String empty = 'Nothing to show yet.';
  static const String retry = 'Retry';
  static const String staleDataNotice =
      'Showing last loaded data — refresh failed.';

  // Agenda (P4) — member bookings / trainer sessions for today + next 7 days.
  static const String agendaSectionTitle = 'Agenda';
  static const String todayAgendaMemberTitle = "Today's bookings";
  static const String todayAgendaTrainerTitle = "Today's sessions";
  static const String todayAgendaMemberEmpty = 'No bookings scheduled for today.';
  static const String todayAgendaTrainerEmpty =
      'No sessions scheduled for today.';
  static const String upcomingAgendaTitle = 'Upcoming';
  static const String upcomingAgendaEmpty = 'Nothing coming up in the next 7 days.';
  static const String agendaError = 'Could not load your agenda.';

  static String agendaItemCount(int count) =>
      count == 1 ? '1 session' : '$count sessions';
}
