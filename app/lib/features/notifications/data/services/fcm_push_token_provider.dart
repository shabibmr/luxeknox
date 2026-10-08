import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/monitoring/crash_reporter.dart';
import '../../../../firebase_options.dart';
import '../../domain/repositories/push_token_provider.dart';
import 'fcm_background_handler.dart';

@LazySingleton(as: PushTokenProvider)
class FcmPushTokenProvider implements PushTokenProvider {
  FcmPushTokenProvider(this._crashReporter);

  final CrashReporter _crashReporter;
  bool _started = false;
  bool _live = false;

  /// Web push requires a VAPID key from Firebase Console → Cloud Messaging.
  /// Pass with `--dart-define=FCM_VAPID_KEY=...`. Empty keeps web non-live.
  static const String _vapidKey = String.fromEnvironment('FCM_VAPID_KEY');

  @override
  bool get isLive => _live;

  @override
  Future<void> ensureStarted() async {
    if (_started) return;
    _started = true;

    if (!DefaultFirebaseOptions.isConfigured) {
      _crashReporter.log(
        'FCM: Firebase options not configured — stub tokens only.',
      );
      return;
    }
    if (!_fcmSupported) {
      _crashReporter.log(
        'FCM: not supported on this platform — stub tokens only.',
      );
      return;
    }
    if (kIsWeb && _vapidKey.isEmpty) {
      _crashReporter.log(
        'FCM: web requires --dart-define=FCM_VAPID_KEY — stub tokens only.',
      );
      return;
    }

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      _live = true;
    } catch (e, st) {
      _crashReporter.recordError(e, st);
      _live = false;
    }
  }

  @override
  Future<String?> getToken({bool forceRefresh = false}) async {
    await ensureStarted();
    if (!_live) return null;

    try {
      final messaging = FirebaseMessaging.instance;
      if (forceRefresh) {
        await messaging.deleteToken();
      }
      if (kIsWeb) {
        return await messaging.getToken(vapidKey: _vapidKey);
      }
      return await messaging.getToken();
    } catch (e) {
      _crashReporter.log('FCM: getToken failed ($e)');
      return null;
    }
  }

  @override
  Stream<String> get onTokenRefresh {
    if (!DefaultFirebaseOptions.isConfigured || !_fcmSupported) {
      return const Stream<String>.empty();
    }
    return FirebaseMessaging.instance.onTokenRefresh;
  }
}

/// firebase_messaging has no Windows/Linux implementation.
bool get _fcmSupported => switch (defaultTargetPlatform) {
  TargetPlatform.windows || TargetPlatform.linux => false,
  _ => true,
};
