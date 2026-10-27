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
  // Production reads Firestore `API_BASE_URL`. Other builds read
  // `API_BASE_URL_DEBUG` and a separate prefs key, so a shared web origin
  // cannot reuse the production host. The dart-define URL is the fallback.
  AppConfigBootstrap.resolved = env.copyWith(
    apiBaseUrl: await _resolveApiBaseUrl(env.apiBaseUrl, env.isProduction),
  );
}

Future<String> _resolveApiBaseUrl(String fallbackUrl, bool isProduction) async {
  if (!DefaultFirebaseOptions.isConfigured) {
    return ApiBaseUrlResolver.normalize(fallbackUrl);
  }

  // Prefs don't need Firebase, so both start together. Neither may abort
  // launch: a prefs failure falls back to the dart-define URL.
  final SharedPreferences prefs;
  try {
    prefs = (await (_initFirebase(), SharedPreferences.getInstance()).wait).$2;
  } catch (e, st) {
    developer.log(
      'SharedPreferences unavailable; using fallback API_BASE_URL',
      name: 'AppConfig',
      error: e,
      stackTrace: st,
    );
    return ApiBaseUrlResolver.normalize(fallbackUrl);
  }
  return ApiBaseUrlResolver(
    // Non-production builds read `API_BASE_URL_DEBUG` (own cache key), so
    // test/debug runs never pick up the production API URL.
    store: RemoteApiBaseUrlStore(
      prefs,
      key: isProduction
          ? RemoteApiBaseUrlStore.defaultKey
          : RemoteApiBaseUrlStore.debugKey,
    ),
    source: FirestoreAppConfigSource(
      apiBaseUrlField: isProduction
          ? FirestoreAppConfigSource.defaultApiBaseUrlField
          : FirestoreAppConfigSource.debugApiBaseUrlField,
    ),
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
