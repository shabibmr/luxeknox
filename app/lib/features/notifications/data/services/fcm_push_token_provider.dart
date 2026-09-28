import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../firebase_options.dart';
import '../../domain/repositories/push_token_provider.dart';
import 'fcm_background_handler.dart';

@LazySingleton(as: PushTokenProvider)
class FcmPushTokenProvider implements PushTokenProvider {
  bool _started = false;
  bool _live = false;

  @override
  bool get isLive => _live;

  @override
  Future<void> ensureStarted() async {
    if (_started) return;
    _started = true;

    if (!DefaultFirebaseOptions.isConfigured) {
      debugPrint('FCM: Firebase options not configured — stub tokens only.');
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
      debugPrint('FCM: failed to start ($e)');
      debugPrint('$st');
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
      return await messaging.getToken();
    } catch (e) {
      debugPrint('FCM: getToken failed ($e)');
      return null;
    }
  }

  @override
  Stream<String> get onTokenRefresh {
    if (!DefaultFirebaseOptions.isConfigured) {
      return const Stream<String>.empty();
    }
    return FirebaseMessaging.instance.onTokenRefresh;
  }
}
