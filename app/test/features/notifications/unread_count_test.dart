import 'package:luxeknox/features/notifications/domain/entities/app_notification.dart';
import 'package:luxeknox/features/notifications/domain/helpers/unread_count.dart';
import 'package:flutter_test/flutter_test.dart';

AppNotification n({required String id, bool? isRead}) {
  return AppNotification(
    id: id,
    title: 't',
    message: 'm',
    createdAt: DateTime.utc(2026, 1, 1),
    isRead: isRead,
  );
}

void main() {
  test('unreadCount counts null and false as unread', () {
    final items = [
      n(id: '1', isRead: false),
      n(id: '2'),
      n(id: '3', isRead: true),
      n(id: '4', isRead: false),
    ];
    expect(unreadCount(items), 3);
  });

  test('unreadCount empty is zero', () {
    expect(unreadCount(const []), 0);
  });
}
