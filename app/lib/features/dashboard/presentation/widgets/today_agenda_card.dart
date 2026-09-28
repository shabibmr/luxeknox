import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../scheduling/domain/entities/schedule_session.dart';
import '../dashboard_strings.dart';

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
    final theme = Theme.of(context);
    return Card(
      key: const Key('today_agenda_card'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (items.isEmpty)
              Text(
                emptyMessage,
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
                    '${_timeFormat.format(start)} · ${session.status.name}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => onTapSession(session),
                );
              }),
            if (items.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  DashboardStrings.agendaItemCount(items.length),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
