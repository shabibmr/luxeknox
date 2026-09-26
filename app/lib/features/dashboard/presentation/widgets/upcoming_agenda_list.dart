import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../scheduling/domain/entities/schedule_session.dart';
import '../dashboard_strings.dart';

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
    final theme = Theme.of(context);
    return Card(
      key: const Key('upcoming_agenda_list'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DashboardStrings.upcomingAgendaTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              Text(
                DashboardStrings.upcomingAgendaEmpty,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              ...items.map((session) {
                final start = session.startTime.toLocal();
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(session.title),
                  subtitle: Text(
                    '${_dayFormat.format(start)} · ${_timeFormat.format(start)}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => onTapSession(session),
                );
              }),
          ],
        ),
      ),
    );
  }
}
