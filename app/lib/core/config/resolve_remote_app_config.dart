import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_options.dart';
import 'api_base_url_resolver.dart';
import 'app_config.dart';
import 'app_config_bootstrap.dart';
import 'firestore_app_config_source.dart';
import 'remote_api_base_url_store.dart';

/// Initializes Firebase (when configured), resolves `API_BASE_URL`, and
/// stores the result on [AppConfigBootstrap.resolved].
Future<void> resolveRemoteAppConfig() async {
  final env = AppConfig.fromEnv();
  AppConfigBootstrap.resolved = env.copyWith(
    apiBaseUrl: await _resolveApiBaseUrl(env.apiBaseUrl),
  );
}

Future<String> _resolveApiBaseUrl(String fallbackUrl) async {
  if (!DefaultFirebaseOptions.isConfigured) return fallbackUrl;

  // Prefs don't need Firebase, so both start together.
  final (_, prefs) = await (
    _initFirebase(),
    SharedPreferences.getInstance(),
  ).wait;
  return ApiBaseUrlResolver(
    store: RemoteApiBaseUrlStore(prefs),
    source: FirestoreAppConfigSource(),
    fallbackUrl: fallbackUrl,
  ).resolve();
}

/// A failed init is logged, not thrown: the resolver then falls back to the
/// cached or default URL, and FCM's own start guard handles the rest.
Future<void> _initFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e, st) {
    developer.log(
      'Firebase init failed',
      name: 'AppConfig',
      error: e,
      stackTrace: st,
    );
  }
}
