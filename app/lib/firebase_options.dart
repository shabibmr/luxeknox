// Generated for Firebase project luxe-knox-app (Luxe-Knox-App).
// Regenerate:
//   cd app && flutterfire configure --project=luxe-knox-app \
//     --platforms=android,ios,web,windows \
//     --android-package-name=com.luxeknox.app \
//     --ios-bundle-id=com.luxeknox.app \
//     --web-app-id=1:27985362758:web:fca5ce8055ad07ac202f47 \
//     --windows-app-id=1:27985362758:web:7b66c77202365047202f47
// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  /// True when the active platform has real Firebase keys (not placeholders).
  static bool get isConfigured {
    try {
      final key = currentPlatform.apiKey;
      return key.isNotEmpty && !key.startsWith('REPLACE_ME');
    } on UnsupportedError {
      return false;
    }
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD6cmsWnEW2EI6j1UxQBfqN2Ms9zpXyxAU',
    appId: '1:27985362758:web:fca5ce8055ad07ac202f47',
    messagingSenderId: '27985362758',
    projectId: 'luxe-knox-app',
    authDomain: 'luxe-knox-app.firebaseapp.com',
    storageBucket: 'luxe-knox-app.firebasestorage.app',
    measurementId: 'G-14J71YHPDY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCEUUspp7at8p493YkCs9Hc3v2-LxObhtw',
    appId: '1:27985362758:android:564da5bc6a105afe202f47',
    messagingSenderId: '27985362758',
    projectId: 'luxe-knox-app',
    storageBucket: 'luxe-knox-app.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD6cmsWnEW2EI6j1UxQBfqN2Ms9zpXyxAU',
    appId: '1:27985362758:web:7b66c77202365047202f47',
    messagingSenderId: '27985362758',
    projectId: 'luxe-knox-app',
    authDomain: 'luxe-knox-app.firebaseapp.com',
    storageBucket: 'luxe-knox-app.firebasestorage.app',
    measurementId: 'G-L1VC0SR91E',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8JmwphfE9825IVco7-0D7GWCG9bap9k4',
    appId: '1:27985362758:ios:34f42685e7e64a78202f47',
    messagingSenderId: '27985362758',
    projectId: 'luxe-knox-app',
    storageBucket: 'luxe-knox-app.firebasestorage.app',
    iosBundleId: 'com.luxeknox.app',
  );

  /// macOS reuses the iOS Firebase app (same bundle id).
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA8JmwphfE9825IVco7-0D7GWCG9bap9k4',
    appId: '1:27985362758:ios:34f42685e7e64a78202f47',
    messagingSenderId: '27985362758',
    projectId: 'luxe-knox-app',
    storageBucket: 'luxe-knox-app.firebasestorage.app',
    iosBundleId: 'com.luxeknox.app',
  );
}
