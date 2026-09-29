import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../scheduling/domain/entities/schedule_session.dart';
import '../dashboard_strings.dart';
import 'agenda_session_list.dart';

/// Compact card of sessions scheduled for the current calendar day.
class TodayAgendaCard extends StatelessWidget {
  const TodayAgendaCard({
    super.key,
    required this.items,
    required this.title,
    required this.emptyMessage,
    required this.onTapSession,
  });

  final List<ScheduleSession> items;
  final String title;
  final String emptyMessage;
  final ValueChanged<ScheduleSession> onTapSession;

  static final _timeFormat = DateFormat('h:mm a');

  @override
  Widget build(BuildContext context) {
    return AgendaSessionList(
      cardKey: const Key('today_agenda_card'),
      items: items,
      title: title,
      emptyMessage: emptyMessage,
      onTapSession: onTapSession,
      subtitleFormatter: (start, session) =>
          '${_timeFormat.format(start)} · ${session.status.name}',
      trailingSummary: items.isEmpty
          ? null
          : DashboardStrings.agendaItemCount(items.length),
    );
  }
}
