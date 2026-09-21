import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/app_notification.dart';
import '../notification_strings.dart';

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unread = notification.unread;
    final time = DateFormat.yMMMd().add_jm().format(
      notification.createdAt.toLocal(),
    );

    return ListTile(
      leading: Icon(
        unread ? Icons.mark_email_unread : Icons.mark_email_read_outlined,
        color: unread ? theme.colorScheme.primary : theme.colorScheme.outline,
      ),
      title: Text(
        notification.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: unread
            ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)
            : theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        '${notification.message}\n$time',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
      trailing: unread
          ? Chip(
              label: Text(
                NotificationStrings.unreadLabel,
                style: theme.textTheme.labelSmall,
              ),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            )
          : null,
      onTap: onTap,
    );
  }
}
