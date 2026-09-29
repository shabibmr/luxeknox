import 'package:flutter/material.dart';

import '../../../scheduling/domain/entities/schedule_session.dart';

/// Shared card+list shape for a set of schedule sessions: title, optional
/// empty message, and a row per session (title + formatted subtitle +
/// chevron + onTap). Callers differ only in subtitle formatting, section
/// title/empty copy, and whether a trailing summary line is shown.
class AgendaSessionList extends StatelessWidget {
  const AgendaSessionList({
    super.key,
    required this.cardKey,
    required this.items,
    required this.title,
    required this.emptyMessage,
    required this.onTapSession,
    required this.subtitleFormatter,
    this.trailingSummary,
  });

  final Key cardKey;
  final List<ScheduleSession> items;
  final String title;
  final String emptyMessage;
  final ValueChanged<ScheduleSession> onTapSession;
  final String Function(DateTime start, ScheduleSession session)
  subtitleFormatter;

  /// Optional summary text shown below the list, e.g. an item count.
  final String? trailingSummary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: cardKey,
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
                  subtitle: Text(subtitleFormatter(start, session)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => onTapSession(session),
                );
              }),
            if (items.isNotEmpty && trailingSummary != null)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  trailingSummary!,
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
