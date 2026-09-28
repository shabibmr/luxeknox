import 'deep_link_parser.dart';
import 'deep_link_resolver.dart';

/// Push payload → route mapper used by FCM listeners and detail CTAs.
///
/// Stays free of firebase_messaging so domain tests stay pure Dart.
class NotificationPushHandler {
  const NotificationPushHandler();

  /// Returns a go_router path for [payload], or null when unknown/unparseable.
  String? handleIncomingPush(Map<String, dynamic> payload) {
    final stringPayload = <String, String?>{
      for (final e in payload.entries) e.key: e.value?.toString(),
    };
    final target = parseNotificationDeepLink(stringPayload);
    if (target == null) return null;
    return resolveDeepLinkPath(target);
  }
}
