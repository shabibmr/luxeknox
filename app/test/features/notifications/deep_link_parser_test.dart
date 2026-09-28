import 'package:luxeknox/features/notifications/domain/helpers/deep_link_parser.dart';
import 'package:luxeknox/features/notifications/domain/helpers/deep_link_resolver.dart';
import 'package:luxeknox/features/notifications/domain/helpers/notification_push_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseNotificationDeepLink', () {
    test('parses entity_type / entity_id', () {
      final target = parseNotificationDeepLink({
        'entity_type': 'schedule',
        'entity_id': '42',
      });
      expect(target?.entityType, 'schedule');
      expect(target?.entityId, '42');
    });

    test('accepts type / id aliases', () {
      final target = parseNotificationDeepLink({
        'type': 'Payment',
        'id': '9',
      });
      expect(target?.entityType, 'payment');
      expect(target?.entityId, '9');
    });

    test('returns null when incomplete', () {
      expect(parseNotificationDeepLink({'type': 'goal'}), isNull);
      expect(parseNotificationDeepLink({}), isNull);
      expect(parseNotificationDeepLink(null), isNull);
    });
  });

  group('resolveDeepLinkPath', () {
    test('maps known types', () {
      final schedule = parseNotificationDeepLink({
        'entity_type': 'schedule',
        'entity_id': '7',
      })!;
      expect(resolveDeepLinkPath(schedule), '/schedule/7');

      final goal = parseNotificationDeepLink({
        'type': 'goal',
        'id': '3',
      })!;
      expect(resolveDeepLinkPath(goal), '/progress/goal/3');
    });

    test('returns null for unknown types', () {
      final target = parseNotificationDeepLink({
        'type': 'spaceship',
        'id': '1',
      })!;
      expect(resolveDeepLinkPath(target), isNull);
    });
  });

  group('NotificationPushHandler', () {
    test('handleIncomingPush returns route for known payload', () {
      const handler = NotificationPushHandler();
      expect(
        handler.handleIncomingPush({
          'entity_type': 'membership',
          'entity_id': '1',
        }),
        '/membership',
      );
    });

    test('handleIncomingPush returns null for unknown', () {
      const handler = NotificationPushHandler();
      expect(handler.handleIncomingPush({'foo': 'bar'}), isNull);
    });
  });
}
