import '../entities/app_notification.dart';

/// Count of notifications that are not marked read (`isRead != true`).
int unreadCount(Iterable<AppNotification> notifications) {
  var count = 0;
  for (final n in notifications) {
    if (n.unread) count++;
  }
  return count;
}
