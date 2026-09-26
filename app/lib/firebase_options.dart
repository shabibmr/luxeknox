// Placeholder Firebase options for LuxeKnox.
//
// Replace by running (after `firebase login`):
//   cd app && flutterfire configure --project=<your-project-id> \
//     --platforms=android,ios,web \
//     --android-package-name=com.algo.luxeknox \
//     --ios-bundle-id=com.algo.luxeknox
//
// Until then [DefaultFirebaseOptions.isConfigured] is false and the app
// keeps stub device tokens + no FCM listeners.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  /// True only after FlutterFire has replaced placeholder values.
  static bool get isConfigured {
    final key = currentPlatform.apiKey;
    return key.isNotEmpty && !key.startsWith('REPLACE_ME');
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_ME_WEB_API_KEY',
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'luxeknox-placeholder',
    authDomain: 'luxeknox-placeholder.firebaseapp.com',
    storageBucket: 'luxeknox-placeholder.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_ME_ANDROID_API_KEY',
    appId: '1:000000000000:android:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'luxeknox-placeholder',
    storageBucket: 'luxeknox-placeholder.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_ME_IOS_API_KEY',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'luxeknox-placeholder',
    storageBucket: 'luxeknox-placeholder.appspot.com',
    iosBundleId: 'com.algo.luxeknox',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REPLACE_ME_MACOS_API_KEY',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'luxeknox-placeholder',
    storageBucket: 'luxeknox-placeholder.appspot.com',
    iosBundleId: 'com.algo.luxeknox',
  );
}
