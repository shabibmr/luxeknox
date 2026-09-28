import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../../firebase_options.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/helpers/notification_push_handler.dart';
import '../../domain/repositories/device_token_registrar.dart';
import '../../domain/repositories/push_token_provider.dart';

/// Starts FCM listeners, shows foreground notifications, and syncs tokens.
@lazySingleton
class FcmMessagingService {
  FcmMessagingService(
    this._pushTokens,
    this._deviceTokens,
    this._router,
    this._sessionCubit,
  );

  final PushTokenProvider _pushTokens;
  final DeviceTokenRegistrar _deviceTokens;
  final GoRouter _router;
  final SessionCubit _sessionCubit;

  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _pushHandler = const NotificationPushHandler();
  final _subscriptions = <StreamSubscription<dynamic>>[];

  static const _androidChannel = AndroidNotificationChannel(
    'luxeknox_push',
    'LuxeKnox notifications',
    description: 'Push notifications from LuxeKnox',
    importance: Importance.high,
  );

  bool _started = false;

  /// Initializes messaging (no-op when Firebase options are placeholders).
  Future<void> start() async {
    if (_started) return;
    _started = true;

    await _pushTokens.ensureStarted();
    if (!_pushTokens.isLive) return;

    await _initLocalNotifications();
    _listenForeground();
    _listenOpens();
    _listenTokenRefresh();
    _listenSession();
    await _syncTokenIfAuthenticated();
    await _handleInitialMessage();
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        try {
          final map = jsonDecode(payload) as Map<String, dynamic>;
          _navigateFromPayload(map);
        } catch (_) {
          // Ignore malformed local payload.
        }
      },
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_androidChannel);
    await androidPlugin?.requestNotificationsPermission();
  }

  void _listenForeground() {
    _subscriptions.add(
      FirebaseMessaging.onMessage.listen(_showForegroundNotification),
    );
  }

  void _listenOpens() {
    _subscriptions.add(
      FirebaseMessaging.onMessageOpenedApp.listen(_navigateFromMessage),
    );
  }

  void _listenTokenRefresh() {
    _subscriptions.add(
      _pushTokens.onTokenRefresh.listen((token) async {
        if (_sessionCubit.state is! SessionAuthenticated) return;
        await _deviceTokens.registerOrRotate(tokenOverride: token);
      }),
    );
  }

  void _listenSession() {
    _subscriptions.add(
      _sessionCubit.stream.listen((state) async {
        if (state is SessionAuthenticated) {
          await _syncTokenIfAuthenticated();
        }
      }),
    );
  }

  Future<void> _syncTokenIfAuthenticated() async {
    if (_sessionCubit.state is! SessionAuthenticated) return;
    final token = await _pushTokens.getToken();
    if (token == null || token.isEmpty) return;
    await _deviceTokens.registerOrRotate(tokenOverride: token);
  }

  Future<void> _handleInitialMessage() async {
    if (!DefaultFirebaseOptions.isConfigured) return;
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      _navigateFromMessage(initial);
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? 'LuxeKnox';
    final body = notification?.body ?? '';
    if (title.isEmpty && body.isEmpty && message.data.isEmpty) return;

    final payload = jsonEncode(message.data);
    await _localNotifications.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  void _navigateFromMessage(RemoteMessage message) {
    _navigateFromPayload(Map<String, dynamic>.from(message.data));
  }

  void _navigateFromPayload(Map<String, dynamic> data) {
    final path = _pushHandler.handleIncomingPush(data);
    if (path == null || path.isEmpty) {
      debugPrint('FCM: no deep link for payload keys ${data.keys}');
      return;
    }
    _router.go(path);
  }

  @disposeMethod
  void dispose() {
    for (final sub in _subscriptions) {
      unawaited(sub.cancel());
    }
    _subscriptions.clear();
  }
}
