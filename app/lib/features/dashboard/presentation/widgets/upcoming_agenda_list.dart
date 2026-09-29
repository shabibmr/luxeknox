import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../scheduling/domain/entities/schedule_session.dart';
import '../dashboard_strings.dart';
import 'agenda_session_list.dart';

/// List of sessions in the next 7 days (after today), tapping opens detail.
class UpcomingAgendaList extends StatelessWidget {
  const UpcomingAgendaList({
    super.key,
    required this.items,
    required this.onTapSession,
  });

  final List<ScheduleSession> items;
  final ValueChanged<ScheduleSession> onTapSession;

  static final _dayFormat = DateFormat('EEE, MMM d');
  static final _timeFormat = DateFormat('h:mm a');

  @override
  Widget build(BuildContext context) {
    return AgendaSessionList(
      cardKey: const Key('upcoming_agenda_list'),
      items: items,
      title: DashboardStrings.upcomingAgendaTitle,
      emptyMessage: DashboardStrings.upcomingAgendaEmpty,
      onTapSession: onTapSession,
      subtitleFormatter: (start, session) =>
          '${_dayFormat.format(start)} · ${_timeFormat.format(start)}',
    );
  }
}
